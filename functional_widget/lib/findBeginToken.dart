import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

String findBeginToken(ParameterElement element) {
  final parsedLibrary =
      element.session.getParsedLibraryByElement(element.library);
  final node = parsedLibrary.getElementDeclaration(element).node;
  final parameter = (node is DefaultFormalParameter) ? node.parameter : node;
  if (parameter is SimpleFormalParameter && parameter.type != null) {
    return parameter.type.beginToken.toString();
  }
  return 'dynamic';
}
