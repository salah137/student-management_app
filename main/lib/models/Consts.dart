import 'package:get/get_connect/http/src/utils/utils.dart';

class Consts {
  static const speciaChar = [
    "²",
    "~",
    "#",
    "{",
    "[",
    "|",
    "`",
    "\\",
    "^",
    "@",
    "]",
    "}",
    "&",
    "é",
    "\"",
    "\'",
    "(",
    "-",
    "_",
    "ç",
    "à",
    ")",
    "}",
    "§",
    "!",
    ":",
    ";",
    ",",
    "?",
    "+",
    "-",
    "*",
    "/",
  ];

  static double countfor12(fard1, fard2, fard3, inchita) {
    double total = (fard1 + fard2 + fard3 + inchita) / 4;
    return total;
  }

  static double count3(fard1, fard2, inchita) {
    double total = 0.0;
    total = (fard1 + fard2) / 2 + inchita / 4;
    return total;
  }
}
