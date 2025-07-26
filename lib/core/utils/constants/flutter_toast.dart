
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {

  static void showToast(
    {
    required String msg,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double fontSize = 16,
  }
  )
   {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}

