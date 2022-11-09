import 'dart:developer' as dev show log;
{{#use_crashlytics}}import 'package:firebase_crashlytics/firebase_crashlytics.dart';{{/use_crashlytics}}
import './log_level.dart';

/// [{{logger_name.pascalCase()}}Logger] is a custom logger that can be used
/// to report errors to another service like Crashlytics
class {{logger_name.pascalCase()}}Logger {
  {{#use_crashlytics}}{{logger_name.pascalCase()}}Logger(
    FirebaseCrashlytics? crashlytics,
  ) : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  final FirebaseCrashlytics _crashlytics;{{/use_crashlytics}}
  /// [debug] level
  void debug(String message) {
    _log(message, level: LogLevel.debug);
  }

  /// [info] level (usefull when you need more context about what is happening)
  void info(String message) {
    _log(message, level: LogLevel.info);
  }

  /// [warning] level
  void warning(String message) {
    _log(message, level: LogLevel.warning);
  }

  /// [error] level (Simulate a "crash")
  void error(String message) {
    _log(message, level: LogLevel.error);
    /// Collect the Crashlytics logs and send to server immediately, only
    /// for high serverity logs
    _throwAndReportError(message);
  }

  /// [critical] level
  void critical(
    String message,
  ) {
    _log(message, level: LogLevel.critical);
    /// Collect the Crashlytics logs and send to server immediately, only
    /// for high serverity logs
    _throwAndReportError(message);
  }

  /// [exception] level (This sends the complete error `Object` with
  /// the corresponding `StackTrace`)
  void exception(Object error, StackTrace stackTrace, {Object? reason}) {
    _log('The following exception occurred: $error', level: LogLevel.critical);
    /// Collect the Crashlytics logs and send to server immediately, only
    /// for high serverity logs
    {{#use_crashlytics}}_crashlytics.recordError(error, stackTrace, reason: reason, fatal: true);{{/use_crashlytics}}
  }

  void _log(String message, {LogLevel level = LogLevel.info}) {
    final currentTime = DateTime.now();
    dev.log(
      message,
      level: level.value,
      time: currentTime,
    );
    {{#use_crashlytics}}_crashlytics.log('${level.name}(level): $message');{{/use_crashlytics}}
  }

  /// Simulate a "crash" so that we can collect the stack trace and report to
  /// crashlytics
  void _throwAndReportError(String message) {
    try {
      throw Exception(message);
    } catch (error, stackTrace) {
      {{^use_crashlytics}}// TODO(): send the error and stackTrace to Crashlytics or another service{{/use_crashlytics}}
      {{#use_crashlytics}}_crashlytics.recordError(error, stackTrace, reason: message, fatal: true);{{/use_crashlytics}}
    }
  }

}
