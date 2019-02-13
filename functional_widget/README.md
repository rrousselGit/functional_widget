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

---

_functional_widgets_, is an attempt to solve this issue, using a code generator.

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

### Customize the output

It is possible to customize the output of the generator by using different decorators or configuring default values in `build.yaml` file.

`build.yaml` change the default behavior of a configuration.

```yaml
# build.yaml
targets:
  $default:
    builders:
      functional_widget:
        options:
          # Default values:
          debugFillProperties: false
          widgetType: stateless # or 'hook'
          equality: none # or 'identical'/'equal'
```

`FunctionalWidget` decorator will override the default behavior for one specific widget.

```dart
@FunctionalWidget(
  debugFillProperties: true,
  widgetType: FunctionalWidgetType.hook,
  equality: FunctionalWidgetEquality.identical,
)
Widget foo() => Container();
```

## debugFillProperties

Widgets can be override `debugFillProperties` to display custom fields on the widget inspector. `functional_widget` offer to generate these bits for your, by enabling `debugFillProperties` option.

For this to work, it is required to add the following import:

```dart
import 'package:flutter/foundation.dart';
```

Example:

(You write)

```dart
import 'package:flutter/foundation.dart';

@widget
Widget example(int foo, String bar) => Container();
```

(It generates)

```dart
class Example extends HookWidget {
  const Example(this.foo, this.bar, {Key key}) : super(key: key);

  final int foo;

  final String bar;

  @override
  Widget build(BuildContext _context) => example(foo, bar);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('foo', foo));
    properties.add(StringProperty('bar', bar));
  }
}
```

## Generate different type of widgets

By default, the generated widget is a `StatelessWidget`.

It is possible to generate a `HookWidget` instead (from https://github.com/rrousselGit/flutter_hooks)







### All the potential syntaxes

_functional_widget_ will inject widget specific parameters if you ask for them.
You can potentially write any of the following:

```dart
Widget foo();
Widget foo(BuildContext context);
Widget foo(Key key);
Widget foo(BuildContext context, Key key);
Widget foo(Key key, BuildContext context);
```

You can then add however many arguments you like **after** the previously defined arguments. They will then be added to the class constructor and as a widget field:

- positional

```dart
@widget
Widget foo(int value) => Text(value.toString());

// USAGE

Foo(42);
```

- named:

```dart
@widget
Widget foo({int value}) => Text(value.toString());

// USAGE

Foo(value: 42);
```

- A bit of everything:

```dart
@widget
Widget foo(BuildContext context, int value, { int value2 }) {
  return Text('$value $value2');
}

// USAGE

Foo(42, value2: 24);
```
