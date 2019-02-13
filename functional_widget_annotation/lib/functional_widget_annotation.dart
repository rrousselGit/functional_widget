enum FunctionalWidgetType {
  hook,
  stateless,
}

enum FunctionalWidgetEquality { none, equal, identical }

class FunctionalWidget {
  const FunctionalWidget({
    this.widgetType,
    this.equality,
    this.debugFillProperties,
  });

  final FunctionalWidgetType widgetType;
  final FunctionalWidgetEquality equality;
  final bool debugFillProperties;
}

/// A decorator for functions to generate a `StatelessWidget`.
///
/// The name of the generated widget is the name of the decorated function,
/// with an uppercase as first letter.
const FunctionalWidget widget = FunctionalWidget(
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
