import 'package:build/build.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:test/test.dart';
import 'package:functional_widget/src/utils.dart';

void main() {
  group('parseOptions', () {
    test('fails for anything unknown', () {
      expect(
        () => parseBuilderOptions(const BuilderOptions(<String, dynamic>{'foo': 42})),
        throwsA(const TypeMatcher<ArgumentError>()
            .having((f) => f.message, 'message', 'Unknown option `foo`: 42')),
      );
      expect(
        () => parseBuilderOptions(const BuilderOptions(<String, dynamic>{'bar': 'foo'})),
        throwsA(const TypeMatcher<ArgumentError>()
            .having((f) => f.message, 'message', 'Unknown option `bar`: foo')),
      );
    });
    group('debugFillProperties', () {
      test('default to null', () {
        expect(
          parseBuilderOptions(const BuilderOptions(<String, dynamic>{})).debugFillProperties,
          null,
        );
      });

      test('throws if not bool', () {
        expect(
          () => parseBuilderOptions(
              const BuilderOptions(<String, dynamic>{'debugFillProperties': 42})),
          throwsArgumentError,
        );
      });
      test('parses valid value', () {
        expect(
          parseBuilderOptions(
                  const BuilderOptions(<String, dynamic>{'debugFillProperties': true}))
              .debugFillProperties,
          true,
        );
        expect(
          parseBuilderOptions(
                  const BuilderOptions(<String, dynamic>{'debugFillProperties': false}))
              .debugFillProperties,
          false,
        );
      });
    });
    group('equality', () {
      test('default to null', () {
        expect(parseBuilderOptions(const BuilderOptions(<String, dynamic>{})).equality, null);
      });
      test('throws if string but not valid', () {
        expect(
          () => parseBuilderOptions(const BuilderOptions(<String, dynamic>{'equality': 'foo'})),
          throwsArgumentError,
        );
      });
      test('throws if not string', () {
        expect(
          () => parseBuilderOptions(const BuilderOptions(<String, dynamic>{'equality': 42})),
          throwsArgumentError,
        );
      });
      test('parses valid value', () {
        expect(
          parseBuilderOptions(const BuilderOptions(<String, dynamic>{'equality': 'none'}))
              .equality,
          FunctionalWidgetEquality.none,
        );

        expect(
          parseBuilderOptions(const BuilderOptions(<String, dynamic>{'equality': 'equal'}))
              .equality,
          FunctionalWidgetEquality.equal,
        );

        expect(
          parseBuilderOptions(const BuilderOptions(<String, dynamic>{'equality': 'identical'}))
              .equality,
          FunctionalWidgetEquality.identical,
        );
      });
    });
    group('widgetType', () {
      test('default to null', () {
        expect(parseBuilderOptions(const BuilderOptions(<String, dynamic>{})).widgetType, null);
      });
      test('throws if string but not valid', () {
        expect(
          () =>
              parseBuilderOptions(const BuilderOptions(<String, dynamic>{'widgetType': 'foo'})),
          throwsArgumentError,
        );
      });
      test('throws if not string', () {
        expect(
          () => parseBuilderOptions(const BuilderOptions(<String, dynamic>{'widgetType': 42})),
          throwsArgumentError,
        );
      });
      test('parses valid value', () {
        expect(
          parseBuilderOptions(const BuilderOptions(<String, dynamic>{'widgetType': 'hook'}))
              .widgetType,
          FunctionalWidgetType.hook,
        );
        expect(
          parseBuilderOptions(const BuilderOptions(<String, dynamic>{'widgetType': 'stateless'}))
              .widgetType,
          FunctionalWidgetType.stateless,
        );
      });
    });
  });
}
