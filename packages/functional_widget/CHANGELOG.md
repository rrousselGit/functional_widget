## [Unreleased]

- Allows nullable widget `Key`

## 0.9.0+2

Fixed an issue where the generator potentially throws an `InconsistentAnalysisException`

## 0.9.0+1

Ugraded dependencies to latest

## 0.9.0

Migrated to null-safety (thanks to @tim-smart)

## 0.8.1

- Updated `analyzer` and `build_runner` versions

## 0.8.0

- removed `@swidget`
- removed `FunctionalWidgetEquality.equal`
- removed `FunctionalWidgetEquality.identical`

## 0.7.3

- Upgraded all the dependencies to latest (thanks to @truongsinh)

## 0.7.1

- support for default values of optional parameters

## 0.7.0

- support `@required` for `Color` and other `dart:ui` types

## 0.6.1

- fixes invalid generation with generic functions

## 0.6.0

- Updated analyzer version to work with `flutter generate` & co

## 0.5.0

- Allows enabling/disable features though both `build.yaml` and a new decorator: `FunctionalWidget`
- `operator==` and `debugFillProperties` overrides are now turned off by default.

## 0.4.0

- Overrides `debugFillProperties` for an integration with the widget inspector.
  This requires adding a new import in your dart files:
  `import 'package:flutter/foundation.dart'`;
- Now overrides `operator==` and `hashCode` on the generated class.

The behavior is that the following function:

```dart
@swidget
Widget foo(int foo, int bar) {
    return Container();
}
```

now generates the following overides:

```dart
@override
int get hashCode => hashValues(foo, bar);

@override
bool operator ==(Object o) =>
    identical(o, this) || (o is Foo && foo == o.foo && bar == o.bar);
```

This is useful because overriding `operator==` prevents pointless rebuild when no parameter change.

## 0.3.0

- Support function callbacks and generic functions:

```dart
@swidget
Widget foo<T>(void onTap(T value)) {
    // do something
}
```

- Updated support for `HookWidget` using new annotation `@hwidget`:

```dart
@hwidget
Widget foo() {
    final counter = useState(0);
    // do something
}
```

## 0.2.2

- Readme update

## 0.2.1

- Fix bug where types from `dart:ui` where generated as `dynamic`

## 0.2.0

- Rename generator
- Add documentation

## 0.1.0

- Generate class documentation from the function documentation.
- Pass down decorators from function parameter to class constructor

## 0.0.1

Initial release
