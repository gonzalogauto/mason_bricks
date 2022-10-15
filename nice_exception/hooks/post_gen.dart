import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context)async {
  final logger = context.logger;
  final isUsingFvm = logger.confirm('Are you using fvm?', defaultValue: true);
  await getPackages(logger,useFvm:isUsingFvm);
  final isUsingBuildRunner = logger.confirm('Are you using build_runner?',defaultValue:true);
  if(isUsingBuildRunner) await runBuildRunner(logger,isUsingFvm); 
}

Future<void> getPackages(dynamic logger,{required bool useFvm})async{
  final using = useFvm?' using fvm':'';
  final installPackages = logger.progress('Installing packages $using..');
  final getPackagesArgs = ['packages','get'];
  if(useFvm) await Process.run('fvm',['flutter',...getPackagesArgs]);
  if(!useFvm) await Process.run('flutter', getPackagesArgs);
  installPackages.complete();
}

Future<void> runBuildRunner(dynamic logger,bool usingFvm)async{
  final runBuildRunnerArgs = ['pub','run','build_runner','build','--delete-conflicting-outputs'];
  final runBuildRunner = logger.progress('Running build_runner..');
  if(usingFvm)await Process.run('fvm',['flutter',...runBuildRunnerArgs]);
  if(!usingFvm)await Process.run('flutter',runBuildRunnerArgs);
  runBuildRunner.complete();
}
