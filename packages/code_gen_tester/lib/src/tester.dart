import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_gen_tester/src/analysis_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:package_config/src/package_config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

Future<void> expectGenerate(
  SourceGenTester tester,
  Generator generator,
  Matcher matcher, {
  BuildStep? buildStep,
  String? reason,
  dynamic skip,
}) async {
  await expectLater(
    Future.microtask(() => tester.generateFor(generator, buildStep)),
    matcher,
    reason: reason,
    skip: skip,
  );
}

Future<void> expectGenerateNamed(
  SourceGenTester tester,
  String name,
  GeneratorForAnnotation generator,
  Matcher matcher, {
  BuildStep? buildStep,
  String? reason,
  dynamic skip,
}) async {
  await expectLater(
    Future.microtask(() => tester.generateForName(generator, name, buildStep)),
    matcher,
    reason: reason,
    skip: skip,
  );
}

final Map<String, LibraryReader> _cacheLibrary = {};

abstract class SourceGenTester {
  static Future<SourceGenTester> fromPath(String path) async {
    var libraryReader = _cacheLibrary[path];
    if (libraryReader == null) {
      libraryReader = await resolveCompilationUnit(path);
      _cacheLibrary[path] = libraryReader;
    }
    return _SourceGenTesterImpl(libraryReader);
  }

  Future<String> generateFor(Generator generator, [BuildStep? buildStep]);
  Future<String> generateForName(GeneratorForAnnotation generator, String name,
      [BuildStep? buildStep]);
}

class _SourceGenTesterImpl implements SourceGenTester {
  final LibraryReader library;
  final formatter = DartFormatter(languageVersion: Version(2, 12, 0));

  _SourceGenTesterImpl(this.library);

  @override
  Future<String> generateFor(
    Generator generator, [
    BuildStep? buildStep,
  ]) async {
    final generated =
        await generator.generate(library, buildStep ?? _BuildStepImpl());
    final output = formatter.format(generated!);
    printOnFailure('''
Generator ${generator.runtimeType} generated:
```
$output
```
''');
    return output;
  }

  @override
  Future<String> generateForName(GeneratorForAnnotation generator, String name,
      [BuildStep? buildStep]) async {
    final e = library
        .annotatedWith(generator.typeChecker)
        .firstWhere((e) => e.element.name == name);
    final dynamic generated = await generator.generateForAnnotatedElement(
      e.element,
      e.annotation,
      buildStep ?? _BuildStepImpl(),
    );

    final output = formatter.format(generated.toString());
    printOnFailure('''
Generator ${generator.runtimeType} generated:
```
$output
```
''');
    return output;
  }
}

Matcher throwsInvalidGenerationSourceError([dynamic messageMatcher]) {
  var c = const TypeMatcher<InvalidGenerationSourceError>()
      .having((e) => e.element, 'element', isNotNull);

  if (messageMatcher != null) {
    c = c.having((e) => e.message, 'message', messageMatcher);
  }
  return throwsA(c);
}

// ignore: subtype_of_sealed_class
class _BuildStepImpl implements BuildStep {
  @override
  AssetId get inputId => throw UnimplementedError();

  @override
  Future<LibraryElement> get inputLibrary => throw UnimplementedError();

  @override
  Resolver get resolver => _ResolverImpl();

  @override
  Future<bool> canRead(AssetId id) {
    throw UnimplementedError();
  }

  @override
  Future<Digest> digest(AssetId id) {
    throw UnimplementedError();
  }

  @override
  Future<T> fetchResource<T>(Resource<T> resource) {
    throw UnimplementedError();
  }

  @override
  Stream<AssetId> findAssets(Glob glob) {
    throw UnimplementedError();
  }

  @override
  Future<List<int>> readAsBytes(AssetId id) {
    throw UnimplementedError();
  }

  @override
  Future<String> readAsString(AssetId id, {Encoding encoding = utf8}) {
    throw UnimplementedError();
  }

  @override
  void reportUnusedAssets(Iterable<AssetId> ids) {}

  @override
  T trackStage<T>(String label, T Function() action,
      {bool isExternal = false}) {
    throw UnimplementedError();
  }

  @override
  Future<void> writeAsBytes(AssetId id, FutureOr<List<int>> bytes) {
    throw UnimplementedError();
  }

  @override
  Future<void> writeAsString(
    AssetId id,
    FutureOr<String> contents, {
    Encoding encoding = utf8,
  }) {
    throw UnimplementedError();
  }

  @override
  Iterable<AssetId> get allowedOutputs => throw UnimplementedError();

  @override
  Future<PackageConfig> get packageConfig => throw UnimplementedError();
}

class _ResolverImpl implements Resolver {
  @override
  Future<AssetId> assetIdForElement(Element element) {
    throw UnimplementedError();
  }

  @override
  Future<AstNode?> astNodeFor(Element element, {bool resolve = false}) {
    return Future.error('UnimplementedError');
  }

  @override
  Future<CompilationUnit> compilationUnitFor(AssetId assetId,
      {bool allowSyntaxErrors = false}) {
    throw UnimplementedError();
  }

  @override
  Future<LibraryElement?> findLibraryByName(String libraryName) {
    throw UnimplementedError();
  }

  @override
  Future<bool> isLibrary(AssetId assetId) {
    throw UnimplementedError();
  }

  @override
  Stream<LibraryElement> get libraries => throw UnimplementedError();

  @override
  Future<LibraryElement> libraryFor(AssetId assetId,
      {bool allowSyntaxErrors = false}) {
    throw UnimplementedError();
  }
}
