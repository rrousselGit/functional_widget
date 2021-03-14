import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'fake_flutter.dart';

@swidget
final closure = () => Container();

@swidget
external Widget externalTest();

@swidget
int notAWidget() {
  return 42;
}

@swidget
// ignore: non_constant_identifier_names
Widget TitleName() {
  return Container();
}

@swidget
dynamic dynamicTest() {
  return Container();
}
