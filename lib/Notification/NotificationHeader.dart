import 'package:flutter/material.dart';
import '../MenuHeader.dart';
import '../constants.dart';

class NotificationHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: kbackgroundColor,
        child: Column(
          children: [
            MenuHeader(
              isJobDetail: true,
              isPayment: false,
              isProfile: false,
            ),
            new SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
            ),
            Text(
              'Notifications',
              style: TextStyle(
                  color: kBluePrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
