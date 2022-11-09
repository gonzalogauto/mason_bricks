import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final logger = context.logger;
  final useCrashlytics = context.vars['use_crashlytics'];
  if (!useCrashlytics) return;
  final isUsingFvm = logger.confirm('Are you using fvm?', defaultValue: true);
  await addCrashlyticsDependency(logger, isUsingFvm: isUsingFvm);
}

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
