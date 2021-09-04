import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appo/components/components.dart';
import 'package:appo/controllers/mainCon.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return GetBuilder<MainController>(
      builder: (c) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  itemBuilder(context, "الاولى اعدادي", "1AC"),
                  itemBuilder(context, "الثانية اعدادي", "2AC"),
                  itemBuilder(context, "الثالثة اعدادي", "3AC"),
                ],
              ),
            ),
          ),
        );
      },
      init: MainController(),
    );
  }
}
