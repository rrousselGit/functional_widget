import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter/widgets.dart';

part 'main.g.dart';

// we create a widget using a widget decorated by `@swidget`
@swidget
Widget foo() {
  return Container();
}

void main() => runApp(
      // we use the generated class
      const Foo(),
    );
