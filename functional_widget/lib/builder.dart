import 'package:build/build.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:source_gen/source_gen.dart';

Builder functionalWidget(BuilderOptions options) {
  return SharedPartBuilder([MyGenerator()], 'functional_widget');
}
