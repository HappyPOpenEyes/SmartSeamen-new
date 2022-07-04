// ignore_for_file: must_be_immutable


import 'package:flutter/material.dart';
import '../MenuHeader.dart';
import '../constants.dart';

class DashboardHeader extends StatelessWidget {
  bool isEdit, isPayment, isDashboard;
  var scaffoldKey;
  DashboardHeader(
      {Key? key, required this.isDashboard,
      required this.isEdit,
      required this.isPayment,
      this.scaffoldKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: kbackgroundColor,
        child: Column(
          children: [
            MenuHeader(
              isJobDetail: isEdit,
              isPayment: isPayment,
              scaffoldKey: scaffoldKey,
              isProfile: false,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              isDashboard ? 'Dashboard' : 'Refer Job',
              style: TextStyle(
                  color: kBluePrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
