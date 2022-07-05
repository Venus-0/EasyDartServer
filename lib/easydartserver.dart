import 'dart:async';

import 'package:easydartserver/db/mysql.dart';
import 'package:easydartserver/server.dart';

void run() async {
    runZoned(() async {
    print('init server...');
    await Server.instance!.initServer();
    print("init database...");
    await Mysql.instance!.connectDB();
  });
}
