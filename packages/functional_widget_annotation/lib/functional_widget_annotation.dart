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

/// Decorates a function to customize the generated class
class FunctionalWidget {
  const FunctionalWidget({
    this.widgetType = FunctionalWidgetType.stateless,
    this.debugFillProperties,
    this.name,
  });

  /// Configures which types of widget is generated.
  ///
  /// Defaults to [FunctionalWidgetType.stateless].
  final FunctionalWidgetType widgetType;

  /// Defines if the generated widget should emit diagnostics informations.
  final bool? debugFillProperties;

  /// Name specifies the widget's name
  final String? name;
}

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
