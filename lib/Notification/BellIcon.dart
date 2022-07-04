// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'NotificationList.dart';
import 'NotificationProvider.dart';

class BellIcon extends StatelessWidget {
  bool isProfile = false;

  BellIcon({Key? key, required this.isProfile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NotificationList(
                isNotificationDetail: false,
              ))),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Icon(
            Icons.notifications,
            size: checkDeviceSize(context)
                ? MediaQuery.of(context).size.height * 0.045
                : MediaQuery.of(context).size.height * 0.04,
            color: isProfile ? kbackgroundColor : kBluePrimaryColor,
          ),
          _displayNotificationNumber(context),
        ],
      ),
    );
  }

  _displayNotificationNumber(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        decoration: BoxDecoration(
            color: kgreenPrimaryColor,
            border: Border.all(
              color: kgreenPrimaryColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        width: checkDeviceSize(context)
            ? MediaQuery.of(context).size.height * 0.023
            : MediaQuery.of(context).size.height * 0.018,
        child: Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Text(
            Provider.of<NotificationsProvider>(context, listen: false)
                .numberOfNotifications
                .toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kbackgroundColor,
              fontSize: checkDeviceSize(context)
                  ? MediaQuery.of(context).size.height * 0.015
                  : MediaQuery.of(context).size.height * 0.012,
            ),
          ),
        ),
      ),
    );
  }
}
