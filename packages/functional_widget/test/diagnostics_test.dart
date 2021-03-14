import 'package:code_gen_tester/code_gen_tester.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:test/test.dart';

void main() {
  final tester = SourceGenTester.fromPath('test/src/diagnostics.dart');

  final _generator = FunctionalWidgetGenerator(
      const FunctionalWidget(debugFillProperties: true));
  final _expect = (String name, Matcher matcher) async =>
      expectGenerateNamed(await tester, name, _generator, matcher);

  group('diagnostics', () {
    test('int', () async {
      await _expect('intTest', completion('''
class IntTest extends StatelessWidget {
  const IntTest(this.a, {Key? key}) : super(key: key);

  final int a;

  @override
  Widget build(BuildContext _context) => intTest(a);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('a', a));
  }
}
'''));
    });

    test('double', () async {
      await _expect('doubleTest', completion('''
class DoubleTest extends StatelessWidget {
  const DoubleTest(this.a, {Key? key}) : super(key: key);

  final double a;

  @override
  Widget build(BuildContext _context) => doubleTest(a);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('a', a));
  }
}
'''));
    });

    test('String', () async {
      await _expect('stringTest', completion('''
class StringTest extends StatelessWidget {
  const StringTest(this.a, {Key? key}) : super(key: key);

  final String a;

  @override
  Widget build(BuildContext _context) => stringTest(a);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('a', a));
  }
}
'''));
    });

    test('enums', () async {
      await _expect('enumTest', completion('''
class EnumTest extends StatelessWidget {
  const EnumTest(this.a, {Key? key}) : super(key: key);

  final _Foo a;

  @override
  Widget build(BuildContext _context) => enumTest(a);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<_Foo>('a', a));
  }
}
'''));
    });

    test('object', () async {
      await _expect('objectTest', completion('''
class ObjectTest extends StatelessWidget {
  const ObjectTest(this.a, {Key? key}) : super(key: key);

  final Object a;

  @override
  Widget build(BuildContext _context) => objectTest(a);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Object>('a', a));
  }
}
'''));
    });

    test('function type', () async {
      await _expect('functionTest', completion('''
class FunctionTest extends StatelessWidget {
  const FunctionTest(this.a, {Key? key}) : super(key: key);

  final void Function() a;

  @override
  Widget build(BuildContext _context) => functionTest(a);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<void Function()>('a', a));
  }
}
'''));
    });

    test('typedef type', () async {
      // TODO should be `final void Function(T) a;` instead of
      // `final void Function(dynamic) a;`
      // and `DiagnosticsProperty<void Function(T)>` instead of
      // `ObjectFlagProperty<dynamic>.has`
      await _expect('typedefTest', completion('''
class TypedefTest<T> extends StatelessWidget {
  const TypedefTest(this.a, {Key? key}) : super(key: key);

  final void Function(dynamic) a;

  @override
  Widget build(BuildContext _context) => typedefTest<T>(a);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<dynamic>.has('a', a));
  }
}
'''));
    });

    test('dynamic type', () async {
      await _expect('dynamicTest', completion('''
class DynamicTest extends StatelessWidget {
  const DynamicTest(this.a, {Key? key}) : super(key: key);

  final dynamic a;

  @override
  Widget build(BuildContext _context) => dynamicTest(a);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<dynamic>('a', a));
  }
}
'''));
    });
  });
}
