import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../asynccallprovider.dart';
import '../constants.dart';
import 'ChangeStatusProvider.dart';
import 'DeleteNotificationProvider.dart';
import 'NotificationProvider.dart';
import 'RemoveNotificationProvider.dart';
import 'ShowAllNotificationsProvider.dart';

class NotificationCard extends StatefulWidget {
  int index;
  bool isNotificationDetail = false;

  NotificationCard({required this.index, required this.isNotificationDetail});

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  final GlobalKey _menuKey = GlobalKey();
  var header;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color: widget.isNotificationDetail
          ? Provider.of<ShowAllNotificationsProvider>(context, listen: false)
                      .notificationStatus[widget.index] ==
                  1
              ? kbackgroundColor
              : Colors.grey[300]
          : Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: kbackgroundColor,
                      foregroundColor: kgreenPrimaryColor,
                      child: widget.index == 0
                          ? Icon(Icons.article)
                          : Icon(Icons.person)),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isNotificationDetail
                            ? Provider.of<ShowAllNotificationsProvider>(context,
                                        listen: false)
                                    .notificationTitle[widget.index] 
                            : Provider.of<NotificationsProvider>(context,
                                        listen: false)
                                    .notificationTitle[widget.index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: checkDeviceSize(context)
                              ? MediaQuery.of(context).size.width * 0.04
                              : MediaQuery.of(context).size.width * 0.03,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(widget.isNotificationDetail
                            ? Provider.of<ShowAllNotificationsProvider>(context,
                                        listen: false)
                                    .notificationSubject[widget.index]
                            : Provider.of<NotificationsProvider>(context,
                                        listen: false)
                                    .notificationSubject[widget.index],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 2),
                      //   child: Text(widget.isNotificationDetail
                      //       ? Provider.of<ShowAllNotificationsProvider>(context,
                      //                   listen: false)
                      //               .notificationDate[widget.index] ??
                      //           'Date'
                      //       : Provider.of<NotificationsProvider>(context,
                      //                   listen: false)
                      //               .notificationDate[widget.index] ??
                      //           'Date'),
                      // ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            widget.isNotificationDetail
                ? PopupMenuButton(
                    key: _menuKey,
                    itemBuilder: (_) => const <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                              child: Text('Read'), value: "0"),
                          PopupMenuItem<String>(
                              child: Text('Unread'), value: "1"),
                          PopupMenuItem<String>(
                              child: Text('Delete'), value: "2"),
                        ],
                    onSelected: (value) {
                      if (value == "0")
                        _callChangeStatusApi(true);
                      else if (value == "1")
                        _callChangeStatusApi(false);
                      else
                        _callDeleteNotificationApi();
                    })
                : InkWell(
                    onTap: () => callRemoveNotificationApi(context),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          color: Color(0xFFF4F5FD),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.red[500],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  callRemoveNotificationApi(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    AsyncCallProvider _asyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);

    if (!_asyncCallProvider.isinasynccall) _asyncCallProvider.changeAsynccall();

    RemoveNotificationsProvider _removeNotificationsProvider =
        Provider.of<RemoveNotificationsProvider>(context, listen: false);

    if (!await _removeNotificationsProvider.callNotificationsapi(
        Provider.of<NotificationsProvider>(context, listen: false)
            .notificationId[widget.index],
        header))
      displaysnackbar('Something went wrong');
    else {
      Provider.of<NotificationsProvider>(context, listen: false)
          .removeData(widget.index);
      displaysnackbar('Notification Removed');
    }

    _asyncCallProvider.changeAsynccall();
  }

  void _callChangeStatusApi(bool isRead) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    AsyncCallProvider _isAsyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);

    if (!_isAsyncCallProvider.isinasynccall)
      _isAsyncCallProvider.changeAsynccall();

    ChangeStatusNotificationsProvider _changeStatusProvider =
        Provider.of<ChangeStatusNotificationsProvider>(context, listen: false);

    if (!await _changeStatusProvider.callChangeStatusNotificationsapi(
        Provider.of<NotificationsProvider>(context, listen: false)
            .notificationId[widget.index],
        isRead ? "1" : "0",
        header))
      displaysnackbar('Something went wrong');
    else {
      isRead
          ? Provider.of<ShowAllNotificationsProvider>(context, listen: false)
              .notificationStatus[widget.index] = 1
          : Provider.of<ShowAllNotificationsProvider>(context, listen: false)
              .notificationStatus[widget.index] = 0;
      displaysnackbar('Notification updated');
    }

    _isAsyncCallProvider.changeAsynccall();
  }

  void _callDeleteNotificationApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    AsyncCallProvider _isAsyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);

    if (!_isAsyncCallProvider.isinasynccall)
      _isAsyncCallProvider.changeAsynccall();

    DeleteNotificationsProvider _deleteNotificationProvider =
        Provider.of<DeleteNotificationsProvider>(context, listen: false);

    if (!await _deleteNotificationProvider.callDeleteNotificationsapi(
        Provider.of<ShowAllNotificationsProvider>(context, listen: false)
            .notificationId[widget.index],
        header))
      displaysnackbar('Something went wrong');
    else {
      Provider.of<ShowAllNotificationsProvider>(context, listen: false)
          .removeData(widget.index);
    }

    _isAsyncCallProvider.changeAsynccall();
  }
}
