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

  /// Will generate a `HookConsumerWidget`, from `hooks_riverpod` package.
  ///
  /// `HookConsumerWidget` must be installed as a separate dependency:
  /// ```yaml
  /// dependencies:
  ///   hooks_riverpod: any
  /// ```
  hookConsumer,

  /// Will generate a `ConsumerWidget`, from `flutter_riverpod` package.
  ///
  /// `ConsumerWidget` must be installed as a separate dependency:
  /// ```yaml
  /// dependencies:
  ///   riverpod: any
  /// ```
  consumer,

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

  /// Defines the name of the generated widget.
  ///
  /// By default, uses the function name, such that:
  ///
  /// - `Widget _myWidget(...)` generates `class MyWidget`
  /// - `Widget __myWidget(...)` generates `class _MyWidget`
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

/// A decorator for functions to generate a `HookConsumerWidget`.
///
/// `HookConsumerWidget` must be installed as a separate dependency:
/// ```yaml
/// dependencies:
///   hooks_riverpod: any
/// ```
///
/// The name of the generated widget is the name of the decorated function,
/// with an uppercase as first letter.
const FunctionalWidget hcwidget = FunctionalWidget(
  widgetType: FunctionalWidgetType.hookConsumer,
);

/// A decorator for functions to generate a `ConsumerWidget`.
///
/// `ConsumerWidget` must be installed as a separate dependency:
/// ```yaml
/// dependencies:
///   riverpod: any
/// ```
///
/// The name of the generated widget is the name of the decorated function,
/// with an uppercase as first letter.
const FunctionalWidget cwidget = FunctionalWidget(
  widgetType: FunctionalWidgetType.consumer,
);
