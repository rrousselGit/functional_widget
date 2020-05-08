// ignore_for_file: implicit_dynamic_parameter

import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:meta/meta.dart' as meta;
import 'fake_flutter.dart';

@swidget
Widget sWidget() => Container();

@hwidget
Widget hWidget() => Container();

@widget
Widget adaptiveWidget() => Container();

@widget
Widget noArgument() => Container();

@widget
Widget required(foo, int bar) => Container();

@widget
Widget named({foo, int bar}) => Container();

@widget
Widget namedDefault({int foo = 42}) => Container();

@widget
Widget mixt(foo, int bar, {nfoo, int nbar}) => Container();

@widget
Widget onlyOneArg(int foo) => Container();

@widget
Widget withContext(BuildContext context) => Container();

@widget
Widget withContextThenOneArg(BuildContext context, int foo) => Container();

@widget
Widget withKey(Key key) => Container();

@widget
Widget withKeyThenOneArg(Key key, int foo) => Container();

@widget
Widget withContextThenKey(BuildContext context, Key key) => Container();

@widget
Widget withContextThenKeyThenOneArg(BuildContext context, Key key, int foo) =>
    Container();

@widget
Widget withKeyThenContext(Key key, BuildContext context) => Container();

@widget
Widget withKeyThenContextThenOneArg(Key key, BuildContext context, int foo) =>
    Container();

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

@widget
// ignore: undefined_class
Widget annotatedUndefinedType({@meta.required Color foo}) => Container();

@hwidget
Widget hookExample() => Container();

typedef Typedef<T> = void Function(T);

@widget
Widget typedefFunction<T>(Typedef<T> t) => Container();

@widget
Widget inlineFunction(void t()) => Container();

@widget
Widget inlineFunction2(void Function() t) => Container();

@widget
Widget nestedFunction(void Function(void Function(int a), int b) t) =>
    Container();

@widget
// ignore: undefined_class
Widget unknownTypeFunction(Color Function() t) => Container();

@widget
Widget generic<T>(T foo) => Container();

@widget
Widget genericMultiple<T, S>(T foo, S bar) => Container();

@widget
Widget genericExtends<T extends Container>(T foo) => Container();

@widget
Widget genericClass<T>(T Function() foo) => Container();

typedef T _GenericFunction<T>(T foo);

@widget
Widget genericFunction(_GenericFunction<int> foo) => Container();

typedef _GenericFunction2 = T Function<T>(T foo);

@widget
Widget genericFunction2(_GenericFunction2 foo) => Container();
