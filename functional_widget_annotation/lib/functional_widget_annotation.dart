class _FunctionalWidget {
  const _FunctionalWidget();
}

/// A decorator for functions to generate a `StatelessWidget`.
/// 
/// The name of the generated widget is the name of the decorated function,
/// with an uppercase as first letter.
const widget = _FunctionalWidget();

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
const hwidget = _FunctionalWidget();