import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stu_ma_/components/components.dart';
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
          body: ListView.separated(
              itemBuilder: (ctx, i) => classBuilder(usedList[i]),
              separatorBuilder: (ctx, i) => Container(),
              itemCount: usedList.length),
        );
      },
      init: MainController(),
    );
  }
}
