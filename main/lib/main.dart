import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:appo/views/Home.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'قسمي',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Directionality(
        child: HomeScreen(),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
