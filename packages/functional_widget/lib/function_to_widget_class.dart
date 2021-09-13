// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:functional_widget/src/parameters.dart';
import 'package:functional_widget/src/utils.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:source_gen/source_gen.dart';

const _kFlutterWidgetsPath = 'package:flutter/material.dart';
const _kHookWidgetsPath = 'package:flutter_hooks/flutter_hooks.dart';
const _kConsumerHookWidgetsPath = 'package:hooks_riverpod/hooks_riverpod.dart';

final _widgetRef = refer('Widget', _kFlutterWidgetsPath);
final _statelessWidgetRef = refer('StatelessWidget', _kFlutterWidgetsPath);
final _hookWidgetRef = refer('HookWidget', _kHookWidgetsPath);
final _consumerHookWidgetRef =
    refer('ConsumerHookWidget', _kConsumerHookWidgetsPath);
final _buildContextRef = refer('BuildContext', _kFlutterWidgetsPath);
final _widgetRefRef = refer('WidgetRef', _kHookWidgetsPath);

final _typeToRefMap = {
  FunctionalWidgetType.hook: _hookWidgetRef,
  FunctionalWidgetType.consumerHook: _consumerHookWidgetRef,
  FunctionalWidgetType.stateless: _statelessWidgetRef,
};

String _toTitle(String string) {
  return string.replaceFirstMapped(RegExp('[a-zA-Z]'), (match) {
    return match.group(0)!.toUpperCase();
  });
}

const _kOverrideDecorator = CodeExpression(Code('override'));

/// A generator that outputs widgets from a function
///
/// The function must be decorated by `@swidget` and be a top level function.
/// The type of the widget is infered by the arguments of the function and defaults
/// to `StatelessWidget`
class FunctionalWidgetGenerator
    extends GeneratorForAnnotation<FunctionalWidget> {
  FunctionalWidgetGenerator([FunctionalWidget? options])
      : _defaultOptions = FunctionalWidget(
          debugFillProperties: options?.debugFillProperties,
          widgetType: options?.widgetType ?? FunctionalWidgetType.stateless,
        );

  final FunctionalWidget _defaultOptions;
  final _emitter = DartEmitter(
    allocator: Allocator.none,
    orderDirectives: false,
    useNullSafetySyntax: true,
  );

  @override
  Future<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    final function = _checkValidElement(element);
    final type = parseFunctionalWidgetAnnotation(annotation);
    final _class =
        await _makeClassFromFunctionElement(function, type, buildStep);

    return _class.accept(_emitter).toString();
  }

  FunctionElement _checkValidElement(Element element) {
    if (element is! FunctionElement) {
      throw InvalidGenerationSourceError(
        'Error, the decorated element is not a function',
        element: element,
      );
    }
    final function = element;
    if (function.isAsynchronous ||
        function.isExternal ||
        function.isGenerator ||
        function.returnType.getDisplayString(withNullability: true) !=
            'Widget') {
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
    return function;
  }

  Future<Spec> _makeClassFromFunctionElement(
    FunctionElement functionElement,
    FunctionalWidget annotation,
    BuildStep buildStep,
  ) async {
    final parameters = await FunctionParameters.parseFunctionElement(
      functionElement,
      buildStep,
    );
    final userDefined = parameters.userDefined;
    final positional = _computeBuildPositionalParametersExpression(parameters);
    final named = _computeBuildNamedParametersExpression(parameters);

    Method? overrideDebugFillProperties;
    if (annotation.debugFillProperties ??
        _defaultOptions.debugFillProperties ??
        false) {
      overrideDebugFillProperties = await _overrideDebugFillProperties(
          userDefined, functionElement.parameters, buildStep);
    }

    return Class(
      (b) {
        final widgetType = annotation.widgetType;
        b
          ..name = _toTitle(functionElement.name)
          ..types.addAll(
              _parseTypeParemeters(functionElement.typeParameters).toList())
          ..extend = _typeToRefMap[widgetType]
          ..fields.addAll(_paramsToFields(userDefined,
              doc: functionElement.documentationComment))
          ..constructors.add(_getConstructor(userDefined,
              doc: functionElement.documentationComment,
              keyIsRequired: parameters.hasNonNullableKey))
          ..methods.add(_createBuildMethod(
            functionElement.displayName,
            positional: positional,
            named: named,
            function: functionElement,
            hasWidgetRefParameter:
                widgetType == FunctionalWidgetType.consumerHook,
          ));
        if (functionElement.documentationComment != null) {
          b.docs.add(functionElement.documentationComment!);
        }
        if (overrideDebugFillProperties != null) {
          b.methods.add(overrideDebugFillProperties);
        }
      },
    );
  }

  Map<String, Expression> _computeBuildNamedParametersExpression(
      FunctionParameters parameters) {
    final named = <String, Expression>{};
    for (final p in parameters.userDefined.where((p) => p.named)) {
      named[p.name] = CodeExpression(Code(p.name));
    }
    return named;
  }

  List<Expression> _computeBuildPositionalParametersExpression(
      FunctionParameters parameters) {
    return <Expression>[
      ...parameters.nonUserDefinedRenamed
          .map((p) => CodeExpression(Code(p.name))),
      ...parameters.userDefined
          .where((p) => !p.named)
          .map((p) => CodeExpression(Code(p.name)))
    ];
  }

  Future<Method?> _overrideDebugFillProperties(List<Parameter> userFields,
      List<ParameterElement> elements, BuildStep buildStep) async {
    if (userFields.isEmpty) {
      return null;
    }

    final _diagnosticProperties = await Future.wait(userFields.map((f) =>
        _parameterToDiagnostic(
            f, elements.firstWhere((e) => e.name == f.name), buildStep)));

    return Method((b) => b
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
        [
          const Code('super.debugFillProperties(properties);'),
          ..._diagnosticProperties,
        ],
      ));
  }

  Future<Code> _parameterToDiagnostic(Parameter parameter,
      ParameterElement element, BuildStep buildStep) async {
    String? propertyType;
    switch (parameter.type!.symbol) {
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
        propertyType = _tryParseClassToEnumDiagnostic(element, propertyType) ??
            _tryParseFunctionToDiagnostic(element, propertyType) ??
            await _getFallbackElementDiagnostic(element, buildStep);
    }

    return Code(
        "properties.add($propertyType('${parameter.name}', ${parameter.name}));");
  }

  Future<String> _getFallbackElementDiagnostic(
      ParameterElement element, BuildStep buildStep) async {
    final parsedDynamicType = await tryParseDynamicType(element, buildStep);
    return 'DiagnosticsProperty<${element.type.isDynamic ? parsedDynamicType : element.type.getDisplayString(withNullability: true)}>';
  }

  String? _tryParseFunctionToDiagnostic(
      ParameterElement element, String? propertyType) {
    final kind = element.type.element?.kind;
    if (kind == ElementKind.FUNCTION ||
        kind == ElementKind.FUNCTION_TYPE_ALIAS ||
        kind == ElementKind.GENERIC_FUNCTION_TYPE) {
      // TODO: find a way to remove this dynamic
      propertyType = 'ObjectFlagProperty<dynamic>.has';
    }
    return propertyType;
  }

  String? _tryParseClassToEnumDiagnostic(
      ParameterElement element, String? propertyType) {
    if (element.type.element is ClassElement) {
      final classElement = element.type.element as ClassElement;
      if (classElement.isEnum) {
        propertyType =
            'EnumProperty<${element.type.getDisplayString(withNullability: true)}>';
      }
    }
    return propertyType;
  }

  Method _createBuildMethod(
    String functionName, {
    required List<Expression> positional,
    required Map<String, Expression> named,
    required FunctionElement function,
    bool hasWidgetRefParameter = false,
  }) {
    return Method(
      (b) => b
        ..name = 'build'
        ..annotations.add(_kOverrideDecorator)
        ..returns = _widgetRef
        ..requiredParameters.addAll([
          Parameter((b) => b
            ..name = FunctionParameters
                .nonUserDefinedNames[_buildContextRef.symbol!]!
            ..type = _buildContextRef),
          if (hasWidgetRefParameter)
            Parameter((b) => b
              ..name =
                  FunctionParameters.nonUserDefinedNames[_widgetRefRef.symbol!]!
              ..type = _widgetRefRef),
        ])
        ..body = CodeExpression(Code(functionName))
            .call(
                positional,
                named,
                function.typeParameters
                    .map((p) => refer(p.displayName))
                    .toList())
            .code,
    );
  }

  Iterable<Reference> _parseTypeParemeters(
    List<TypeParameterElement> typeParameters,
  ) {
    return typeParameters.map((e) {
      final displayName = e.bound?.getDisplayString(withNullability: true);
      return displayName != null
          ? refer('${e.displayName} extends $displayName')
          : refer(e.displayName);
    });
  }

  Constructor _getConstructor(
    List<Parameter> fields, {
    String? doc,
    required bool keyIsRequired,
  }) {
    return Constructor(
      (b) => b
        ..constant = true
        ..optionalParameters.add(Parameter((b) => b
          ..required = keyIsRequired
          ..named = true
          ..name = 'key'
          ..docs.clear()
          ..type = TypeReference((b) => b
            ..symbol = 'Key'
            ..url = _kFlutterWidgetsPath
            ..isNullable = !keyIsRequired)))
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

  Iterable<Field> _paramsToFields(List<Parameter> params, {String? doc}) sync* {
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
}
