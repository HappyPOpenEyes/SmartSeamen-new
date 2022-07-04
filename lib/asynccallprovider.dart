import 'package:flutter/material.dart';

enum AsyncAction { True, False }

class AsyncCallProvider extends ChangeNotifier {
  bool isinasynccall = false;

  void changeAsynccall() {
    if (isinasynccall)
      isinasynccall = false;
    else
      isinasynccall = true;
    notifyListeners();
  }
}
