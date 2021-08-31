import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stu_ma_/controllers/mainCon.dart';

class LevelScreen extends StatelessWidget {
  final code;

  LevelScreen({Key? key, required this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainController cont = Get.find();

    return GetBuilder<MainController>(
      builder: (contr) {
        var usedList = code == "1AC"
            ? contr.level1
            : code == "2AC"
                ? contr.level2
                : contr.level3;

        return Scaffold(
          body: SafeArea(
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    ' ',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    ' ',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                if (code != "3AC")
                  DataColumn(
                    label: Text(
                      "",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                DataColumn(
                  label: Text(
                    "",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: <DataRow>[
                ...usedList.map(
                  (e) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          e["name"].toString(),
                        ),
                      ),
                      DataCell(
                        Text(
                          e["students"].toString(),
                        ),
                      ),
                      DataCell(
                        Text(
                          e["fard1"].toString(),
                        ),
                      ),
                      DataCell(
                        Text(
                          e["fard2"].toString(),
                        ),
                      ),
                      if (code != "3AC")
                        DataCell(
                          Text(
                            e["fard3"].toString(),
                          ),
                        ),
                      DataCell(
                        Text(
                          e["nchita"].toString(),
                        ),
                      ),
                      DataCell(
                        Text(
                          e["moyen"].toString(),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      init: MainController(),
    );
  }
}
