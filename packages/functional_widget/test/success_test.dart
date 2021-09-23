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
  const NamedDefault({Key? key, this.foo = 42}) : super(key: key);

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
  Widget build(BuildContext _context) => withContextThenKey(_context, key!);
}
'''));
    });

    test('key then context', () async {
      await _expect('withKeyThenContext', completion('''
class WithKeyThenContext extends StatelessWidget {
  const WithKeyThenContext({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withKeyThenContext(key!, _context);
}
'''));
    });

    test('whatever then context', () async {
      await _expect('whateverThenContext', completion('''
class WhateverThenContext extends StatelessWidget {
  const WhateverThenContext(this.foo, this.bar, {Key? key}) : super(key: key);

  final int foo;

  final BuildContext bar;

  @override
  Widget build(BuildContext _context) => whateverThenContext(foo, bar);
}
'''));
    });

    test('whatever then key', () async {
      await _expect('whateverThenKey', completion('''
class WhateverThenKey extends StatelessWidget {
  const WhateverThenKey(this.foo, this.bar, {Key? key}) : super(key: key);

  final int foo;

  final Key bar;

  @override
  Widget build(BuildContext _context) => whateverThenKey(foo, bar);
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
  const Documentation(this.foo, {Key? key}) : super(key: key);

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
  const WithRequired({Key? key, required this.foo}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => withRequired(foo: foo);
}
'''));
    });

    test('optional', () async {
      await _expect('withOptional', completion('''
class WithOptional extends StatelessWidget {
  const WithOptional({Key? key, this.foo}) : super(key: key);

  final int? foo;

  @override
  Widget build(BuildContext _context) => withOptional(foo: foo);
}
'''));
    });

    test('positional optional', () async {
      await _expect('withPositionalOptional', completion('''
class WithPositionalOptional extends StatelessWidget {
  const WithPositionalOptional(this.foo, {Key? key}) : super(key: key);

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
  Widget build(BuildContext _context, WidgetRef _ref) => hookConsumerExample();
}
'''));
    });

    test('consumer hook widget with WidgetRef', () async {
      await _expect('hookConsumerExampleWithRef', completion('''
class HookConsumerExampleWithRef extends HookConsumerWidget {
  const HookConsumerExampleWithRef({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context, WidgetRef _ref) =>
      hookConsumerExampleWithRef(_ref);
}
'''));
    });

    test('consumer hook widget with WidgetRef and BuildContext', () async {
      await _expect('hookConsumerExampleWithRefAndContext', completion('''
class HookConsumerExampleWithRefAndContext extends HookConsumerWidget {
  const HookConsumerExampleWithRefAndContext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context, WidgetRef _ref) =>
      hookConsumerExampleWithRefAndContext(_ref, _context);
}
'''));
    });

    test('consumer widget', () async {
      await _expect('consumerExample', completion('''
class ConsumerExample extends ConsumerWidget {
  const ConsumerExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context, WidgetRef _ref) => consumerExample();
}
'''));
    });

    test('consumer widget with WidgetRef', () async {
      await _expect('consumerExampleWithRef', completion('''
class ConsumerExampleWithRef extends ConsumerWidget {
  const ConsumerExampleWithRef({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context, WidgetRef _ref) =>
      consumerExampleWithRef(_ref);
}
'''));
    });

    test('consumer widget with WidgetRef and BuildContext', () async {
      await _expect('consumerExampleWithRefAndContext', completion('''
class ConsumerExampleWithRefAndContext extends ConsumerWidget {
  const ConsumerExampleWithRefAndContext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _context, WidgetRef _ref) =>
      consumerExampleWithRefAndContext(_ref, _context);
}
'''));
    });

    test('generic widget', () async {
      // currently not possible to know the type
      await _expect('generic', completion('''
class Generic<T> extends StatelessWidget {
  const Generic(this.foo, {Key? key}) : super(key: key);

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
  const GenericExtends(this.foo, {Key? key}) : super(key: key);

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
  const TypedefFunction(this.t, {Key? key}) : super(key: key);

  final void Function(T) t;

  @override
  Widget build(BuildContext _context) => typedefFunction<T>(t);
}
'''));
      });

      test('inline', () async {
        await _expect('inlineFunction', completion('''
class InlineFunction extends StatelessWidget {
  const InlineFunction(this.t, {Key? key}) : super(key: key);

  final void Function() t;

  @override
  Widget build(BuildContext _context) => inlineFunction(t);
}
'''));
      });

      test('inline2', () async {
        await _expect('inlineFunction2', completion('''
class InlineFunction2 extends StatelessWidget {
  const InlineFunction2(this.t, {Key? key}) : super(key: key);

  final void Function() t;

  @override
  Widget build(BuildContext _context) => inlineFunction2(t);
}
'''));
      });

      test('inline with args', () async {
        await _expect('inlineFunctionWithArgs', completion('''
class InlineFunctionWithArgs extends StatelessWidget {
  const InlineFunctionWithArgs(this.t, {Key? key}) : super(key: key);

  final void Function(BuildContext?) t;

  @override
  Widget build(BuildContext _context) => inlineFunctionWithArgs(t);
}
'''));
      });

      test('optional inline', () async {
        await _expect('optionalInlineFunction', completion('''
class OptionalInlineFunction extends StatelessWidget {
  const OptionalInlineFunction(this.t, {Key? key}) : super(key: key);

  final void Function()? t;

  @override
  Widget build(BuildContext _context) => optionalInlineFunction(t);
}
'''));
      });

      test('nested function', () async {
        await _expect('nestedFunction', completion('''
class NestedFunction extends StatelessWidget {
  const NestedFunction(this.t, {Key? key}) : super(key: key);

  final void Function(void Function(int), int) t;

  @override
  Widget build(BuildContext _context) => nestedFunction(t);
}
'''));
      });

      test('generic class', () async {
        // currently not possible to know the type
        await _expect('genericClass', completion('''
class GenericClass<T> extends StatelessWidget {
  const GenericClass(this.foo, {Key? key}) : super(key: key);

  final T Function() foo;

  @override
  Widget build(BuildContext _context) => genericClass<T>(foo);
}
'''));
      });

      test('generic class with nullable', () async {
        await _expect('genericClassWithNullable', completion('''
class GenericClassWithNullable<T> extends StatelessWidget {
  const GenericClassWithNullable(this.foo, {Key? key}) : super(key: key);

  final T? Function() foo;

  @override
  Widget build(BuildContext _context) => genericClassWithNullable<T>(foo);
}
'''));
      });

      test('multiple generic class', () async {
        await _expect('genericMultiple', completion('''
class GenericMultiple<T, S> extends StatelessWidget {
  const GenericMultiple(this.foo, this.bar, {Key? key}) : super(key: key);

  final T foo;

  final S bar;

  @override
  Widget build(BuildContext _context) => genericMultiple<T, S>(foo, bar);
}
'''));
      });

      test('generic function', () async {
        await _expect('genericFunction', completion('''
class GenericFunction extends StatelessWidget {
  const GenericFunction(this.foo, {Key? key}) : super(key: key);

  final int Function(int) foo;

  @override
  Widget build(BuildContext _context) => genericFunction(foo);
}
'''));
      });

      test('generic function #2', () async {
        await _expect('genericFunction2', completion('''
class GenericFunction2 extends StatelessWidget {
  const GenericFunction2(this.foo, {Key? key}) : super(key: key);

  final T Function<T>(T) foo;

  @override
  Widget build(BuildContext _context) => genericFunction2(foo);
}
'''));
      });

      test('generic function #3', () async {
        await _expect('genericFunction3', completion('''
class GenericFunction3 extends StatelessWidget {
  const GenericFunction3(this.foo, {Key? key}) : super(key: key);

  final String Function(int) foo;

  @override
  Widget build(BuildContext _context) => genericFunction3(foo);
}
'''));
      });

      test('generic function #4', () async {
        await _expect('genericFunction4', completion('''
class GenericFunction4 extends StatelessWidget {
  const GenericFunction4(this.foo, {Key? key}) : super(key: key);

  final T? Function<T>(T?)? foo;

  @override
  Widget build(BuildContext _context) => genericFunction4(foo);
}
'''));
      });
    });
  });
}
