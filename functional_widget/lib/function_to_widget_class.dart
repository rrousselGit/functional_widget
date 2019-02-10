import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart' show DartType;
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:functional_widget/src/utils.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:source_gen/source_gen.dart';

const _kFlutterWidgetsPath = 'package:flutter/material.dart';
const _kHookWidgetsPath = 'package:flutter_hooks/flutter_hooks.dart';

final _widgetRef = refer('Widget', _kFlutterWidgetsPath);
final _statelessWidgetRef = refer('StatelessWidget', _kFlutterWidgetsPath);
final _hookWidgetRef = refer('HookWidget', _kHookWidgetsPath);
final _keyRef = refer('Key', _kFlutterWidgetsPath);
final _buildContextRef = refer('BuildContext', _kFlutterWidgetsPath);

String _toTitle(String string) {
  return string.replaceFirstMapped(RegExp('[a-zA-Z]'), (match) {
    return match.group(0).toUpperCase();
  });
}

const _kOverrideDecorator = CodeExpression(Code('override'));

/// A generator that outputs widgets from a function
///
/// The function must be decorated by `@widget` and be a top level function.
/// The type of the widget is infered by the arguments of the function and defaults
/// to `StatelessWidget`
class FunctionalWidgetGenerator
    extends GeneratorForAnnotation<FunctionalWidget> {
  final _emitter = DartEmitter();

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! FunctionElement) {
      throw InvalidGenerationSourceError(
        'Error, the decorated element is not a function',
        element: element,
      );
    }
    var function = element as FunctionElement;
    if (function.isAsynchronous ||
        function.isExternal ||
        function.isGenerator ||
        function.returnType?.displayName != 'Widget') {
      throw InvalidGenerationSourceError(
        'Invalid prototype. The function must be synchronous, top level, and return a Widget',
        element: function,
      );
    }
    final className = _toTitle(function.name);
    if (className == function.name) {
      throw InvalidGenerationSourceError(
        'The function name must start with a lowercase',
        element: function,
      );
    }

    final type = parseFunctionalWidetAnnotation(annotation);

    return _functionToWidgetClass(function, type).accept(_emitter).toString();
  }
}

Spec _functionToWidgetClass(
    FunctionElement functionElement, FunctionalWidget annotation) {
  final function = _functionElementToMethod(functionElement);
  final params = List<Parameter>.from(function.requiredParameters)
    ..addAll(function
        .optionalParameters); // _parseParameters(function.parameters).toList();

  final startsWithKey = params.isNotEmpty && _isKey(params.first);
  final startsWithContext = params.isNotEmpty && _isContext(params.first);
  final followedByKey =
      params.length > 1 && startsWithContext && _isKey(params[1]);
  final followedByContext =
      params.length > 1 && startsWithKey && _isContext(params[1]);

  final userFields = (followedByContext || followedByKey)
      ? (List<Parameter>.from(params)..removeRange(0, 2))
      : (startsWithContext || startsWithKey)
          ? (List<Parameter>.from(params)..removeRange(0, 1))
          : params;

  final positional = <Expression>[];
  if (startsWithContext) positional.add(const CodeExpression(Code('_context')));
  if (startsWithKey) positional.add(const CodeExpression(Code('key')));
  if (followedByContext) positional.add(const CodeExpression(Code('_context')));
  if (followedByKey) positional.add(const CodeExpression(Code('key')));
  positional.addAll(userFields
      .where((p) => !p.named)
      .map((p) => CodeExpression(Code(p.name))));

  final named = <String, Expression>{};
  for (final p in userFields.where((p) => p.named)) {
    named[p.name] = CodeExpression(Code(p.name));
  }

  return Class(
    (b) => b
      ..name = _toTitle(functionElement.name)
      ..docs.add(functionElement.documentationComment ?? '')
      ..types
          .addAll(_parseTypeParemeters(functionElement.typeParameters).toList())
      ..extend = annotation.widgetType == FunctionalWidgetType.hook
          ? _hookWidgetRef
          : _statelessWidgetRef
      ..fields.addAll(_paramsToFields(userFields,
          doc: functionElement.documentationComment))
      ..constructors.add(_getConstructor(userFields,
          doc: functionElement.documentationComment))
      ..methods.addAll([
        _createBuildMethod(function, positional, named, functionElement),
        _overrideHashCode(userFields),
        _overrideOperatorEqual(userFields, _toTitle(functionElement.name),
            functionElement.typeParameters),
        _overrideDebugFillProperties(userFields, functionElement.parameters),
      ].where((f) => f != null)),
  );
}

Method _overrideDebugFillProperties(
    List<Parameter> userFields, List<ParameterElement> elements) {
  return userFields.isEmpty
      ? null
      : Method((b) => b
        ..annotations.add(_kOverrideDecorator)
        ..name = 'debugFillProperties'
        ..requiredParameters.add(
          Parameter((b) => b
            ..name = 'properties'
            ..type = refer('DiagnosticPropertiesBuilder')),
        )
        ..returns = refer('void')
        ..lambda = false
        ..body = Block.of(
          [const Code('super.debugFillProperties(properties);')]..addAll(
              userFields.map((f) => _parameterToDiagnostic(
                  f, elements.firstWhere((e) => e.name == f.name)))),
        ));
}

Code _parameterToDiagnostic(Parameter parameter, ParameterElement element) {
  String propertyType;
  switch (parameter.type.symbol) {
    case 'int':
      propertyType = 'IntProperty';
      break;
    case 'double':
      propertyType = 'DoubleProperty';
      break;
    case 'String':
      propertyType = 'StringProperty';
      break;
    // TODO: Duration
    default:
      if (element.type != null) {
        if (element.type.element is ClassElement) {
          final clasElement = element.type.element as ClassElement;
          if (clasElement.isEnum) {
            propertyType = 'EnumProperty<${element.type.displayName}>';
            break;
          }
        }
        final kind = element.type.element?.kind;
        if (kind == ElementKind.FUNCTION ||
            kind == ElementKind.FUNCTION_TYPE_ALIAS ||
            kind == ElementKind.GENERIC_FUNCTION_TYPE) {
          // TODO: find a way to remove this dynamic
          propertyType = 'ObjectFlagProperty<dynamic>.has';
          break;
        }

        propertyType =
            'DiagnosticsProperty<${element.type.isUndefined ? element.computeNode().beginToken : element.type.displayName}>';
        break;
      }
      propertyType = 'DiagnosticsProperty';
  }

  return Code(
      "properties.add($propertyType('${parameter.name}', ${parameter.name}));");
}

Method _overrideOperatorEqual(List<Parameter> userFields, String className,
    List<TypeParameterElement> typeParameters) {
  return userFields.isEmpty
      ? null
      : Method(
          (b) => b
            ..annotations.add(_kOverrideDecorator)
            ..returns = refer('bool')
            ..name = 'operator=='
            ..lambda = true
            ..requiredParameters.add(
              Parameter(
                (b) => b
                  ..name = 'o'
                  ..type = refer('Object'),
              ),
            )
            ..body = Code(
                'identical(o, this) || (o is $className${typeParameters.isEmpty ? '' : '<${typeParameters.map((t) => t.displayName).join(', ')}>'} && ${userFields.map((f) => f.name).map((name) => '$name == o.$name').join(' &&')})'),
        );
}

Method _overrideHashCode(List<Parameter> userFields) {
  return userFields.isEmpty
      ? null
      : Method((b) => b
        ..annotations.add(_kOverrideDecorator)
        ..returns = refer('int')
        ..name = 'hashCode'
        ..type = MethodType.getter
        ..lambda = true
        ..body = userFields.length == 1
            ? Code('${userFields.first.name}.hashCode')
            : Code('hashValues(${userFields.map((f) => f.name).join(', ')})'));
}

Method _createBuildMethod(Method t, List<Expression> positional,
    Map<String, Expression> named, FunctionElement function) {
  return Method(
    (b) => b
      ..name = 'build'
      ..annotations.add(_kOverrideDecorator)
      ..returns = _widgetRef
      ..requiredParameters.add(
        Parameter((b) => b
          ..name = '_context'
          ..type = _buildContextRef),
      )
      ..body = CodeExpression(Code(t.name))
          .call(
              positional,
              named,
              function.typeParameters
                  ?.map((p) => refer(p.displayName))
                  ?.toList())
          .code,
  );
}

Iterable<Reference> _parseTypeParemeters(
  List<TypeParameterElement> typeParameters,
) {
  return typeParameters?.map((e) {
        return e.bound?.displayName != null
            ? refer('${e.displayName} extends ${e.bound.displayName}')
            : refer(e.displayName);
      }) ??
      [];
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

Constructor _getConstructor(List<Parameter> fields, {String doc}) {
  return Constructor(
    (b) => b
      ..constant = true
      ..optionalParameters.add(Parameter((b) => b
        ..named = true
        ..name = 'key'
        ..docs.clear()
        ..type = _keyRef))
      ..docs.add(doc ?? '')
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

bool _isKey(Parameter param) => param.type?.symbol == 'Key';

bool _isContext(Parameter param) =>
    param.type?.symbol == 'BuildContext' || param.type?.symbol == 'HookContext';

Iterable<Field> _paramsToFields(List<Parameter> params, {String doc}) sync* {
  for (final param in params) {
    yield Field(
      (b) => b
        ..name = param.name
        ..modifier = FieldModifier.final$
        ..docs.add(doc ?? '')
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
    final functionTyped = type.element as FunctionTypedElement;
    final t = _functionTypedElementToFunctionType(functionTyped);
    return t.type;
  }

  return type.displayName != null ? refer(type.displayName) : null;
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
