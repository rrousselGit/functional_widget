import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart' as element_type;
import 'package:code_builder/code_builder.dart';
import 'package:analyzer/dart/ast/ast.dart';

class FunctionParameters {
  FunctionParameters._(this._parameters);

  static Future<FunctionParameters> parseFunctionElement(
      FunctionElement element, BuildStep buildStep) async {
    final parsedParameters =
        element.parameters.map((p) => _parseParameter(p, buildStep));
    final elementParams = await Future.wait(parsedParameters);

    return FunctionParameters._(elementParams.toList());
  }

  final List<Parameter> _parameters;

  bool get startsWithKey => _parameters.isNotEmpty && _isKey(_parameters.first);
  bool get startsWithContext =>
      _parameters.isNotEmpty && _isContext(_parameters.first);
  bool get followedByKey =>
      _parameters.length > 1 && startsWithContext && _isKey(_parameters[1]);
  bool get followedByContext =>
      _parameters.length > 1 && startsWithKey && _isContext(_parameters[1]);

  List<Parameter> get userDefined => (followedByContext || followedByKey)
      ? (List<Parameter>.from(_parameters)..removeRange(0, 2))
      : (startsWithContext || startsWithKey)
          ? (List<Parameter>.from(_parameters)..removeRange(0, 1))
          : _parameters;
}

bool _isKey(Parameter param) => param.type?.symbol == 'Key';

bool _isContext(Parameter param) =>
    param.type?.symbol == 'BuildContext' || param.type?.symbol == 'HookContext';

Future<Parameter> _parseParameter(
    ParameterElement parameter, BuildStep buildStep) async {
  final _type = await _parameterToReference(parameter, buildStep);

  return Parameter(
    (b) => b
      ..name = parameter.name
      ..defaultTo = parameter.defaultValueCode != null
          ? Code(parameter.defaultValueCode!)
          : null
      ..docs.add(parameter.documentationComment ?? '')
      ..annotations.addAll(parameter.metadata.map((meta) {
        // ignore: invalid_use_of_visible_for_testing_member
        return CodeExpression(Code(meta.element!.displayName));
      }))
      ..named = parameter.isNamed
      ..required = parameter.isRequiredNamed
      ..type = _type,
  );
}

Future<Reference> _parameterToReference(
    ParameterElement element, BuildStep buildStep) async {
  if (element.type.isDynamic) {
    return refer(await tryParseDynamicType(element, buildStep));
  }
  final typeToReference = await _typeToReference(element.type, buildStep);

  return typeToReference;
}

Future<Reference> _typeToReference(
    element_type.DartType type, BuildStep buildStep) async {
  if (type is element_type.FunctionType) {
    // final functionTyped = type.element as FunctionTypedElement;
    final t = await _functionTypedElementToFunctionType(type, buildStep);
    return t.type;
  }
  final displayName = type.getDisplayString(withNullability: true);
  return refer(displayName);
}

Future<FunctionType> _functionTypedElementToFunctionType(
    element_type.FunctionType element, BuildStep buildStep) async {
  final _returnType = await _typeToReference(element.returnType, buildStep);
  final _parameterTypes = await Future.wait(element.typeFormals.map(
    (f) => _typeToReference(
        f.instantiate(nullabilitySuffix: NullabilitySuffix.none), buildStep),
  ));
  final _requiredParameterReferences =
      await _mapOrListParameterReferences<Reference>(
    element.parameters,
    (p) => p.isNotOptional,
    (p) => p.type!,
    buildStep,
  );
  final _namedParameterEntries =
      await _mapOrListParameterReferences<MapEntry<String, Reference>>(
    element.parameters,
    (p) => p.isNamed,
    (p) => MapEntry(p.name, p.type!),
    buildStep,
  );
  final _optionalParameterReferences =
      await _mapOrListParameterReferences<Reference>(
    element.parameters,
    (p) => p.isOptionalPositional,
    (p) => p.type!,
    buildStep,
  );

  return FunctionType(
    (b) => b
      ..returnType = _returnType
      ..types.addAll(_parameterTypes)
      ..isNullable = element.nullabilitySuffix == NullabilitySuffix.question
      ..requiredParameters.addAll(_requiredParameterReferences)
      ..namedParameters.addEntries(_namedParameterEntries)
      ..optionalParameters.addAll(_optionalParameterReferences),
  );
}

Future<Iterable<T>> _mapOrListParameterReferences<T>(
  List<ParameterElement> params,
  bool Function(ParameterElement param) filterFunction,
  T Function(Parameter p) mapOrListfunction,
  BuildStep buildStep,
) async {
  final parsedParams = await Future.wait(
    params.where(filterFunction).map((p) => _parseParameter(p, buildStep)),
  );
  final mapOrListParamaterReferences = parsedParams.map<T>(mapOrListfunction);

  return mapOrListParamaterReferences;
}

Future<String> tryParseDynamicType(
    ParameterElement element, BuildStep buildStep) async {
  final node = await buildStep.resolver.astNodeFor(element);
  final parameter = node is DefaultFormalParameter ? node.parameter : node;
  if (parameter is SimpleFormalParameter && parameter.type != null) {
    return parameter.type!.beginToken.toString();
  }
  return 'dynamic';
}
