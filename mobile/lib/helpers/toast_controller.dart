import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Show toast based on toast package
void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.teal,
      fontSize: 16.0);
}
