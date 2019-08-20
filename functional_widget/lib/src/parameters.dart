import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

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
      ..defaultTo = parameter.defaultValueCode != null
          ? Code.scope((_) => parameter.defaultValueCode)
          : null
      ..docs.add(parameter.documentationComment ?? '')
      ..annotations.addAll(parameter.metadata.map((meta) {
        return CodeExpression(Code(meta.element.displayName));
      }))
      ..named = parameter.isNamed
      ..type = _parameterToReference(parameter),
  );
}

Reference _parameterToReference(ParameterElement element) =>
    _astFormalParameterToReference(findParameterNode(element));

Reference _astFormalParameterToReference(FormalParameter node) {
  if (node is SimpleFormalParameter) {
    return node.type == null ? refer('dynamic') : refer(node.type.toSource());
  }
  if (node is DefaultFormalParameter) {
    return _astFormalParameterToReference(node.parameter);
  }
  return _astFunctionTypedFormalParameterToFunctionType(
      node as FunctionTypedFormalParameter);
}

FunctionType _astFunctionTypedFormalParameterToFunctionType(
  FunctionTypedFormalParameter node,
) {
  return FunctionType((b) {
    return b
      ..returnType = refer(node.returnType.toSource())
      ..types.addAll(node.typeParameters?.typeParameters
              ?.map((f) => refer(f.toSource())) ??
          [])
      ..requiredParameters.addAll(node.parameters.parameters
          .where((p) => !p.isOptional)
          .map(_astFormalParameterToReference))
      ..namedParameters.addEntries(node.parameters.parameters
          .where((p) => p.isNamed)
          .map((p) =>
              MapEntry(p.identifier.name, _astFormalParameterToReference(p))))
      ..optionalParameters.addAll(node.parameters.parameters
          .where((p) => p.isOptionalPositional)
          .map(_astFormalParameterToReference));
  });
}

FormalParameter findParameterNode(ParameterElement element) {
  final parsedLibrary =
      element.session.getParsedLibraryByElement(element.library);
  final declaration = parsedLibrary.getElementDeclaration(element);
  return declaration.node as FormalParameter;
}
