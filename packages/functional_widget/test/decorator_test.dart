import 'package:code_gen_tester/code_gen_tester.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:matcher/matcher.dart';
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

      await _expect('sXWidget', completion('''
class SXWidget extends StatelessWidget {
  const SXWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => sXWidget();
}
'''));
    });

    test(
        'swidget generate statelesswidget even if default value is hook and private',
        () async {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(widgetType: FunctionalWidgetType.hook));
      final _expect = (String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);

      await _expect('_privateSWidget', completion('''
class _PrivateSWidget extends StatelessWidget {
  const _PrivateSWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => _privateSWidget();
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

    test(
        'hwidget generate hookwidget even if default value is stateless and private',
        () async {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(widgetType: FunctionalWidgetType.stateless));
      final _expect = (String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);

      await _expect('_privateHWidget', completion('''
class _PrivateHWidget extends HookWidget {
  const _PrivateHWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => _privateHWidget();
}
'''));
    });

    group('exported private widgets', () {
      test('sWidget exports private member', () async {
        final _generator = FunctionalWidgetGenerator(
            const FunctionalWidget(widgetType: FunctionalWidgetType.stateless));
        final _expect = (String name, Matcher matcher) async =>
            expectGenerateNamed(await tester, name, _generator, matcher);

        await _expect('_privateButPublicSWidget', completion('''
class PrivateButPublicSWidget extends StatelessWidget {
  const PrivateButPublicSWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => _privateButPublicSWidget();
}
'''));
      });

      test('hWidget exports private member', () async {
        final _generator = FunctionalWidgetGenerator(
            const FunctionalWidget(widgetType: FunctionalWidgetType.stateless));
        final _expect = (String name, Matcher matcher) async =>
            expectGenerateNamed(await tester, name, _generator, matcher);

        await _expect('_privateButPublicHWidget', completion('''
class PrivateButPublicHWidget extends HookWidget {
  const PrivateButPublicHWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => _privateButPublicHWidget();
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
