import 'dart:io';

import 'package:colorize/colorize.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

File getInput() => File(path.join(path.dirname(Platform.script.path), 'input.txt'));

/// Sets the logging level to ALL
Logger getLogger() {
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen(_prettyPrint);

  return Logger(path.basename(path.dirname(Platform.script.path)));
}

void _prettyPrint(final LogRecord rec) {
  stdout.writeln(_formatLog(
    _makeLevelPart(rec.level),
    Colorize(rec.loggerName).lightGreen(),
    Colorize(rec.message).lightBlue(),
  ));
}

/* Private */

///
String _formatLog(final Object p1, final Object p2, final Object p3,
        [final bool newLine = false]) =>
    '[$p1] | $p2: $p3${newLine ? '\n' : ''}';

Colorize _makeLevelPart(final Level level) {
  return switch (level) {
    Level.SHOUT => Colorize(level.name).white().bgRed(),
    Level.SEVERE => Colorize(level.name).red(),
    Level.WARNING => Colorize(level.name).yellow(),
    Level.INFO => Colorize(level.name).blue(),
    Level.CONFIG => Colorize(level.name).lightBlue(),
    Level.FINE => Colorize(level.name).lightBlue(),
    Level.FINER => Colorize(level.name).lightBlue(),
    Level.FINEST => Colorize(level.name).lightBlue(),
    _ => Colorize(level.name).white(), // Level.ALL
  };
}
