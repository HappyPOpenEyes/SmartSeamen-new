// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartseaman/SideBar/SideBar.dart';
import '../../asynccallprovider.dart';
import '../../bottomnavigation.dart';
import '../../constants.dart';
import '../Header.dart';
import '../SeaServiceRecord/SeaServiceProvider.dart';
import '../SeaServiceRecord/SeaServiceRecord.dart';
import 'DangerousCargoProvider.dart';
import 'EditDangerousCargo.dart';

class DangerousCargo extends StatefulWidget {
  const DangerousCargo({Key? key}) : super(key: key);

  @override
  _DangerousCargoState createState() => _DangerousCargoState();
}

class _DangerousCargoState extends State<DangerousCargo> {
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
              child: Sidebar())),
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
              ResumeHeader(
                  'Dangerous Cargo Endorsements', 3, false, _scaffoldkey),
              _displayDangerousCard(),
            ],
          ),
        ),
      ),
    );
  }

  _displayDangerousCard() {
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
              _displaycardheader('Dangerous Cargo Endorsements'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Provider.of<ResumeDangerousCargoProvider>(context)
                      .issuingAuthorityName
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
                                    MediaQuery.of(context).size.width * 0.038)),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // AsyncCallProvider _asyncProvider =
                              //     Provider.of<AsyncCallProvider>(context,
                              //         listen: false);
                              // _asyncProvider.changeAsynccall();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditDangerousCargo()));
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
                            text: ' to add document.',
                            style: TextStyle(
                                color: kblackPrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038)),
                      ])),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              Provider.of<ResumeDangerousCargoProvider>(context)
                                  .issuingAuthorityName
                                  .length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _displayCardData(
                                    Provider.of<ResumeDangerousCargoProvider>(
                                            context)
                                        .docStaticName[index],
                                    index),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  _displaycardheader(String s) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: checkDeviceSize(context)
                ? MediaQuery.of(context).size.width * 0.68
                : MediaQuery.of(context).size.width * 0.745,
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
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditDangerousCargo()));
            },
            child: Text(
                Provider.of<ResumeDangerousCargoProvider>(context)
                        .issuingAuthorityName
                        .isEmpty
                    ? 'Add'
                    : 'Edit',
                style: TextStyle(
                    color: kgreenPrimaryColor,
                    fontSize: checkDeviceSize(context)
                        ? MediaQuery.of(context).size.width * 0.045
                        : MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  _displaySubHeading(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text(
            category,
            style: TextStyle(
              color: kBluePrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: checkDeviceSize(context)
                  ? MediaQuery.of(context).size.width * 0.042
                  : MediaQuery.of(context).size.width * 0.037,
            ),
          )
        ],
      ),
    );
  }

  _displayDangerousData(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _displaystatictext(
            'Issuing Authority',
            Provider.of<ResumeDangerousCargoProvider>(context)
                    .issuingAuthorityName[index]
                    .isEmpty
                ? '-'
                : Provider.of<ResumeDangerousCargoProvider>(context)
                    .issuingAuthorityName[index]),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.44,
              child: _displaystatictext(
                  'Issue Date',
                  Provider.of<ResumeDangerousCargoProvider>(context)
                      .issueDate[index]),
            ),
            _displaystatictext(
                'Expiry Date',
                Provider.of<ResumeDangerousCargoProvider>(context)
                        .validTillType[index]
                        .isEmpty
                    ? Provider.of<ResumeDangerousCargoProvider>(context)
                        .expiryDate[index]
                    : Provider.of<ResumeDangerousCargoProvider>(context)
                        .validTillType[index]),
          ],
        ),
      ],
    );
  }

  _displaystatictext(String label, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
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
                  : MediaQuery.of(context).size.width * 0.032,
            ),
          ),
        ],
      ),
    );
  }

  _displayCardData(String category, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _displaySubHeading(category),
        const SizedBox(
          height: 5,
        ),
        _displayDangerousData(index),
        index + 1 ==
                Provider.of<ResumeDangerousCargoProvider>(context)
                    .issuingAuthorityName
                    .length
            ? const SizedBox()
            : const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Divider(
                  thickness: 0.25,
                  color: Colors.grey,
                ),
              ),
      ],
    );
  }

  void getdata() async {
    bool isRedirect = false;
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const DangerousCargo(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    if (prefs.getString('DangeousCargoUpdateSuccess') != null) {
      displaysnackbar(prefs.getString('DangeousCargoUpdateSuccess') ?? '');
      prefs.remove('DangeousCargoUpdateSuccess');
      if (checkNavigation()) {
        isRedirect = true;
        Future.delayed(const Duration(seconds: 1)).then((value) =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SeaServiceRecord())));
      }
    }
    if (!isRedirect) {
      AsyncCallProvider asyncProvider =
          Provider.of<AsyncCallProvider>(context, listen: false);
      if (!Provider.of<AsyncCallProvider>(context, listen: false)
          .isinasynccall) {
        asyncProvider.changeAsynccall();
      }
      ResumeDangerousCargoProvider getResumeDangerousProvider =
          Provider.of<ResumeDangerousCargoProvider>(context, listen: false);
      if (!await getResumeDangerousProvider.callgetDangerousCargoapi(header)) {
        displaysnackbar('Something went wrong');
      }
      asyncProvider.changeAsynccall();
    }
  }

  bool checkNavigation() {
    if (Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
            .isComplete &&
        !Provider.of<ResumeSeaServiceProvider>(context, listen: false)
            .isComplete) {
      return true;
    } else {
      return false;
    }
  }
}
