// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../SwitchButtonBloc.dart';
import '../../asynccallprovider.dart';
import '../../constants.dart';
import '../Header.dart';
import 'DocumentScreen.dart';
import 'DocumentScreenProvider.dart';
import 'MedicalDocUpdateProvider.dart';
import 'PostMedicalData.dart';

class EditMedicalDocuments extends StatefulWidget {
  const EditMedicalDocuments({Key? key}) : super(key: key);

  @override
  _EditMedicalDocumentsState createState() => _EditMedicalDocumentsState();
}

class _EditMedicalDocumentsState extends State<EditMedicalDocuments> {
  final List<bool> _hasMedicalDocument = [];
  final List<SwitchButtonBloc> __switchButtonBloc = [];
  @override
  void initState() {
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
            children: [
              ResumeHeader('Documents', 2, true, ""),
              _buildMedicalCard(),
            ],
          ),
        ),
      ),
    );
  }

  _displayOptions(String label) {
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
      ],
    );
  }

  _buildMedicalCard() {
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
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: Provider.of<ResumeDocumentProvider>(context,
                            listen: false)
                        .medicalDocumentName
                        .length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.72,
                                child: _displayOptions(
                                    Provider.of<ResumeDocumentProvider>(context,
                                            listen: false)
                                        .medicalDocumentName[index]),
                              ),
                              _displaySwitchbuttons(index),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Divider(
                              thickness: 0.25,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      callpostMedicalDoc();
                    },
                    style: buttonStyle(),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          color: kbackgroundColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: kgreenPrimaryColor,
                          fontWeight: FontWeight.bold),
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

  _displaySwitchbuttons(int index) {
    return StreamBuilder(
      initialData: Provider.of<ResumeDocumentProvider>(context, listen: false)
          .hasMedicalDocument[index],
      stream: __switchButtonBloc[index].stateSwitchButtonStrean,
      builder: (context, snapshot) {
        return FlutterSwitch(
          height: 20,
          width: MediaQuery.of(context).size.height * 0.06,
          value:
              snapshot.hasData ? __switchButtonBloc[index].switchValue : false,
          onToggle: (val) {
            _hasMedicalDocument[index] = val;
            if (val) {
              __switchButtonBloc[index]
                  .eventSwitchButtonSink
                  .add(SwitchButtonAction.True);
            } else {
              __switchButtonBloc[index]
                  .eventSwitchButtonSink
                  .add(SwitchButtonAction.False);
            }
          },
        );
      },
    );
  }

  void getdata() {
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .medicalDocumentName
                .length;
        i++) {
      __switchButtonBloc.add(SwitchButtonBloc());
      _hasMedicalDocument.add(
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .hasMedicalDocument[i]);
    }
  }

  void callpostMedicalDoc() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditMedicalDocuments(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    ResumeEditMedicalDocUpdateProvider editMedicalDocProvider =
        Provider.of<ResumeEditMedicalDocUpdateProvider>(context, listen: false);
    List<PostMedicalData> postData = [];
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .medicalDocumentId
                .length;
        i++) {
      postData.add(PostMedicalData(
          id: Provider.of<ResumeDocumentProvider>(context, listen: false)
              .medicaluserId[i],
          documentId:
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .medicalDocumentId[i],
          hasDocument: _hasMedicalDocument[i]));
    }

    if (await editMedicalDocProvider.callpostResumeMedicalDocapi(
        postData, header)) {
      asyncProvider.changeAsynccall();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('RecordAdded', 'Record has been added successfully');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DocumentScreen()));
    } else {
      asyncProvider.changeAsynccall();
      displaysnackbar('Something went wrong');
    }
  }
}
