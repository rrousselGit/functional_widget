import 'package:flutter/widgets.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'main.g.dart';

void main() => runApp(const Foo(42));

/// Class documentation
///
/// * [value] Field documentation
@widget
Widget foo(BuildContext context, int value) {
  return Container();
}
