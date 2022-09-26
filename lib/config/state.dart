import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:test_pc/config/app_color.dart';

class ThemeChangeNotifier extends ChangeNotifier {
  Color primary = AppColor.primary;
  void changeColor(int color) async {
    primary = Color(color);
    notifyListeners();
  }
}
