import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stu_ma_/views/second.dart';

Widget itemBuilder(context, model, code) {
  print(code);
  return GestureDetector(
    onTap: () {
      Get.to(
          () => LevelScreen(
                code: code,
              ),
          duration: Duration(milliseconds: 200));
    },
    child: Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromRGBO(155, 50, 0, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      height: MediaQuery.of(context).size.height / 6,
      child: Text(
        "$model",
        style: TextStyle(fontSize: 50, color: Colors.white),
      ),
    ),
  );
}
