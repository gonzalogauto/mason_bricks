import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final logger = context.logger;
  final useCrashlytics = context.vars['use_crashlytics'];
  final loggerName = context.vars['logger_name'];
  final outputDir =
      '${Directory.current.path..replaceAll(RegExp(r"'"), '')}\\${loggerName}_logger';
  final isUsingFvm = logger.confirm('Are you using FVM?', defaultValue: true);
  await applyDartFixes(
    logger,
    isUsingFvm: isUsingFvm,
    cwd: outputDir,
  );
  await applyFormat(
    logger,
    isUsingFvm: isUsingFvm,
    cwd: outputDir,
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

/// [applyDartFixes] runs the dart fix command
Future<void> applyDartFixes(
  Logger logger, {
  required bool isUsingFvm,
  String cwd = '.',
}) async {
  final installCrashlytics = logger.progress('Applying dart fixes in $cwd..');
  final applyDartFixesArgs = ['fix', '--apply'];
  if (isUsingFvm)
    await _runCommand(
      'fvm',
      ['dart', ...applyDartFixesArgs],
      cwd: cwd,
    );
  if (!isUsingFvm)
    await _runCommand(
      'dart',
      applyDartFixesArgs,
      cwd: cwd,
    );
  installCrashlytics.complete('Dart fixes applied!');
}

/// [applyFormat] runs the flutter format command
Future<void> applyFormat(
  Logger logger, {
  required bool isUsingFvm,
  String cwd = '.',
}) async {
  final installCrashlytics = logger.progress('Applying format in $cwd..');
  final applyDartFixesArgs = ['format', '.'];
  if (isUsingFvm)
    await _runCommand(
      'fvm',
      ['dart', ...applyDartFixesArgs],
      cwd: cwd,
    );
  if (!isUsingFvm)
    await _runCommand(
      'dart',
      applyDartFixesArgs,
      cwd: cwd,
    );
  installCrashlytics.complete('Format applied!');
}

Future<void> _runCommand(
  String executable,
  List<String> arguments, {
  String cwd = '.',
}) async {
  final currentDirectory = Directory.current.path;
  await Process.run(
    executable,
    arguments,
    runInShell: true,
    workingDirectory: cwd,
  );
}
