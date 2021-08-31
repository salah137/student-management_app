import 'package:get/state_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class MainController extends GetxController {
  List classs = [].obs;
  List level1 = [].obs;
  List level3 = [].obs;
  List level2 = [].obs;
  @override
  void onInit() async {
    await openMyDataBase();
    super.onInit();
  }

  Database? database;

  Future openMyDataBase() async {
    database = await openDatabase("my.db", version: 1, onCreate: (db, v) {
      db.execute(
        "CREATE TABLE first (id INTEGER PRIMARY KEY, name TEXT, students INTEGER, fard1 REAL,fard2 REAL,fard3 REAL,nchita REAL,moyen REAL)",
      );
      db.execute(
        "CREATE TABLE second (id INTEGER PRIMARY KEY, name TEXT, students INTEGER, fard1 REAL,fard2 REAL,fard3 REAL,inchita REAL ,moyen REAL)",
      );
      db.execute(
        "CREATE TABLE third (id INTEGER PRIMARY KEY, name TEXT, students INTEGER, fard1 REAL,fard2 REAL,inchita REAL,moyen REAL)",
      );
    }, onOpen: (db) async {
      db.transaction((txn) async {
        await txn.rawInsert(
            "INSERT INTO third (name,students,fard1,fard1,inchita,moyen) VALUES(?,?,?,?,?,?)",
            ["1AC", 12, 23.0, 33.0, 22.0, 11.0]);
      });
      await getData(db);
      print("done");
    });
  }

  Future getData(Database db) async {
    level1 = await db.rawQuery("SELECT * FROM first");

    level2 = await db.rawQuery("SELECT * FROM second");

    level3 = await db.rawQuery("SELECT * FROM third");
/*
    level1.forEach(
      (i) async {
        classs.addAll(await db.rawQuery("SELECT * FROM ${i["name"]}"));
      },
    );

    level2.forEach(
      (i) async {
        classs.addAll(await db.rawQuery("SELECT * FROM ${i["name"]}"));
      },
    );

    level3.forEach(
      (i) async {
        classs.addAll(await db.rawQuery("SELECT * FROM ${i["name"]}"));
      },
    );*/
  }
}
