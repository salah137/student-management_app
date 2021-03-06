import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:stu_ma_/models/Consts.dart';

class MainController extends GetxController {
  var level1 = [].obs;
  var level3 = [].obs;
  var level2 = [].obs;
  var usedStudentList = [].obs;
  var isEditing = false.obs;
  var btnIsShwing = false.obs;
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

                    if (v == null || v.isEmpty) return "?????????? ???????? ?????? ??????????";
                    if (contSpec) return "?????????? ?????? ??????????";
                    if (isUsed) return "?????????? ???????????? ???? ??????";
                    return null;
                  },
                  controller: classNamCont,
                  decoration: InputDecoration(
                    hintText: " ?????? ??????????",
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
                    child: Text("????"),
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
    print(model);
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

      print("moyen =>$moyen");

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
    if (model["id"] > 1) {
      btnIsShwing.value = true;
    }
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
                  onTap: () {
                    name.text = "";
                  },
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
                  onTap: () {
                    fard1.text = "";
                  },
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
                  onTap: () {
                    fatrd2.text = "";
                  },
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
                    onTap: () {
                      fard3!.text = "";
                    },
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
                  onTap: () {
                    inchita.text = "";
                  },
                  onChanged: (v) {
                    usedModel["inchita"] = int.tryParse(v);
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
            Text(
              getRating(
                usedModel["moyen"],
              ),
            ),
            Container(
              margin: EdgeInsets.all(3),
              height: 40,
              width: 30,
              child: FloatingActionButton(
                heroTag: "btn${Random().nextInt(100)}",
                onPressed: () async {
                  if (controller.isEditing.value)
                    updateStudents(usedModel, code, namee);
                  controller.isEditing.value = !controller.isEditing.value;
                },
                child:
                    Icon(controller.isEditing.value ? Icons.done : Icons.edit),
              ),
            ),
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

                    if (v == null || v.isEmpty) return "?????????? ???????? ?????? ??????????????";
                    if (contSpec) return "?????????? ?????? ??????????";
                    if (isUsed) return "?????????? ???????????? ???? ??????";
                    return null;
                  },
                  controller: classNamCont,
                  decoration: InputDecoration(
                    hintText: " ?????? ??????????????",
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
                    child: Text("????"),
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
        ? "???????? ??????"
        : moyn > 5 && moyn <= 9
            ? "????????"
            : moyn >= 10 && moyn <= 11
                ? "??????????"
                : moyn >= 12 && moyn <= 13
                    ? "?????????? ????"
                    : moyn >= 14 && moyn <= 15
                        ? "????????????"
                        : moyn >= 16 && moyn <= 17
                            ? "??????"
                            : "??????";
    return toReturn;
  }

  Future deleteClass(
    id,
    level,
  ) async {
    await database!.rawDelete(
      "DELETE FROM $level WHERE id = ?",
      [
        id,
      ],
    );
    getData(database!);
  }

  onLongPressCom(level, context, model) {
    Get.bottomSheet(
      Column(
        children: [
          Container(
            margin: EdgeInsets.all(50),
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              child: MaterialButton(
                onPressed: () async {
                  await deleteClass(model["id"], level);
                  Navigator.pop(context);
                },
                child: Text("?????? ??????????"),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Container(
            margin: EdgeInsets.all(50),
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              child: MaterialButton(
                onPressed: () async {
                  await toCsv(model["name"], level, context);
                  Navigator.pop(context);
                },
                child: Text("?????? ??????????"),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
    );
  }

  Future toCsv(className, code, context) async {
    print(className);
    getClassByName(className);
    String path = await FilesystemPicker.open(
      title: 'Save to folder',
      context: context,
      rootDirectory: Directory(
          await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DOCUMENTS)),
      fsType: FilesystemType.folder,
      pickText: 'Save file to this folder',
      folderIconColor: Colors.teal,
    );
    print(await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOCUMENTS));

    var result = ListToCsvConverter().convert([
      [
        "?????????? ????????????",
        "?????????? ??????????",
        "?????????? ????????????",
        (code != "3AC") ? "?????????? ????????????" : "",
        "??????????????",
        "???????????? ??????????",
        "??????????????????"
      ],
      ...usedStudentList.map(
        (element) {
          return [
            element["name"],
            element["fard1"],
            element["fard2"],
            code != "3AC" ? element["fard3"] : "",
            element["inchita"],
            element["moyen"],
            getRating(
              element["moyen"],
            ),
          ];
        },
      ),
    ]);
    var file = await File("${path}/${className}.csv").create(recursive: true);
    await file.writeAsString(result);
    Navigator.pop(context);
    Get.snackbar("Done", "the fil was saved in Documents",
        backgroundColor: Colors.green, colorText: Colors.white);
  }
}
