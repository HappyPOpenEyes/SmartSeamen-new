import 'package:flutter/material.dart';

class GetSortOrderProvider extends ChangeNotifier {
  bool success = false;
  String sortOrder = "";
  Future<bool> callGetSortOrderapi(sortOrderApi) async {
    this.sortOrder = sortOrderApi;
    return true;
  }
}
