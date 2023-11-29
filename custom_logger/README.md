# custom_logger

Create a custom logger with different levels in just a few seconds.

## Firebase Crashlytics integration

This brick adds the [firebase_crashlytics](https://pub.dev/packages/firebase_crashlytics) package and implements this service inside the custom logger for you. (Native configuration is still needed to make it work so follow the official docs [here](https://firebase.google.com/docs/crashlytics/get-started?platform=flutter))

## How to use 🚀

```
mason make custom_logger --logger_name custom
```

## Variables ✨

| Variable         | Description                       | Default | Type      |
| ---------------- | --------------------------------- | ------- | --------- |
| `logger_name`    | The name of the logger            | custom  | `string`  |
| `use_crashlytics`| Whether to use Crashlytics or not | true    | `boolean` |

## Outputs 📦

```
--logger_name custom 
├── custom_logger
│   ├── lib
│   │   ├── src
│   │   │   ├── contract
│   │   │   │   ├── custom_logger_contract.dart
|   |   |   ├── log_levels
│   │   │   │   ├── log_levels.dart
│   │   │   ├── custom_logger.dart
│   │   └── custom_logger.dart
│   ├── test
│   │   └── src
│   │       └── custom_logger_test.dart
│   ├── .gitignore
│   ├── analysis_options.yaml
│   ├── pubspec.yaml
│   └── README.md
└── ...
```
```

```dart
import 'dart:developer' as dev show log;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'contract/custom_contract.dart';
import 'log_levels/log_level.dart';

/// [CustomLogger] is a custom logger that can be used
/// to report errors to another service like Crashlytics
class CustomLogger implements CustomLoggerContract {
  /// [CustomLogger] constructor
  /// (here we initialize Firebase Crashlytics)
  CustomLogger({
    FirebaseCrashlytics? crashlytics,
  }) : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  /// Please complete native configuration before start using Crashlytics.
  /// For more info visit:
  /// https://firebase.google.com/docs/crashlytics/get-started?platform=flutter
  final FirebaseCrashlytics _crashlytics;

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

  @override
  void exception(
    Object error,
    StackTrace stackTrace, {
    Object? reason,
    bool fatal = true,
  }) {
    _log('The following exception occurred: $error', level: LogLevel.critical);

    /// Avoid report while in debug mode
    if (kDebugMode) return;

    _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  void _log(String message, {LogLevel level = LogLevel.info}) {
    final currentTime = DateTime.now();
    dev.log(
      message,
      level: level.value,
      time: currentTime,
    );

    /// Avoid send log to an external service while in debug
    if (kDebugMode) return;
    _crashlytics.log('${level.name}(level): $message');
  }

  /// Simulate a "crash" so that we can collect the stack trace and report to
  /// crashlytics
  void _throwAndReportError(String message) {
    try {
      throw Exception(message);
    } catch (error, stackTrace) {
      /// Avoid report while in debug mode
      if (kDebugMode) return;

      _crashlytics.recordError(
        error,
        stackTrace,
        reason: message,
        fatal: true,
      );
    }
  }

  @override
  void recordFlutterFatalError(FlutterErrorDetails flutterErrorDetails) {
    /// Avoid report while in debug mode
    if (kDebugMode) return;
    _crashlytics.recordFlutterFatalError(flutterErrorDetails);
  }

  @override
  void recordFlutterError(FlutterErrorDetails flutterErrorDetails) {
    /// Avoid report while in debug mode
    if (kDebugMode) return;
    _crashlytics.recordFlutterError(flutterErrorDetails);
  }
}
```