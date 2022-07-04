// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'ClearNotificationsProvider.dart';
import 'NotificationCard.dart';
import 'NotificationHeader.dart';
import 'NotificationProvider.dart';
import 'ShowAllNotificationsProvider.dart';

class NotificationList extends StatefulWidget {
  bool isNotificationDetail = false;

  NotificationList({required this.isNotificationDetail});

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Color(0xFFF4F5FD),
        body: ModalProgressHUD(
          inAsyncCall: Provider.of<AsyncCallProvider>(context).isinasynccall,
          // demo of some additional parameters
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(
              backgroundColor: kbackgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                NotificationHeader(),
                SizedBox(
                  height: 10,
                ),
                _displayNotifications(context),
                SizedBox(
                  height: 5,
                ),
                widget.isNotificationDetail
                    ? SizedBox()
                    : _displayOptions(context),
              ],
            ),
          ),
        ));
  }

  _displayNotifications(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.isNotificationDetail
                ? Provider.of<ShowAllNotificationsProvider>(context,
                        listen: false)
                    .numberOfNotifications
                : Provider.of<NotificationsProvider>(context, listen: false)
                    .numberOfNotifications,
            itemBuilder: (context, index) {
              return NotificationCard(
                index: index,
                isNotificationDetail: widget.isNotificationDetail,
              );
            }),
      ),
    );
  }

  _displayOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.isNotificationDetail = true;
              getdata();
            });
          },
          style: buttonStyle(),
          child: Text(
            'Older Notifications',
            style: TextStyle(color: kbackgroundColor),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () => _callClearNotificationsAPI(context),
          child: Text(
            'Clear',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w600,
                color: kgreenPrimaryColor,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }

  _callClearNotificationsAPI(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider _asyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);

    if (!_asyncCallProvider.isinasynccall) _asyncCallProvider.changeAsynccall();

    ClearNotificationsProvider _clearNotificationsProvider =
        Provider.of<ClearNotificationsProvider>(context, listen: false);

    if (!await _clearNotificationsProvider.callClearNotificationsapi(header))
      displaysnackbar('Something went wrong');
  }

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider _isAsyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);

    if (!_isAsyncCallProvider.isinasynccall)
      _isAsyncCallProvider.changeAsynccall();

    ShowAllNotificationsProvider _showAllProvider =
        Provider.of<ShowAllNotificationsProvider>(context, listen: false);

    if (!await _showAllProvider.callShowAllNotificationsapi(header))
      displaysnackbar('Something went wrong');

    _isAsyncCallProvider.changeAsynccall();
  }
}
