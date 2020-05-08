import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

String findBeginToken(ParameterElement element) {
  final parsedLibrary =
      element.session.getParsedLibraryByElement(element.library);
  final declaration = parsedLibrary.getElementDeclaration(element);
  final parameter = declaration.node as SimpleFormalParameter;
  return parameter.type?.beginToken?.toString() ?? 'dynamic';
}
