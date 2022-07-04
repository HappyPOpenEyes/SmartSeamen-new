import 'package:flutter/material.dart';

import '../MenuHeader.dart';
import '../constants.dart';


class ContactUsHeader extends StatelessWidget {
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
            scaffoldKey: "",
            isProfile: false,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Contact Us',
                style: TextStyle(
                    color: kBluePrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: checkDeviceSize(context)
                        ? MediaQuery.of(context).size.width * 0.05
                        : MediaQuery.of(context).size.width * 0.045),
              )),
        ],
      ),
    );
  }
}
