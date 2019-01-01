## 0.3.0

-   Support function callbacks and generic functions:

```dart
@widget
Widget foo<T>(void onTap(T value)) {
    // do something
}
```

-   Updated support for `HookWidget` using new annotation `@hwidget`:

```dart
@hwidget
Widget foo() {
    final counter = useState(0);
    // do something
}
```

## 0.2.2

-   Readme update

## 0.2.1

-   Fix bug where types from `dart:ui` where generated as `dynamic`

## 0.2.0

-   Rename generator
-   Add documentation

## 0.1.0

-   Generate class documentation from the function documentation.
-   Pass down decorators from function parameter to class constructor

## 0.0.1

Initial release
