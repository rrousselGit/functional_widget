import 'package:analyzer/dart/constant/value.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:source_gen/source_gen.dart';

FunctionalWidget parseFunctionalWidetAnnotation(ConstantReader reader) {
  return FunctionalWidget(
    widgetType: _parseEnum(reader.read('widgetType'), FunctionalWidgetType.values),
    equality:
        _parseEnum(reader.read('equality'), FunctionalWidgetEquality.values),
  );
}

T _parseEnum<T>(ConstantReader reader, List<T> values) => reader.isNull
    ? null
    : _enumValueForDartObject(
        reader.objectValue, values, (f) => f.toString().split('.')[1]);

// code from json_serializable
T _enumValueForDartObject<T>(
        DartObject source, List<T> items, String Function(T) name) =>
    items.singleWhere(
      (v) => source.getField(name(v)) != null,
      // TODO: remove once pkg:analyzer < 0.35.0 is no longer supported
      orElse: () => items[source.getField('index').toIntValue()],
    );
