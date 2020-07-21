// ignore_for_file: implicit_dynamic_parameter

import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:meta/meta.dart' as meta;
import 'fake_flutter.dart';

@swidget
Widget sWidget() => Container();

@hwidget
Widget hWidget() => Container();

@swidget
Widget adaptiveWidget() => Container();

@swidget
Widget noArgument() => Container();

@swidget
Widget required(foo, int bar) => Container();

@swidget
Widget named({foo, int bar}) => Container();

@swidget
Widget namedDefault({int foo = 42}) => Container();

@swidget
Widget mixt(foo, int bar, {nfoo, int nbar}) => Container();

@swidget
Widget onlyOneArg(int foo) => Container();

@swidget
Widget withContext(BuildContext context) => Container();

@swidget
Widget withContextThenOneArg(BuildContext context, int foo) => Container();

@swidget
Widget withKey(Key key) => Container();

@swidget
Widget withKeyThenOneArg(Key key, int foo) => Container();

@swidget
Widget withContextThenKey(BuildContext context, Key key) => Container();

@swidget
Widget withContextThenKeyThenOneArg(BuildContext context, Key key, int foo) =>
    Container();

@swidget
Widget withKeyThenContext(Key key, BuildContext context) => Container();

@swidget
Widget withKeyThenContextThenOneArg(Key key, BuildContext context, int foo) =>
    Container();

@swidget
Widget whateverThenContext(int foo, BuildContext bar) => Container();

@swidget
Widget whateverThenKey(int foo, Key bar) => Container();

/// Hello
/// World
@swidget
Widget documentation(int foo) => Container();

@swidget
Widget annotated({@meta.required int foo}) => Container();

@swidget
// ignore: undefined_class
Widget undefinedType({Color foo}) => Container();

@swidget
// ignore: undefined_class
Widget annotatedUndefinedType({@meta.required Color foo}) => Container();

@hwidget
Widget hookExample() => Container();

typedef Typedef<T> = void Function(T);

@swidget
Widget typedefFunction<T>(Typedef<T> t) => Container();

@swidget
// ignore: use_function_type_syntax_for_parameters
Widget inlineFunction(void t()) => Container();

@swidget
Widget inlineFunction2(void Function() t) => Container();

@swidget
Widget nestedFunction(void Function(void Function(int a), int b) t) =>
    Container();

@swidget
// ignore: undefined_class
Widget unknownTypeFunction(Color Function() t) => Container();

@swidget
Widget generic<T>(T foo) => Container();

@swidget
Widget genericMultiple<T, S>(T foo, S bar) => Container();

@swidget
Widget genericExtends<T extends Container>(T foo) => Container();

@swidget
Widget genericClass<T>(T Function() foo) => Container();

// ignore: prefer_generic_function_type_aliases
typedef T _GenericFunction<T>(T foo);

@swidget
Widget genericFunction(_GenericFunction<int> foo) => Container();

typedef _GenericFunction2 = T Function<T>(T foo);

@swidget
Widget genericFunction2(_GenericFunction2 foo) => Container();

typedef _GenericFunction3<T, U> = U Function(T foo);

@swidget
Widget genericFunction3(_GenericFunction3<int, String> foo) => Container();
