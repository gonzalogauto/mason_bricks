import './log_level.dart';
import 'dart:developer' as dev show log;
/// [{{logger_name.pascalCase()}}] is a custom logger that can be used
/// to report errors to another service like Crashlytics
class {{logger_name.pascalCase()}} {

  void debug(String message) {
    _log(message, level: LogLevel.debug);
  }

  void info(String message) {
    _log(message, level: LogLevel.info);
  }

  void warning(String message) {
    _log(message, level: LogLevel.warning);
  }

  void error(String message) {
    _log(message, level: LogLevel.error);
    /// Collect the Crashlytics logs and send to server immediately, only
    /// for high serverity logs
    _throwAndReportError(message);
  }

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
  }

  void _log(String message, {LogLevel level = LogLevel.info}) {
    final currentTime = DateTime.now();
    dev.log(
      message,
      level: level.value,
      time: currentTime,
    );
    /// send error 
  }

  void _throwAndReportError(String message) {
    /// Simulate a "crash" so that we can collect the stack trace and report to
    /// crashlytics
    try {
      throw Exception(message);
    } catch (error, stackTrace) {
      /// send error 
    }
  }

}
