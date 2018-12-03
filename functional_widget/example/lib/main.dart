import 'package:flutter/widgets.dart';
import 'package:functional_widget/functional_widget.dart';

part 'main.g.dart';

void main() => runApp(Foo(42));

/// Hello World
/// World
@widget
Widget foo(BuildContext context, int value) {
  return Container();
}
