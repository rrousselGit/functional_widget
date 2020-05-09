import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'fake_flutter.dart';

@widget
final closure = () => Container();

@widget
external Widget externalTest();

@widget
// ignore: implicit_dynamic_return, always_declare_return_types
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

@widget
dynamic dynamicTest() {
  return Container();
}

@widget
// ignore: implicit_dynamic_return, always_declare_return_types
implicitDynamic() {
  return Container();
}
