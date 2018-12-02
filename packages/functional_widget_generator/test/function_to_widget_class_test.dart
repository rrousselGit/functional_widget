import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:functional_widget_generator/function_to_widget_class.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:dart_style/dart_style.dart';

class MFunctionElement extends Mock implements FunctionElement {
  MFunctionElement() : super();
  MFunctionElement.valid(
      {String name = "name", List<ParameterElement> parameters = const []})
      : super() {
    when(isAbstract).thenReturn(false);
    when(isAsynchronous).thenReturn(false);
    when(isExternal).thenReturn(false);
    when(isGenerator).thenReturn(false);
    when(isStatic).thenReturn(true);

    when(this.name).thenReturn(name);
    when(this.parameters).thenReturn(parameters);
  }
}

class MDartType extends Mock implements DartType {
  MDartType();
  MDartType.valid(String displayName) {
    when(this.displayName).thenReturn(displayName);
  }
}

class MParameterElement extends Mock implements ParameterElement {
  MParameterElement() : super();
  MParameterElement.valid(String name, {bool named = false, DartType type})
      : super() {
    when(this.name).thenReturn(name);
    when(this.isNamed).thenReturn(named);
    when(this.type).thenReturn(type);
  }
}

String generate(FunctionElement fe) {
  return MyGenerator().generateForAnnotatedElement(fe, null, null);
}

void main() {
  final formatter = DartFormatter();
  void expectGenerated(String expectation, String value) {
    expect(formatter.format(expectation), equals(value));
  }

  group('invalid input', () {
    test('isAbstract', () {
      final fe = MFunctionElement.valid();
      when(fe.isAbstract).thenReturn(true);
      expect(() => generate(fe), throwsArgumentError);
    });
    test('isAsynchronous', () {
      final fe = MFunctionElement.valid();
      when(fe.isAsynchronous).thenReturn(true);
      expect(() => generate(fe), throwsArgumentError);
    });
    test('isExternal', () {
      final fe = MFunctionElement.valid();
      when(fe.isExternal).thenReturn(true);
      expect(() => generate(fe), throwsArgumentError);
    });
    test('isGenerator', () {
      final fe = MFunctionElement.valid();
      when(fe.isGenerator).thenReturn(true);
      expect(() => generate(fe), throwsArgumentError);
    });
    test('isStatic', () {
      final fe = MFunctionElement.valid();
      when(fe.isStatic).thenReturn(false);
      expect(() => generate(fe), throwsArgumentError);
    });

    test('name', () {
      final fe = MFunctionElement.valid();
      when(fe.name).thenReturn("Foo");
      expect(() => generate(fe), throwsArgumentError);
      when(fe.name).thenReturn("_Foo");
      expect(() => generate(fe), throwsArgumentError);
    });
  });

  group('arguments', () {
    test("none", () {
      final value = generate(MFunctionElement.valid(parameters: []));

      expectGenerated(value, '''
class Name extends StatelessWidget {
  const Name({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) {
    return name();
  }
}
''');
    });
    test("required", () {
      final fe = MFunctionElement.valid();
      final parameters = [
        MParameterElement.valid("foo"),
        MParameterElement.valid("bar", type: MDartType.valid("Bar")),
      ];
      when(fe.parameters).thenReturn(parameters);
      final value = generate(fe);

      expectGenerated(value, '''
class Name extends StatelessWidget {
  const Name(this.foo, this.bar, {Key key}) : super(key: key);

  final foo;

  final Bar bar;

  @override
  Widget build(BuildContext _context) {
    return name(foo, bar);
  }
}
''');
    });

    test("named", () {
      final fe = MFunctionElement.valid();
      final parameters = [
        MParameterElement.valid("foo", named: true),
        MParameterElement.valid("bar",
            named: true, type: MDartType.valid("Bar")),
      ];
      when(fe.parameters).thenReturn(parameters);
      final value = generate(fe);

      expectGenerated(value, '''
class Name extends StatelessWidget {
  const Name({Key key, this.foo, this.bar}) : super(key: key);

  final foo;

  final Bar bar;

  @override
  Widget build(BuildContext _context) {
    return name(foo: foo, bar: bar);
  }
}
''');
    });

    test("mixt", () {
      final fe = MFunctionElement.valid();
      final parameters = [
        MParameterElement.valid("foo"),
        MParameterElement.valid("bar", type: MDartType.valid("Bar")),
        MParameterElement.valid("nfoo", named: true),
        MParameterElement.valid("nbar",
            named: true, type: MDartType.valid("Bar")),
      ];
      when(fe.parameters).thenReturn(parameters);
      final value = generate(fe);

      expectGenerated(value, '''
class Name extends StatelessWidget {
  const Name(this.foo, this.bar, {Key key, this.nfoo, this.nbar})
      : super(key: key);

  final foo;

  final Bar bar;

  final nfoo;

  final Bar nbar;

  @override
  Widget build(BuildContext _context) {
    return name(foo, bar, nfoo: nfoo, nbar: nbar);
  }
}
''');
    });

    group('inject parameters', () {
      test("context", () {
        final fe = MFunctionElement.valid();
        final parameters = [
          MParameterElement.valid("foo", type: MDartType.valid("BuildContext")),
        ];
        when(fe.parameters).thenReturn(parameters);
        final value = generate(fe);

        expectGenerated(value, '''
class Name extends StatelessWidget {
  const Name({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) {
    return name(_context);
  }
}
''');
      });

      test("key", () {
        final fe = MFunctionElement.valid();
        final parameters = [
          MParameterElement.valid("foo", type: MDartType.valid("Key")),
        ];
        when(fe.parameters).thenReturn(parameters);
        final value = generate(fe);

        expectGenerated(value, '''
class Name extends StatelessWidget {
  const Name({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) {
    return name(key);
  }
}
''');
      });

      test("context then key", () {
        final fe = MFunctionElement.valid();
        final parameters = [
          MParameterElement.valid("bar", type: MDartType.valid("BuildContext")),
          MParameterElement.valid("foo", type: MDartType.valid("Key")),
        ];
        when(fe.parameters).thenReturn(parameters);
        final value = generate(fe);

        expectGenerated(value, '''
class Name extends StatelessWidget {
  const Name({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) {
    return name(_context, key);
  }
}
''');
      });

      test("key then context", () {
        final fe = MFunctionElement.valid();
        final parameters = [
          MParameterElement.valid("foo", type: MDartType.valid("Key")),
          MParameterElement.valid("bar", type: MDartType.valid("BuildContext")),
        ];
        when(fe.parameters).thenReturn(parameters);
        final value = generate(fe);

        expectGenerated(value, '''
class Name extends StatelessWidget {
  const Name({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) {
    return name(key, _context);
  }
}
''');
      });

      test("whatever then context", () {
        final fe = MFunctionElement.valid();
        final parameters = [
          MParameterElement.valid("foo", type: MDartType.valid("Whatever")),
          MParameterElement.valid("bar", type: MDartType.valid("BuildContext")),
        ];
        when(fe.parameters).thenReturn(parameters);
        final value = generate(fe);

        expectGenerated(value, '''
class Name extends StatelessWidget {
  const Name(this.foo, this.bar, {Key key}) : super(key: key);

  final Whatever foo;

  final BuildContext bar;

  @override
  Widget build(BuildContext _context) {
    return name(foo, bar);
  }
}
''');
      });

      test("whatever then key", () {
        final fe = MFunctionElement.valid();
        final parameters = [
          MParameterElement.valid("foo", type: MDartType.valid("Whatever")),
          MParameterElement.valid("bar", type: MDartType.valid("Key")),
        ];
        when(fe.parameters).thenReturn(parameters);
        final value = generate(fe);

        expectGenerated(value, '''
class Name extends StatelessWidget {
  const Name(this.foo, this.bar, {Key key}) : super(key: key);

  final Whatever foo;

  final Key bar;

  @override
  Widget build(BuildContext _context) {
    return name(foo, bar);
  }
}
''');
      });
    });
  });

  group('HookWidget', () {
    test('first argument', () {
      final fe = MFunctionElement.valid();
      final parameters = [
        MParameterElement.valid("foo",
            named: true, type: MDartType.valid("HookContext")),
      ];
      when(fe.parameters).thenReturn(parameters);
      final value = generate(fe);

      expectGenerated(value, '''
class Name extends HookWidget {
  const Name({Key key}) : super(key: key);

  @override
  Widget build(HookContext _context) {
    return name(_context);
  }
}
''');
    });
    test('second argument', () {
      final fe = MFunctionElement.valid();
      final parameters = [
        MParameterElement.valid("foo",
            named: true, type: MDartType.valid("Key")),
        MParameterElement.valid("bar",
            named: true, type: MDartType.valid("HookContext")),
      ];
      when(fe.parameters).thenReturn(parameters);
      final value = generate(fe);

      expectGenerated(value, '''
class Name extends HookWidget {
  const Name({Key key}) : super(key: key);

  @override
  Widget build(HookContext _context) {
    return name(key, _context);
  }
}
''');
    });
  });
}
