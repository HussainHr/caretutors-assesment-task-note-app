import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../configs/app_configs/app_colors.dart';

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.greenColor,
      textColor: Colors.white);
}
