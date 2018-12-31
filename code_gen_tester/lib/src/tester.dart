import 'package:build/build.dart';
import 'package:code_gen_tester/src/analysis_utils.dart';
import 'package:dart_style/dart_style.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void testGenerate(
  String description,
  Future<void> callback(SourceGenTester tester), {
  @required String path,
  String testOn,
  Timeout timeout,
  dynamic skip,
  dynamic tags,
  Map<String, dynamic> onPlatform,
  int retry,
}) {
  test(
    description,
    () async {
      assert(path != null);
      final tester = await SourceGenTester.fromPath(path);
      await callback(tester);
    },
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

Future<void> expectGenerate(
  SourceGenTester tester,
  Generator generator,
  Matcher matcher, {
  BuildStep buildStep,
  String reason,
  dynamic skip,
}) async {
  await expectLater(
    () => tester.generateFor(generator, buildStep),
    matcher,
    reason: reason,
    skip: skip,
  );
}

abstract class SourceGenTester {
  factory SourceGenTester(LibraryReader library) = _SourceGenTesterImpl;

  static Future<SourceGenTester> fromPath(String path) async {
    return SourceGenTester(await resolveCompilationUnit(path));
  }

  Future<String> generateFor(Generator generator, BuildStep step);
}

class _SourceGenTesterImpl implements SourceGenTester {
  final LibraryReader library;
  final formatter = DartFormatter();

  _SourceGenTesterImpl(this.library);

  @override
  Future<String> generateFor(Generator generator, [BuildStep step]) async {
    final generated = await generator.generate(library, step);
    final output = formatter.format(generated);
    printOnFailure('''
Generator ${generator.runtimeType} generated:
```
$output
```
''');
    return output;
  }
}
