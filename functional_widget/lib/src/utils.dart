import 'package:analyzer/dart/constant/value.dart';
import 'package:build/build.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:source_gen/source_gen.dart';

const _kKnownOptionsName = ['widgetType', 'equality', 'debugFillProperties'];

FunctionalWidget parseBuilderOptions(BuilderOptions options) {
  final unknownOption = options?.config?.keys?.firstWhere(
      (key) => !_kKnownOptionsName.contains(key),
      orElse: () => null);

  if (unknownOption != null) {
    throw ArgumentError(
        'Unknown option `$unknownOption`: ${options.config[unknownOption]}');
  }
  final widgetType = _parseWidgetType(options.config['widgetType']);
  final debugFillProperties =
      _parseDebugFillProperties(options.config['debugFillProperties']);
  final equality = _parseEquality(options.config['equality']);
  return FunctionalWidget(
    widgetType: widgetType,
    debugFillProperties: debugFillProperties,
    equality: equality,
  );
}

bool _parseDebugFillProperties(dynamic value) {
  if (value == null) {
    // ignore: avoid_returning_null
    return null;
  }
  if (value is bool) {
    return value;
  }
  throw ArgumentError.value(value, 'debugFillProperties',
      'Invalid value. Potential values are `true` or `false`');
}

FunctionalWidgetEquality _parseEquality(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is String) {
    switch (value) {
      case 'none':
        return FunctionalWidgetEquality.none;
      case 'equal':
        return FunctionalWidgetEquality.equal;
      case 'identical':
        return FunctionalWidgetEquality.identical;
    }
  }
  throw ArgumentError.value(value, 'widgetType',
      'Invalid value. Potential values are `none`/`equal`/`identical`');
}

FunctionalWidgetType _parseWidgetType(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is String) {
    switch (value) {
      case 'hook':
        return FunctionalWidgetType.hook;
      case 'stateless':
        return FunctionalWidgetType.stateless;
    }
  }
  throw ArgumentError.value(value, 'widgetType',
      'Invalid value. Potential values are `hook` or `stateless`');
}

FunctionalWidget parseFunctionalWidgetAnnotation(ConstantReader reader) {
  return FunctionalWidget(
    widgetType:
        _parseEnum(reader.read('widgetType'), FunctionalWidgetType.values),
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
