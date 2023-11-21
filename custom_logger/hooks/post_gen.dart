import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final logger = context.logger;
  final useCrashlytics = context.vars['use_crashlytics'];
  final isUsingFvm = logger.confirm('Are you using FVM?', defaultValue: true);
  if (useCrashlytics) {
    await addCrashlyticsDependency(
      logger,
      isUsingFvm: isUsingFvm,
    );
  }
  await applyDartFixes(
    logger,
    isUsingFvm: isUsingFvm,
  );
  await applyFormat(
    logger,
    isUsingFvm: isUsingFvm,
  );
  if (useCrashlytics) {
    logger.info(
      lightCyan.wrap('''
+---------------------------------------------------------------------------+
| Please complete native configuration before start using Crashlytics.      |
|                                                                           |
| For more info visit:                                                      |
| https://firebase.google.com/docs/crashlytics/get-started?platform=flutter |
+---------------------------------------------------------------------------+'''),
    );
  }
}

/// [addCrashlyticsDependency] adds the firebase_crashlytics package
Future<void> addCrashlyticsDependency(
  Logger logger, {
  required bool isUsingFvm,
}) async {
  final installCrashlytics = logger.progress('Adding crashlytics..');
  final addCrashlyticsArgs = ['pub', 'add', 'firebase_crashlytics'];
  if (isUsingFvm)
    await _runCommand(
      'fvm',
      ['flutter', ...addCrashlyticsArgs],
    );
  if (!isUsingFvm)
    await _runCommand(
      'flutter',
      addCrashlyticsArgs,
    );
  installCrashlytics.complete('Crashlytics added!');
}

/// [applyDartFixes] runs the dart fix command
Future<void> applyDartFixes(
  Logger logger, {
  required bool isUsingFvm,
}) async {
  final installCrashlytics = logger.progress('Applying dart fixes..');
  final applyDartFixesArgs = ['fix', '--apply'];
  if (isUsingFvm)
    await _runCommand(
      'fvm',
      ['dart', ...applyDartFixesArgs],
    );
  if (!isUsingFvm)
    await _runCommand(
      'dart',
      applyDartFixesArgs,
    );
  installCrashlytics.complete('Dart fixes applied!');
}

/// [applyFormat] runs the flutter format command
Future<void> applyFormat(
  Logger logger, {
  required bool isUsingFvm,
}) async {
  final installCrashlytics = logger.progress('Applying format..');
  final applyDartFixesArgs = ['format', '.'];
  if (isUsingFvm)
    await _runCommand(
      'fvm',
      ['dart', ...applyDartFixesArgs],
    );
  if (!isUsingFvm)
    await _runCommand(
      'dart',
      applyDartFixesArgs,
    );
  installCrashlytics.complete('Format applied!');
}

Future<void> _runCommand(
  String executable,
  List<String> arguments,
) async {
  final currentDirectory = Directory.current.path;
  final root = currentDirectory.split('lib')[0];
  await Process.run(
    executable,
    arguments,
    runInShell: true,
    workingDirectory: root,
  );
}
