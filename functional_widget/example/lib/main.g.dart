// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// FunctionalWidgetGenerator
// **************************************************************************

class Foo extends StatelessWidget {
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

class Example extends StatelessWidget {
  const Example(this.foo, this.bar, {Key key, this.onChanged})
      : super(key: key);

  final int foo;

  final String bar;

  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext _context) =>
      example(foo, bar, onChanged: onChanged);
  @override
  int get hashCode => hashValues(foo, bar, onChanged);
  @override
  bool operator ==(Object o) =>
      identical(o, this) ||
      (o is Example &&
          foo == o.foo &&
          bar == o.bar &&
          onChanged == o.onChanged);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('foo', foo));
    properties.add(StringProperty('bar', bar));
    properties.add(ObjectFlagProperty<dynamic>.has('onChanged', onChanged));
  }
}
