import 'package:build/build.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:source_gen/source_gen.dart';

/// Builds generators for `build_runner` to run
Builder functionalWidget(BuilderOptions options) {
  return SharedPartBuilder([FunctionalWidgetGenerator()], 'functional_widget');
}
