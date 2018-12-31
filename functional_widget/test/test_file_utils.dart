// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore: uri_does_not_exist
import 'dart:mirrors';

import 'package:path/path.dart' as p;

String testFilePath(String part1, [String part2, String part3]) =>
    p.join(_packagePath(), part1, part2, part3);

String _packagePathCache;

String _packagePath() {
  if (_packagePathCache == null) {
    // Getting the location of this file – via reflection
    // ignore: undefined_function, cast_to_non_type
    final currentFilePath = (reflect(_packagePath) as ClosureMirror)
        .function
        .location
        .sourceUri
        .path;

    // ignore: argument_type_not_assignable
    _packagePathCache = p.normalize(p.join(p.dirname(currentFilePath), '..'));
  }
  return _packagePathCache;
}
