import 'package:code_gen_tester/code_gen_tester.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:test/test.dart';

void main() {
  final tester = SourceGenTester.fromPath('test/src/success.dart');

  group('equality', () {
    // test('TODO', () {
    //   // TODO: document
    //   // TODO: update readme
    //   throw UnimplementedError();
    // });

    group('none', () {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(equality: FunctionalWidgetEquality.none));
      _expect(String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);

      test('never generate hashcode/operator==', () async {
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
    });

    group('hashCode', () {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(equality: FunctionalWidgetEquality.equal));
      _expect(String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);
      test("functions with no argument don't generate any hashCode override",
          () async {
        await _expect('noArgument', completion('''
class NoArgument extends StatelessWidget {
  const NoArgument({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => noArgument();
}
'''));
      });
      test(
          "functions with context or key or both are considered non argument and still don't have hashCode",
          () async {
        await _expect('withContext', completion('''
class WithContext extends StatelessWidget {
  const WithContext({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withContext(_context);
}
'''));
        await _expect('withKey', completion('''
class WithKey extends StatelessWidget {
  const WithKey({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withKey(key);
}
'''));
        await _expect('withContextThenKey', completion('''
class WithContextThenKey extends StatelessWidget {
  const WithContextThenKey({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withContextThenKey(_context, key);
}
'''));
        await _expect('withKeyThenContext', completion('''
class WithKeyThenContext extends StatelessWidget {
  const WithKeyThenContext({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withKeyThenContext(key, _context);
}
'''));
      });
      test(
          'functions with only one argument (context/key excluded) return that argument hashCode directly',
          () async {
        await _expect('onlyOneArg', completion('''
class OnlyOneArg extends StatelessWidget {
  const OnlyOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => onlyOneArg(foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is OnlyOneArg && foo == o.foo);
}
'''));
        await _expect('withContextThenOneArg', completion('''
class WithContextThenOneArg extends StatelessWidget {
  const WithContextThenOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => withContextThenOneArg(_context, foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is WithContextThenOneArg && foo == o.foo);
}
'''));
        await _expect('withKeyThenOneArg', completion('''
class WithKeyThenOneArg extends StatelessWidget {
  const WithKeyThenOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => withKeyThenOneArg(key, foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is WithKeyThenOneArg && foo == o.foo);
}
'''));

        await _expect('withContextThenKeyThenOneArg', completion('''
class WithContextThenKeyThenOneArg extends StatelessWidget {
  const WithContextThenKeyThenOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) =>
      withContextThenKeyThenOneArg(_context, key, foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is WithContextThenKeyThenOneArg && foo == o.foo);
}
'''));
        await _expect('withKeyThenContextThenOneArg', completion('''
class WithKeyThenContextThenOneArg extends StatelessWidget {
  const WithKeyThenContextThenOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) =>
      withKeyThenContextThenOneArg(key, _context, foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is WithKeyThenContextThenOneArg && foo == o.foo);
}
'''));
      });

      test(
          'functions with multiple arguments generates hash with hashValues from flutter',
          () async {
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
}
'''));
      });
    });

    group('equal', () {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(equality: FunctionalWidgetEquality.equal));
      _expect(String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);
      test("functions with no argument don't generate any operator== override",
          () async {
        await _expect('noArgument', completion('''
class NoArgument extends StatelessWidget {
  const NoArgument({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => noArgument();
}
'''));
      });
      test(
          "functions with context or key or both are considered non argument and still don't have operator==",
          () async {
        await _expect('withContext', completion('''
class WithContext extends StatelessWidget {
  const WithContext({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withContext(_context);
}
'''));
        await _expect('withKey', completion('''
class WithKey extends StatelessWidget {
  const WithKey({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withKey(key);
}
'''));
        await _expect('withContextThenKey', completion('''
class WithContextThenKey extends StatelessWidget {
  const WithContextThenKey({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withContextThenKey(_context, key);
}
'''));
        await _expect('withKeyThenContext', completion('''
class WithKeyThenContext extends StatelessWidget {
  const WithKeyThenContext({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withKeyThenContext(key, _context);
}
'''));
      });
      test(
          'functions with only one argument (context/key excluded) test == on that argument and identical on this',
          () async {
        await _expect('onlyOneArg', completion('''
class OnlyOneArg extends StatelessWidget {
  const OnlyOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => onlyOneArg(foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is OnlyOneArg && foo == o.foo);
}
'''));
        await _expect('withContextThenOneArg', completion('''
class WithContextThenOneArg extends StatelessWidget {
  const WithContextThenOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => withContextThenOneArg(_context, foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is WithContextThenOneArg && foo == o.foo);
}
'''));
        await _expect('withKeyThenOneArg', completion('''
class WithKeyThenOneArg extends StatelessWidget {
  const WithKeyThenOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => withKeyThenOneArg(key, foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is WithKeyThenOneArg && foo == o.foo);
}
'''));

        await _expect('withContextThenKeyThenOneArg', completion('''
class WithContextThenKeyThenOneArg extends StatelessWidget {
  const WithContextThenKeyThenOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) =>
      withContextThenKeyThenOneArg(_context, key, foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is WithContextThenKeyThenOneArg && foo == o.foo);
}
'''));
        await _expect('withKeyThenContextThenOneArg', completion('''
class WithKeyThenContextThenOneArg extends StatelessWidget {
  const WithKeyThenContextThenOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) =>
      withKeyThenContextThenOneArg(key, _context, foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is WithKeyThenContextThenOneArg && foo == o.foo);
}
'''));
      });

      test(
          'functions with multiple arguments generates hash with hashValues from flutter',
          () async {
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
}
'''));
      });
    });
    group('identical', () {
      final _generator = FunctionalWidgetGenerator(
          const FunctionalWidget(equality: FunctionalWidgetEquality.identical));
      _expect(String name, Matcher matcher) async =>
          expectGenerateNamed(await tester, name, _generator, matcher);
      test("functions with no argument don't generate any operator== override",
          () async {
        await _expect('noArgument', completion('''
class NoArgument extends StatelessWidget {
  const NoArgument({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => noArgument();
}
'''));
      });
      test(
          "functions with context or key or both are considered non argument and still don't have operator==",
          () async {
        await _expect('withContext', completion('''
class WithContext extends StatelessWidget {
  const WithContext({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withContext(_context);
}
'''));
        await _expect('withKey', completion('''
class WithKey extends StatelessWidget {
  const WithKey({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withKey(key);
}
'''));
        await _expect('withContextThenKey', completion('''
class WithContextThenKey extends StatelessWidget {
  const WithContextThenKey({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withContextThenKey(_context, key);
}
'''));
        await _expect('withKeyThenContext', completion('''
class WithKeyThenContext extends StatelessWidget {
  const WithKeyThenContext({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => withKeyThenContext(key, _context);
}
'''));
      });
      test(
          'functions with only one argument (context/key excluded) test identical on that argument and on this',
          () async {
        await _expect('onlyOneArg', completion('''
class OnlyOneArg extends StatelessWidget {
  const OnlyOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => onlyOneArg(foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is OnlyOneArg && identical(foo, o.foo));
}
'''));
        await _expect('withContextThenOneArg', completion('''
class WithContextThenOneArg extends StatelessWidget {
  const WithContextThenOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => withContextThenOneArg(_context, foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) ||
      (o is WithContextThenOneArg && identical(foo, o.foo));
}
'''));
        await _expect('withKeyThenOneArg', completion('''
class WithKeyThenOneArg extends StatelessWidget {
  const WithKeyThenOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) => withKeyThenOneArg(key, foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is WithKeyThenOneArg && identical(foo, o.foo));
}
'''));

        await _expect('withContextThenKeyThenOneArg', completion('''
class WithContextThenKeyThenOneArg extends StatelessWidget {
  const WithContextThenKeyThenOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) =>
      withContextThenKeyThenOneArg(_context, key, foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) ||
      (o is WithContextThenKeyThenOneArg && identical(foo, o.foo));
}
'''));
        await _expect('withKeyThenContextThenOneArg', completion('''
class WithKeyThenContextThenOneArg extends StatelessWidget {
  const WithKeyThenContextThenOneArg(this.foo, {Key key}) : super(key: key);

  final int foo;

  @override
  Widget build(BuildContext _context) =>
      withKeyThenContextThenOneArg(key, _context, foo);
  @override
  int get hashCode => foo.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) ||
      (o is WithKeyThenContextThenOneArg && identical(foo, o.foo));
}
'''));
      });

      test(
          'functions with multiple arguments generates hash with hashValues from flutter',
          () async {
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
          identical(foo, o.foo) &&
          identical(bar, o.bar) &&
          identical(nfoo, o.nfoo) &&
          identical(nbar, o.nbar));
}
'''));
      });
    });
  });
}
