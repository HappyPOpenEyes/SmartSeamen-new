// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartseaman/constants.dart';

import '../JobScreen/JobHeader.dart';
import '../asynccallprovider.dart';
import 'PlanHistoryProvider.dart';
import 'PlanScreens.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: const Color(0xFFF4F5FD),
        body: ModalProgressHUD(
          inAsyncCall: Provider.of<AsyncCallProvider>(context).isinasynccall,
          opacity: 0.5,
          progressIndicator: const CircularProgressIndicator(
              backgroundColor: kbackgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                JobHeader(
                  isJobDetail: false,
                  isPayment: true,
                  isTransaction: true,
                  numOfNotifications: 0,
                ),
                _displayWidgetArea(context)
              ],
            ),
          ),
        ));
  }

  _displayWidgetArea(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _displayCurrentPackage(),
            Provider.of<PlanHistoryProvider>(context, listen: false)
                    .upcomingPlanAmount
                    .isEmpty
                ? const SizedBox()
                : _displayPlanData(false),
            _displayPlanData(true),
          ],
        ));
  }

  _displayCurrentPackage() {
    return Card(
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _displaycardheader('Current Package', true),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: checkData()
                  ? const Text('There are no plan records')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Plan Name',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      Provider.of<PlanHistoryProvider>(context,
                                              listen: false)
                                          .currentPlanName,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.038,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    // Container(
                                    //   width:
                                    //       MediaQuery.of(context).size.width *
                                    //           0.2,
                                    //   height:
                                    //       MediaQuery.of(context).size.height *
                                    //           0.02,
                                    //   decoration: BoxDecoration(
                                    //       color: Colors.red[500],
                                    //       border: Border.all(
                                    //         color: Colors.red[500],
                                    //       ),
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(10))),
                                    //   child: Center(
                                    //     child: Text(
                                    //       'Expired',
                                    //       style: TextStyle(
                                    //           color: kbackgroundColor),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: _displaystatictext(
                                  'Start Date',
                                  Provider.of<PlanHistoryProvider>(context,
                                          listen: false)
                                      .currentPlanStartDate,
                                  context),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            _displaystatictext(
                                'End Date',
                                Provider.of<PlanHistoryProvider>(context,
                                        listen: false)
                                    .currentPlanExpiryDate,
                                context),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _displaycardheader(String s, bool isCurrent) {
    return Column(
      children: [
        Row(
          children: [
            Text(s,
                style: TextStyle(
                    color: isCurrent ? kBluePrimaryColor : kblackPrimaryColor,
                    fontSize: isCurrent
                        ? MediaQuery.of(context).size.width * 0.055
                        : MediaQuery.of(context).size.width * 0.045,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              width: 10,
            ),
            isCurrent
                ? Row(
                    children: [
                      const VerticalDivider(
                        thickness: 1.5,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.create,
                        color: kgreenPrimaryColor,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PlanScreens()));
                        },
                        child: Text('Buy Package',
                            style: TextStyle(
                                color: kgreenPrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.042,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                : const SizedBox(),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  _displaystatictext(String label, String text, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.038,
          ),
        ),
      ],
    );
  }

  _displayPlanData(bool isPast) {
    return Card(
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _displaycardheader(isPast ? 'Past Plan' : 'Upcoming Plans', false),
            isPast
                ? Provider.of<PlanHistoryProvider>(context, listen: false)
                        .pastPlanAmount
                        .isEmpty
                    ? const Text('There are no past plan records')
                    : _displayListRecords(isPast)
                : _displayListRecords(isPast),
          ],
        ),
      ),
    );
  }

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider isinAsyncCall =
        Provider.of<AsyncCallProvider>(context, listen: false);

    isinAsyncCall.changeAsynccall();

    PlanHistoryProvider planHistoryProvider =
        Provider.of<PlanHistoryProvider>(context, listen: false);

    if (!await planHistoryProvider.callPlanHistoryapi(header))
      displaysnackbar('Something went wrong');

    isinAsyncCall.changeAsynccall();
  }

  _displayListRecords(bool isPast) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: isPast
            ? Provider.of<PlanHistoryProvider>(context, listen: false)
                .pastPlanAmount
                .length
            : Provider.of<PlanHistoryProvider>(context, listen: false)
                .upcomingPlanAmount
                .length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: kBluePrimaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: RichText(
                          text: TextSpan(
                              text: '\u{20B9}',
                              style: TextStyle(
                                  color: kbackgroundColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.042,
                                  fontWeight: FontWeight.bold),
                              children: [
                            TextSpan(
                              text: isPast
                                  ? Provider.of<PlanHistoryProvider>(context,
                                              listen: false)
                                          .pastPlanAmount[index] 
                                  : Provider.of<PlanHistoryProvider>(context,
                                          listen: false)
                                      .upcomingPlanAmount[index],
                              style: TextStyle(
                                  color: kbackgroundColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.042,
                                  fontWeight: FontWeight.bold),
                            )
                          ])),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.29,
                              child: Text(
                                isPast
                                    ? Provider.of<PlanHistoryProvider>(context,
                                            listen: false)
                                        .pastPlanName[index]
                                    : Provider.of<PlanHistoryProvider>(context,
                                            listen: false)
                                        .upcomingPlanName[index],
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            Text(
                              isPast
                                  ? Provider.of<PlanHistoryProvider>(context,
                                          listen: false)
                                      .pastPlanStatus[index]
                                  : Provider.of<PlanHistoryProvider>(context,
                                          listen: false)
                                      .upcomingPlanStatus[index],
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.036,
                                  color: isPast
                                      ? Provider.of<PlanHistoryProvider>(
                                                      context,
                                                      listen: false)
                                                  .pastPlanStatus[index] ==
                                              "failed"
                                          ? Colors.red[500]
                                          : kgreenPrimaryColor
                                      : Provider.of<PlanHistoryProvider>(
                                                      context,
                                                      listen: false)
                                                  .upcomingPlanStatus[index] ==
                                              "Pending"
                                          ? Colors.red[500]
                                          : kgreenPrimaryColor),
                            ),
                          ],
                        ),
                        Text(
                          isPast
                              ? Provider.of<PlanHistoryProvider>(context,
                                          listen: false)
                                      .pastPlanDuration[index] 
                              : Provider.of<PlanHistoryProvider>(context,
                                      listen: false)
                                  .upcomingPlanDuration[index],
                        ),
                        Row(
                          children: [
                            Text(
                              isPast
                                  ? Provider.of<PlanHistoryProvider>(context,
                                              listen: false)
                                          .pastPlanStartDate[index] 
                                  : Provider.of<PlanHistoryProvider>(context,
                                          listen: false)
                                      .upcomingPlanStartDate[index],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text('-'),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              isPast
                                  ? Provider.of<PlanHistoryProvider>(context,
                                              listen: false)
                                          .pastPlanExpiryDate[index] 
                                  : Provider.of<PlanHistoryProvider>(context,
                                          listen: false)
                                      .upcomingPlanExpiryDate[index],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool checkData() {
    if (Provider.of<PlanHistoryProvider>(context, listen: false)
            // ignore: unnecessary_null_comparison
            .currentPlanExpiryDate ==
        null) {
      return Provider.of<PlanHistoryProvider>(context, listen: false)
              .currentPlanStartDate
              .isEmpty
          ? true
          : false;
    } else {
      return Provider.of<PlanHistoryProvider>(context, listen: false)
              .currentPlanExpiryDate
              .isEmpty
          ? true
          : false;
    }
  }
}
