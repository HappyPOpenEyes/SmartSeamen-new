// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Dashboard/Dashboard.dart';
import '../Dashboard/DashboardHeader.dart';
import '../GreenBullet.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'package:intl/intl.dart';
import 'ReferJobProvider.dart';

class JobPreview extends StatefulWidget {
  const JobPreview({Key? key}) : super(key: key);

  @override
  _JobPreviewState createState() => _JobPreviewState();
}

class _JobPreviewState extends State<JobPreview> {
  String tentativeJoiningDate = "",
      nationality = "",
      description = "",
      deckRankDetail = "",
      engineRankDetail = "",
      cookRankDetail = "",
      vesselType = "",
      companyName = "";
  var header;
  final List<String> _labelList = ["Tentaive Joining", "Nationality"];
  static final DateFormat formatter = DateFormat('dd MMMM, yyyy');

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
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(
            backgroundColor: kbackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(
                isDashboard: false,
                isEdit: true,
                isPayment: false,
                scaffoldKey: null,
              ),
              const SizedBox(
                height: 2,
              ),
              _displayJOBS(),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    callPostJobAPI();
                  },
                  style: buttonStyle(),
                  child: const Text(
                    'Post Job',
                    style: TextStyle(color: kbackgroundColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _displayCompanyName() {
    return Container(
      color: kbackgroundColor,
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.14,
            height: MediaQuery.of(context).size.width * 0.14,
            decoration: const ShapeDecoration(
                shape: CircleBorder(), color: Colors.white),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/user.jpg'))),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            child: Text(
              companyName,
              style: TextStyle(
                  color: kBluePrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.045),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  _displayCardData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _labelList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.38,
                              child: _displayLabel(
                                  index == 0
                                      ? Icons.calendar_today
                                      : Icons.flag,
                                  _labelList[index]),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.48,
                              child: Text(
                                index == 0 ? tentativeJoiningDate : nationality,
                                style: TextStyle(
                                  fontSize: checkDeviceSize(context)
                                      ? MediaQuery.of(context).size.width *
                                          0.035
                                      : MediaQuery.of(context).size.width *
                                          0.038,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
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

  _displayLabel(IconData calendarToday, String s) {
    return Padding(
      padding: s == _labelList[1]
          ? const EdgeInsets.only(bottom: 0.0)
          : const EdgeInsets.only(bottom: 0.0),
      child: Row(
        children: [
          Icon(
            calendarToday,
            size: checkDeviceSize(context)
                ? MediaQuery.of(context).size.width * 0.045
                : MediaQuery.of(context).size.width * 0.04,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            s,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void getdata() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const JobPreview(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      header = prefs.getString('header');
      tentativeJoiningDate =
          formatter.format(DateTime.parse(prefs.getString('Expiration') ?? ''));
      nationality = prefs.getString('Nationalities') ?? '';
      deckRankDetail = prefs.getString('DeckRanks') ?? '';
      engineRankDetail = prefs.getString('EngineRanks') ?? '';
      cookRankDetail = prefs.getString('CookRanks') ?? '';
      vesselType = prefs.getString('Vessel') ?? '';
      companyName = prefs.getString('CompanyName') ?? '';
    });

    prefs.remove('Expiration');
    prefs.remove('Nationalities');
    prefs.remove('DeckRanks');
    prefs.remove('CookRanks');
    prefs.remove('EngineRanks');
    prefs.remove('Vessel');
    prefs.remove('CompanyName');
  }

  _displayRankData() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    'Ranks',
                    style: TextStyle(
                        color: kBluePrimaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              deckRankDetail.isEmpty ? Container() : _displaySubRankData(0),
              engineRankDetail.isEmpty ? Container() : _displaySubRankData(1),
              cookRankDetail.isEmpty ? Container() : _displaySubRankData(2)
            ],
          ),
        ),
      ),
    );
  }

  _displaySubRankData(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Card(
        elevation: 3,
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                index == 0
                    ? 'Deck'
                    : index == 1
                        ? 'Engine'
                        : 'Galley',
                style: const TextStyle(
                    color: kblackPrimaryColor, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: GreenBullet(),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Text(
                            index == 0
                                ? deckRankDetail
                                : index == 1
                                    ? engineRankDetail
                                    : cookRankDetail,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displayVesselData() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vessel Types',
                style: TextStyle(
                    color: kBluePrimaryColor, fontWeight: FontWeight.bold),
              ),
              _displayVesselTypes(),
            ],
          ),
        ),
      ),
    );
  }

  _displayVesselTypes() {
    List<Widget> vesselTypeList = [];

    vesselTypeList.add(Wrap(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: GreenBullet(),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(vesselType),
        const SizedBox(
          width: 25,
        ),
      ],
    ));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Wrap(
          children: vesselTypeList,
        ),
      ),
    );
  }

  _displayJobDetailData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _displayCompanyName(),
        const SizedBox(
          height: 5,
        ),
        Provider.of<AsyncCallProvider>(context).isinasynccall
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _displayCardData(),
                  _displayRankData(),
                  _displayVesselData(),
                ],
              )
      ],
    );
  }

  _displayJOBS() {
    return Container(child: _displayJobDetailData());
  }

  void callPostJobAPI() async {
    AsyncCallProvider asyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!asyncCallProvider.isinasynccall) {
      asyncCallProvider.changeAsynccall();
    }

    PostReferJobProvider referJobPost =
        Provider.of<PostReferJobProvider>(context, listen: false);
    if (!await referJobPost.callPostReferJobapi(header)) {
      displaysnackbar('Something went wrong');
    } else {
      displaysnackbar('Job Posted Successfully');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('ReferJob', 'Your job has been posted');
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Dashboard()));
    }

    asyncCallProvider.changeAsynccall();
  }
}
