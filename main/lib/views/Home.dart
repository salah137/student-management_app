import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stu_ma_/components/components.dart';
import 'package:stu_ma_/controllers/mainCon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainController myControlller = Get.put(MainController());

    return GetBuilder<MainController>(
      builder: (c) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              itemBuilder(context, "الاولى اعدادي","1AC"),
              itemBuilder(context,"الثانية اعدادي","2AC"),
              itemBuilder(context, "الثالثة اعدادي","3AC"),  
            ],
          ),
        );
      },
      init: MainController(),
    );
  }
}
