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
