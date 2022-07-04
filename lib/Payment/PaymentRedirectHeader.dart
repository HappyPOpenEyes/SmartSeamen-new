import 'dart:ui';
import 'package:flutter/material.dart';
import '../MenuHeader.dart';
import '../constants.dart';

class PaymentRedirectHeader extends StatelessWidget {
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
            ),
            Text(
              'Payment',
              style: TextStyle(
                  color: kBluePrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
            const Divider(
              thickness: 0.2,
              color: Colors.grey,
            )
          ],
        ));
  }
}
