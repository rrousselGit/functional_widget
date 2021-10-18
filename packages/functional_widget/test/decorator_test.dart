import 'package:code_gen_tester/code_gen_tester.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:matcher/matcher.dart';
import 'package:test/test.dart';

void main() {
  final tester = SourceGenTester.fromPath('test/src/success.dart');

  group('decorators', () {
    test('swidget generates stateless widget even if default value is hook',
        () async {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(widgetType: FunctionalWidgetType.hook));
      final _expect = (String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);

      await _expect('sXWidget', completion('''
class SXWidget extends StatelessWidget {
  const SXWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => sXWidget();
}
'''));
    });

    test('swidget generates private widget from double-private fn', () async {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(widgetType: FunctionalWidgetType.hook));
      final _expect = (String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);

      await _expect('__privateSWidget', completion('''
class _PrivateSWidget extends StatelessWidget {
  const _PrivateSWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => __privateSWidget();
}
'''));
    });

    test('swidget generates public stateless widget from private fn', () async {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(widgetType: FunctionalWidgetType.hook));
      final _expect = (String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);

      await _expect('_publicSWidget', completion('''
class PublicSWidget extends StatelessWidget {
  const PublicSWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => _publicSWidget();
}
'''));
    });

    test('hwidget generate hookwidget even if default value is stateless',
        () async {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(widgetType: FunctionalWidgetType.stateless));
      final _expect = (String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);

      await _expect('hXWidget', completion('''
class HXWidget extends HookWidget {
  const HXWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => hXWidget();
}
'''));
    });

    test('hwidget generates public hook widget from private fn', () async {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(widgetType: FunctionalWidgetType.stateless));
      final _expect = (String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);

      await _expect('_publicHWidget', completion('''
class PublicHWidget extends HookWidget {
  const PublicHWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => _publicHWidget();
}
'''));
    });

    test('hwidget generates private hook widget from double-private fn',
        () async {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(widgetType: FunctionalWidgetType.stateless));
      final _expect = (String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);

      await _expect('__privateHWidget', completion('''
class _PrivateHWidget extends HookWidget {
  const _PrivateHWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => __privateHWidget();
}
'''));
    });

    group('exported private widgets', () {
      test('generate hook if conf is hook', () async {
        var _generator = FunctionalWidgetGenerator(
            const FunctionalWidget(widgetType: FunctionalWidgetType.hook));
        final _expect = (String name, Matcher matcher) async =>
            expectGenerateNamed(await tester, name, _generator, matcher);

        await _expect('adaptiveWidget', completion('''
class AdaptiveWidget extends StatelessWidget {
  const AdaptiveWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => adaptiveWidget();
}
'''));
      });
    });

    group('@swidget', () {
      test('generate stateless if conf is stateless', () async {
        var _generator = FunctionalWidgetGenerator(
            const FunctionalWidget(widgetType: FunctionalWidgetType.stateless));
        final _expect = (String name, Matcher matcher) async =>
            expectGenerateNamed(await tester, name, _generator, matcher);

        await _expect('adaptiveWidget', completion('''
class AdaptiveWidget extends StatelessWidget {
  const AdaptiveWidget({Key? key}) : super(key: key);

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
  const AdaptiveWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => adaptiveWidget();
}
'''));
      });
    });
  });
}
