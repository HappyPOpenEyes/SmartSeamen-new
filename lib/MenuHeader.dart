// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Notification/BellIcon.dart';
import 'constants.dart';

class MenuHeader extends StatelessWidget {
  bool isJobDetail, isPayment, isProfile;
  var scaffoldKey;

  MenuHeader(
      {Key? key, required this.isJobDetail,
      required this.isPayment,
      this.scaffoldKey,
      required this.isProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
        top: MediaQuery.of(context).size.height * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isJobDetail
              ? _displayPreviousIcon(context)
              : isPayment
                  ? _displayPreviousIcon(context)
                  : InkWell(
                      onTap: () => scaffoldKey.currentState.openDrawer(),
                      child: Image.asset(
                        'images/list.png',
                        color: kBluePrimaryColor,
                        height: MediaQuery.of(context).size.height * 0.035,
                      ),
                    ),
          Center(
            child: Image.asset(
              'logos/smartsemen-logo.png',
              height: MediaQuery.of(context).size.height * 0.045,
            ),
          ),
          //new Spacer(),
          isJobDetail
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.08,
                )
              : BellIcon(
                  isProfile: isProfile,
                )
        ],
      ),
    );
  }

  _displayPreviousIcon(BuildContext context) {
    return InkWell(
      onTap: () {
        bool navigate = false;
        // if (Provider.of<ResumeEditCompetencyRecordDeleteProvider>(context,
        //         listen: false)
        //     .isMandatoryDelete) navigate = true;
        // if (Provider.of<ResumeEditSTCWRecordDeleteProvider>(context,
        //         listen: false)
        //     .isMandatoryDelete) navigate = true;
        if (!navigate) Navigator.pop(context);
      },
      child: Image.asset(
        'images/previous.png',
        color: kBluePrimaryColor,
        height: MediaQuery.of(context).size.height * 0.035,
      ),
    );
  }
}
