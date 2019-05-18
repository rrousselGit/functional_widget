import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart' as element_type;
import 'package:code_builder/code_builder.dart';
import 'package:functional_widget/findBeginToken.dart';

class FunctionParameters {
  FunctionParameters._(this._parameters);

  factory FunctionParameters.parseFunctionElement(FunctionElement element) {
    return FunctionParameters._(
        element.parameters.map(_parseParameter).toList());
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
    var token = findBeginToken(element);
    return refer(token.toString());
  }

  return _typeToReference(element.type);
}

Reference _typeToReference(element_type.DartType type) {
  if (type == null) {
    return null;
  }
  if (type is element_type.FunctionType) {
    // final functionTyped = type.element as FunctionTypedElement;
    final t = _functionTypedElementToFunctionType(type);
    return t.type;
  }

  return type.displayName != null ? refer(type.displayName) : null;
}

FunctionType _functionTypedElementToFunctionType(
  element_type.FunctionType element,
) {
  return FunctionType((b) {
    return b
      ..returnType = _typeToReference(element.returnType)
      ..types.addAll(element.typeFormals.map((f) => _typeToReference(f.type)))
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
          .map((p) => p.type));
  });
}
