import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:stu_ma_/models/Consts.dart';

class MainController extends GetxController {
  var level1 = [].obs;
  var level3 = [].obs;
  var level2 = [].obs;
  var usedStudentList = [].obs;
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
                    hintTextDirection: TextDirection.rtl,
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
    usedStudentList.value = await database!.rawQuery("SELECT * FROM ${name}");
  }

  updateStudents(model, code, name) async {
    var moyen;
    if (code == "3AC") {
      moyen = Consts.count3(
        model["fard1"],
        model["fard2"],
        model["inchita"],
      );
      print(moyen);

      await database!.rawUpdate(
        "UPDATE $name SET fard1 = ?,fard2 = ?,inchita = ?, moyen = ? WHERE id = ?",
        [
          model["fard1"],
          model["fard2"],
          model["inchita"],
          moyen,
          model["id"],
        ],
      );

      database!.rawUpdate("");
    } else {
      moyen = Consts.countfor12(
        model["fard1"],
        model["fard2"],
        model["fard3"],
        model["inchita"],
      );

      print(moyen);

      database!.rawUpdate(
        "UPDATE $name SET fard1 = ?,fard2 = ?,fard3 = ?,inchita = ?, moyen = ? WHERE id = ?",
        [
          model["fard1"],
          model["fard2"],
          model["fard3"],
          model["inchita"],
          moyen,
          model["id"],
        ],
      );
    }
    await getClassByName(name);
    await getData(database!);
  }

  Widget tableComponents(model, code, namee) {
    TextEditingController? fard3;
    Map usedModel = Map<String, dynamic>.from(model);
    TextEditingController name =
        TextEditingController(text: model["name"].toString());
    TextEditingController fard1 =
        TextEditingController(text: model["fard1"].toString());
    TextEditingController fatrd2 =
        TextEditingController(text: model["fard2"].toString());
    if (code != "3AC")
      fard3 = TextEditingController(text: model["fard3"].toString());
    TextEditingController inchita =
        TextEditingController(text: model["inchita"].toString());
    MainController controller = Get.find();
    return Obx(
      () {
        return Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                child: TextField(
                  onChanged: (v) {
                    usedModel["name"] = int.tryParse(v);
                  },
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
                  onChanged: (v) {
                    usedModel["fard1"] = int.tryParse(v);
                    ;
                  },
                  enabled: controller.isEditing.value,
                  controller: fard1,
                ),
                height: 50,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                child: TextField(
                  onChanged: (v) {
                    usedModel["fard2"] = int.tryParse(v);
                    ;
                  },
                  enabled: controller.isEditing.value,
                  controller: fatrd2,
                ),
                height: 50,
              ),
            ),
            if (code != "3AC")
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: TextField(
                    onChanged: (v) {
                      usedModel["fard3"] = int.tryParse(v);
                    },
                    enabled: controller.isEditing.value,
                    controller: fard3!,
                  ),
                  height: 50,
                ),
              ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                child: TextField(
                  onChanged: (v) {
                    usedModel["inchita"] = int.tryParse(v);
                    ;
                  },
                  enabled: controller.isEditing.value,
                  controller: inchita,
                ),
                height: 50,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                child: TextField(
                  enabled: false,
                  decoration:
                      InputDecoration(hintText: "${usedModel["moyen"]}"),
                ),
                height: 50,
              ),
            ),
            Expanded(
              child: Text(
                getRating(
                  usedModel["moyen"],
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 40,
                child: FloatingActionButton(
                  heroTag: "btn${Random().nextInt(100)}",
                  onPressed: () async {
                    if (controller.isEditing.value)
                      updateStudents(usedModel, code, namee);
                    controller.isEditing.value = !controller.isEditing.value;
                  },
                  child: Icon(controller.isEditing.value
                      ? Icons.done
                      : Icons.edit_road),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void addAstudents(stuName, stuClass, code) async {
    await database!.transaction(
      (txn) async {
        code != "3AC"
            ? await txn.rawInsert(
                "INSERT INTO $stuClass (name,fard1,fard2,fard3,inchita,moyen) VALUES(?,?,?,?,?,?)",
                [
                  stuName,
                  0,
                  0,
                  0,
                  0,
                  0,
                ],
              )
            : await txn.rawInsert(
                "INSERT INTO $stuClass (name,fard1,fard2,inchita,moyen) VALUES(?,?,?,?,?)",
                [
                  stuName,
                  0,
                  0,
                  0,
                  0,
                ],
              );
      },
    );
    await getClassByName(stuClass);
    await getData(database!);
  }

  void addStudentUi(level, stuClass, context) async {
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
                        ? usedStudentList.value.forEach(
                            (element) {
                              if (element["name"] == v!) isUsed = true;
                            },
                          )
                        : level == "2AC"
                            ? usedStudentList.value.forEach(
                                (element) {
                                  if (element["name"] == v!) isUsed = true;
                                },
                              )
                            : usedStudentList.value.forEach(
                                (element) {
                                  if (element["name"] == v!) isUsed = true;
                                },
                              );

                    if (v == null || v.isEmpty) return "ارجوك ادخل اسم التلميد";
                    if (contSpec) return "الاسم غير مناسب";
                    if (isUsed) return "الاسم مستعمل من قبل";
                    return null;
                  },
                  controller: classNamCont,
                  decoration: InputDecoration(
                    hintText: " اسم التلميد",
                    hintTextDirection: TextDirection.rtl,
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
                        addAstudents(
                          classNamCont.text,
                          stuClass,
                          level,
                        );
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

  String getRating(moyn) {
    var toReturn = moyn < 5
        ? "ضعيف جدا"
        : moyn > 5 && moyn <= 9
            ? "ضعيف"
            : moyn >= 10 && moyn <= 11
                ? "متوسط"
                : moyn >= 12 && moyn <= 13
                    ? "لاباس به"
                    : moyn >= 14 && moyn <= 15
                        ? "مستحسن"
                        : moyn >= 16 && moyn <= 17
                            ? "حسن"
                            : "جيد";
    return toReturn;
  }

  void deleteClass(id, level) async {
    await database!.rawDelete(
      "DELETE FROM $level1 WHERE id = ?",
      [id,],
    );
  }
}
