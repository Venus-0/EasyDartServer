import 'dart:async';

import 'package:easydartserver/db/mysql.dart';
import 'package:easydartserver/server.dart';
import 'package:easydartserver/utils/log_utils.dart';

void run() async {
  runZoned(() async {
    Log.init();
    Log.info('init server...');
    await Server.instance!.initServer();
    Log.info('init database...');
    // await Mysql.instance!.connectDB();
  });
}
