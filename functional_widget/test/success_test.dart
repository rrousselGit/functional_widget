import 'package:code_gen_tester/code_gen_tester.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:test/test.dart';

void main() async {
  final tester = await SourceGenTester.fromPath('test/src/success.dart');

  final _generator = FunctionalWidget();
  _expect(String name, Matcher matcher) =>
      expectGenerateNamed(tester, name, _generator, matcher);
  group('success', () {
    test('noArgument', () async {
      await _expect('noArgument', completion('''
class NoArgument extends StatelessWidget {
  const NoArgument({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => noArgument();
}
'''));
    });

    test('required', () async {
      await _expect('required', completion('''
class Required extends StatelessWidget {
  const Required(this.foo, this.bar, {Key key}) : super(key: key);

  final dynamic foo;

  final int bar;

  @override
  Widget build(BuildContext _context) => required(foo, bar);
  @override
  int get hashCode => hashValues(foo, bar);
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is Required && foo == o.foo && bar == o.bar);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<dynamic>('foo', foo));
    properties.add(IntProperty('bar', bar));
  }
}
'''));
    });

    test('named', () async {
      await _expect('named', completion('''
class Named extends StatelessWidget {
  const Named({Key key, this.foo, this.bar}) : super(key: key);

  final dynamic foo;

  final int bar;

  @override
  Widget build(BuildContext _context) => named(foo: foo, bar: bar);
  @override
  int get hashCode => hashValues(foo, bar);
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is Named && foo == o.foo && bar == o.bar);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<dynamic>('foo', foo));
    properties.add(IntProperty('bar', bar));
  }
}
'''));
    });

    test('mixt', () async {
      await _expect('mixt', completion('''
class Mixt extends StatelessWidget {
  const Mixt(this.foo, this.bar, {Key key, this.nfoo, this.nbar})
      : super(key: key);

  final dynamic foo;

  final int bar;

  final dynamic nfoo;

  final int nbar;

  @override
  Widget build(BuildContext _context) => mixt(foo, bar, nfoo: nfoo, nbar: nbar);
  @override
  int get hashCode => hashValues(foo, bar, nfoo, nbar);
  @override
  bool operator ==(Object o) =>
      identical(o, this) ||
      (o is Mixt &&
          foo == o.foo &&
          bar == o.bar &&
          nfoo == o.nfoo &&
          nbar == o.nbar);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<dynamic>('foo', foo));
    properties.add(IntProperty('bar', bar));
    properties.add(DiagnosticsProperty<dynamic>('nfoo', nfoo));
    properties.add(IntProperty('nbar', nbar));
  }
}
'''));
    });

    test('context', () async {
      await _expect('withContext', completion('''
class WithContext extends StatelessWidget {
  const WithContext({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withContext(_context);
}
'''));
    });
    test('key', () async {
      await _expect('withKey', completion('''
class WithKey extends StatelessWidget {
  const WithKey({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withKey(key);
}
'''));
    });
    test('context then key', () async {
      await _expect('withContextThenKey', completion('''
class WithContextThenKey extends StatelessWidget {
  const WithContextThenKey({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withContextThenKey(_context, key);
}
'''));
    });
    test('key then context', () async {
      await _expect('withKeyThenContext', completion('''
class WithKeyThenContext extends StatelessWidget {
  const WithKeyThenContext({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withKeyThenContext(key, _context);
}
'''));
    });
    test('whatever then context', () async {
      await _expect('whateverThenContext', completion('''
class WhateverThenContext extends StatelessWidget {
  const WhateverThenContext(this.foo, this.bar, {Key key}) : super(key: key);

  final int foo;

  final BuildContext bar;

  @override
  Widget build(BuildContext _context) => whateverThenContext(foo, bar);
  @override
  int get hashCode => hashValues(foo, bar);
  @override
  bool operator ==(Object o) =>
      identical(o, this) ||
      (o is WhateverThenContext && foo == o.foo && bar == o.bar);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('foo', foo));
    properties.add(DiagnosticsProperty<BuildContext>('bar', bar));
  }
}
'''));
    });
    test('whatever then key', () async {
      await _expect('whateverThenKey', completion('''
class WhateverThenKey extends StatelessWidget {
  const WhateverThenKey(this.foo, this.bar, {Key key}) : super(key: key);

  final int foo;

  final Key bar;

  @override
  Widget build(BuildContext _context) => whateverThenKey(foo, bar);
  @override
  int get hashCode => hashValues(foo, bar);
  @override
  bool operator ==(Object o) =>
      identical(o, this) ||
      (o is WhateverThenKey && foo == o.foo && bar == o.bar);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('foo', foo));
    properties.add(DiagnosticsProperty<Key>('bar', bar));
  }
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
  const Documentation(this.foo, {Key key}) : super(key: key);

  /// Hello
  /// World
  final int foo;

  @override
  Widget build(BuildContext _context) => documentation(foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is Documentation && foo == o.foo);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('foo', foo));
  }
}
'''));
    });
    test('annotated', () async {
      await _expect('annotated', completion('''
class Annotated extends StatelessWidget {
  const Annotated({Key key, @required this.foo}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => annotated(foo: foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is Annotated && foo == o.foo);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('foo', foo));
  }
}
'''));
    });
    test('undefined type', () async {
      await _expect('undefinedType', completion('''
class UndefinedType extends StatelessWidget {
  const UndefinedType({Key key, this.foo}) : super(key: key);

  final Color foo;

  @override
  Widget build(BuildContext _context) => undefinedType(foo: foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is UndefinedType && foo == o.foo);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Color>('foo', foo));
  }
}
'''));
    });
    test('hook widget', () async {
      await _expect('hookExample', completion('''
class HookExample extends HookWidget {
  const HookExample({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => hookExample();
}
'''));
    });

    test('generic widget', () async {
      // currently not possible to know the type
      await _expect('generic', completion('''
class Generic<T> extends StatelessWidget {
  const Generic(this.foo, {Key key}) : super(key: key);

  final T foo;

  @override
  Widget build(BuildContext _context) => generic<T>(foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is Generic<T> && foo == o.foo);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('foo', foo));
  }
}
'''));
    });
    test('generic widget extends', () async {
      // currently not possible to know the type
      await _expect('genericExtends', completion('''
class GenericExtends<T extends Container> extends StatelessWidget {
  const GenericExtends(this.foo, {Key key}) : super(key: key);

  final T foo;

  @override
  Widget build(BuildContext _context) => genericExtends<T>(foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is GenericExtends<T> && foo == o.foo);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('foo', foo));
  }
}
'''));
    });

    group('functions', () {
      test('typedef', () async {
        await _expect('typedefFunction', completion('''
class TypedefFunction extends StatelessWidget {
  const TypedefFunction(this.t, {Key key}) : super(key: key);

  final void Function() t;

  @override
  Widget build(BuildContext _context) => typedefFunction(t);
  @override
  int get hashCode => t.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is TypedefFunction && t == o.t);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<dynamic>.has('t', t));
  }
}
'''));
      });
      test('inline', () async {
        await _expect('inlineFunction', completion('''
class InlineFunction extends StatelessWidget {
  const InlineFunction(this.t, {Key key}) : super(key: key);

  final void Function() t;

  @override
  Widget build(BuildContext _context) => inlineFunction(t);
  @override
  int get hashCode => t.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is InlineFunction && t == o.t);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<dynamic>.has('t', t));
  }
}
'''));
      });
      test('inline2', () async {
        await _expect('inlineFunction2', completion('''
class InlineFunction2 extends StatelessWidget {
  const InlineFunction2(this.t, {Key key}) : super(key: key);

  final void Function() t;

  @override
  Widget build(BuildContext _context) => inlineFunction2(t);
  @override
  int get hashCode => t.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is InlineFunction2 && t == o.t);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<dynamic>.has('t', t));
  }
}
'''));
      });
      test('nested function', () async {
        await _expect('nestedFunction', completion('''
class NestedFunction extends StatelessWidget {
  const NestedFunction(this.t, {Key key}) : super(key: key);

  final void Function(void Function(int), int) t;

  @override
  Widget build(BuildContext _context) => nestedFunction(t);
  @override
  int get hashCode => t.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is NestedFunction && t == o.t);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<dynamic>.has('t', t));
  }
}
'''));
      });
      test('unknown type function', () async {
        // currently not possible to know the type
        await _expect('unknownTypeFunction', completion('''
class UnknownTypeFunction extends StatelessWidget {
  const UnknownTypeFunction(this.t, {Key key}) : super(key: key);

  final dynamic Function() t;

  @override
  Widget build(BuildContext _context) => unknownTypeFunction(t);
  @override
  int get hashCode => t.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is UnknownTypeFunction && t == o.t);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<dynamic>.has('t', t));
  }
}
'''));
      });
      test('generic function', () async {
        // currently not possible to know the type
        await _expect('genericFunction', completion('''
class GenericFunction<T> extends StatelessWidget {
  const GenericFunction(this.foo, {Key key}) : super(key: key);

  final T Function() foo;

  @override
  Widget build(BuildContext _context) => genericFunction<T>(foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is GenericFunction<T> && foo == o.foo);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<dynamic>.has('foo', foo));
  }
}
'''));
      });
      test('multiple generic function', () async {
        await _expect('genericMultiple', completion('''
class GenericMultiple<T, S> extends StatelessWidget {
  const GenericMultiple(this.foo, this.bar, {Key key}) : super(key: key);

  final T foo;

  final S bar;

  @override
  Widget build(BuildContext _context) => genericMultiple<T, S>(foo, bar);
  @override
  int get hashCode => hashValues(foo, bar);
  @override
  bool operator ==(Object o) =>
      identical(o, this) ||
      (o is GenericMultiple<T, S> && foo == o.foo && bar == o.bar);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('foo', foo));
    properties.add(DiagnosticsProperty<S>('bar', bar));
  }
}
'''));
      });
    });
  });
}
