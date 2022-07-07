import 'dart:convert';

class User {
  String uuid = "";
  String account = "";
  String password = "";
  String nickname = "";
  int addTime = 0;

  User({this.account = "", this.password = "", this.nickname = "", this.addTime = 0, this.uuid = ""});

  factory User.fromJson(Map<String, dynamic>? jsonRes) {
    if (jsonRes == null) {
      return User();
    } else {
      return User(
        uuid: jsonRes['uuid'],
        account: jsonRes['account'],
        password: jsonRes['password'],
        nickname: jsonRes['nickname'],
        addTime: jsonRes['addTime'],
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "account": account,
        "password": password,
        "nickname": nickname,
        "addTime": addTime,
      };
}
