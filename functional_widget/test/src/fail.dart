import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'fake_flutter.dart';

@widget
final closure = () => Container();

@widget
external Widget externalTest();

@widget
// ignore: strong_mode_implicit_dynamic_return
asyncTest() async {
  return Container();
}

@widget
int notAWidget() {
  return 42;
}

@widget
// ignore: non_constant_identifier_names
Widget TitleName() {
  return Container();
}
