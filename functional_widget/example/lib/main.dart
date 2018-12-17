import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'main.g.dart';

void main() => runApp(const Foo(
      42,
      Colors.red,
    ));

/// Class documentation
///
/// * [value] Field documentation
@widget
Widget foo(
  BuildContext context,
  Key key,
  int value,
  Color bar, {
  int pos,
  String pos2,
  Color test1(int foo, {String bar}),
  void Function(int foo) stuff,
}
    // void Function() boo,
    // void bar(),
    // // ignore: generic_function_typed_param_unsupported
    // T b1(),
    // Bidule truc,
    ) {
  return Container();
}

class Nidule {
  final void Function() foo;

  Nidule(this.foo);
}

typedef Truc = void Function();
typedef void Bidule();
