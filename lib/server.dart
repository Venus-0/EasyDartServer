import 'dart:async';
import 'dart:convert';

import 'package:easydartserver/conf/config.dart';
import 'package:easydartserver/utils/log_utils.dart';
import 'package:jaguar/jaguar.dart';

import 'api/common.dart';
import 'api/login.dart';

class Server {
  static const int ERROR = 403;
  static const int SUCCESS = 200;
  static const int NOT_FOUND = 404;
  static const String GET = "GET";
  static const String POST = "POST";

  bool isInit = false;
  Jaguar? server;
  static Server? _instance;
  static Server? get instance {
    if (_instance == null) {
      _instance = Server();
    }
    return _instance;
  }

  ///过滤器
  final Map<String, dynamic> filter = {
    'login': Login.login,
    "serverTest": Common.serverTest,
    "register": Login.register,
  };

  Future<void> initServer() async {
    if (server == null && !isInit) {
      server = new Jaguar(address: Config.serverSettings['host'], port: Config.serverSettings['port'])

        /// ..staticFiles("/*", 'lib')
        ..post('/api/*', handler)
        ..get('/api/*', handler);
      await server!.serve();
      Log.info("local server opened , port:${Config.serverSettings['port']}");
      isInit = true;
    }
  }

  FutureOr<dynamic> handler(Context ctx) async {
    Log.info("request url ${ctx.uri}");
    String apiIndex = ctx.uri.toString().substring(5, getEnd(ctx.uri.toString()));
    print(apiIndex);
    Response? _response;
    if (filter.containsKey(apiIndex)) {
      _response = await filter[apiIndex](ctx);
    }
    if (_response != null) {
      ctx.response = _response;
    } else {
      ctx.response = Response(body: jsonEncode({}), statusCode: NOT_FOUND);
    }
  }

  int? getEnd(String url) {
    if (url.contains('?')) {
      return url.indexOf('?');
    } else {
      return null;
    }
  }
}
