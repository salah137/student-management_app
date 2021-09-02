import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:stu_ma_/models/Consts.dart';

class MainController extends GetxController {
  var level1 = [].obs;
  var level3 = [].obs;
  var level2 = [].obs;
  var usedStudentLisy = [].obs;
  var isEditing = false.obs;

  Database? database;
  @override
  void onInit() async {
    await openMyDataBase();
    super.onInit();
  }

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
    level1.value = await db.rawQuery("SELECT * FROM first");

    level2.value = await db.rawQuery("SELECT * FROM second");

    level3.value = await db.rawQuery("SELECT * FROM third");

    print("level1 $level1");
    print("level2 $level2");
    print("level3 $level3");
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
                "INSERT INTO $classLevel(name , students , fard1 ,fard2 ,inchita ,moyen ) VALUES(?,?,?,?,?,?)",
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
            "CREATE TABLE ${className} (id INTEGER PRIMARY KEY, name TEXT, students INTEGER, fard1 REAL,fard2 REAL,fard3 REAL,inchita REAL,moyen REAL)")
        : await database!.execute(
            "CREATE TABLE ${className} (id INTEGER PRIMARY KEY, name TEXT, students INTEGER, fard1 REAL,fard2 REAL,inchita REAL,moyen REAL)");

    await getData(database!);
  }

  void addFromUi(level, context) {
    GlobalKey<FormState> myKey = GlobalKey<FormState>();
    TextEditingController classNamCont = TextEditingController();
    Get.bottomSheet(
        Form(
          key: myKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: TextFormField(
                  validator: (v) {
                    var contSpec = false;
                    var isUsed = false;
                    Consts.speciaChar.forEach((element) {
                      if (v!.contains(element)) contSpec = true;
                    });
                    level == "1AC"
                        ? level1.value.forEach(
                            (element) {
                              if (element["name"] == v!) isUsed = true;
                            },
                          )
                        : level == "2AC"
                            ? level2.value.forEach(
                                (element) {
                                  if (element["name"] == v!) isUsed = true;
                                },
                              )
                            : level3.value.forEach(
                                (element) {
                                  if (element["name"] == v!) isUsed = true;
                                },
                              );

                    if (v == null || v.isEmpty) return "ارجوك ادخل اسم القسم";
                    if (contSpec) return "الاسم غير مناسب";
                    if (isUsed) return "الاسم مستعمل من قبل";
                    return null;
                  },
                  controller: classNamCont,
                  decoration: InputDecoration(
                    hintText: " اسم القسم",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                margin: EdgeInsets.all(10),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.all(10),
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  child: MaterialButton(
                    onPressed: () {
                      if (myKey.currentState!.validate()) {
                        addAclass(
                            classNamCont.text,
                            level == "1AC"
                                ? "first"
                                : level == "2AC"
                                    ? "second"
                                    : "third");
                        Navigator.pop(context);
                      }
                    },
                    child: Text("تم"),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white);
  }

  Future getClassByName(name) async {
    usedStudentLisy.value = await database!.rawQuery("SELECT * FROM ${name}");
  }

  tableComponents(model, code) {
    Map usedModel = model;
    TextEditingController name = TextEditingController(text: model["name"]);
    TextEditingController fard1 = TextEditingController(text: model["fard1"]);
    TextEditingController fatrd2 = TextEditingController(text: model["fard2"]);
    if (code != "3AC")
      TextEditingController fard3 = TextEditingController(text: model["fard3"]);
    TextEditingController inchita =
        TextEditingController(text: model["inchita"]);
    MainController controller = Get.find();
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(5),
              child: TextField(
                enabled: controller.isEditing.value,
                controller: name,
              ),
              height: 50,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(5),
              child: TextField(
                enabled: controller.isEditing.value,
                controller: TextEditingController(text: "name"),
              ),
              height: 50,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(5),
              child: TextField(
                enabled: controller.isEditing.value,
                controller: TextEditingController(text: "name"),
              ),
              height: 50,
            ),
          ),
          if (code != "3AC")
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                child: TextField(
                  enabled: controller.isEditing.value,
                  controller: TextEditingController(text: "name"),
                ),
                height: 50,
              ),
            ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(5),
              child: TextField(
                enabled: controller.isEditing.value,
                controller: TextEditingController(text: "name"),
              ),
              height: 50,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(5),
              child: TextField(
                enabled: controller.isEditing.value,
                controller: TextEditingController(text: "name"),
              ),
              height: 50,
            ),
          ),
          Expanded(
            child: Container(
              height: 40,
              child: FloatingActionButton(
                onPressed: () {
                  controller.isEditing.value = !controller.isEditing.value;
                },
                child: Icon(
                    controller.isEditing.value ? Icons.done : Icons.edit_road),
              ),
            ),
          )
        ],
      );
    });
  }
}
