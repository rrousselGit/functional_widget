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
}
'''));
    });
  });
}
