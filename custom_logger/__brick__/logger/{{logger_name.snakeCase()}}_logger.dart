import 'dart:developer' as dev show log;
{{#use_crashlytics}}import 'package:firebase_crashlytics/firebase_crashlytics.dart';{{/use_crashlytics}}
import 'log_levels/log_level.dart';
import 'contract/{{logger_name.snakeCase()}}_contract.dart';

/// [{{logger_name.pascalCase()}}Logger] is a custom logger that can be used
/// to report errors to another service like Crashlytics
class {{logger_name.pascalCase()}}Logger implements {{logger_name.pascalCase()}}LoggerContract{
  {{#use_crashlytics}}/// [{{logger_name.pascalCase()}}Logger] constructor 
  /// (here we initialize Firebase Crashlytics)
  {{logger_name.pascalCase()}}Logger(
    FirebaseCrashlytics? crashlytics,
  ) : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  final FirebaseCrashlytics _crashlytics;{{/use_crashlytics}}
  
  @override
  void debug(String message) {
    _log(message, level: LogLevel.debug);
  }

  @override
  void info(String message) {
    _log(message, level: LogLevel.info);
  }

  @override
  void warning(String message) {
    _log(message, level: LogLevel.warning);
  }

  @override
  void error(String message) {
    _log(message, level: LogLevel.error);
    /// Collect the Crashlytics logs and send to server immediately, only
    /// for high serverity logs
    _throwAndReportError(message);
  }

  @override
  void critical(
    String message,
  ) {
    _log(message, level: LogLevel.critical);
    /// Collect the Crashlytics logs and send to server immediately, only
    /// for high serverity logs
    _throwAndReportError(message);
  }

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
