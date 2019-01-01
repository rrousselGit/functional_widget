import 'package:code_gen_tester/code_gen_tester.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:test/test.dart';

void main() async {
  final tester = await SourceGenTester.fromPath('test/src/fail.dart');

  group('fail', () {
    test('closure', () async {
      await expectGenerateNamed(
        tester,
        'closure',
        FunctionalWidget(),
        throwsInvalidGenerationSourceError(
            'Error, the decorated element is not a function'),
      );
    });
    test('external', () async {
      await expectGenerateNamed(
        tester,
        'externalTest',
        FunctionalWidget(),
        throwsInvalidGenerationSourceError(),
      );
    });
    test('dynamic', () async {
      await expectGenerateNamed(
        tester,
        'dynamicTest',
        FunctionalWidget(),
        throwsInvalidGenerationSourceError(),
      );
      await expectGenerateNamed(
        tester,
        'implicitDynamic',
        FunctionalWidget(),
        throwsInvalidGenerationSourceError(),
      );
    });
    test('async', () async {
      await expectGenerateNamed(
        tester,
        'asyncTest',
        FunctionalWidget(),
        throwsInvalidGenerationSourceError(),
      );
    });
    test('return type not widget', () async {
      await expectGenerateNamed(
        tester,
        'notAWidget',
        FunctionalWidget(),
        throwsInvalidGenerationSourceError(),
      );
    });

    test('name must start with a lowercase', () async {
      await expectGenerateNamed(
        tester,
        'TitleName',
        FunctionalWidget(),
        throwsInvalidGenerationSourceError(),
      );
    });
  });
}
