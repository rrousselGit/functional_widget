import 'package:flutter/foundation.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';


part 'main.g.dart';

// we create a widget using a widget decorated by `@widget`
@widget
Widget foo(int value) {
  return Container();
}

@widget
Widget example(int foo, String bar) {
  return Container();
}

void main() => runApp(
      // we use the generated class
      const Foo(42),
    );
