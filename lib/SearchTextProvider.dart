import 'package:flutter/material.dart';

class SearchChangeProvider extends ChangeNotifier {
  List<String> searchList = [];
  String searchKeyword = "", noData = "No Data Found";
  bool noDataFound = false;

  void changeSearchText() {
    
    notifyListeners();
  }
}
