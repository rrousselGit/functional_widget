## 0.10.0

- Changed the logic for how the generated widget name is determined. (thanks to @doejon)
  Now, defining:

  ```dart
  @swidget
  Widget first() {}

  @swidget
  Widget _second() {}

  @swidget
  Widget __third() {}
  ```

  generates:

  ```dart
  class First {...}
  class Second {...}
  class _Third {...}
  ```

  That gives more control over whether the generated class is public or private.

- Added support for manually overriding the generated widget name (thanks to @doejon)

  ```
  @FunctionalWidget(name: 'MyClass')
  Widget _myWidget() {}
  ```

- Correctly support advanced annotations on widget parameters (thanks to @Almighty-Alpaca)

- Upgraded dependencies to support analyzer 3.0.0 and 4.0.0 (thanks to @realshovanshah)

## 0.9.2

Added support for `HookConsumerWidget` and `ConsumerWidget` from [Riverpod](https://pub.dev/packages/riverpod) (thanks to @tim-smart)

## 0.9.0+1

Fix homepage URL

## 0.9.0

Migrated to null-safety (thanks to @tim-smart)

## 0.8.0

- removed `@swidget`
- removed `FunctionalWidgetEquality.equal`
- removed `FunctionalWidgetEquality.identical`

## 0.5.3

- deprecated `@swidget`
- deprecated `FunctionalWidgetEquality.equal`
- deprecated `FunctionalWidgetEquality.identical`

## 0.0.1

Initial release
