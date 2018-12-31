// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
import 'dart:async';

import 'package:analyzer/src/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart' as dart_style;
import 'package:json_annotation/json_annotation.dart';
import 'package:functional_widget/function_to_widget_class.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

import 'analysis_utils.dart';
import 'test_file_utils.dart';

Matcher _matcherFromShouldGenerateAnnotation(ConstantReader reader,
    {bool wrapped = false}) {
  String expectedOutput;
  if (wrapped) {
    final expectedWrappedOutput = reader.read('expectedWrappedOutput');
    if (expectedWrappedOutput.isNull) {
      return null;
    }
    expectedOutput = expectedWrappedOutput.stringValue;
  } else {
    expectedOutput = reader.read('expectedOutput').stringValue;
  }

  final isContains = reader.read('contains').boolValue;

  if (isContains) {
    return contains(expectedOutput);
  }
  return equals(expectedOutput);
}

Matcher _throwsInvalidGenerationSourceError(messageMatcher, todoMatcher) =>
    throwsA(const TypeMatcher<InvalidGenerationSourceError>()
        .having((e) => e.message, 'message', messageMatcher)
        .having((e) => e.todo, 'todo', todoMatcher)
        .having((e) => e.element, 'element', isNotNull));

final _formatter = dart_style.DartFormatter();

LibraryReader _library;

final _buildLogItems = <String>[];

const _expectedAnnotatedTests = {
  '_functional_widget_test_input.dart': [
    'Foo',
    'bar',
  ],
};

void main() async {
  final path = testFilePath('test', 'src');
  _library = await resolveCompilationUnit(path);

  StreamSubscription logSubscription;

  setUp(() {
    assert(_buildLogItems.isEmpty);
    assert(logSubscription == null);
    logSubscription = log.onRecord.listen((r) => _buildLogItems.add(r.message));
  });

  tearDown(() async {
    if (logSubscription != null) {
      await logSubscription.cancel();
      logSubscription = null;
    }

    final remainingItems = _buildLogItems.toList();
    _buildLogItems.clear();
    expect(remainingItems, isEmpty,
        reason:
            'Tests should validate entries and clear this before `tearDown`.');
    _buildLogItems.clear();
  });

  // Only need to run this check once!
  test('[all expected files]', () {
    expect(_annotatedElements.keys, _expectedAnnotatedTests.keys);
  });

  for (final entry in _annotatedElements.entries) {
    group(entry.key, () {
      test('[all expected classes]', () {
        expect(
            _expectedAnnotatedTests,
            containsPair(
                entry.key,
                unorderedEquals(
                    entry.value.map<String>((ae) => ae.element.name))));
      });

      for (final annotatedElement in entry.value) {
        _testAnnotatedClass(annotatedElement);
      }
    });
  }
}

void _testAnnotatedClass(AnnotatedElement annotatedElement) {
  final annotationName = annotatedElement.annotation.objectValue.type.name;
  switch (annotationName) {
    case 'ShouldThrow':
      _testShouldThrow(annotatedElement);
      break;
    case 'ShouldGenerate':
      _testShouldGenerate(annotatedElement);
      break;
    default:
      throw UnsupportedError("We don't support $annotationName");
  }
}

void _testShouldThrow(AnnotatedElement annotatedElement) {
  final element = annotatedElement.element;
  final constReader = annotatedElement.annotation;
  final messageMatcher = constReader.read('errorMessage').stringValue;
  var todoMatcher = constReader.read('todo').literalValue;

  test(element.name, () {
    todoMatcher ??= isEmpty;

    expect(
        () => _runForElementNamed(
            const JsonSerializable(useWrappers: false), element.name),
        _throwsInvalidGenerationSourceError(messageMatcher, todoMatcher),
        reason: 'Should fail without wrappers.');

    expect(
        () => _runForElementNamed(
            const JsonSerializable(useWrappers: true), element.name),
        _throwsInvalidGenerationSourceError(messageMatcher, todoMatcher),
        reason: 'Should fail with wrappers.');
  });
}

void _testShouldGenerate(AnnotatedElement annotatedElement) {
  final element = annotatedElement.element;

  final matcher =
      _matcherFromShouldGenerateAnnotation(annotatedElement.annotation);

  final expectedLogItems = annotatedElement.annotation
      .read('expectedLogItems')
      .listValue
      .map((obj) => obj.toStringValue())
      .toList();

  final checked = annotatedElement.annotation.read('checked').boolValue;

  test(element.name, () {
    final output =
        _runForElementNamed(JsonSerializable(checked: checked), element.name);
    expect(output, matcher);

    expect(_buildLogItems, expectedLogItems);
    _buildLogItems.clear();
  });

  final wrappedMatcher = _matcherFromShouldGenerateAnnotation(
      annotatedElement.annotation,
      wrapped: true);
  if (wrappedMatcher != null) {
    test('${element.name} - (wrapped)', () {
      final output = _runForElementNamed(
          JsonSerializable(checked: checked, useWrappers: true), element.name);
      expect(output, wrappedMatcher);

      expect(_buildLogItems, expectedLogItems);
      _buildLogItems.clear();
    });
  }
}

String _runForElementNamed(JsonSerializable config, String name) {
  final generator = FunctionalWidget();
  return _runForElementNamedWithGenerator(generator, name);
}

String _runForElementNamedWithGenerator(
    FunctionalWidget generator, String name) {
  final element = _library.allElements
      .singleWhere((e) => e is! ConstVariableElement && e.name == name);
  final annotation = generator.typeChecker.firstAnnotationOf(element);
  final generated = generator.generateForAnnotatedElement(
      element, ConstantReader(annotation), null);
  // // .map((e) => e.trim())
  // .where((e) => e.isNotEmpty)
  // .map((e) => '$e\n\n')
  // .join();

  final output = _formatter.format(generated);
  printOnFailure("r'''\n$output'''");
  return output;
}

final _annotatedElements = _library.allElements
    .map<AnnotatedElement>((e) {
      for (final md in e.metadata) {
        final reader = ConstantReader(md.constantValue);
        if (const ['ShouldGenerate', 'ShouldThrow']
            .contains(reader.objectValue.type.name)) {
          return AnnotatedElement(reader, e);
        }
      }
      return null;
    })
    .where((ae) => ae != null)
    .fold<Map<String, List<AnnotatedElement>>>(
        <String, List<AnnotatedElement>>{}, (map, annotatedElement) {
      map
          .putIfAbsent(
            annotatedElement.element.source.uri.pathSegments.last,
            () => <AnnotatedElement>[],
          )
          .add(annotatedElement);
      return map;
    });
