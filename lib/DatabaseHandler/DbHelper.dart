import 'package:care_giver/models/alarm_model.dart';
import 'package:care_giver/models/new_feed_model.dart';
import 'package:care_giver/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _db;

  static const String DB_Name = 'db_caregiver';
  static const String Table_User = 'tbl_user';
  static const String Table_New_Feed = 'tbl_first_aid';
  static const String Table_Alarm = 'tbl_alarm';
  static const int Version = 1;

  static const String userId = 'userid';
  static const String userName = 'username';
  static const String password = 'password';
  static const String email = 'email';

  static const String faId = 'faid';
  static const String name = 'name';
  static const String instruction = 'instruction';
  static const String caution = 'caution';
  static const String photo = 'photo';

  static const String alId = 'alid';
  static const String alarmTime = 'alarm_time';
  static const String alarmTitle = 'alarm_title';
  static const String columnPending = 'isPending';
  static const String columnColorIndex = 'gradientColorIndex';
  static const String flag = 'flag';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();

    return _db;
  }

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DB_Name);

    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {


      await db.execute("CREATE TABLE $Table_User ("
          " $userId int AUTO_INCREMENT, "
          " $userName varchar(100) NOT NULL, "
          " $email varchar(100) NOT NULL, "
          " $password varchar(20) NOT NULL, "
          " PRIMARY KEY($userId)"
          ")");

      await db.execute("CREATE TABLE $Table_New_Feed ("
          " $faId int AUTO_INCREMENT, "
          " $name varchar(500) NOT NULL, "
          " $instruction varchar(1000) NOT NULL, "
          " $caution varchar(1000) NOT NULL, "
          " $photo varchar(500), "
          " PRIMARY KEY($faId)"
          ")");

      await db.execute("CREATE TABLE $Table_Alarm ("
          " $alId int AUTO_INCREMENT, "
          " $alarmTitle varchar(500) NOT NULL, "
          " $alarmTime varchar(500) NOT NULL, "
          " $columnColorIndex int, "
          " $flag varchar(500) NOT NULL, "
          " PRIMARY KEY($alId)"
          ")");

      var userModel = UserModel({
        'username': "James",
        'email': "htet1234.kg11@gmail.com",
        'password': "1234"
      });
      db.insert(Table_User, userModel.toMap());
    });

    return _db;
  }

  Future<int> saveData(UserModel userModel) async {
    var dbClient = await db;
    var res = await dbClient!.insert(Table_User, userModel.toMap());
    return res;
  }

  Future<UserModel?> getLoginUser(String username, String pwd) async {
    var dbClient = await db;
    var res = await dbClient!.rawQuery("SELECT * FROM $Table_User WHERE "
        "$userName = '$username' AND "
        "$password = '$pwd' ");

    if (res.isNotEmpty) {
      return UserModel.fromMap(res.first);
    }

    return null;
  }

  Future<int> updateUser(UserModel userModel) async {
    var dbClient = await db;
    var res = await dbClient!.update(Table_User, userModel.toMap(),
        where: '$userId = ?', whereArgs: [userModel.userId]);
    return res;
  }

  Future<int> deleteUser(String userid) async {
    var dbClient = await db;
    var res = await dbClient!
        .delete(Table_User, where: '$userId = ?', whereArgs: [userid]);
    return res;
  }

  ///New feed
  Future<int> createNewFeed(NewFeedModel newFeedModel) async {
    var dbClient = await db;
    var res = await dbClient!.insert(Table_New_Feed, newFeedModel.toMap());
    return res;
  }

  Future<List> allNewFeed() async {
    var dbClient = await db;
    // var res = await dbClient.rawQuery("SELECT * FROM $Table_New_Feed");
    var res = await dbClient!.query(Table_New_Feed);
    return res;
  }

  Future<int> deleteNewFeed(String n) async {
    var dbClient = await db;
    var res = await dbClient!
        .delete(Table_New_Feed, where: '$name = ?', whereArgs: [n]);
    return res;
  }

  Future<int> updateNewFeed(NewFeedModel newFeedModel) async {
    var dbClient = await db;
    var res = await dbClient!.update(Table_New_Feed, newFeedModel.toMap(),
        where: '$faId = ?', whereArgs: [newFeedModel.faid]);
    return res;
  }

  ///Alarm
  Future<int> insertAlarm(AlarmModel alarmModel) async {
    var dbClient = await db;
    var res = await dbClient!.insert(Table_Alarm, alarmModel.toMap());
    return res;
  }

  Future<List<AlarmModel>> getAlarms() async {
    List<AlarmModel> _alarms = [];

    var dbClient = await db;
    var result = await dbClient!.query(Table_Alarm);
    result.forEach((element) {
      var alarmInfo = AlarmModel.fromMap(element);
      _alarms.add(alarmInfo);
    });

    return _alarms;
  }

// Future<int> delete(String title) async {
//   var dbClient = await db;
//   return await dbClient!.delete(Table_Alarm, where: '$alarmTitle = ?', whereArgs: [title]);
// }

}
