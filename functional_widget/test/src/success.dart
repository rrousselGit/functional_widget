import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:meta/meta.dart' as meta;
import 'fake_flutter.dart';

@widget
Widget noArgument() => Container();

@widget
Widget required(foo, int bar) => Container();

@widget
Widget named({foo, int bar}) => Container();

@widget
Widget mixt(foo, int bar, {nfoo, int nbar}) => Container();

@widget
Widget withContext(BuildContext context) => Container();

@widget
Widget withKey(Key key) => Container();

@widget
Widget withContextThenKey(BuildContext context, Key key) => Container();

@widget
Widget withKeyThenContext(Key key, BuildContext context) => Container();

@widget
Widget whateverThenContext(int foo, BuildContext bar) => Container();

@widget
Widget whateverThenKey(int foo, Key bar) => Container();

/// Hello
/// World
@widget
Widget documentation(int foo) => Container();

@widget
Widget annotated({@meta.required int foo}) => Container();

@widget
// ignore: undefined_class
Widget undefinedType({Color foo}) => Container();

@hwidget
Widget hookExample() => Container();

typedef Typedef = void Function();

@widget
Widget typedefFunction(Typedef t) => Container();

@widget
Widget inlineFunction(void t()) => Container();

@widget
Widget inlineFunction2(void Function() t) => Container();

@widget
Widget nestedFunction(void Function(void Function(int a), int b) t) =>
    Container();

@widget
// ignore: undefined_class
Widget unknownTypeFunction(Color Function() t) =>
    Container();
