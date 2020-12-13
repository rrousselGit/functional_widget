import 'package:code_gen_tester/code_gen_tester.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:test/test.dart';

void main() {
  final tester = SourceGenTester.fromPath('test/src/success.dart');

  group('decorators', () {
    test('swidget generate statelesswidget even if default value is hook',
        () async {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(widgetType: FunctionalWidgetType.hook));
      final _expect = (String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);

      await _expect('sWidget', completion('''
class SWidget extends StatelessWidget {
  const SWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => sWidget();
}
'''));
    });

    test('hwidget generate hookwidget even if default value is stateless',
        () async {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(widgetType: FunctionalWidgetType.stateless));
      final _expect = (String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);

      await _expect('hWidget', completion('''
class HWidget extends HookWidget {
  const HWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => hWidget();
}
'''));
    });
    group('@swidget', () {
      test('generate stateless if conf is stateless', () async {
        var _generator = FunctionalWidgetGenerator(
            const FunctionalWidget(widgetType: FunctionalWidgetType.stateless));
        final _expect = (String name, Matcher matcher) async =>
            expectGenerateNamed(await tester, name, _generator, matcher);

        await _expect('adaptiveWidget', completion('''
class AdaptiveWidget extends StatelessWidget {
  const AdaptiveWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => adaptiveWidget();
}
'''));
      });

      test('generate hook if conf is hook', () async {
        var _generator = FunctionalWidgetGenerator(
            const FunctionalWidget(widgetType: FunctionalWidgetType.hook));
        final _expect = (String name, Matcher matcher) async =>
            expectGenerateNamed(await tester, name, _generator, matcher);

        await _expect('adaptiveWidget', completion('''
class AdaptiveWidget extends StatelessWidget {
  const AdaptiveWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => adaptiveWidget();
}
'''));
      });
    });
  });
}
