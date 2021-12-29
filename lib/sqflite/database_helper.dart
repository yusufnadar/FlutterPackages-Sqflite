import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_packages/sqflite/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async{
    if(_database != null) return _database!;

    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(filePath)async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,filePath);
    var exists = await databaseExists(path);
    if(!exists){
      var data = await rootBundle.load(join('assets','db','users.db')); //'assets/db/users.db'
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }
    return await openDatabase(path,readOnly: false);
  }

  Future addUser()async{
    var db = await instance.database;
    //var id = await db.insert('user', {'name':'Ayşe'});
    var id = await db.rawInsert('INSERT INTO user (name) VALUES ("Hakan");');
    print(id);
  }

  Future<List<UserModel>> getUser()async{
    var db = await instance.database;
    var liste = <UserModel>[];
    //var users  = await db.query('user');
    var users = await db.rawQuery('Select * from user');
    for(var item in users){
      liste.add(UserModel.fromJson(item));
    }
    return liste;
  }

  updateUser(userId)async{
    var db = await instance.database;
    //var id = await db.update('user', {'name':'Güncellenen İsim'},where: 'id = ?',whereArgs: [userId]);
    var id = await db.rawUpdate('UPDATE user set name = "güncellenen isim 2" where id = $userId');
    print(id);
  }

  deleteUser(userId)async{
    var db = await instance.database;
    //await db.delete('user',where: 'id=?',whereArgs: [userId]);
    await db.rawDelete('DELETE from user where id = $userId');
  }




}