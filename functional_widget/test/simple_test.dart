import 'package:code_gen_tester/code_gen_tester.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:test/test.dart';

void main() {
  testGenerate('foo', (tester) async {
    await expectGenerate(tester, FunctionalWidget(), completion('''
class Bar extends StatelessWidget {
  const Bar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => bar();
}
'''));
  }, path: 'test/src/_functional_widget_test_input.dart');
  testGenerate('bar', (tester) async {
    await expectGenerate(tester, FunctionalWidget(), completion('''
class Truc extends StatelessWidget {
  const Truc({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => truc();
}
'''));
  }, path: 'test/src/_truc_test_input.dart');
}
