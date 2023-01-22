import 'package:code_gen_tester/code_gen_tester.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:test/test.dart';

void main() {
  final tester = SourceGenTester.fromPath('test/src/success.dart');

  final _generator = FunctionalWidgetGenerator();
  final _expect = (String name, Matcher matcher) async =>
      expectGenerateNamed(await tester, name, _generator, matcher);
  group('success', () {
    test('noArgument', () async {
      await _expect('noArgument', completion('''
class NoArgument extends StatelessWidget {
  const NoArgument({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => noArgument();
}
'''));
    });

    test('namedDefault', () async {
      await _expect('namedDefault', completion('''
class NamedDefault extends StatelessWidget {
  const NamedDefault({
    Key? key,
    this.foo = 42,
  }) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => namedDefault(foo: foo);
}
'''));
    });

    test('context', () async {
      await _expect('withContext', completion('''
class WithContext extends StatelessWidget {
  const WithContext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withContext(_context);
}
'''));
    });

    test('key', () async {
      await _expect('withKey', completion('''
class WithKey extends StatelessWidget {
  const WithKey({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withKey(key!);
}
'''));
    });

    test('nullable key', () async {
      await _expect('withNullableKey', completion('''
class WithNullableKey extends StatelessWidget {
  const WithNullableKey({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withNullableKey(key);
}
'''));
    });

    test('context then key', () async {
      await _expect('withContextThenKey', completion('''
class WithContextThenKey extends StatelessWidget {
  const WithContextThenKey({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withContextThenKey(
        _context,
        key!,
      );
}
'''));
    });

    test('context then key then arg', () async {
      await _expect('withContextThenKeyThenOneArg', completion('''
class WithContextThenKeyThenOneArg extends StatelessWidget {
  const WithContextThenKeyThenOneArg(
    this.foo, {
    required Key key,
  }) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => withContextThenKeyThenOneArg(
        _context,
        key!,
        foo,
      );
}
'''));
    });

    test('context then context', () async {
      await _expect('withContextThenContext', completion('''
class WithContextThenContext extends StatelessWidget {
  const WithContextThenContext(
    this.context2, {
    Key? key,
  }) : super(key: key);

  final BuildContext context2;

  @override
  Widget build(BuildContext _context) => withContextThenContext(
        _context,
        context2,
      );
}
'''));
    });

    test('theme data', () async {
      await _expect('withThemeData', completion('''
class WithThemeData extends StatelessWidget {
  const WithThemeData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withThemeData(Theme.of(_context));
}
'''));
    });

    test('key then context', () async {
      await _expect('withKeyThenContext', completion('''
class WithKeyThenContext extends StatelessWidget {
  const WithKeyThenContext({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withKeyThenContext(
        key!,
        _context,
      );
}
'''));
    });

    test('context then theme data', () async {
      await _expect('withContextThenThemeData', completion('''
class WithContextThenThemeData extends StatelessWidget {
  const WithContextThenThemeData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withContextThenThemeData(
        _context,
        Theme.of(_context),
      );
}
'''));
    });

    test('theme data then context', () async {
      await _expect('withThemeDataThenContext', completion('''
class WithThemeDataThenContext extends StatelessWidget {
  const WithThemeDataThenContext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withThemeDataThenContext(
        Theme.of(_context),
        _context,
      );
}
'''));
    });

    test('key then theme data', () async {
      await _expect('withKeyThenThemeData', completion('''
class WithKeyThenThemeData extends StatelessWidget {
  const WithKeyThenThemeData({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withKeyThenThemeData(
        key!,
        Theme.of(_context),
      );
}
'''));
    });

    test('key then context then theme data', () async {
      await _expect('withKeyThenContextThenThemeData', completion('''
class WithKeyThenContextThenThemeData extends StatelessWidget {
  const WithKeyThenContextThenThemeData({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withKeyThenContextThenThemeData(
        key!,
        _context,
        Theme.of(_context),
      );
}
'''));
    });

    test('key then context then arg', () async {
      await _expect('withKeyThenContextThenOneArg', completion('''
class WithKeyThenContextThenOneArg extends StatelessWidget {
  const WithKeyThenContextThenOneArg(
    this.foo, {
    required Key key,
  }) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => withKeyThenContextThenOneArg(
        key!,
        _context,
        foo,
      );
}
'''));
    });

    test('key then context then theme data then arg', () async {
      await _expect('withKeyThenContextThenThemeDataThenOneArg', completion('''
class WithKeyThenContextThenThemeDataThenOneArg extends StatelessWidget {
  const WithKeyThenContextThenThemeDataThenOneArg(
    this.foo, {
    required Key key,
  }) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) =>
      withKeyThenContextThenThemeDataThenOneArg(
        key!,
        _context,
        Theme.of(_context),
        foo,
      );
}
'''));
    });

    test('key then key', () async {
      await _expect('withKeyThenKey', completion('''
class WithKeyThenKey extends StatelessWidget {
  const WithKeyThenKey(
    this.key2, {
    Key? key,
  }) : super(key: key);

  final Key key2;

  @override
  Widget build(BuildContext _context) => withKeyThenKey(
        key,
        key2,
      );
}
'''));
    });

    test('whatever then context', () async {
      await _expect('whateverThenContext', completion('''
class WhateverThenContext extends StatelessWidget {
  const WhateverThenContext(
    this.foo,
    this.bar, {
    Key? key,
  }) : super(key: key);

  final int foo;

  final BuildContext bar;

  @override
  Widget build(BuildContext _context) => whateverThenContext(
        foo,
        bar,
      );
}
'''));
    });

    test('whatever then key', () async {
      await _expect('whateverThenKey', completion('''
class WhateverThenKey extends StatelessWidget {
  const WhateverThenKey(
    this.foo,
    this.bar, {
    Key? key,
  }) : super(key: key);

  final int foo;

  final Key bar;

  @override
  Widget build(BuildContext _context) => whateverThenKey(
        foo,
        bar,
      );
}
'''));
    });

    test('whatever then theme data', () async {
      await _expect('whateverThenThemeData', completion('''
class WhateverThenThemeData extends StatelessWidget {
  const WhateverThenThemeData(
    this.foo,
    this.bar, {
    Key? key,
  }) : super(key: key);

  final int foo;

  final ThemeData bar;

  @override
  Widget build(BuildContext _context) => whateverThenThemeData(
        foo,
        bar,
      );
}
'''));
    });

    test('documentation', () async {
      await _expect('documentation', completion('''
/// Hello
/// World
class Documentation extends StatelessWidget {
  /// Hello
  /// World
  const Documentation(
    this.foo, {
    Key? key,
  }) : super(key: key);

  /// Hello
  /// World
  final int foo;

  @override
  Widget build(BuildContext _context) => documentation(foo);
}
'''));
    });

    test('required', () async {
      await _expect('withRequired', completion('''
class WithRequired extends StatelessWidget {
  const WithRequired({
    Key? key,
    required this.foo,
  }) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => withRequired(foo: foo);
}
'''));
    });

    test('optional', () async {
      await _expect('withOptional', completion('''
class WithOptional extends StatelessWidget {
  const WithOptional({
    Key? key,
    this.foo,
  }) : super(key: key);

  final int? foo;

  @override
  Widget build(BuildContext _context) => withOptional(foo: foo);
}
'''));
    });

    test('positional optional', () async {
      await _expect('withPositionalOptional', completion('''
class WithPositionalOptional extends StatelessWidget {
  const WithPositionalOptional(
    this.foo, {
    Key? key,
  }) : super(key: key);

  final int? foo;

  @override
  Widget build(BuildContext _context) => withPositionalOptional(foo);
}
'''));
    });

    test('hook widget', () async {
      await _expect('hookExample', completion('''
class HookExample extends HookWidget {
  const HookExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => hookExample();
}
'''));
    });

    test('consumer hook widget', () async {
      await _expect('hookConsumerExample', completion('''
class HookConsumerExample extends HookConsumerWidget {
  const HookConsumerExample({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext _context,
    WidgetRef _ref,
  ) =>
      hookConsumerExample();
}
'''));
    });

    test('consumer hook widget with WidgetRef', () async {
      await _expect('hookConsumerExampleWithRef', completion('''
class HookConsumerExampleWithRef extends HookConsumerWidget {
  const HookConsumerExampleWithRef({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext _context,
    WidgetRef _ref,
  ) =>
      hookConsumerExampleWithRef(_ref);
}
'''));
    });

    test('consumer hook widget with WidgetRef and BuildContext', () async {
      await _expect('hookConsumerExampleWithRefAndContext', completion('''
class HookConsumerExampleWithRefAndContext extends HookConsumerWidget {
  const HookConsumerExampleWithRefAndContext({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext _context,
    WidgetRef _ref,
  ) =>
      hookConsumerExampleWithRefAndContext(
        _ref,
        _context,
      );
}
'''));
    });

    test('consumer widget', () async {
      await _expect('consumerExample', completion('''
class ConsumerExample extends ConsumerWidget {
  const ConsumerExample({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext _context,
    WidgetRef _ref,
  ) =>
      consumerExample();
}
'''));
    });

    test('consumer widget with WidgetRef', () async {
      await _expect('consumerExampleWithRef', completion('''
class ConsumerExampleWithRef extends ConsumerWidget {
  const ConsumerExampleWithRef({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext _context,
    WidgetRef _ref,
  ) =>
      consumerExampleWithRef(_ref);
}
'''));
    });

    test('consumer widget with WidgetRef and BuildContext', () async {
      await _expect('consumerExampleWithRefAndContext', completion('''
class ConsumerExampleWithRefAndContext extends ConsumerWidget {
  const ConsumerExampleWithRefAndContext({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext _context,
    WidgetRef _ref,
  ) =>
      consumerExampleWithRefAndContext(
        _ref,
        _context,
      );
}
'''));
    });

    test('generic widget', () async {
      // currently not possible to know the type
      await _expect('generic', completion('''
class Generic<T> extends StatelessWidget {
  const Generic(
    this.foo, {
    Key? key,
  }) : super(key: key);

  final T foo;

  @override
  Widget build(BuildContext _context) => generic<T>(foo);
}
'''));
    });

    test('generic widget extends', () async {
      // currently not possible to know the type
      await _expect('genericExtends', completion('''
class GenericExtends<T extends Container> extends StatelessWidget {
  const GenericExtends(
    this.foo, {
    Key? key,
  }) : super(key: key);

  final T foo;

  @override
  Widget build(BuildContext _context) => genericExtends<T>(foo);
}
'''));
    });

    group('functions', () {
      test('typedef', () async {
        await _expect('typedefFunction', completion('''
class TypedefFunction<T> extends StatelessWidget {
  const TypedefFunction(
    this.t, {
    Key? key,
  }) : super(key: key);

  final void Function(T) t;

  @override
  Widget build(BuildContext _context) => typedefFunction<T>(t);
}
'''));
      });

      test('inline', () async {
        await _expect('inlineFunction', completion('''
class InlineFunction extends StatelessWidget {
  const InlineFunction(
    this.t, {
    Key? key,
  }) : super(key: key);

  final void Function() t;

  @override
  Widget build(BuildContext _context) => inlineFunction(t);
}
'''));
      });

      test('inline2', () async {
        await _expect('inlineFunction2', completion('''
class InlineFunction2 extends StatelessWidget {
  const InlineFunction2(
    this.t, {
    Key? key,
  }) : super(key: key);

  final void Function() t;

  @override
  Widget build(BuildContext _context) => inlineFunction2(t);
}
'''));
      });

      test('inline with args', () async {
        await _expect('inlineFunctionWithArgs', completion('''
class InlineFunctionWithArgs extends StatelessWidget {
  const InlineFunctionWithArgs(
    this.t, {
    Key? key,
  }) : super(key: key);

  final void Function(BuildContext?) t;

  @override
  Widget build(BuildContext _context) => inlineFunctionWithArgs(t);
}
'''));
      });

      test('optional inline', () async {
        await _expect('optionalInlineFunction', completion('''
class OptionalInlineFunction extends StatelessWidget {
  const OptionalInlineFunction(
    this.t, {
    Key? key,
  }) : super(key: key);

  final void Function()? t;

  @override
  Widget build(BuildContext _context) => optionalInlineFunction(t);
}
'''));
      });

      test('nested function', () async {
        await _expect('nestedFunction', completion('''
class NestedFunction extends StatelessWidget {
  const NestedFunction(
    this.t, {
    Key? key,
  }) : super(key: key);

  final void Function(
    void Function(int),
    int,
  ) t;

  @override
  Widget build(BuildContext _context) => nestedFunction(t);
}
'''));
      });

      test('generic class', () async {
        // currently not possible to know the type
        await _expect('genericClass', completion('''
class GenericClass<T> extends StatelessWidget {
  const GenericClass(
    this.foo, {
    Key? key,
  }) : super(key: key);

  final T Function() foo;

  @override
  Widget build(BuildContext _context) => genericClass<T>(foo);
}
'''));
      });

      test('generic class with nullable', () async {
        await _expect('genericClassWithNullable', completion('''
class GenericClassWithNullable<T> extends StatelessWidget {
  const GenericClassWithNullable(
    this.foo, {
    Key? key,
  }) : super(key: key);

  final T? Function() foo;

  @override
  Widget build(BuildContext _context) => genericClassWithNullable<T>(foo);
}
'''));
      });

      test('multiple generic class', () async {
        await _expect('genericMultiple', completion('''
class GenericMultiple<T, S> extends StatelessWidget {
  const GenericMultiple(
    this.foo,
    this.bar, {
    Key? key,
  }) : super(key: key);

  final T foo;

  final S bar;

  @override
  Widget build(BuildContext _context) => genericMultiple<T, S>(
        foo,
        bar,
      );
}
'''));
      });

      test('generic function', () async {
        await _expect('genericFunction', completion('''
class GenericFunction extends StatelessWidget {
  const GenericFunction(
    this.foo, {
    Key? key,
  }) : super(key: key);

  final int Function(int) foo;

  @override
  Widget build(BuildContext _context) => genericFunction(foo);
}
'''));
      });

      test('generic function #2', () async {
        await _expect('genericFunction2', completion('''
class GenericFunction2 extends StatelessWidget {
  const GenericFunction2(
    this.foo, {
    Key? key,
  }) : super(key: key);

  final T Function<T>(T) foo;

  @override
  Widget build(BuildContext _context) => genericFunction2(foo);
}
'''));
      });

      test('generic function #3', () async {
        await _expect('genericFunction3', completion('''
class GenericFunction3 extends StatelessWidget {
  const GenericFunction3(
    this.foo, {
    Key? key,
  }) : super(key: key);

  final String Function(int) foo;

  @override
  Widget build(BuildContext _context) => genericFunction3(foo);
}
'''));
      });

      test('generic function #4', () async {
        await _expect('genericFunction4', completion('''
class GenericFunction4 extends StatelessWidget {
  const GenericFunction4(
    this.foo, {
    Key? key,
  }) : super(key: key);

  final T? Function<T>(T?)? foo;

  @override
  Widget build(BuildContext _context) => genericFunction4(foo);
}
'''));
      });
    });

    group('custom named widgets', () {
      test('hook widget', () async {
        await _expect('hookWidgetWithCustomName', completion('''
class CustomHookWidget extends HookWidget {
  const CustomHookWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => hookWidgetWithCustomName(_context);
}
'''));
      });
    });

    group('annotations', () {
      test('annotation', () async {
        await _expect('annotation', completion('''
class Annotation extends StatelessWidget {
  const Annotation({
    Key? key,
    @TestAnnotation() this.foo = 42,
  }) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => annotation(foo: foo);
}
'''));
      });

      test('stateless widget', () async {
        await _expect('statelessWidgetWithCustomName', completion('''
class CustomStatelessWidget extends StatelessWidget {
  const CustomStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context) =>
      statelessWidgetWithCustomName(_context);
}
'''));
      });

      test('annotationParameter', () async {
        await _expect('annotationParameter', completion('''
class AnnotationParameter extends StatelessWidget {
  const AnnotationParameter({
    Key? key,
    @TestAnnotation('Test') this.foo = 42,
  }) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => annotationParameter(foo: foo);
}
'''));
      });

      test('annotationConstant', () async {
        await _expect('annotationConstant', completion('''
class AnnotationConstant extends StatelessWidget {
  const AnnotationConstant({
    Key? key,
    @testAnnotation this.foo = 42,
  }) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => annotationConstant(foo: foo);
}
'''));
      });
    });
  });
}
