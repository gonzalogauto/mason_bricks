import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final logger = context.logger;
  final useCrashlytics = context.vars['use_crashlytics'];
  final isUsingFvm = logger.confirm('Are you using fvm?', defaultValue: true);
  if (useCrashlytics) {
    await addCrashlyticsDependency(logger, isUsingFvm: isUsingFvm);
  }
  await applyDartFixes(logger, isUsingFvm: isUsingFvm);
  await applyFormat(logger, isUsingFvm: isUsingFvm);
}

/// [addCrashlyticsDependency] adds the firebase_crashlytics package
Future<void> addCrashlyticsDependency(
  Logger logger, {
  required bool isUsingFvm,
}) async {
  final using = isUsingFvm ? 'using fvm' : '';
  final installCrashlytics = logger.progress('Adding crashlytics $using..');
  final addCrashlyticsArgs = ['pub', 'add', 'firebase_crashlytics'];
  if (isUsingFvm) await Process.run('fvm', ['flutter', ...addCrashlyticsArgs]);
  if (!isUsingFvm) await Process.run('flutter', addCrashlyticsArgs);
  installCrashlytics.complete('Crashlytics added!');
}

/// [applyDartFixes] runs the dart fix command
Future<void> applyDartFixes(
  Logger logger, {
  required bool isUsingFvm,
}) async {
  final using = isUsingFvm ? 'using fvm' : '';
  final installCrashlytics = logger.progress('Applying dart fixes $using..');
  final applyDartFixesArgs = ['fix', '--apply'];
  if (isUsingFvm) await Process.run('fvm', ['dart', ...applyDartFixesArgs]);
  if (!isUsingFvm) await Process.run('dart', applyDartFixesArgs);
  installCrashlytics.complete('Dart fixes applyed!');
}

/// [applyFormat] runs the flutter format command
Future<void> applyFormat(
  Logger logger, {
  required bool isUsingFvm,
}) async {
  final using = isUsingFvm ? 'using fvm' : '';
  final installCrashlytics = logger.progress('Applying format $using..');
  final applyDartFixesArgs = ['format', '.'];
  if (isUsingFvm) await Process.run('fvm', ['flutter', ...applyDartFixesArgs]);
  if (!isUsingFvm) await Process.run('flutter', applyDartFixesArgs);
  installCrashlytics.complete('Format applyed!');
}
