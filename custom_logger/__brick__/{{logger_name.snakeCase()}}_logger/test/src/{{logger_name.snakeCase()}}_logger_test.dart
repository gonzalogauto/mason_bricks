// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:{{logger_name.snakeCase()}}_logger/{{logger_name.snakeCase()}}_logger.dart';

void main() {
  group('{{logger_name.pascalCase()}}Logger', () {
    test('can be instantiated', () {
      expect({{logger_name.pascalCase()}}Logger(), isNotNull);
    });
  });
}
