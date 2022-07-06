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
    Results res = await conn!.query("INSERT INTO user VALUES(\"$account\",\"$pwd\",\"$nickName\")");
    if (res.isNotEmpty) {
      return res.affectedRows ?? 0;
    }
    return -1;
  }
}
