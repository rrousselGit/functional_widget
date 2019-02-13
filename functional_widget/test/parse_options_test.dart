import 'package:build/build.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:test/test.dart';
import 'package:functional_widget/src/utils.dart';

void main() {
  group('parseOptions', () {
    test('fails for anything unknown', () {
      expect(
        () => parseBuilderOptions(const BuilderOptions({'foo': 42})),
        throwsA(const TypeMatcher<ArgumentError>()
            .having((f) => f.message, 'message', 'Unknown option `foo`: 42')),
      );
      expect(
        () => parseBuilderOptions(const BuilderOptions({'bar': 'foo'})),
        throwsA(const TypeMatcher<ArgumentError>()
            .having((f) => f.message, 'message', 'Unknown option `bar`: foo')),
      );
    });
    group('debugFillProperties', () {
      test('default to null', () {
        expect(
          parseBuilderOptions(const BuilderOptions({})).debugFillProperties,
          null,
        );
      });

      test('throws if not bool', () {
        expect(
          () => parseBuilderOptions(
              const BuilderOptions({'debugFillProperties': 42})),
          throwsArgumentError,
        );
      });
      test('parses valid value', () {
        expect(
          parseBuilderOptions(
                  const BuilderOptions({'debugFillProperties': true}))
              .debugFillProperties,
          true,
        );
        expect(
          parseBuilderOptions(
                  const BuilderOptions({'debugFillProperties': false}))
              .debugFillProperties,
          false,
        );
      });
    });
    group('equality', () {
      test('default to null', () {
        expect(parseBuilderOptions(const BuilderOptions({})).equality, null);
      });
      test('throws if string but not valid', () {
        expect(
          () => parseBuilderOptions(const BuilderOptions({'equality': 'foo'})),
          throwsArgumentError,
        );
      });
      test('throws if not string', () {
        expect(
          () => parseBuilderOptions(const BuilderOptions({'equality': 42})),
          throwsArgumentError,
        );
      });
      test('parses valid value', () {
        expect(
          parseBuilderOptions(const BuilderOptions({'equality': 'none'}))
              .equality,
          FunctionalWidgetEquality.none,
        );

        expect(
          parseBuilderOptions(const BuilderOptions({'equality': 'equal'}))
              .equality,
          FunctionalWidgetEquality.equal,
        );

        expect(
          parseBuilderOptions(const BuilderOptions({'equality': 'identical'}))
              .equality,
          FunctionalWidgetEquality.identical,
        );
      });
    });
    group('widgetType', () {
      test('default to null', () {
        expect(parseBuilderOptions(const BuilderOptions({})).widgetType, null);
      });
      test('throws if string but not valid', () {
        expect(
          () =>
              parseBuilderOptions(const BuilderOptions({'widgetType': 'foo'})),
          throwsArgumentError,
        );
      });
      test('throws if not string', () {
        expect(
          () => parseBuilderOptions(const BuilderOptions({'widgetType': 42})),
          throwsArgumentError,
        );
      });
      test('parses valid value', () {
        expect(
          parseBuilderOptions(const BuilderOptions({'widgetType': 'hook'}))
              .widgetType,
          FunctionalWidgetType.hook,
        );
        expect(
          parseBuilderOptions(const BuilderOptions({'widgetType': 'stateless'}))
              .widgetType,
          FunctionalWidgetType.stateless,
        );
      });
    });
  });
}
