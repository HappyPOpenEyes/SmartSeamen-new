import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'CalculatePlanProvider.dart';
import 'PaymentStripe.dart';
import 'PlanProvider.dart';

class PlanCard extends StatelessWidget {
  int index;
  var header;
  var scaffoldKey;

  PlanCard(
      {Key? key, required this.index, this.header, required this.scaffoldKey})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color: Provider.of<GetPlanListProvider>(context, listen: false)
                  .planId[index] ==
              Provider.of<GetPlanListProvider>(context, listen: false)
                  .currentPlanId
          ? kgreenPrimaryColor
          : Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                    Provider.of<GetPlanListProvider>(context, listen: false)
                        .planName[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    )),
                const Spacer(),
                Text(
                    '\u20B9${Provider.of<GetPlanListProvider>(context, listen: false).planAmount[index]} / mo',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    )),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () => _showModalSheet(context, index),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Text('View Details'),
                  ),
                ),
                const Spacer(),
                Provider.of<GetPlanListProvider>(context, listen: false)
                            .planId[index] ==
                        starterPlanId
                    ? Container()
                    : Provider.of<GetPlanListProvider>(context, listen: false)
                                .planId[index] ==
                            Provider.of<GetPlanListProvider>(context,
                                    listen: false)
                                .currentPlanId
                        ? Container()
                        : ElevatedButton(
                            onPressed: () {
                              calculatePlan(context, index);
                            },
                            style: buttonStyle(),
                            child: const Text(
                              'Buy',
                              style: TextStyle(color: kbackgroundColor),
                            ),
                          )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showModalSheet(BuildContext context, int index) {
    print(Provider.of<GetPlanListProvider>(context, listen: false)
        .planCreateProfile);
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Wrap(
            children: [
              Container(
                //height: MediaQuery.of(context).size.height * 0.8,
                color: const Color(0xFF737373),
                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: const BoxDecoration(
                            color: Color(0xFFF4F5FD),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                            ),
                            Column(
                              children: [
                                Text(
                                  Provider.of<GetPlanListProvider>(context,
                                          listen: false)
                                      .planName[index],
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: kBluePrimaryColor),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  '\$${Provider.of<GetPlanListProvider>(context, listen: false).planAmount[index]}/ Month',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: kBluePrimaryColor),
                                )
                              ],
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.cancel,
                                    color: kBluePrimaryColor,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            )
                          ],
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: kbackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Provider.of<GetPlanListProvider>(context,
                                        listen: false)
                                    .planCreateProfile[index]
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Create Profile',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      _showDivider(),
                                    ],
                                  )
                                : const SizedBox(),
                            Provider.of<GetPlanListProvider>(context,
                                        listen: false)
                                    .planDownloadResume[index]
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Download Resume',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      _showDivider()
                                    ],
                                  )
                                : const SizedBox(),
                            Provider.of<GetPlanListProvider>(context,
                                        listen: false)
                                    .planJobNotification[index]
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Job Notifications',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      _showDivider()
                                    ],
                                  )
                                : const SizedBox(),
                            Provider.of<GetPlanListProvider>(context,
                                        listen: false)
                                    .planEmailSupport[index]
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Email Support',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      _showDivider()
                                    ],
                                  )
                                : const SizedBox(),
                            Provider.of<GetPlanListProvider>(context,
                                        listen: false)
                                    .planShortlistNotificaiton[index]
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Shortlist Notification',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      _showDivider()
                                    ],
                                  )
                                : const SizedBox(),
                            Provider.of<GetPlanListProvider>(context,
                                        listen: false)
                                    .planJobApplicationPerDay[index]
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Job Application Per Day',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      _showDivider()
                                    ],
                                  )
                                : const SizedBox(),
                            Provider.of<GetPlanListProvider>(context,
                                        listen: false)
                                    .planProfileViewNotification[index]
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Profile View Notification',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      _showDivider()
                                    ],
                                  )
                                : const SizedBox(),
                            Provider.of<GetPlanListProvider>(context,
                                        listen: false)
                                    .planProfileHighlightEmployer[index]
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Profile Highlight Employer',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      _showDivider()
                                    ],
                                  )
                                : const SizedBox(),
                            Text(
                              '${Provider.of<GetPlanListProvider>(context, listen: false).planDuration[index]} Duration',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold),
                            ),
                            _showDivider(),
                            Text(
                                '${Provider.of<GetPlanListProvider>(context, listen: false).planJobViews[index]} Job Views',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.bold)),
                            // Row(
                            //   children: [
                            //     Text('Duration',
                            //         style: TextStyle(fontSize: 18)),
                            //     new Spacer(),
                            //     Text(
                            //       Provider.of<GetPlanListProvider>(context,
                            //               listen: false)
                            //           .planDuration[index],
                            //       style: TextStyle(
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.bold),
                            //     )
                            //   ],
                            // ),
                            // Divider(
                            //   thickness: 0.2,
                            //   color: Colors.grey,
                            // ),
                            // Row(
                            //   children: [
                            //     Text('Job Views',
                            //         style: TextStyle(fontSize: 18)),
                            //     new Spacer(),
                            //     Text(
                            //         Provider.of<GetPlanListProvider>(context,
                            //                 listen: false)
                            //             .planJobViews[index],
                            //         style: TextStyle(
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold))
                            //   ],
                            // ),
                            // Divider(
                            //   thickness: 0.2,
                            //   color: Colors.grey,
                            // ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  _showDivider() {
    return const Divider(
      thickness: 0.2,
      color: Colors.grey,
    );
  }

  void calculatePlan(BuildContext context, int index) async {
    AsyncCallProvider asyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!asyncCallProvider.isinasynccall) asyncCallProvider.changeAsynccall();

    GetPlanCalculationProvider calculatePlan =
        Provider.of<GetPlanCalculationProvider>(context, listen: false);

    if (await calculatePlan.callGetPlanListapi(
        Provider.of<GetPlanListProvider>(context, listen: false).planId[index],
        header)) {
      showAlert(scaffoldKey);
    } else if (Provider.of<GetPlanCalculationProvider>(context, listen: false)
        .isAlreadyPlan) {
      showIsAlreadyAlert(context);
      Provider.of<GetPlanCalculationProvider>(context, listen: false)
          .isAlreadyPlan = false;
    } else {
      displaysnackbar('Something went wrong');
    }

    //Provider.of<PaymentStripe>(context, listen: false).makePayment();

    asyncCallProvider.changeAsynccall();
  }

  showIsAlreadyAlert(BuildContext context) {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title:
              const Text('Plan Error', style: TextStyle(color: Colors.black)),
          content: const Text('You have already taken future plan.'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: kbackgroundColor,
                  //width: double.maxFinite,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      style: buttonStyle(),
                      child: const Text(
                        "OK",
                        style: TextStyle(color: kbackgroundColor),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            )
          ],
        ));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlert(var scaffoldKey) {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: const Text('Calculated Plan Amount',
              style: TextStyle(color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Amount to be paid: ',
                      style: TextStyle(color: Colors.black)),
                  Text(
                    Provider.of<GetPlanCalculationProvider>(
                            scaffoldKey.currentContext,
                            listen: false)
                        .calculatedPlanAmount,
                    style: const TextStyle(color: kBluePrimaryColor),
                  )
                ],
              ),
              const SizedBox(height: 5),
              double.parse(Provider.of<GetPlanListProvider>(
                              scaffoldKey.currentContext,
                              listen: false)
                          .currentAmount) <
                      double.parse(Provider.of<GetPlanListProvider>(
                              scaffoldKey.currentContext,
                              listen: false)
                          .planAmount[index])
                  ? Text(
                      '(This is prorated amount based on your current plan. Original Plan amount is:${Provider.of<GetPlanListProvider>(scaffoldKey.currentContext, listen: false).planAmount[index]})',
                      style: TextStyle(
                          fontSize: MediaQuery.of(scaffoldKey.currentContext)
                                  .size
                                  .width *
                              0.035),
                    )
                  : Container(),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text('Plan Start Date: '),
                  Text(
                    Provider.of<GetPlanCalculationProvider>(
                            scaffoldKey.currentContext,
                            listen: false)
                        .startDate,
                    style: const TextStyle(color: kBluePrimaryColor),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text('Plan End Date: '),
                  Text(
                    Provider.of<GetPlanCalculationProvider>(
                            scaffoldKey.currentContext,
                            listen: false)
                        .endDate,
                    style: const TextStyle(color: kBluePrimaryColor),
                  )
                ],
              )
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: kbackgroundColor,
                  //width: double.maxFinite,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      style: buttonStyle(),
                      child: const Text(
                        "Proceed",
                        style: TextStyle(color: kbackgroundColor),
                      ),
                      onPressed: () {
                        Navigator.pop(scaffoldKey.currentContext);
                        Provider.of<PaymentStripe>(scaffoldKey.currentContext,
                                listen: false)
                            .makePayment(
                                scaffoldKey.currentContext, index, header);
                      }),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  color: kbackgroundColor,
                  //width: double.maxFinite,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: buttonStyle(),
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(scaffoldKey.currentContext).pop();
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            )
          ],
        ));
    showDialog(
      context: scaffoldKey.currentContext,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
