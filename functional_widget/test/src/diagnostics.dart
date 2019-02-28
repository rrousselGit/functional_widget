import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

@widget
Widget intTest(int a) => Container();

@widget
Widget doubleTest(double a) => Container();

@widget
Widget stringTest(String a) => Container();

enum _Foo { a, b }

@widget
Widget enumTest(_Foo a) => Container();

@widget
Widget objectTest(Object a) => Container();

typedef Foo<T> = void Function(T);

@widget
// ignore: undefined_class
Widget colorTest(Color a) => Container();

@widget
Widget functionTest(void Function() a) => Container();

@widget
Widget dynamicTest(dynamic a) => Container();
