// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Profile/UserDetailsProvider.dart';
import '../../SideBar/SideBar.dart';
import '../../asynccallprovider.dart';
import '../../bottomnavigation.dart';
import '../../constants.dart';
import '../Header.dart';
import '../PreviousEmployeeReference.dart/PreviousEmployee.dart';
import '../PreviousEmployeeReference.dart/PreviousEmplyeeProvider.dart';
import 'EditSeaServiceRecord.dart';
import 'SeaServiceProvider.dart';

class SeaServiceRecord extends StatefulWidget {
  const SeaServiceRecord({Key? key}) : super(key: key);

  @override
  _SeaServiceRecordState createState() => _SeaServiceRecordState();
}

class _SeaServiceRecordState extends State<SeaServiceRecord> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: const Color(0xFFF4F5FD),
      bottomNavigationBar: BottomNavigationClass(3),
      drawer: Drawer(
          child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.57,
              child: const Sidebar())),
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
              ResumeHeader('Sea Service Record', 4, false, _scaffoldkey),
              _displaySeaServiceCard(),
              _displayDurationCard(),
            ],
          ),
        ),
      ),
    );
  }

  _displaySeaServiceCard() {
    return Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall
        ? const SizedBox()
        : Padding(
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
                    _displaycardheader('Sea Service Record', true),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Provider.of<ResumeSeaServiceProvider>(context,
                                listen: false)
                            .vesselId
                            .isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: 'No document added. Click ',
                                  style: TextStyle(
                                      color: kblackPrimaryColor,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.038)),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // AsyncCallProvider _asyncProvider =
                                    //     Provider.of<AsyncCallProvider>(context,
                                    //         listen: false);
                                    // _asyncProvider.changeAsynccall();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const EditSeaServiceRecord()));
                                  },
                                text: 'here',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kBluePrimaryColor,
                                    decoration: TextDecoration.underline,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.038),
                              ),
                              TextSpan(
                                  text: ' to add document.',
                                  style: TextStyle(
                                      color: kblackPrimaryColor,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.038)),
                            ])),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: Provider.of<ResumeSeaServiceProvider>(
                                      context,
                                      listen: false)
                                  .vessel_name
                                  .length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _displaySeaServiceData(index),
                                      index ==
                                              Provider.of<ResumeSeaServiceProvider>(
                                                          context,
                                                          listen: false)
                                                      .vessel_name
                                                      .length -
                                                  1
                                          ? const SizedBox()
                                          : const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4, vertical: 6),
                                              child: Divider(
                                                thickness: 0.5,
                                                color: Colors.grey,
                                              ),
                                            ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
  }

  _displaycardheader(String s, bool isEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Text(s,
                style: TextStyle(
                    color: kBluePrimaryColor,
                    fontSize: checkDeviceSize(context)
                        ? MediaQuery.of(context).size.width * 0.05
                        : MediaQuery.of(context).size.width * 0.045,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            width: 10,
          ),
          const Spacer(),
          isEdit
              ? InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EditSeaServiceRecord())),
                  child: Text(
                      Provider.of<ResumeSeaServiceProvider>(context,
                                  listen: false)
                              .vesselId
                              .isEmpty
                          ? 'Add'
                          : 'Edit',
                      style: TextStyle(
                          color: kgreenPrimaryColor,
                          fontSize: checkDeviceSize(context)
                              ? MediaQuery.of(context).size.width * 0.042
                              : MediaQuery.of(context).size.width * 0.037,
                          fontWeight: FontWeight.bold)),
                )
              : Container()
        ],
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
            fontWeight: FontWeight.w600,
            fontSize: checkDeviceSize(context)
                ? MediaQuery.of(context).size.width * 0.04
                : MediaQuery.of(context).size.width * 0.035,
          ),
        ),
        Text(
          text,
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

  _displaySeaServiceData(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _displaystatictext(
            'Vessel Name',
            Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                .vessel_name[index]),
        const SizedBox(
          height: 8,
        ),
        _displaystatictext(
            'Company Name',
            Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                .companyName[index]),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.46,
              child: _displaystatictext(
                  'IMO Number',
                  Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                      .imo_number[index]),
            ),
            _displaystatictext(
                'Gross Tonage',
                Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                    .gross_tonnage[index]),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.46,
              child: _displaystatictext(
                  'Ranks',
                  Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                      .rank_name[index]),
            ),
            _displaystatictext(
                'Vessel Type',
                Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                    .vesselTypeName[index]),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.46,
              child: _displaystatictext(
                  'Sign on date',
                  Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                      .signondate[index]),
            ),
            _displaystatictext(
                'Sign off date',
                Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                    .signoffdate[index]),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                .engine_name[index]
                .isEmpty
            ? const SizedBox(
                height: 0,
              )
            : _displaystatictext(
                'Engine Name',
                Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                    .engine_name[index]),
      ],
    );
  }

  void getdata() async {
    bool isRedirect = false;
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const SeaServiceRecord(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    if (prefs.getString('DeleteSuccesful') != null) {
      displaysnackbar(prefs.getString('DeleteSuccesful') ?? '');
      prefs.remove('DeleteSuccesful');
    }
    if (prefs.getString('RecordAdded') != null) {
      displaysnackbar(prefs.getString('RecordAdded') ?? '');
      prefs.remove('RecordAdded');
      if (checkNavigation()) {
        isRedirect = true;
        Future.delayed(const Duration(seconds: 1)).then((value) =>
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const PreviousEmployeeReference())));
      }
    }

    if (!isRedirect) {
      AsyncCallProvider asyncProvider =
          Provider.of<AsyncCallProvider>(context, listen: false);
      if (!Provider.of<AsyncCallProvider>(context, listen: false)
          .isinasynccall) {
        asyncProvider.changeAsynccall();
      }
      ResumeSeaServiceProvider getResumeSeaServiceProvider =
          Provider.of<ResumeSeaServiceProvider>(context, listen: false);
      if (!await getResumeSeaServiceProvider.callgetSeaServiceapi(header,
          Provider.of<UserDetailsProvider>(context, listen: false).userid)) {
        displaysnackbar('Something went wrong');
      }
      asyncProvider.changeAsynccall();
    }
  }

  bool checkNavigation() {
    if (Provider.of<ResumeSeaServiceProvider>(context, listen: false)
            .isComplete &&
        !Provider.of<ResumeEmployerProvider>(context, listen: false)
            .isComplete) {
      return true;
    } else {
      return false;
    }
  }

  _displayDurationCard() {
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
              _displaycardheader('Sea Time Experience', false),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
              ),
              Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                      .durationRankName
                      .isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('No record found'),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: Provider.of<ResumeSeaServiceProvider>(
                                context,
                                listen: false)
                            .durationRankName
                            .length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                _displaystatictext(
                                    'Rank Name',
                                    Provider.of<ResumeSeaServiceProvider>(
                                            context,
                                            listen: false)
                                        .durationRankName[index]),
                                const Spacer(),
                                _displaystatictext(
                                    'Duration',
                                    Provider.of<ResumeSeaServiceProvider>(
                                            context,
                                            listen: false)
                                        .duration[index]),
                              ],
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
}
