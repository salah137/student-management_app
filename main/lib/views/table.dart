import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stu_ma_/controllers/mainCon.dart';

class StudentTableScreen extends StatefulWidget {
  Map model;
  String code;
  StudentTableScreen({
    Key? key,
    required this.model,
    required this.code,
  }) : super(key: key);

  @override
  _StudentTableScreenState createState() => _StudentTableScreenState();
}

class _StudentTableScreenState extends State<StudentTableScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MainController controller = Get.find();
    print(widget.code);
    return Obx(
      () {
        return Scaffold(
          body: ListView(
            children: [
              ...controller.usedStudentList.map((element) => controller
                  .tableComponents(element, widget.code, widget.model["name"]))
            ],
          ),
        );
      },
    );
  }
}
