import 'dart:async';
import 'dart:io';

import '../server.dart';
import 'package:jaguar/jaguar.dart';

import '../db/sessionDao.dart';
import '../db/userDao.dart';
import '../model/response.dart';
import '../model/user_bean.dart';

class Login {
  static FutureOr<Response> login(Context ctx) async {
    ResponseBean responseBean = ResponseBean();
    String account = "";
    String pwd = "";
    if (ctx.method == Server.GET) {
      account = ctx.query.get("account") ?? "";
      pwd = ctx.query.get("pwd") ?? "";
    } else if (ctx.method == Server.POST) {
      final res = await ctx.bodyAsUrlEncodedForm();
      print(res);
      account = res['account'] ?? '';
      pwd = res['pwd'] ?? '';
    }
    print(account);
    print(pwd);
    if (account.isEmpty) {
      responseBean.code = Server.ERROR;
      responseBean.msg = "账号不能为空";
      return Response(statusCode: responseBean.code, body: responseBean.toJsonString());
    }
    if (pwd.isEmpty) {
      responseBean.code = Server.ERROR;
      responseBean.msg = "密码不能为空";
      return Response(statusCode: responseBean.code, body: responseBean.toJsonString());
    }

    User? user = await UserDao().queryUser(account);
    if (user == null) {
      responseBean.code = Server.ERROR;
      responseBean.msg = "账户或密码错误";
      return Response(statusCode: responseBean.code, body: responseBean.toJsonString());
    } else {
      if (user.password != pwd) {
        responseBean.code = Server.ERROR;
        responseBean.msg = "账户或密码错误";
        return Response(statusCode: responseBean.code, body: responseBean.toJsonString());
      } else {
        String session = await SessionDao().loginSession(account, pwd);
        responseBean.result = {'user': session};
        responseBean.msg = "登陆成功";
        return Response(statusCode: responseBean.code, body: responseBean.toJsonString(), headers: {"Set-Cookie": "user=$session"});
      }
    }
  }

  ///注册接口
  ///[account]注册账号
  ///[pwd]注册密码
  ///[nickName]昵称
  static FutureOr<Response> register(Context ctx) async {
    ResponseBean responseBean = ResponseBean();
    String account = "";
    String pwd = "";
    String nickName = "";
    if (ctx.method == Server.GET) {
      account = ctx.query.get("account") ?? "";
      pwd = ctx.query.get("pwd") ?? "";
      nickName = ctx.query.get("nickName") ?? "";
    } else if (ctx.method == Server.POST) {
      final res = await ctx.bodyAsUrlEncodedForm();
      print(res);
      account = res['account'] ?? '';
      pwd = res['pwd'] ?? '';
      nickName = res['nickName'] ?? '';
    }
    if (account.isEmpty) {
      responseBean.code = Server.ERROR;
      responseBean.msg = "账户不能为空";
    } else if (pwd.isEmpty) {
      responseBean.code = Server.ERROR;
      responseBean.msg = "密码不能为空";
    } else if (pwd.length < 8) {
      responseBean.code = Server.ERROR;
      responseBean.msg = "密码长度不能小于8位";
    } else {
      User? user = await UserDao().queryUser(account);
      if (user != null) {
        responseBean.code = Server.ERROR;
        responseBean.msg = "该账户已注册";
      } else {
        int ret = await UserDao().addUser(account, pwd, nickName);
        responseBean.msg = "注册状态 $ret";
      }
    }

    return Response(statusCode: responseBean.code, body: responseBean.toJsonString());
  }
}
