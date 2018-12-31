// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

//ignore_for_file: avoid_unused_constructor_parameters, prefer_initializing_formals
import 'package:flutter/widgets.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'annotation.dart';

@ShouldThrow('Error, the decorated element is not a function')
class Foo {}

@ShouldGenerate('''
class Bar extends StatelessWidget {
  const Bar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => bar();
}
''')
@widget
Widget bar() {
  return Container();
}
