import 'package:flutter/material.dart';

class StudentTableScreen extends StatelessWidget {
  Map model;
  String code;
  StudentTableScreen({
    Key? key,
    required this.model,
    required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(''),
            ),
            DataColumn(
              label: Text(''),
            ),
            DataColumn(
              label: Text(''),
            ),
            if (code != "3AC")
              DataColumn(
                label: Text(''),
              ),
            DataColumn(
              label: Text(''),
            ),
            DataColumn(
              label: Text(''),
            ),
          ],
          rows: [
              
          ],
        ),
      ),
    );
  }
}
