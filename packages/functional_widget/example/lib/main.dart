import 'package:flutter/foundation.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'main.g.dart';

// we create a widget using a widget decorated by `@swidget`
@swidget
Widget foo(int value) {
  return Container();
}

@swidget
Widget example(
  int foo,
  String bar, {
  ValueChanged<bool>? onChanged,
}) {
  return Container();
}

@FunctionalWidget(name: 'Example2')
Widget _example(BuildContext ctx) {
  return Container();
}

@hwidget
Widget __privateHook(BuildContext ctx) {
  return Container();
}

@swidget
Widget __privateStatelessWidget(BuildContext ctx) {
  return Container();
}

void main() => runApp(
      // we use the generated class
      const Foo(42),
    );
