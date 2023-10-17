{{#use_crashlytics}}import 'package:flutter/material.dart';{{/use_crashlytics}}

/// [{{logger_name.pascalCase()}}LoggerContract] class
abstract class {{logger_name.pascalCase()}}LoggerContract {
  
  /// [debug] level
  void debug(String message);

  /// [info] level (usefull when you need more context about what is happening)
  void info(String message);
  
  /// [warning] level
  void warning(String message);
  
  /// [error] level (Simulate a "crash")
  void error(String message);

  /// [critical] level
  void critical(String message);
  
  /// [exception] level (This sends the complete error `Object` with
  /// the corresponding `StackTrace`)
  void exception(
    Object error,
    StackTrace stackTrace, {
    Object? reason,
    bool fatal = true,
  });
  {{#use_crashlytics}}
  /// [recordFlutterFatalError] method used to record a Flutter error as fatal
  void recordFlutterFatalError(FlutterErrorDetails flutterErrorDetails);

  /// [recordFlutterFatalError] method used to record a Flutter error as 
  /// non-fatal
  void recordFlutterError(FlutterErrorDetails flutterErrorDetails);{{/use_crashlytics}}
}
