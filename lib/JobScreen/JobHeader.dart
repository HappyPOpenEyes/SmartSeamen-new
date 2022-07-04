// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../MenuHeader.dart';
import '../constants.dart';

class JobHeader extends StatefulWidget {
  bool isJobDetail;
  var scaffoldKey;
  bool isPayment = false, isTransaction = false;
  int numOfNotifications;

  JobHeader(
      {Key? key,
      required this.isJobDetail,
      this.scaffoldKey,
      required this.isPayment,
      required this.isTransaction,
      required this.numOfNotifications})
      : super(key: key);

  @override
  _JobHeaderState createState() => _JobHeaderState();
}

class _JobHeaderState extends State<JobHeader> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: kbackgroundColor,
        child: Column(
          children: [
            MenuHeader(
              isJobDetail: widget.isJobDetail,
              isPayment: widget.isPayment,
              scaffoldKey: widget.scaffoldKey,
              isProfile: false,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
            ),
            Text(
              widget.isJobDetail
                  ? 'Job Detail'
                  : widget.isPayment
                      ? widget.isTransaction
                          ? 'Plan History'
                          : 'Plans'
                      : 'Jobs',
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
