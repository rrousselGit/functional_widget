enum FunctionalWidgetType {
  hook,
  stateless,
}

class FunctionalWidget {
  const FunctionalWidget({this.type});

  final FunctionalWidgetType type;
}

/// A decorator for functions to generate a `StatelessWidget`.
///
/// The name of the generated widget is the name of the decorated function,
/// with an uppercase as first letter.
const FunctionalWidget widget = FunctionalWidget(
  type: FunctionalWidgetType.stateless,
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
  type: FunctionalWidgetType.hook,
);
