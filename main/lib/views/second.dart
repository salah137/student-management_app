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

    return Obx(
      () => Scaffold(
        body: ListView.builder(
          itemBuilder: (ctx, i) => classBuilder(
            code == "1AC"
                ? cont.level1.value[i]
                : code == "2AC"
                    ? cont.level2.value[i]
                    : cont.level3.value[i],
            code,
          ),
          itemCount: code == "1AC"
              ? cont.level1.value.length
              : code == "2AC"
                  ? cont.level2.value.length
                  : cont.level3.value.length,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            cont.addFromUi(code, context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
