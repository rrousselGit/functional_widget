// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// FunctionalWidgetGenerator
// **************************************************************************

class Foo extends HookWidget {
  const Foo(this.value, {Key key}) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext _context) => foo(value);
  @override
  int get hashCode => value.hashCode;
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is Foo && value == o.value);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('value', value));
  }
}

class Example extends HookWidget {
  const Example(this.foo, this.bar, {Key key}) : super(key: key);

  final int foo;

  final String bar;

  @override
  Widget build(BuildContext _context) => example(foo, bar);
  @override
  int get hashCode => hashValues(foo, bar);
  @override
  bool operator ==(Object o) =>
      identical(o, this) || (o is Example && foo == o.foo && bar == o.bar);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('foo', foo));
    properties.add(StringProperty('bar', bar));
  }
}
