Widgets are cool. But classes are quite verbose:

```dart
class Foo extends StatelessWidget {
  final int value;
  final int value2;

  const Foo({Key key, this.value, this.value2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('$value $value2');
  }
}
```


So much code for something that could be done much better using a plain function: 

```dart
Widget foo(BuildContext context, { int value, int value2 }) {
  return Text('$value $value2');
}
```



The problem is, using functions instead of classes is not recommended:

- https://stackoverflow.com/questions/53234825/what-is-the-difference-between-functions-and-classes-to-create-widgets/53234826#53234826
- https://github.com/flutter/flutter/issues/19269




... Or is it?


____


Introducing _functional_widgets_, a code generator that generates widget classes from functions.

Simply write your widget as a function, decorate it with a `@widget`, and then this library will generate a class for you to use.




## Example


You write: 

```dart
part 'main.g.dart';

@widget
Widget foo(BuildContext context, int value) {
  return Text('$value');
}
```


It generates:

```dart
part of 'main.dart'

class Foo extends StatelessWidget {
  final int value;

  const Foo(this.value, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return foo(context, value);
  }
}
```


And then you use it:

```dart
runApp(
    Foo(42)
);
```

