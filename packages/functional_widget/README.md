[![Build](https://github.com/rrousselGit/functional_widget/actions/workflows/build.yml/badge.svg)](https://github.com/rrousselGit/functional_widget/actions/workflows/build.yml)
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

Simply write your widget as a function, decorate it with a `@swidget`, and then
this library will generate a class for you to use.

As the added benefit, you also get for free the ability to inspect the parameters
passed to your widgets in the devtool

## Example

You write:

```dart
@swidget
Widget foo(BuildContext context, int value) {
  return Text('$value');
}
```

It generates:

```dart
class Foo extends StatelessWidget {
  const Foo(this.value, {Key key}) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext context) {
    return foo(context, value);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('value', value));
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

### Install (builder)

There are a few separate packages you need to install:

- `functional_widget_annotation`, a package containing decorators. You must
  install it as `dependencies`.
- `functional_widget`, a code-generator that uses the decorators from the previous
  packages to generate your widget.
- `build_runner`, a dependency that all applications using code-generation should have

Your `pubspec.yaml` should look like:

```yaml
dependencies:
  functional_widget_annotation: ^0.8.0

dev_dependencies:
  functional_widget: ^0.8.0
  build_runner: ^1.9.0
```

That's it!

You can then start the code-generator with:

```sh
flutter pub run build_runner watch
```

## Customize the output

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
```

`FunctionalWidget` decorator will override the default behavior for one specific widget.

```dart
@FunctionalWidget(
  debugFillProperties: true,
  widgetType: FunctionalWidgetType.hook,
)
Widget foo() => Container();
```

### debugFillProperties override

Widgets can be override `debugFillProperties` to display custom fields on the widget inspector. `functional_widget` offer to generate these bits for your, by enabling `debugFillProperties` option.

For this to work, it is required to add the following import:

```dart
import 'package:flutter/foundation.dart';
```

Example:

(You write)

```dart
import 'package:flutter/foundation.dart';

@swidget
Widget example(int foo, String bar) => Container();
```

(It generates)

```dart
class Example extends StatelessWidget {
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

### Generate different type of widgets

By default, the generated widget by `@FunctionalWidget()` is a `StatelessWidget`.

It is possible to generate a `HookWidget` instead (from https://github.com/rrousselGit/flutter_hooks)

There are a few ways to do so:

- Through `build.yaml`:

  ```yaml
  # build.yaml
  targets:
    $default:
      builders:
        functional_widget:
          options:
            widgetType: hook
  ```

  then used as:

  ```dart
  @FunctionalWidget()
  Widget example(int foo, String bar) => Container();
  ```

- With parameters on the `@FunctionalWidget` decorator:

  ```dart
  @FunctionalWidget(widgetType: FunctionalWidgetType.hook)
  Widget example(int foo, String bar) => Container();
  ```

- With parameters on the `@FunctionalWidget` decorator that will export the generated widget for private functions:

  ```dart
  @FunctionalWidget(public: true)
  Widget _privateButExportedExample(int foo, String bar) => Container();
  ```

- With parameters on the `@FunctionalWidget` decorator that will replace the name with a custom name:

  ```dart
  @FunctionalWidget(name: "CustomName")
  Widget willReceiveCustomNameExample(int foo, String bar) => Container();
  ```

- With the shorthand `@hwidget` decorator:

  ```dart
  @hwidget
  Widget example(int foo, String bar) => Container();
  ```

In any cases, `flutter_hooks` must be added as a separate dependency in the `pubspec.yaml`

```yaml
dependencies:
  flutter_hooks: # some version number
```

### All the potential function prototypes

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
@swidget
Widget foo(int value) => Text(value.toString());

// USAGE

Foo(42);
```

- named:

```dart
@swidget
Widget foo({int value}) => Text(value.toString());

// USAGE

Foo(value: 42);
```

- A bit of everything:

```dart
@swidget
Widget foo(BuildContext context, int value, { int value2 }) {
  return Text('$value $value2');
}

// USAGE

Foo(42, value2: 24);
```

### Private vs public widgets

In order to allow for private function definitions but exported widgets, all
decorated widget functions with a single underscore will generate an exported widget.

```dart
@swidget
Widget _foo(BuildContext context, int value, { int value2 }) {
  return Text('$value $value2');
}

// USAGE

Foo(42, value2: 24);
```

In order to keep generated widget private, do use two underscores:

```dart
@swidget
Widget __foo(BuildContext context, int value, { int value2 }) {
  return Text('$value $value2');
}

// USAGE

_Foo(42, value2: 24);
```
