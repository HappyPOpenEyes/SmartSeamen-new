// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, unnecessary_new

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../AnimatedText.dart';
import '../JobScreen/JobDetail.dart';
import '../JobScreen/JobList.dart';
import '../Profile/UserDetailsProvider.dart';
import '../ShimmerLoader.dart';
import '../SideBar/SideBar.dart';
import '../SwitchButtonBloc.dart';
import '../asynccallprovider.dart';
import '../bottomnavigation.dart';
import '../constants.dart';
import 'DashboardHeader.dart';
import 'DashboardStatusProvider.dart';
import 'GetDashboardCountDataProvider.dart';
import 'GetDashboardDataProvider.dart';
import 'GetDashboardNotificationProvider.dart';
import 'GetExpiredDataProvider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  bool _hasChanged = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  var header;
  static final DateFormat formatter = DateFormat('dd MMMM, yyyy');
  final SwitchButtonBloc _switchButtonBloc = SwitchButtonBloc();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getdata();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _switchButtonBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
      drawer: Drawer(
        child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.57,
            child: const Sidebar()),
      ),
      backgroundColor: const Color(0xFFF4F5FD),
      bottomNavigationBar: BottomNavigationClass(0),
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<AsyncCallProvider>(context).isinasynccall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(
            backgroundColor: kbackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DashboardHeader(
                isDashboard: true,
                isEdit: false,
                isPayment: false,
                scaffoldKey: _scaffoldkey,
              ),
              Provider.of<GetDashboardCountDataProvider>(context, listen: false)
                      .publishStatus
                  ? const SizedBox()
                  : AnimatedText(
                      animationController: _animationController, index: 0),
              _displayWidgetArea(),
            ],
          ),
        ),
      ),
    );
  }

  _displayDataCards(String title, String count) {
    return Card(
      color: kBluePrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        width: checkDeviceSize(context)
            ? MediaQuery.of(context).size.width * 0.466
            : MediaQuery.of(context).size.width * 0.468,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: kbackgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.045),
              ),
              Text(
                count,
                style: TextStyle(
                    color: kbackgroundColor,
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              )
            ],
          ),
        ),
      ),
    );
  }

  _displayTop5JobCard() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Recent 5 Job Post',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: checkDeviceSize(context)
                          ? MediaQuery.of(context).size.width * 0.042
                          : MediaQuery.of(context).size.width * 0.037,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const JobList())),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: kgreenPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              ),
              const Divider(
                thickness: 0.2,
                color: kblackPrimaryColor,
              ),
              Provider.of<GetDashboardDataProvider>(context, listen: false)
                      .companyName
                      .isEmpty
                  ? const Text('There are no jobs')
                  : SizedBox(
                      height: checkDeviceSize(context)
                          ? MediaQuery.of(context).size.height * 0.24
                          : MediaQuery.of(context).size.height * 0.3,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: Provider.of<GetDashboardDataProvider>(
                                context,
                                listen: false)
                            .companyName
                            .length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => JobDetail(
                                          companyId: Provider.of<
                                                      GetDashboardDataProvider>(
                                                  context,
                                                  listen: false)
                                              .companyId[index],
                                        ))),
                            child: Card(
                              color: Colors.grey[50],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _displaystatictext(
                                          'Company Name',
                                          Provider.of<GetDashboardDataProvider>(
                                                  context,
                                                  listen: false)
                                              .companyName[index]),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      _displaystatictext(
                                          'Ranks',
                                          Provider.of<GetDashboardDataProvider>(
                                                  context,
                                                  listen: false)
                                              .rankName[index]),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      _displaystatictext(
                                          'Vessel Type',
                                          Provider.of<GetDashboardDataProvider>(
                                                  context,
                                                  listen: false)
                                              .vesselname[index]),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      _displaystatictext(
                                          'Expiration Date',
                                          Provider.of<GetDashboardDataProvider>(
                                                  context,
                                                  listen: false)
                                              .expirationDate[index]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  _displaystatictext(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: kblackPrimaryColor,
            fontWeight: FontWeight.w600,
            fontSize: checkDeviceSize(context)
                ? MediaQuery.of(context).size.width * 0.04
                : MediaQuery.of(context).size.width * 0.035,
          ),
        ),
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: checkDeviceSize(context)
                ? MediaQuery.of(context).size.width * 0.038
                : MediaQuery.of(context).size.width * 0.033,
          ),
        ),
      ],
    );
  }

  void getdata() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const Dashboard(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');

    if (prefs.getString('ReferJob') != null) {
      displaysnackbar(prefs.getString('ReferJob') ?? '');
      prefs.remove('ReferJob');
    }

    AsyncCallProvider asyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncCallProvider.changeAsynccall();
    }
    UserDetailsProvider userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    userDetailsProvider.changeUserDetails(
        prefs.getString('firstname'),
        prefs.getString('lastname'),
        prefs.getString('email'),
        "",
        prefs.getString('mobile'),
        prefs.getString('userid'),
        prefs.getString('header'));

    GetDashboardCountDataProvider getDashboardCountDataProvider =
        Provider.of<GetDashboardCountDataProvider>(context, listen: false);
    if (!await getDashboardCountDataProvider.callGetDashboardCountDataapi(
        header)) displaysnackbar('Something went wrong');

    GetDashboardDataProvider getDashboardDataProvider =
        Provider.of<GetDashboardDataProvider>(context, listen: false);
    if (!await getDashboardDataProvider.callGetDashboardDataapi(header)) {
      displaysnackbar('Something went wrong');
    }

    GetDashboardExpiredDataProvider getDashboardExpiredDataProvider =
        Provider.of<GetDashboardExpiredDataProvider>(context, listen: false);
    if (!await getDashboardExpiredDataProvider.callGetDashboardExpiredDataapi(
        header)) displaysnackbar('Something went wrong');

    GetDashboardNotificationProvider getDashboardNotificationProvider =
        Provider.of<GetDashboardNotificationProvider>(context, listen: false);
    if (!await getDashboardNotificationProvider
        .callGetDashboardNotificationapi(header)) {
      displaysnackbar('Something went wrong');
    }

    asyncCallProvider.changeAsynccall();
  }

  _displayDocumentExpirationCard() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Document Expirations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: checkDeviceSize(context)
                      ? MediaQuery.of(context).size.width * 0.04
                      : MediaQuery.of(context).size.width * 0.035,
                ),
              ),
              const Divider(
                thickness: 0.2,
                color: kblackPrimaryColor,
              ),
              SizedBox(
                //width: MediaQuery.of(context).size.width,
                height: checkDeviceSize(context)
                    ? MediaQuery.of(context).size.height * 0.3
                    : MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Provider.of<GetDashboardExpiredDataProvider>(
                            context,
                            listen: false)
                        .docName
                        .length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.78,
                                  color:
                                      Provider.of<GetDashboardExpiredDataProvider>(
                                                  context,
                                                  listen: false)
                                              .expirationDate[index]
                                              .isBefore(DateTime.now())
                                          ? const Color(0xFFFF6358)
                                          : kbackgroundColor,
                                  child: _displaystatictext(
                                      'Type',
                                      Provider.of<GetDashboardExpiredDataProvider>(
                                              context,
                                              listen: false)
                                          .docType[index]),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                _displaystatictext(
                                    'Document Name',
                                    Provider.of<GetDashboardExpiredDataProvider>(
                                            context,
                                            listen: false)
                                        .docName[index]),
                                const SizedBox(
                                  height: 8,
                                ),
                                _displaystatictext(
                                    'Number',
                                    Provider.of<GetDashboardExpiredDataProvider>(
                                            context,
                                            listen: false)
                                        .docNumber[index]),
                                const SizedBox(
                                  height: 8,
                                ),
                                _displaystatictext(
                                    'Expiration Date',
                                    formatter.format(Provider.of<
                                                GetDashboardExpiredDataProvider>(
                                            context,
                                            listen: false)
                                        .expirationDate[index])),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  _displayWidgetArea() {
    return Provider.of<AsyncCallProvider>(context).isinasynccall
        ? const ShimmerLoader()
        : Column(
            children: [
              _displayActiveToggle(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  children: [
                    _displayDataCards(
                        'Total Jobs',
                        Provider.of<GetDashboardCountDataProvider>(context,
                                listen: false)
                            .totalJobs),
                    _displayDataCards(
                        'Jobs for your Rank',
                        Provider.of<GetDashboardCountDataProvider>(context,
                                listen: false)
                            .availableJobs),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    _displayDataCards(
                        'Applied Jobs',
                        Provider.of<GetDashboardCountDataProvider>(context,
                                listen: false)
                            .appliedJobs),
                    _displayDataCards(
                        'Short Lists',
                        Provider.of<GetDashboardCountDataProvider>(context,
                                listen: false)
                            .shortListCount),
                  ],
                ),
              ),
              _displayTop5JobCard(),
              Provider.of<GetDashboardExpiredDataProvider>(context,
                          listen: false)
                      .docName
                      .isEmpty
                  ? const SizedBox()
                  : _displayDocumentExpirationCard(),
              _displayTop5NotificationCard()
            ],
          );
  }

  _displayTop5NotificationCard() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  'Recent 5 notifications from employer',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
              ),
              const Divider(
                thickness: 0.2,
                color: kblackPrimaryColor,
              ),
              Provider.of<GetDashboardNotificationProvider>(context,
                          listen: false)
                      .notificationCompanyName
                      .isEmpty
                  ? const Text('There are no recent notifications')
                  : SizedBox(
                      height: checkDeviceSize(context)
                          ? MediaQuery.of(context).size.height * 0.23
                          : MediaQuery.of(context).size.height * 0.235,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            Provider.of<GetDashboardNotificationProvider>(
                                    context,
                                    listen: false)
                                .notificationCompanyName
                                .length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.grey[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _displaystatictext(
                                      'Company Name',
                                      Provider.of<GetDashboardNotificationProvider>(
                                              context,
                                              listen: false)
                                          .notificationCompanyName[index],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    _displaystatictext(
                                        'Subject',
                                        Provider.of<GetDashboardNotificationProvider>(
                                                context,
                                                listen: false)
                                            .notificationSubject[index]),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    _displaystatictext(
                                        'Notification Date',
                                        Provider.of<GetDashboardNotificationProvider>(
                                                context,
                                                listen: false)
                                            .notificationDate[index]),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  _displayActiveToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Text(
            'Are you Available or On Board?',
            style: TextStyle(
                fontSize: checkDeviceSize(context)
                    ? MediaQuery.of(context).size.width * 0.035
                    : MediaQuery.of(context).size.width * 0.03,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 10,
          ),
          StreamBuilder(
            stream: _switchButtonBloc.stateSwitchButtonStrean,
            builder: (context, snapshot) {
              if (!_hasChanged) {
                if (Provider.of<GetDashboardCountDataProvider>(context,
                        listen: false)
                    .isAvailable) {
                  _switchButtonBloc.eventSwitchButtonSink
                      .add(SwitchButtonAction.True);
                  _hasChanged = true;
                }
              }

              return FlutterSwitch(
                  height: 25,
                  width: checkDeviceSize(context)
                      ? MediaQuery.of(context).size.height * 0.145
                      : MediaQuery.of(context).size.height * 0.14,
                  value: snapshot.hasData
                      ? _switchButtonBloc.switchValue
                      : Provider.of<GetDashboardCountDataProvider>(context,
                              listen: false)
                          .isAvailable,
                  activeText: 'Available',
                  activeColor: kBluePrimaryColor,
                  activeTextColor: kbackgroundColor,
                  inactiveText: 'On Board',
                  showOnOff: true,
                  onToggle: (val) {
                    showConfirmationDialog(val);
                  });
            },
          )
        ],
      ),
    );
  }

  void showConfirmationDialog(bool val) {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: const Text(
            'Availability Status',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            val
                ? 'You will now be visible as Available to the employers. Are you sure you want to proceed?'
                : 'You will now be visible as On board to the employers. Are you sure you want to proceed?',
            style: const TextStyle(color: Colors.black),
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
                    child: const Text("Yes"),
                    onPressed: () {
                      callChangeAvailability(val);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  color: kbackgroundColor,
                  //width: double.maxFinite,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: bluebuttonStyle(),
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
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

  void callChangeAvailability(bool val) async {
    DashboardStatusProvider dashboardStatusProvider =
        Provider.of<DashboardStatusProvider>(context, listen: false);
    if (!await dashboardStatusProvider.callPostDashboardStatusapi(
        val ? '1' : '0', header)) {
      if (dashboardStatusProvider.checkJobPref) {
        displaysnackbar(
            'Please fill up the job preference section in resume builder to access this feature.');
      } else {
        displaysnackbar('Something went wrong');
      }
    } else {
      if (val) {
        _switchButtonBloc.eventSwitchButtonSink.add(SwitchButtonAction.True);
      } else {
        _switchButtonBloc.eventSwitchButtonSink.add(SwitchButtonAction.False);
      }
    }
  }
}
