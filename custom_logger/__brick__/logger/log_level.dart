/// Log level enums
enum LogLevel {
  /// debug level enum.
  debug(10),

  /// info level enum.
  info(20),

  /// warning level enum.
  warning(30),

  /// error level enum.
  error(40),

  /// critical level enum.
  critical(50),

  /// unknown level enum.
  unknown(0);

  /// [LogLevel] constructor with name and value.
  const LogLevel(this.value);

  /// [value] of the level.
  final int value;
}
