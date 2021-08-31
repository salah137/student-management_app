import 'package:get/state_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class MainController extends GetxController {
  List classs1 = [].obs;
  List classs2 = [].obs;
  List classs3 = [].obs;

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
        "CREATE TABLE first (id INTEGER PRIMARY KEY, name TEXT, students INTEGER, fard1 REAL,fard2 REAL,fard3 REAL,inchita REAL,moyen REAL)",
      );
      db.execute(
        "CREATE TABLE second (id INTEGER PRIMARY KEY, name TEXT, students INTEGER, fard1 REAL,fard2 REAL,fard3 REAL,inchita REAL ,moyen REAL)",
      );
      db.execute(
        "CREATE TABLE third (id INTEGER PRIMARY KEY, name TEXT, students INTEGER, fard1 REAL,fard2 REAL,inchita REAL,moyen REAL)",
      );
    }, onOpen: (db) async {
      await getData(db);
      print("done");
    });
  }

  Future getData(Database db) async {
    level1 = await db.rawQuery("SELECT * FROM first");

    level2 = await db.rawQuery("SELECT * FROM second");

    level3 = await db.rawQuery("SELECT * FROM third");

    level1.forEach(
      (i) async {
        classs1.addAll(await db.rawQuery("SELECT * FROM ${i["name"]}"));
      },
    );

    level2.forEach(
      (i) async {
        classs2.addAll(await db.rawQuery("SELECT * FROM ${i["name"]}"));
      },
    );

    level3.forEach(
      (i) async {
        classs3.addAll(await db.rawQuery("SELECT * FROM ${i["name"]}"));
      },
    );

    print(classs1);
    print(classs2);
    print(classs3);

    print(level1);
    print(level2);
    print(level3);
  }

  Future addAclass(className, classLevel) async {
    database!.transaction(
      (txn) async {
        classLevel != "third"
            ? await txn.rawInsert(
                "INSERT INTO $classLevel(name , students , fard1 ,fard2 ,fard3 ,inchita ,moyen ) VALUES(?,?,?,?,?,?,?)",
                [
                    className,
                    0,
                    0,
                    0,
                    0,
                    0,
                  ])
            : await txn.rawInsert(
                "INSERT INTO $classLevel(name , students , fard1 ,fard2 ,inchita ,moyen ) VALUES(?,?,?,?,?,?,?)",
                [
                  className,
                  0,
                  0,
                  0,
                  0,
                ],
              );
      },
    );

    classLevel != "third"
        ? await database!.execute(
            "CREATE TABLE $className (id INTEGER PRIMARY KEY, name TEXT, students INTEGER, fard1 REAL,fard2 REAL,fard3 REAL,inchita REAL,moyen REAL)")
        : await database!.execute(
            "CREATE TABLE $className (id INTEGER PRIMARY KEY, name TEXT, students INTEGER, fard1 REAL,fard2 REAL,inchita REAL,moyen REAL)");

    getData(database!);
  }



}
