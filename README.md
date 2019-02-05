[![Build Status](https://travis-ci.org/rrousselGit/functional_widget.svg?branch=master)](https://travis-ci.org/rrousselGit/functional_widget)
[![pub package](https://img.shields.io/pub/v/functional_widget.svg)](https://pub.dartlang.org/packages/functional_widget) [![pub package](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter)


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
@widget
Widget foo(BuildContext context, int value) {
  return Text('$value');
}
```


It generates:

```dart
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



## How to use

### Install

There are a few separate packages you need to install:

- `functional_widget_annotation`, a package containing decorators. You must install it as `dependencies`.
- `functional_widget`, a generator that uses the decorators from the previous packages to generate your widget. Install it as `dev_dependencies`
- `build_runner`, a tool that is able to run code-generators. Install it as `dev_dependencies`

```yaml
dependencies:
  functional_widget_annotation: ^0.3.0

dev_dependencies:
  functional_widget: ^0.4.0
  build_runner: ^1.1.2
```



### Run the generator

To run the generator, you must use `build_runner` cli:


```sh
flutter pub pub run build_runner watch
```

### All the potential syntaxtes

_functional_widget_ will inject widget specific parameters if you ask for them.
You can potentially write any of the following:

```dart
Widget foo();
Widget foo(BuildContext context);
Widget foo(Key key);
Widget foo(BuildContext context, Key key);
Widget foo(Key key, BuildContext context);
```

You can also replace `BuildContext` by `HookContext` from https://github.com/rrousselGit/flutter_hooks

You can then add however many arguments you like **after** the previously defined arguments. They will then be added to the class constructor and as a widget field:

- positional
```dart
@widget
Widget foo(int value) => Text(value.toString());

// USAGE

new Foo(42);
```

- named:

```dart
@widget
Widget foo({int value}) => Text(value.toString());

// USAGE

new Foo(value: 42);
```

- A bit of everything:

```dart
@widget
Widget foo(BuildContext context, int value, { int value2 }) {
  return Text('$value $value2')
}

// USAGE

new Foo(42, value2: 24);
```

