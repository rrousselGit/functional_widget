import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';

Token findBeginToken(ParameterElement element) {
  final parsedLibrary =
      element.session.getParsedLibraryByElement(element.library);
  final declaration = parsedLibrary.getElementDeclaration(element);
  final parameter = declaration.node as FormalParameter;
  return parameter.beginToken;
}
