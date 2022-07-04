// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartseaman/LoginScreen/UserDataProvider.dart';
import 'package:smartseaman/ResumeBuilder/Documents/DocumentScreen.dart';

import '../MenuHeader.dart';
import '../Profile/UserDetailsProvider.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'DangerousCargoEndorsment/DangerourCargo.dart';
import 'DangerousCargoEndorsment/DangerousCargoProvider.dart';
import 'Documents/DocumentScreenProvider.dart';
import 'GeneratePDFProvider.dart';
import 'PersonalInformation/GetResumeProvider.dart';
import 'PersonalInformation/ResumeBuilder.dart';
import 'PreviousEmployeeReference.dart/PreviousEmployee.dart';
import 'PreviousEmployeeReference.dart/PreviousEmplyeeProvider.dart';
import 'PublishResumeProvider.dart';
import 'SeaServiceRecord/SeaServiceProvider.dart';
import 'SeaServiceRecord/SeaServiceRecord.dart';

class ResumeHeader extends StatefulWidget {
  late String text;
  late int index;
  late bool _isedit;
  var scaffoldKey;

  ResumeHeader(this.text, this.index, isedit, bloc, {super.key}) {
    _isedit = isedit;
    scaffoldKey = bloc;
  }

  @override
  _ResumeHeaderState createState() => _ResumeHeaderState();
}

class _ResumeHeaderState extends State<ResumeHeader> {
  bool disclaimerValue = false;
  bool isPersonal = false,
      isDangerous = false,
      isDocument = false,
      isSeaService = false,
      isEmployer = false;

  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: kbackgroundColor,
        child: Column(
          children: [
            MenuHeader(
              isJobDetail: widget._isedit,
              isPayment: false,
              scaffoldKey: widget.scaffoldKey,
              isProfile: false,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resume Builder',
                        style: TextStyle(
                            color: kBluePrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: checkDeviceSize(context)
                                ? MediaQuery.of(context).size.width * 0.05
                                : MediaQuery.of(context).size.width * 0.045),
                      ),
                      _showDownloadResumeButton(context),
                    ],
                  ),
                  const Spacer(),
                  _showPublishUnPublishButton(context)
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
              child: Divider(
                thickness: 0.4,
                color: Colors.grey,
              ),
            ),
            _buildProgressBar(context),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  _buildProgressBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(
                  widget.text,
                  style: TextStyle(
                      fontSize: checkDeviceSize(context)
                          ? MediaQuery.of(context).size.width * 0.045
                          : MediaQuery.of(context).size.width * 0.04,
                      color: kBluePrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${widget.index} / 5',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.036,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.012,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _displayprogressbuttons(isPersonal, context, 0),
                _displayprogressbuttons(isDocument, context, 1),
                _displayprogressbuttons(isDangerous, context, 2),
                _displayprogressbuttons(isSeaService, context, 3),
                _displayprogressbuttons(isEmployer, context, 4),
              ],
            ),
          )
        ],
      ),
    );
  }

  _displayprogressbuttons(bool value, BuildContext context, int tab) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (widget.index != 1 && tab == 0) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const ResumeBuilder()));
            } else if (widget.index != 2 && tab == 1) {
              if (Provider.of<GetResumeProvider>(context, listen: false)
                  .rankName
                  .isEmpty) {
                _displayRankAlert(context);
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const DocumentScreen()));
              }
            } else if (widget.index != 3 && tab == 2) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const DangerousCargo()));
            } else if (widget.index != 4 && tab == 3) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const SeaServiceRecord()));
            } else if (widget.index != 5 && tab == 4) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const PreviousEmployeeReference()));
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.158,
            height: MediaQuery.of(context).size.width * 0.025,
            decoration: BoxDecoration(
                color: tab + 1 == widget.index
                    ? kBluePrimaryColor
                    : value
                        ? kgreenPrimaryColor
                        : Colors.grey,
                border: Border.all(
                  color: value ? kgreenPrimaryColor : Colors.grey,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.022,
        ),
      ],
    );
  }

  void _displayRankAlert(BuildContext context) {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: const Text('Rank not selected!',
              style: TextStyle(color: Colors.black)),
          content: const Text(
              'Please select the rank in job preferences to move to Documents tab.',
              style: TextStyle(color: Colors.black)),
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

  _showPublishUnPublishButton(BuildContext context) {
    bool isPublished = false;
    if (isPersonal &&
        isDocument &&
        isDangerous &&
        isSeaService) isPublished = true;
    return ElevatedButton(
      style: bluebuttonStyle(),
      onPressed: () {
        if (Provider.of<GetResumeProvider>(context, listen: false)
            .isResumePublished) {
          _showIncompleteDialog(
              context,
              'Unpublish Resume',
              'Once you publish your resume, it will not be visible to employers. Are you sure you want to unpublish?',
              'Unpublish');
        } else {
          if (!isPublished) {
            _showIncompleteDialog(
                context,
                'Publish Resume',
                'Please complete all the tabs to publish the resume',
                'Incomplete');
          } else {
            _showIncompleteDialog(
                context,
                'Publish Resume',
                'Once you publish your resume, it will be visible to employers. Are you sure you want to publish?',
                'Complete');
          }
        }
      },
      child: Text(
        Provider.of<GetResumeProvider>(context, listen: false).isResumePublished
            ? 'Unpublish Resume'
            : 'Publish Resume',
        style: const TextStyle(color: kbackgroundColor),
      ),
    );
  }

  void _showIncompleteDialog(
      BuildContext context, String label, String text, String action) {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: Text(label, style: const TextStyle(color: Colors.black)),
          content: Text(text, style: const TextStyle(color: Colors.black)),
          actions: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    action == "Incomplete"
                        ? const SizedBox()
                        : Container(
                            color: kbackgroundColor,
                            //width: double.maxFinite,
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                style: buttonStyle(),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: kbackgroundColor),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  action == "Complete"
                                      ? publishResume(context, 1)
                                      : publishResume(context, 0);
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
                        style: bluebuttonStyle(),
                        child: Text(action == "Incomplete" ? "OK" : "Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
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

  publishResume(BuildContext context, int publishStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    asyncProvider.changeAsynccall();

    ResumePublishStatusProvider publishProvider =
        Provider.of<ResumePublishStatusProvider>(context, listen: false);
    if (await publishProvider.callPublishStatusPostapi(publishStatus, header)) {
      Provider.of<GetResumeProvider>(context, listen: false).isResumePublished =
          !Provider.of<GetResumeProvider>(context, listen: false)
              .isResumePublished;
      Provider.of<GetResumeProvider>(context, listen: false).isResumePublished
          ? displaysnackbar('Your resume has been published successfully.')
          : displaysnackbar('Your resume has been unpublished successfully.');
    } else {
      displaysnackbar('Something went wrong.');
    }
    asyncProvider.changeAsynccall();
  }

  _showDownloadResumeButton(BuildContext context) {
    return Provider.of<GetResumeProvider>(context, listen: false)
            .isResumePublished
        ? InkWell(
            onTap: () => Provider.of<UserDataProvider>(context, listen: false)
                    .canDownloadResume
                ? _callGeneratePDFAPI(context)
                : _callPermissionError(context),
            child: Row(
              children: const [
                Text(
                  'Download Resume',
                  style: TextStyle(
                      color: kgreenPrimaryColor, fontWeight: FontWeight.w600),
                ),
                Icon(
                  Icons.file_download,
                  size: 16,
                  color: kgreenPrimaryColor,
                )
              ],
            ),
          )
        : Container();
  }

  _callGeneratePDFAPI(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider isAsyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);

    if (!isAsyncCallProvider.isinasynccall) {
      isAsyncCallProvider.changeAsynccall();
    }

    GeneratePDFProvider generatePDFProvider =
        Provider.of<GeneratePDFProvider>(context, listen: false);

    await generatePDFProvider.callGeneratePDFapi(header,
        Provider.of<UserDetailsProvider>(context, listen: false).userid);
    displaysnackbar(prefs.getString('Downloading status') ?? '');
    prefs.remove('Downloading status');
    isAsyncCallProvider.changeAsynccall();
  }

  _callPermissionError(BuildContext context) {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: const Text('Error', style: TextStyle(color: Colors.black)),
          content: const Text(
              'Please upgrade your plan to access this feature  .',
              style: TextStyle(color: Colors.black)),
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

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isPersonal = prefs.getBool('PersonalTab') ?? false;
      isDocument = prefs.getBool('DocumentTab') ?? false;
      isDangerous = prefs.getBool('DangerousTab') ?? false;
      isSeaService = prefs.getBool('SeaServiceTab') ?? false;
      isEmployer = prefs.getBool('EmployerTab') ?? false;
    });
  }
}
