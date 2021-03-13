import 'package:code_gen_tester/code_gen_tester.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:test/test.dart';

void main() {
  final tester = SourceGenTester.fromPath('test/src/fail.dart');

  group('fail', () {
    test('closure', () async {
      await expectGenerateNamed(
        await tester,
        'closure',
        FunctionalWidgetGenerator(),
        throwsInvalidGenerationSourceError(
            'Error, the decorated element is not a function'),
      );
    });

    test('external', () async {
      await expectGenerateNamed(
        await tester,
        'externalTest',
        FunctionalWidgetGenerator(),
        throwsInvalidGenerationSourceError(),
      );
    });

    test('return type not widget', () async {
      await expectGenerateNamed(
        await tester,
        'notAWidget',
        FunctionalWidgetGenerator(),
        throwsInvalidGenerationSourceError(),
      );
    });

    test('name must start with a lowercase', () async {
      await expectGenerateNamed(
        await tester,
        'TitleName',
        FunctionalWidgetGenerator(),
        throwsInvalidGenerationSourceError(),
      );
    });
  });
}
