/// [{{logger_name.pascalCase()}}LoggerContract] class
abstract class {{logger_name.pascalCase()}}LoggerContract {
  
  /// [debug] level
  void debug(String message);

  /// [info] level (usefull when you need more context about what is happening)
  void info(String message);
  
  /// [warning] level
  void warning(String message);
  
  /// [error] level (Simulate a "crash")
  void error(String message);

  /// [critical] level
  void critical(String message);
  
  /// [exception] level (This sends the complete error `Object` with
  /// the corresponding `StackTrace`)
  void exception(
    Object error,
    StackTrace stackTrace, {
    Object? reason,
  });

}