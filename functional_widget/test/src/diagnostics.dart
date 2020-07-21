// ignore_for_file: unused_field
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'fake_flutter.dart';

@swidget
Widget intTest(int a) => Container();

@swidget
Widget doubleTest(double a) => Container();

@swidget
Widget stringTest(String a) => Container();

enum _Foo { a, b }

@swidget
Widget enumTest(_Foo a) => Container();

@swidget
Widget objectTest(Object a) => Container();

typedef Typedef<T> = void Function(T);

@swidget
Widget typedefTest<T>(Typedef a) => Container();

@swidget
// ignore: undefined_class
Widget colorTest(Color a) => Container();

@swidget
Widget functionTest(void Function() a) => Container();

@swidget
Widget dynamicTest(dynamic a) => Container();

@swidget
// ignore: implicit_dynamic_parameter
Widget inferredTest(a) => Container();
