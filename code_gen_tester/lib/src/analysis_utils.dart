// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

Future<LibraryReader> resolveCompilationUnit(String filePath) async {
  final assetId = AssetId.parse('a|lib/${p.basename(filePath)}');
  final files =
      Directory(p.dirname(filePath)).listSync().whereType<File>().toList();

  final fileMap = Map<String, String>.fromEntries(files.map(
      (f) => MapEntry('a|lib/${p.basename(f.path)}', f.readAsStringSync())));

  final library = await resolveSources(fileMap, (item) async {
    return await item.libraryFor(assetId);
  }, resolverFor: 'a|lib/${p.basename(filePath)}');

  return LibraryReader(library);
}
