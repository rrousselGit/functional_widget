import 'package:analyzer/dart/element/element.dart';
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

Class _functionToWidgetClass(FunctionElement function) {
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

  final params = _parseParameters(function.parameters).toList();

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

  return Class(
    (b) => b
      ..name = _toTitle(function.name)
      ..docs.add(function.documentationComment ?? '')
      ..extend =
          widgetType == _WidgetType.hook ? _hookWidgetRef : _statelessWidgetRef
      ..fields.addAll(_paramsToFields(fields))
      ..constructors.add(Constructor(
        (b) => b
          ..constant = true
          ..optionalParameters.add(Parameter((b) => b
            ..named = true
            ..name = 'key'
            ..docs.clear()
            ..type = _keyRef))
          ..requiredParameters.addAll(
              fields.where((p) => !p.named).map((p) => p.rebuild((b) => b
                ..toThis = true
                ..docs.clear()
                ..type = null)))
          ..optionalParameters
              .addAll(fields.where((p) => p.named).map((p) => p.rebuild((b) => b
                ..toThis = true
                ..docs.clear()
                ..type = null)))
          ..initializers.add(const Code('super(key: key)')),
      ))
      ..methods.add(Method(
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
          ..body = Code(
              'return ${function.name}(${_formatConstructor(startsWithContext, startsWithKey, followedByContext, followedByKey, fields)});'),
      )),
  );
}

String _formatConstructor(bool startsWithContext, bool startsWithKey,
    bool followedByContext, bool followedByKey, List<Parameter> fields) {
  return ([
    startsWithContext ? '_context' : startsWithKey ? 'key' : null,
    followedByContext ? '_context' : followedByKey ? 'key' : null,
  ]
        ..addAll(fields.where((f) => !f.named).map((f) => f.name))
        ..addAll(
            fields.where((f) => f.named).map((f) => '${f.name}: ${f.name}')))
      .where((s) => s != null)
      .join(', ');
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

Iterable<Parameter> _parseParameters(List<ParameterElement> parameters) sync* {
  for (final parameter in parameters) {
    yield Parameter(
      (b) => b
        ..name = parameter.name
        ..docs.add(parameter.documentationComment ?? '')
        ..annotations.addAll(parameter.metadata.map((meta) {
          return CodeExpression(Code(meta.element.displayName));
        }))
        ..named = parameter.isNamed
        ..type = parameter.type?.displayName != null
            ? refer(parameter.type.displayName)
            : null,
    );
  }
}
