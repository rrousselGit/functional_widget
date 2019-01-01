import 'package:code_gen_tester/code_gen_tester.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:test/test.dart';

void main() {
  test('foo', () async {
    final tester = await SourceGenTester.fromPath(
        'test/src/_functional_widget_test_input.dart');
    await expectGenerate(tester, FunctionalWidget(), completion('''
class Bar extends StatelessWidget {
  const Bar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => bar();
}
'''));
  });
  test('bar', () async {
    final tester =
        await SourceGenTester.fromPath('test/src/_truc_test_input.dart');
    await expectGenerate(tester, FunctionalWidget(), completion('''
class Truc extends StatelessWidget {
  const Truc({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => truc();
}
'''));
  });
}
