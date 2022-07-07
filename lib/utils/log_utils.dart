import 'package:logging/logging.dart';

class Log {
  static void init() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('[${record.level.name}] ${record.time}: ${record.message}');
    });
    Logger.root.info("Logger init");
  }

  static void info(String msg) {
    Logger.root.info(msg);
  }

  static void error(String msg, {String? e, StackTrace? t}) {
    Logger.root.warning(msg, e, t);
  }
}
