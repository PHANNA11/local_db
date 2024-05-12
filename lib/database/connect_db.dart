import 'dart:developer';
import 'dart:io';

import 'package:local_db/database/constant.dart';
import 'package:local_db/model/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//ORM = Object related Mapping

class ConnectDB {
  Future<Database> initializeUserDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'user.db'), onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $userTable($fId INTEGER PRIMIRY KEY AUTO INCREMENT,$fName TEXT,$fGender TEXT,$fAge INTEGER,$fPositoin TEXT)');
    }, version: 1);
  }

  Future<void> insertUser({required UserModel user}) async {
    var db = await initializeUserDB();
    await db.insert(userTable, user.toMap());
    log('message success');
  }

  Future<List<UserModel>> getUsers() async {
    var db = await initializeUserDB();
    List<Map<String, dynamic>> result = await db.query(userTable);

    return result.map((e) => UserModel.fromMap(e)).toList();
  }
}
