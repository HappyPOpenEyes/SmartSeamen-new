import 'dart:async';

import 'package:flutter/material.dart';

class UserDetailsProvider extends ChangeNotifier {
  String fname = "",
      lname = "",
      phonenumber = "",
      email = "",
      alternateemail = "",
      userid = "",
      header = "", tokenheader = "";

  void changeUserDetails(callfname, calllname, callemail, callalternateemail,
      callphonenumber, calluserid, callheader) {
    fname = callfname;
    lname = calllname;
    email = callemail;
    alternateemail = callalternateemail;
    phonenumber = callphonenumber;
    header = callheader;
    userid = calluserid;
    notifyListeners();
  }
}
