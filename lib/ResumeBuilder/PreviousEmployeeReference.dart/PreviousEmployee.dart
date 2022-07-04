// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../SideBar/SideBar.dart';
import '../../asynccallprovider.dart';
import '../../bottomnavigation.dart';
import '../../constants.dart';
import '../Header.dart';
import 'EditPerviousEmployer.dart';
import 'PreviousEmplyeeProvider.dart';

class PreviousEmployeeReference extends StatefulWidget {
  const PreviousEmployeeReference({Key? key}) : super(key: key);

  @override
  _PreviousEmployeeReferenceState createState() =>
      _PreviousEmployeeReferenceState();
}

class _PreviousEmployeeReferenceState extends State<PreviousEmployeeReference> {
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
              ResumeHeader(
                  'Previous Employer Reference', 5, false, _scaffoldkey),
              const SizedBox(
                height: 5,
              ),
              _displayPreviousEmployerData(),
            ],
          ),
        ),
      ),
    );
  }

  _displayPreviousEmployerData() {
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
              _displaycardheader('Previous Employer Reference'),
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
              Provider.of<ResumeEmployerProvider>(context, listen: false)
                      .companyName
                      .isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'No employer added. Click ',
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
                                      const EditPreviousEmployer()));
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
                            text: ' to add employer.',
                            style: TextStyle(
                                color: kblackPrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038)),
                      ])),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: Provider.of<ResumeEmployerProvider>(
                                    context,
                                    listen: false)
                                .companyName
                                .length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _displaySubHeading(
                                        Provider.of<ResumeEmployerProvider>(
                                                context,
                                                listen: false)
                                            .companyName[index]),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    _displayPreviousData(index),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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
                ? MediaQuery.of(context).size.width * 0.65
                : MediaQuery.of(context).size.width * 0.75,
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
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EditPreviousEmployer())),
            child: Text(
                Provider.of<ResumeEmployerProvider>(context, listen: false)
                        .companyName
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
        ],
      ),
    );
  }

  _displaySubHeading(String category) {
    return Wrap(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            category,
            style: TextStyle(
              color: kgreenPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: checkDeviceSize(context)
                  ? MediaQuery.of(context).size.width * 0.045
                  : MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        )
      ],
    );
  }

  _displayPreviousData(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.44,
              child: _displaystatictext(
                  'Contact Person',
                  Provider.of<ResumeEmployerProvider>(context, listen: false)
                      .contactPersonName[index]),
            ),
            _displaystatictext(
                'Contact Number',
                Provider.of<ResumeEmployerProvider>(context, listen: false)
                    .contactNumber[index]),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        index + 1 ==
                Provider.of<ResumeEmployerProvider>(context, listen: false)
                    .companyName
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
                : MediaQuery.of(context).size.width * 0.032,
          ),
        ),
      ],
    );
  }

  void getdata() async {
    bool result = await checkConnectivity();
    if (result)
      callNoInternetScreen(const PreviousEmployeeReference(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    ResumeEmployerProvider resumeEmployerProvider =
        Provider.of<ResumeEmployerProvider>(context, listen: false);
    if (!await resumeEmployerProvider.callgetSeaServiceapi(header)) {
      displaysnackbar('Something went wrong.');
    }
    asyncProvider.changeAsynccall();
  }
}
