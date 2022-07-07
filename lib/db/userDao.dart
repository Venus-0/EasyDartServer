import 'package:easydartserver/utils/data_utils.dart';
import 'package:mysql1/mysql1.dart';

import '../model/user_bean.dart';
import 'mysql.dart';

class UserDao {
  Future<User?> queryUser(String account) async {
    MySqlConnection? conn = await Mysql.getDB();
    Results res = await conn!.query("SELECT * FROM user WHERE account = \"$account\"");
    User? user;
    if (res.isNotEmpty) {
      ResultRow row = res.first;
      user = User.fromJson(row.fields);
    }
    return user;
  }

  Future<int> addUser(String account, String pwd, String nickName) async {
    MySqlConnection? conn = await Mysql.getDB();
    int time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String uuid = DataUtils.generateUUID(account, time);
    pwd = DataUtils.generate_MD5(pwd);
    try {
      Results res = await conn!.query("INSERT INTO user VALUES(\"$uuid\",\"$account\",\"$pwd\",\"$nickName\", $time)");
      // if (res.isNotEmpty) {
      return res.insertId ?? 0;
      // }
      // return -1;
    } catch (e) {
      print(e);
      return -1;
    }
  }
}
