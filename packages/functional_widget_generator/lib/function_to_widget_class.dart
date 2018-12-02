import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:functional_widget/functional_widget.dart';
import 'package:code_builder/code_builder.dart';

String toTitle(String string) {
  return string.replaceFirstMapped(RegExp('[a-zA-Z]'), (match) {
    return match.group(0).toUpperCase();
  });
}

class MyGenerator extends GeneratorForAnnotation {
  final _emitter = DartEmitter();

  TypeChecker get typeChecker => TypeChecker.fromRuntime(widget.runtimeType);

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return _functionToWidgetClass(element).accept(_emitter).toString();
  }
}

const _kFlutterWidgetsPath = 'package:flutter/material.dart';
const _kHookWidgetsPath = 'package:flutter_hooks/flutter_hooks.dart';

final widgetRef = refer('Widget', _kFlutterWidgetsPath);
final statelessWidgetRef = refer('StatelessWidget', _kFlutterWidgetsPath);
final hookWidgetRef = refer('HookWidget', _kHookWidgetsPath);
final hookContextRef = refer('HookContext', _kHookWidgetsPath);
final keyRef = refer('Key', _kFlutterWidgetsPath);
final buildContextRef = refer('BuildContext', _kFlutterWidgetsPath);

enum WidgetType { stateless, hook }

Class _functionToWidgetClass(FunctionElement element) {
  FunctionElement function = element;
  if (function.isAsynchronous ||
      function.isExternal ||
      function.isGenerator ||
      !function.isStatic ||
      function.isAbstract) {
    throw ArgumentError();
  }
  final className = toTitle(function.name);
  if (className == function.name) {
    throw ArgumentError("The function name must start with a lowercase");
  }

  final params = _parseParameters(element.parameters).toList();

  final startsWithKey = params.length > 0 && isKey(params.first);
  final startsWithContext = params.length > 0 && isContext(params.first);
  final followedByKey =
      params.length > 1 && startsWithContext && isKey(params[1]);
  final followedByContext =
      params.length > 1 && startsWithKey && isContext(params[1]);

  final widgetType =
      hasHookContext(params) ? WidgetType.hook : WidgetType.stateless;

  final List<Parameter> fields = (followedByContext || followedByKey)
      ? (List.from(params)..removeRange(0, 2))
      : (startsWithContext || startsWithKey)
          ? (List.from(params)..removeRange(0, 1))
          : params;

  return Class(
    (b) => b
      ..name = toTitle(function.name)
      ..extend =
          widgetType == WidgetType.hook ? hookWidgetRef : statelessWidgetRef
      ..fields.addAll(_paramsToFields(fields))
      ..constructors.add(Constructor(
        (b) => b
          ..constant = true
          ..optionalParameters.add(Parameter((b) => b
            ..named = true
            ..name = "key"
            ..type = keyRef))
          ..requiredParameters.addAll(
              fields.where((p) => !p.named).map((p) => p.rebuild((b) => b
                ..toThis = true
                ..type = null)))
          ..optionalParameters
              .addAll(fields.where((p) => p.named).map((p) => p.rebuild((b) => b
                ..toThis = true
                ..type = null)))
          ..initializers.add(Code('super(key: key)')),
      ))
      ..methods.add(Method(
        (b) => b
          ..name = "build"
          ..annotations.add(CodeExpression(Code('override')))
          ..returns = widgetRef
          ..requiredParameters.add(
            Parameter((b) => b
              ..name = "_context"
              ..type = widgetType == WidgetType.hook
                  ? hookContextRef
                  : buildContextRef),
          )
          ..body = Code('return ${function.name}(' +
              ([
                startsWithContext ? "_context" : startsWithKey ? "key" : null,
                followedByContext ? "_context" : followedByKey ? "key" : null,
              ]
                    ..addAll(fields.where((f) => !f.named).map((f) => f.name))
                    ..addAll(fields
                        .where((f) => f.named)
                        .map((f) => '${f.name}: ${f.name}')))
                  .where((s) => s != null)
                  .join(', ') +
              ');'),
      )),
  );
}

bool hasHookContext(List<Parameter> params) {
  return (params.length > 0 && params.first.type?.symbol == "HookContext") ||
      (params.length > 1 && params[1].type?.symbol == "HookContext");
}

bool isKey(Parameter param) => param.type?.symbol == "Key";

bool isContext(Parameter param) =>
    param.type?.symbol == "BuildContext" || param.type?.symbol == "HookContext";

Iterable<Field> _paramsToFields(List<Parameter> params) sync* {
  for (final param in params) {
    yield Field(
      (b) => b
        ..name = param.name
        ..modifier = FieldModifier.final$
        ..type = param.type,
    );
  }
}

Iterable<Parameter> _parseParameters(List<ParameterElement> parameters) sync* {
  for (final parameter in parameters) {
    yield Parameter(
      (b) => b
        ..name = parameter.name
        ..named = parameter.isNamed
        ..type = parameter.type?.displayName != null
            ? refer(parameter.type.displayName)
            : null,
    );
  }
}
