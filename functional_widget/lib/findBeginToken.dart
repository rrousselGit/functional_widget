import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

String findBeginToken(ParameterElement element) {
  final parsedLibrary =
      element.session.getParsedLibraryByElement(element.library);
  final declaration = parsedLibrary.getElementDeclaration(element);
  final parameter = declaration.node;
  if (parameter is SimpleFormalParameter && parameter.type != null) {
    return parameter.type.beginToken.toString();
  }
  return 'dynamic';
}
