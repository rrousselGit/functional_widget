import 'package:code_gen_tester/code_gen_tester.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:test/test.dart';

void main() {
  final tester = SourceGenTester.fromPath('test/src/diagnostics.dart');

  final _generator = FunctionalWidgetGenerator(
      const FunctionalWidget(debugFillProperties: true));
  Future<void> _expect(String name, Matcher matcher) async {
    return expectGenerateNamed(await tester, name, _generator, matcher);
  }

  group('diagnostics', () {
    test('int', () async {
      await _expect('intTest', completion('''
class IntTest extends StatelessWidget {
  const IntTest(this.a, {Key key}) : super(key: key);

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
  const DoubleTest(this.a, {Key key}) : super(key: key);

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
  const StringTest(this.a, {Key key}) : super(key: key);

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
  const EnumTest(this.a, {Key key}) : super(key: key);

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
  const ObjectTest(this.a, {Key key}) : super(key: key);

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
    test('unknown type', () async {
      await _expect('colorTest', completion('''
class ColorTest extends StatelessWidget {
  const ColorTest(this.a, {Key key}) : super(key: key);

  final Color a;

  @override
  Widget build(BuildContext _context) => colorTest(a);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Color>('a', a));
  }
}
'''));
    });
    test('function type', () async {
      await _expect('functionTest', completion('''
class FunctionTest extends StatelessWidget {
  const FunctionTest(this.a, {Key key}) : super(key: key);

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
    test('dynamic type', () async {
      await _expect('dynamicTest', completion('''
class DynamicTest extends StatelessWidget {
  const DynamicTest(this.a, {Key key}) : super(key: key);

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
    test('inferred type', () async {
      await _expect('inferredTest', completion('''
class InferredTest extends StatelessWidget {
  const InferredTest(this.a, {Key key}) : super(key: key);

  final dynamic a;

  @override
  Widget build(BuildContext _context) => inferredTest(a);
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
