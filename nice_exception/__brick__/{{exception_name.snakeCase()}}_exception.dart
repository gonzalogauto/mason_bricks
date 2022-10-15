import 'package:freezed_annotation/freezed_annotation.dart';

part '{{exception_name.snakeCase()}}_exception.freezed.dart';

@freezed
class {{exception_name.pascalCase()}}Exception with _${{exception_name.pascalCase()}}Exception implements Exception {
  const factory {{exception_name.pascalCase()}}Exception.otherError({
    required Object error,
    required StackTrace stacktrace,
  }) = _OtherError;
  {{#error_types}}
  const factory {{exception_name.pascalCase()}}Exception.{{..camelCase()}}Error({
    @Default('{{..pascalCase()}}Error') String? message,
  }) = _{{..pascalCase()}}Error;
  {{/error_types}}
}
