import 'package:flutter/material.dart';

enum JobLoaderAction { True, False }

class JobLoaderProvider extends ChangeNotifier {
  bool isinJobLoader = false;

  void changeJobLoader() {
    isinJobLoader = !isinJobLoader;
    notifyListeners();
  }
}
