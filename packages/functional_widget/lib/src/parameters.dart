import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart' as element_type;
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';

class FunctionParameters {
  FunctionParameters._(this._parameters);

  static const nonUserDefinedTypeSymbols = [
    'Key',
    'Key?',
    'BuildContext',
    'WidgetRef',
    'ThemeData',
  ];
  static const nonUserDefinedNames = {
    'Key': 'key!',
    'Key?': 'key',
    'BuildContext': '_context',
    'WidgetRef': '_ref',
    'ThemeData': 'theme',
  };

  static Future<FunctionParameters> parseFunctionElement(
      FunctionElement element, BuildStep buildStep) async {
    final parsedParameters =
        element.parameters.map((p) => _parseParameter(p, buildStep));
    final elementParams = await Future.wait(parsedParameters);

    return FunctionParameters._(elementParams.toList());
  }

  final List<Parameter> _parameters;

  int get _userDefinedStartIndex {
    final remainingSymbols = nonUserDefinedTypeSymbols.fold<Map<String, bool>>(
      {},
      (acc, symbol) => {...acc, symbol.replaceAll('?', ''): true},
    );

    final index = _parameters.indexWhere((p) {
      final symbol = p.type?.symbol ?? '';
      final symbolWithoutNullable = symbol.replaceAll('?', '');
      final isNonUser = remainingSymbols[symbolWithoutNullable] ?? false;

      if (isNonUser) {
        remainingSymbols[symbolWithoutNullable] = false;
      }

      return !isNonUser;
    });

    return index == -1 ? _parameters.length : index;
  }

  late final List<Parameter> nonUserDefined = _parameters.sublist(
    0,
    _userDefinedStartIndex,
  );

  late final List<Parameter> nonUserDefinedRenamed = nonUserDefined
      .map((p) => Parameter((b) => b
        ..name = nonUserDefinedNames[p.type?.symbol ?? ''] ?? p.name
        ..type = p.type
        ..named = p.named))
      .toList();

  late final String? keySymbol =
      nonUserDefined.firstWhereOrNull(_isKey)?.type?.symbol;
  late final bool hasKey = keySymbol != null;
  late final bool hasNonNullableKey = keySymbol == 'Key';

  late final List<Parameter> userDefined =
      _parameters.sublist(_userDefinedStartIndex);
}

bool _isKey(Parameter param) =>
    param.type?.symbol == 'Key' || param.type?.symbol == 'Key?';

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
        return CodeExpression(Code(meta.toSource().replaceFirst('@', '')));
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
    (p) => p.isRequired,
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
  T Function(Parameter p) mapOrListFunction,
  BuildStep buildStep,
) async {
  final parsedParams = await Future.wait(
    params.where(filterFunction).map((p) => _parseParameter(p, buildStep)),
  );
  final mapOrListParameterReferences = parsedParams.map<T>(mapOrListFunction);

  return mapOrListParameterReferences;
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
