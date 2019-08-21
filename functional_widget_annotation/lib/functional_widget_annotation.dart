/// Determines which type of widget will be generated
///
/// Defaults to [stateless].
enum FunctionalWidgetType {
  /// Will generate a `HookWidget`, from `flutter_hooks` package.
  ///
  /// `HookWidget` must be installed as a separate dependency:
  /// ```yaml
  /// dependencies:
  ///   flutter_hooks: any
  /// ```
  hook,

  /// Will generate a `StatelessWidget`.
  stateless,
}

/// Determines how [operator==] and [hashCode] of the class will be treated.
///
/// Defaults to [none].
enum FunctionalWidgetEquality {
  /// No override.
  none,

  /// Compares all fields besides `BuildContext` and `Key` using [operator==].
  ///
  /// Example of generated code:
  /// ```dart
  /// class Foo extends StatelessWidget {
  ///   const Foo(this.value, {Key key}) : super(key: key);
  ///
  ///   final int value;
  ///
  ///   @override
  ///   Widget build(BuildContext _context) => foo(value);
  ///   @override
  ///   int get hashCode => value.hashCode;
  ///   @override
  ///   bool operator ==(Object o) =>
  ///       identical(o, this) || (o is Foo && value == o.value);
  /// }
  /// ```
  equal,

  /// Compares all fields besides `BuildContext` and `Key` using [identical].
  ///
  /// Example of generated code:
  /// ```dart
  /// class Foo extends StatelessWidget {
  ///   const Foo(this.value, {Key key}) : super(key: key);
  ///
  ///   final int value;
  ///
  ///   @override
  ///   Widget build(BuildContext _context) => foo(value);
  ///   @override
  ///   int get hashCode => value.hashCode;
  ///   @override
  ///   bool operator ==(Object o) =>
  ///       identical(o, this) || (o is Foo && identical(value, o.value));
  /// }
  /// ```
  identical
}

/// Decorates a function to customize the generated class
class FunctionalWidget {
  const FunctionalWidget({
    this.widgetType,
    this.equality,
    this.debugFillProperties,
    this.removeLeadingUnderscore,
  });

  /// Configures which types of widget is generated.
  ///
  /// Defaults to [FunctionalWidgetType.stateless].
  final FunctionalWidgetType widgetType;

  /// Configures how [operator==] and [hashCode] behaves
  ///
  /// Defaults to [FunctionalWidgetEquality.none].
  final FunctionalWidgetEquality equality;

  /// Defines if the generated widget should emit diagnostics informations.
  final bool debugFillProperties;

  /// If `true` the leading underscore of the function is removed. This way,
  /// a private function can be used to create a public widget class. If the
  /// function does not have a leading underscore, this option is ignored.
  ///
  /// For example, the function `_foo` would generate class `Foo`.
  final bool removeLeadingUnderscore;
}

/// A decorator for functions to generate a `Widget`.
///
/// The type of the generated widget depends on the configurations from `build.yaml` file.
/// Defaults to `StatelessWidget`.
///
/// The name of the generated widget is the name of the decorated function,
/// with an uppercase as first letter.
const FunctionalWidget widget = FunctionalWidget();

/// A decorator for functions to generate a `StatelessWidget`.
///
/// The name of the generated widget is the name of the decorated function,
/// with an uppercase as first letter.
const FunctionalWidget swidget = FunctionalWidget(
  widgetType: FunctionalWidgetType.stateless,
);

/// A decorator for functions to generate a `HookWidget`.
///
/// `HookWidget` must be installed as a separate dependency:
/// ```yaml
/// dependencies:
///   flutter_hooks: any
/// ```
///
/// The name of the generated widget is the name of the decorated function,
/// with an uppercase as first letter.
const FunctionalWidget hwidget = FunctionalWidget(
  widgetType: FunctionalWidgetType.hook,
);
