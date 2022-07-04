// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../RadioButtonBloc.dart';
import '../../SideBar/SideBar.dart';
import '../../VerifiedContainer.dart';
import '../../asynccallprovider.dart';
import '../../bottomnavigation.dart';
import '../../constants.dart';
import '../Documents/DocumentScreen.dart';
import '../Documents/DocumentScreenProvider.dart';
import '../GetValidTypeProvider.dart';
import '../Header.dart';
import '../ShowDrawerBloc.dart';
import 'AdressEdit.dart';
import 'GetResumeProvider.dart';
import 'JobPreferencesEdit.dart';
import 'PersonalInfoEdit.dart';

class ResumeBuilder extends StatefulWidget {
  const ResumeBuilder({Key? key}) : super(key: key);

  @override
  _ResumeBuilderState createState() => _ResumeBuilderState();
}

class _ResumeBuilderState extends State<ResumeBuilder> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  int displayprogesscounter = 0;
  final _radioBloc = RadioButtonBloc();
  final _showDrawerBloc = ShowDrawerBloc();

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  void dispose() {
    _radioBloc.dispose();
    _showDrawerBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FD),
      key: _scaffoldkey,
      drawer: Drawer(
          child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.57,
              child: const Sidebar())),
      bottomNavigationBar: BottomNavigationClass(3),
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<AsyncCallProvider>(context).isinasynccall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(
            backgroundColor: kbackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const DocumentScreen()));
            }

            // Swiping in left direction.
            if (details.delta.dx < 0) {}
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ResumeHeader('Personal Information', 1, false, _scaffoldkey),
                _buildPersonalInfoCard(),
                _buildJobPreferencesCard(),
                _buildPermanentAddressCard(),
                _buildCommunicationAddressCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildPersonalInfoCard() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Card(
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                _displaycardheader('Personal Information', 0),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: _displaystatictext(
                            'First Name',
                            Provider.of<GetResumeProvider>(context,
                                        listen: false)
                                    .fname
                                    .isEmpty
                                ? "-"
                                : Provider.of<GetResumeProvider>(context,
                                        listen: false)
                                    .fname,
                            false),
                      ),
                      _displaystatictext(
                          'Last Name',
                          Provider.of<GetResumeProvider>(context, listen: false)
                                  .lname
                                  .isEmpty
                              ? "-"
                              : Provider.of<GetResumeProvider>(context,
                                      listen: false)
                                  .lname,
                          false),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        _displaystatictext(
                            'Email',
                            Provider.of<GetResumeProvider>(context,
                                        listen: false)
                                    .email
                                    .isEmpty
                                ? "-"
                                : Provider.of<GetResumeProvider>(context,
                                        listen: false)
                                    .email,
                            true),
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: Row(
                          children: [
                            _displaystatictext(
                                'Phone',
                                Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .phonenumber
                                        .isEmpty
                                    ? "-"
                                    : Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .phonenumber,
                                true),
                          ],
                        ),
                      ),
                      Provider.of<GetResumeProvider>(context, listen: false)
                                  .alternatephonenumber ==
                              "null"
                          ? const SizedBox()
                          : Row(
                              children: [
                                _displaystatictext(
                                    'Alternate Phone',
                                    Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .alternatephonenumber,
                                    false)
                              ],
                            ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Provider.of<GetResumeProvider>(context, listen: false)
                        .dob
                        .isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            _displaystatictext(
                                'Dob',
                                Provider.of<GetResumeProvider>(context,
                                        listen: false)
                                    .dob,
                                false),
                          ],
                        )),
              ]),
            )));
  }

  _displaycardheader(String s, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text(s,
              style: TextStyle(
                  color: kBluePrimaryColor,
                  fontSize: checkDeviceSize(context)
                      ? MediaQuery.of(context).size.width * 0.05
                      : MediaQuery.of(context).size.width * 0.045,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            width: 10,
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              if (index == 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PersonalInfoEdit()));
              } else if (index == 1) {
                // AsyncCallProvider _asyncProvider =
                //     Provider.of<AsyncCallProvider>(context, listen: false);
                // _asyncProvider.changeAsynccall();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const JobPreferencesEdit()));
              } else if (index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditAdress(0)));
              } else if (index == 3) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditAdress(1)));
              }
            },
            child: displayAddEditText(index),
          )
        ],
      ),
    );
  }

  _displaystatictext(String label, String text, bool showVerified) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            const SizedBox(
              width: 10,
            ),
            showVerified
                ? VerifiedContainer(
                    width: MediaQuery.of(context).size.width * 0.06,
                    height: MediaQuery.of(context).size.height * 0.03,
                  )
                : Container()
          ],
        ),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: checkDeviceSize(context)
                ? MediaQuery.of(context).size.width * 0.038
                : MediaQuery.of(context).size.width * 0.032,
          ),
        ),
      ],
    );
  }

  _buildJobPreferencesCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
              _displaycardheader('Job Preferences', 1),
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
              Provider.of<GetResumeProvider>(context, listen: false)
                      .rankName
                      .isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'No Job Preferences added. Click ',
                            style: TextStyle(
                                color: kblackPrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038)),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // AsyncCallProvider _asyncProvider =
                              //     Provider.of<AsyncCallProvider>(context,
                              //         listen: false);
                              // _asyncProvider.changeAsynccall();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const JobPreferencesEdit()));
                            },
                          text: 'here',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kBluePrimaryColor,
                              decoration: TextDecoration.underline,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.038),
                        ),
                        TextSpan(
                            text: ' to add job preferences.',
                            style: TextStyle(
                                color: kblackPrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038)),
                      ])),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _displaystatictext(
                                'Looking for Promotion?',
                                Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .lookingPromotion
                                        .isEmpty
                                    ? "-"
                                    : Provider.of<GetResumeProvider>(context,
                                                    listen: false)
                                                .lookingPromotion ==
                                            "1"
                                        ? 'Yes'
                                        : 'No',
                                false)),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _displaystatictext(
                                'Application for the rank',
                                Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .rankName
                                        .isEmpty
                                    ? "-"
                                    : Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .rankName,
                                false)),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _displaystatictext(
                                'Application for secondary rank',
                                Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .secondaryRank
                                        .isEmpty
                                    ? "-"
                                    : Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .secondaryRank,
                                false)),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _displaystatictext(
                                'Vessel Preferences',
                                Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .vesselType
                                        .isEmpty
                                    ? "-"
                                    : Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .vesselpreftext,
                                false)),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _displaystatictext(
                                'Tentative Available Date',
                                Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .tentativejoiningdate
                                        .isEmpty
                                    ? "-"
                                    : Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .tentativejoiningdate,
                                false)),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nationality',
                                style: TextStyle(
                                  color: kblackPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              _displayNationality(
                                Provider.of<GetResumeProvider>(context,
                                        listen: false)
                                    .nationality,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _buildPermanentAddressCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              _displaycardheader('Permanent Address', 2),
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
              Provider.of<GetResumeProvider>(context, listen: false)
                      .address1
                      .isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'No permanent address added. Click ',
                            style: TextStyle(
                                color: kblackPrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038)),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditAdress(0)));
                            },
                          text: 'here',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kBluePrimaryColor,
                              decoration: TextDecoration.underline,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.038),
                        ),
                        TextSpan(
                            text: ' to add permanent address.',
                            style: TextStyle(
                                color: kblackPrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038)),
                      ])),
                    )
                  : _displayaddressforms(0),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCommunicationAddressCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
              _displaycardheader('Communication Address', 3),
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
              Provider.of<GetResumeProvider>(context, listen: false)
                          .isCommunication ==
                      "null"
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Communication address not added. Click ',
                            style: TextStyle(
                                color: kblackPrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038)),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditAdress(1)));
                            },
                          text: 'here',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kBluePrimaryColor,
                              decoration: TextDecoration.underline,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.038),
                        ),
                        TextSpan(
                            text: ' to add communication address.',
                            style: TextStyle(
                                color: kblackPrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038)),
                      ])),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _displaystatictext(
                                'Same as permanent address?',
                                Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .isCommunication
                                        .isEmpty
                                    ? "-"
                                    : Provider.of<GetResumeProvider>(context,
                                                    listen: false)
                                                .isCommunication ==
                                            "0"
                                        ? "No"
                                        : "Yes",
                                false)),
                        const SizedBox(
                          height: 10,
                        ),
                        Provider.of<GetResumeProvider>(context, listen: false)
                                .isCommunication
                                .isEmpty
                            ? const SizedBox()
                            : Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .isCommunication ==
                                    "0"
                                ? Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .comaddress1
                                        .isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  'Communication address not added. Click ',
                                              style: TextStyle(
                                                  color: kblackPrimaryColor,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.038)),
                                          TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditAdress(1)));
                                              },
                                            text: 'here',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kBluePrimaryColor,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.038),
                                          ),
                                          TextSpan(
                                              text:
                                                  ' to add communication address.',
                                              style: TextStyle(
                                                  color: kblackPrimaryColor,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.038)),
                                        ])),
                                      )
                                    : _displayaddressforms(1)
                                : const SizedBox()
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displayaddressforms(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _displaystatictext(
                'Address 1',
                index == 0
                    ? Provider.of<GetResumeProvider>(context, listen: false)
                            .address1
                            .isEmpty
                        ? "-"
                        : Provider.of<GetResumeProvider>(context, listen: false)
                            .address1
                    : Provider.of<GetResumeProvider>(context, listen: false)
                            .comaddress1
                            .isEmpty
                        ? "-"
                        : Provider.of<GetResumeProvider>(context, listen: false)
                            .comaddress1,
                false)),
        const SizedBox(
          height: 10,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _displaystatictext(
                'Address 2',
                index == 0
                    ? Provider.of<GetResumeProvider>(context, listen: false)
                            .address2
                            .isEmpty
                        ? "-"
                        : Provider.of<GetResumeProvider>(context, listen: false)
                            .address2
                    : Provider.of<GetResumeProvider>(context, listen: false)
                            .comaddress2
                            .isEmpty
                        ? "-"
                        : Provider.of<GetResumeProvider>(context, listen: false)
                            .comaddress2,
                false)),
        const SizedBox(
          height: 10,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _displaystatictext(
                'Landmark',
                index == 0
                    ? Provider.of<GetResumeProvider>(context, listen: false)
                            .landmark
                            .isEmpty
                        ? "-"
                        : Provider.of<GetResumeProvider>(context, listen: false)
                            .landmark
                    : Provider.of<GetResumeProvider>(context, listen: false)
                            .comlandmark
                            .isEmpty
                        ? "-"
                        : Provider.of<GetResumeProvider>(context, listen: false)
                            .comlandmark,
                false)),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _displaystatictext(
                      'Country',
                      index == 0
                          ? Provider.of<GetResumeProvider>(context,
                                      listen: false)
                                  .adressCountry
                                  .isEmpty
                              ? "-"
                              : Provider.of<GetResumeProvider>(context,
                                      listen: false)
                                  .adressCountry
                          : Provider.of<GetResumeProvider>(context,
                                      listen: false)
                                  .comadressCountry
                                  .isEmpty
                              ? "-"
                              : Provider.of<GetResumeProvider>(context,
                                      listen: false)
                                  .comadressCountry,
                      false)),
            ),
            const SizedBox(
              width: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _displaystatictext(
                    'State',
                    index == 0
                        ? Provider.of<GetResumeProvider>(context, listen: false)
                                .state
                                .isEmpty
                            ? "-"
                            : Provider.of<GetResumeProvider>(context,
                                    listen: false)
                                .state
                        : Provider.of<GetResumeProvider>(context, listen: false)
                                .comstate
                                .isEmpty
                            ? "-"
                            : Provider.of<GetResumeProvider>(context,
                                    listen: false)
                                .comstate,
                    false)),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _displaystatictext(
                        'Pin Code',
                        index == 0
                            ? Provider.of<GetResumeProvider>(context,
                                        listen: false)
                                    .pincode
                                    .isEmpty
                                ? "-"
                                : Provider.of<GetResumeProvider>(context,
                                        listen: false)
                                    .pincode
                            : Provider.of<GetResumeProvider>(context,
                                        listen: false)
                                    .compincode
                                    .isEmpty
                                ? "-"
                                : Provider.of<GetResumeProvider>(context,
                                        listen: false)
                                    .compincode,
                        false))),
            const SizedBox(
              width: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _displaystatictext(
                    'City',
                    index == 0
                        ? Provider.of<GetResumeProvider>(context, listen: false)
                                .city
                                .isEmpty
                            ? "-"
                            : Provider.of<GetResumeProvider>(context,
                                    listen: false)
                                .city
                        : Provider.of<GetResumeProvider>(context, listen: false)
                                .comcity
                                .isEmpty
                            ? "-"
                            : Provider.of<GetResumeProvider>(context,
                                    listen: false)
                                .comcity,
                    false)),
          ],
        ),
      ],
    );
  }

  void getdata() async {
    var isRedirect = false;
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const ResumeBuilder(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    if (prefs.getString('ProfileUpdateSuccess') != null) {
      displaysnackbar(prefs.getString('ProfileUpdateSuccess') ?? '');
      prefs.remove('ProfileUpdateSuccess');
      if (checkNavigation()) {
        isRedirect = true;
        Future.delayed(const Duration(seconds: 1)).then((value) =>
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DocumentScreen())));
      }
    }
    if (prefs.getString('ResumeUpdateSuccess') != null) {
      displaysnackbar(prefs.getString('ResumeUpdateSuccess') ?? '');
      prefs.remove('ResumeUpdateSuccess');
      if (checkNavigation()) {
        isRedirect = true;
        Future.delayed(const Duration(seconds: 1)).then((value) =>
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DocumentScreen())));
      }
    }
    if (prefs.getString('AddressUpdateSuccess') != null) {
      displaysnackbar(prefs.getString('AddressUpdateSuccess') ?? '');
      prefs.remove('AddressUpdateSuccess');
      if (checkNavigation()) {
        isRedirect = true;
        Future.delayed(const Duration(seconds: 1)).then((value) =>
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DocumentScreen())));
      }
    }
    if (!isRedirect) {
      AsyncCallProvider asyncProvider =
          Provider.of<AsyncCallProvider>(context, listen: false);
      if (!Provider.of<AsyncCallProvider>(context, listen: false)
          .isinasynccall) {
        asyncProvider.changeAsynccall();
      }

      GetResumeProvider getResumeProvider =
          Provider.of<GetResumeProvider>(context, listen: false);
      if (!await getResumeProvider.callgetResumeapi(header)) {
        displaysnackbar('Something went wrong');
      }

      GetValidTypeProvider validProvider =
          Provider.of<GetValidTypeProvider>(context, listen: false);

      if (!await validProvider.callgetValidTypeapi(header)) {
        displaysnackbar('Something went wrong');
      }

      asyncProvider.changeAsynccall();
    }
  }

  displayAddEditText(int index) {
    return Text(
        index == 0
            ? 'Edit'
            : index == 1
                ? Provider.of<GetResumeProvider>(context, listen: false)
                        .rankName
                        .isEmpty
                    ? 'Add'
                    : 'Edit'
                : index == 2
                    ? Provider.of<GetResumeProvider>(context, listen: false)
                            .address1
                            .isEmpty
                        ? 'Add'
                        : 'Edit'
                    : Provider.of<GetResumeProvider>(context, listen: false)
                                .isCommunication ==
                            "null"
                        ? 'Add'
                        : 'Edit',
        style: TextStyle(
            color: kgreenPrimaryColor,
            fontSize: checkDeviceSize(context)
                ? MediaQuery.of(context).size.width * 0.045
                : MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.bold));
  }

  _displayNationality(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.of(context).size.width * 0.038,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Provider.of<GetResumeProvider>(context, listen: false)
                .indosno
                .isNotEmpty
            ? Text(
                '(Indos No: ${Provider.of<GetResumeProvider>(context, listen: false).indosno})')
            : const SizedBox()
      ],
    );
  }

  bool checkNavigation() {
    if (Provider.of<GetResumeProvider>(context, listen: false).isComplete &&
        !Provider.of<ResumeDocumentProvider>(context, listen: false)
            .isComplete) {
      return true;
    } else {
      return false;
    }
  }
}
