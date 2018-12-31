import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart' show DartType;
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:source_gen/source_gen.dart';

String _toTitle(String string) {
  return string.replaceFirstMapped(RegExp('[a-zA-Z]'), (match) {
    return match.group(0).toUpperCase();
  });
}

/// A generator that outputs widgets from a function
///
/// The function must be decorated by `@widget` and be a top level function.
/// The type of the widget is infered by the arguments of the function and defaults
/// to `StatelessWidget`
class FunctionalWidget extends GeneratorForAnnotation<dynamic> {
  final _emitter = DartEmitter();

  @override
  TypeChecker get typeChecker => TypeChecker.fromRuntime(widget.runtimeType);

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! FunctionElement) {
      throw InvalidGenerationSourceError(
        'Error, the decorated element is not a function',
        element: element,
      );
    }
    return _functionToWidgetClass(element as FunctionElement)
        .accept(_emitter)
        .toString();
  }
}

const _kFlutterWidgetsPath = 'package:flutter/material.dart';
const _kHookWidgetsPath = 'package:flutter_hooks/flutter_hooks.dart';

final _widgetRef = refer('Widget', _kFlutterWidgetsPath);
final _statelessWidgetRef = refer('StatelessWidget', _kFlutterWidgetsPath);
final _hookWidgetRef = refer('HookWidget', _kHookWidgetsPath);
final _hookContextRef = refer('HookContext', _kHookWidgetsPath);
final _keyRef = refer('Key', _kFlutterWidgetsPath);
final _buildContextRef = refer('BuildContext', _kFlutterWidgetsPath);

enum _WidgetType { stateless, hook }

Spec _functionToWidgetClass(FunctionElement function) {
  if (function.isAsynchronous ||
      function.isExternal ||
      function.isGenerator ||
      !function.isStatic ||
      function.isAbstract) {
    throw ArgumentError();
  }
  final className = _toTitle(function.name);
  if (className == function.name) {
    throw ArgumentError('The function name must start with a lowercase');
  }

  final t = _functionElementToMethod(function);
  final params = List<Parameter>.from(t.requiredParameters)
    ..addAll(t
        .optionalParameters); // _parseParameters(function.parameters).toList();

  final startsWithKey = params.isNotEmpty && _isKey(params.first);
  final startsWithContext = params.isNotEmpty && _isContext(params.first);
  final followedByKey =
      params.length > 1 && startsWithContext && _isKey(params[1]);
  final followedByContext =
      params.length > 1 && startsWithKey && _isContext(params[1]);

  final widgetType =
      _hasHookContext(params) ? _WidgetType.hook : _WidgetType.stateless;

  final fields = (followedByContext || followedByKey)
      ? (List<Parameter>.from(params)..removeRange(0, 2))
      : (startsWithContext || startsWithKey)
          ? (List<Parameter>.from(params)..removeRange(0, 1))
          : params;

  final positional = <Expression>[];
  if (startsWithContext) positional.add(const CodeExpression(Code('_context')));
  if (startsWithKey) positional.add(const CodeExpression(Code('key')));
  if (followedByContext) positional.add(const CodeExpression(Code('_context')));
  if (followedByKey) positional.add(const CodeExpression(Code('key')));
  positional.addAll(
      fields.where((p) => !p.named).map((p) => CodeExpression(Code(p.name))));

  final named = <String, Expression>{};
  for (final p in fields.where((p) => p.named)) {
    named[p.name] = CodeExpression(Code(p.name));
  }

  return Class(
    (b) => b
      ..name = _toTitle(function.name)
      ..docs.add(function.documentationComment ?? '')
      ..extend =
          widgetType == _WidgetType.hook ? _hookWidgetRef : _statelessWidgetRef
      ..fields.addAll(_paramsToFields(fields))
      ..constructors.add(_getConstructor(fields))
      ..methods.add(
        Method(
          (b) => b
            ..name = 'build'
            ..annotations.add(const CodeExpression(Code('override')))
            ..returns = _widgetRef
            ..requiredParameters.add(
              Parameter((b) => b
                ..name = '_context'
                ..type = widgetType == _WidgetType.hook
                    ? _hookContextRef
                    : _buildContextRef),
            )
            ..body = CodeExpression(Code(t.name)).call(positional, named).code,
        ),
      ),
  );
}

Method _functionElementToMethod(FunctionElement element) {
  return Method((b) => b
    ..name = element.name
    ..returns = _typeToReference(element.returnType)
    ..types.addAll(element.typeParameters.map((f) => _typeToReference(f.type)))
    ..requiredParameters.addAll(
        element.parameters.where((p) => p.isNotOptional).map(_parseParameter))
    ..optionalParameters.addAll(
        element.parameters.where((p) => p.isOptional).map(_parseParameter)));
}

FunctionType _functionTypedElementToFunctionType(FunctionTypedElement element) {
  return FunctionType((b) => b
    ..returnType = _typeToReference(element.returnType)
    ..types.addAll(element.typeParameters.map((f) => _typeToReference(f.type)))
    ..requiredParameters.addAll(element.parameters
        .where((p) => p.isNotOptional)
        .map(_parseParameter)
        .map((p) => p.type))
    ..namedParameters.addEntries(element.parameters
        .where((p) => p.isNamed)
        .map(_parseParameter)
        .map((p) => MapEntry(p.name, p.type)))
    ..optionalParameters.addAll(element.parameters
        .where((p) => p.isOptionalPositional)
        .map(_parseParameter)
        .map((p) => p.type)));
}

Constructor _getConstructor(List<Parameter> fields) {
  return Constructor(
    (b) => b
      ..constant = true
      ..optionalParameters.add(Parameter((b) => b
        ..named = true
        ..name = 'key'
        ..docs.clear()
        ..type = _keyRef))
      ..requiredParameters
          .addAll(fields.where((p) => !p.named).map((p) => p.rebuild((b) => b
            ..toThis = true
            ..docs.clear()
            ..type = null)))
      ..optionalParameters
          .addAll(fields.where((p) => p.named).map((p) => p.rebuild((b) => b
            ..toThis = true
            ..docs.clear()
            ..type = null)))
      ..initializers.add(const Code('super(key: key)')),
  );
}

bool _hasHookContext(List<Parameter> params) {
  return (params.isNotEmpty && params.first.type?.symbol == 'HookContext') ||
      (params.length > 1 && params[1].type?.symbol == 'HookContext');
}

bool _isKey(Parameter param) => param.type?.symbol == 'Key';

bool _isContext(Parameter param) =>
    param.type?.symbol == 'BuildContext' || param.type?.symbol == 'HookContext';

Iterable<Field> _paramsToFields(List<Parameter> params) sync* {
  for (final param in params) {
    yield Field(
      (b) => b
        ..name = param.name
        ..modifier = FieldModifier.final$
        ..docs.addAll(param.docs)
        ..type = param.type,
    );
  }
}

Parameter _parseParameter(ParameterElement parameter) {
  return Parameter(
    (b) => b
      ..name = parameter.name
      ..docs.add(parameter.documentationComment ?? '')
      ..annotations.addAll(parameter.metadata.map((meta) {
        return CodeExpression(Code(meta.element.displayName));
      }))
      ..named = parameter.isNamed
      ..type = _parameterToReference(parameter),
  );
}

Reference _parameterToReference(ParameterElement element) {
  if (element.type == null) {
    return null;
  }
  if (element.type.isUndefined) {
    return refer(element.computeNode().beginToken.toString());
  }

  return _typeToReference(element.type);
}

Reference _typeToReference(DartType type) {
  if (type == null) {
    return null;
  }
  if (type.element is FunctionTypedElement) {
    final FunctionTypedElement functionTyped = type.element;
    final t = _functionTypedElementToFunctionType(functionTyped);
    print('''
${functionTyped.returnType}
${functionTyped.name}
${functionTyped.typeParameters.map((f) => f.name).join(',')}
''');
    return t.type;
  }

  return type.displayName != null ? refer(type.displayName) : null;
}
