import 'dart:developer' as dev show log;

{{#use_crashlytics}}import 'package:firebase_crashlytics/firebase_crashlytics.dart';{{/use_crashlytics}}
import 'package:flutter/foundation.dart';
import 'contract/{{logger_name.snakeCase()}}_contract.dart';
import 'log_levels/log_level.dart';

/// [{{logger_name.pascalCase()}}Logger] is a custom logger that can be used
/// to report errors to another service like Crashlytics
class {{logger_name.pascalCase()}}Logger implements {{logger_name.pascalCase()}}LoggerContract{
  {{#use_crashlytics}}/// [{{logger_name.pascalCase()}}Logger] constructor 
  /// (here we initialize Firebase Crashlytics)
  {{logger_name.pascalCase()}}Logger({
    FirebaseCrashlytics? crashlytics,
  }) : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;
  
  /// Complete the final steps in order report errors without any problems
  /// on Android/IOS in https://firebase.google.com/docs/crashlytics/get-started?platform=flutter
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

  void exception(Object error, StackTrace stackTrace, {Object? reason,bool fatal=true,}) {
    _log('The following exception occurred: $error', level: LogLevel.critical);
    /// Avoid report while in debug mode
    if(kDebugMode) return;
    {{^use_crashlytics}}// TODO!(logger): Send the error and stackTrace to server immediately{{/use_crashlytics}}
    {{#use_crashlytics}}_crashlytics.recordError(error, stackTrace, reason: reason, fatal: fatal,);{{/use_crashlytics}}
  }

  void _log(String message, {LogLevel level = LogLevel.info}) {
    final currentTime = DateTime.now();
    dev.log(
      message,
      level: level.value,
      time: currentTime,
    );
    /// Avoid send log to an external service while in debug
    if(kDebugMode) return;  
    {{#use_crashlytics}}_crashlytics.log('${level.name}(level): $message');{{/use_crashlytics}}
  }

  /// Simulate a "crash" so that we can collect the stack trace and report to
  /// crashlytics
  void _throwAndReportError(String message) {
    try {
      throw Exception(message);
    } catch (error, stackTrace) {
      /// Avoid report while in debug mode
      if(kDebugMode) return;
      {{^use_crashlytics}}// TODO!(logger): Send the error and stackTrace to Crashlytics or another service {{/use_crashlytics}}
      {{#use_crashlytics}}_crashlytics.recordError(error, stackTrace, reason: message, fatal: true,);{{/use_crashlytics}}
    }
  }
  {{#use_crashlytics}}
  @override
  void recordFlutterFatalError(FlutterErrorDetails flutterErrorDetails){
    /// Avoid report while in debug mode
    if (kDebugMode) return;
    _crashlytics.recordFlutterFatalError(flutterErrorDetails);
  }

  @override
  void recordFlutterError(FlutterErrorDetails flutterErrorDetails){
    /// Avoid report while in debug mode
    if (kDebugMode) return;
    _crashlytics.recordFlutterError(flutterErrorDetails);
  }{{/use_crashlytics}}
}
