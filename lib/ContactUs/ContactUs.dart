// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartseaman/TextBoxLabel.dart';

import '../IssuingAuthorityErrorBloc.dart';
import '../ResumeBuilder/PersonalInformation/IndosNoBloc.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'ContactUsHeader.dart';
import 'ContactUsProvider.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final TextEditingController _subjectController = TextEditingController(),
      _messageController = TextEditingController();
  List<String> errors = [];
  static final _formKey = GlobalKey<FormState>();
  final _radioBloc = IndosNoBloc();
  final _errorCategoryBloc = ResumeErrorIssuingAuthorityBloc();

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _radioBloc.dispose();
    _errorCategoryBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

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
              ContactUsHeader(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.grey[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('images/contact.jpg'),
                          const SizedBox(
                            height: 10,
                          ),
                          _displayRadioOptions(),
                          _displayErrorText(),
                          const SizedBox(
                            height: 10,
                          ),
                          _displayTF(true),
                          const SizedBox(
                            height: 10,
                          ),
                          _displayTF(false),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                if (!checkError()) {
                                  callContactUsApi();
                                }
                              } else {
                                var data = checkError();
                              }
                            },
                            style: buttonStyle(),
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: kbackgroundColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _displayTF(bool isSubject) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: kbackgroundColor,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller: isSubject ? _subjectController : _messageController,
              maxLines: isSubject ? 1 : 5,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  isSubject
                      ? removeError(error: 'Please enter the subject')
                      : removeError(error: 'Please enter your message');
                }
                return;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return isSubject
                      ? 'Please enter the subject'
                      : 'Please enter your message';
                  //addError(error: kEmailNullError);

                }
                return null;
              },
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  hintText: isSubject ? 'Enter subject' : 'Enter your message',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel(isSubject ? 'Subject' : 'Message')
      ],
    );
  }

  _displayRadioOptions() {
    return StreamBuilder(
      stream: _radioBloc.stateIndosNoStrean,
      builder: (context, snapshot) {
        return Stack(
          children: [
            StreamBuilder(
              stream: _errorCategoryBloc.stateResumeIssuingAuthorityStrean,
              builder: (context, errorsnapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: errorsnapshot.hasData &&
                                  _errorCategoryBloc.showtext
                              ? Colors.red
                              : Colors.grey,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 12, bottom: 12, left: 30),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _radioBloc.eventIndosNoSink
                                  .add(IndosNoAction.True);
                              _errorCategoryBloc.eventResumeIssuingAuthoritySink
                                  .add(ResumeErrorIssuingAuthorityAction.False);
                            },
                            child: Row(
                              children: [
                                snapshot.data == null
                                    ? const Icon(
                                        Icons.radio_button_unchecked,
                                        color: kgreenPrimaryColor,
                                      )
                                    : _radioBloc.isedited
                                        ? const Icon(
                                            Icons.radio_button_checked,
                                            color: kgreenPrimaryColor,
                                          )
                                        : const Icon(
                                            Icons.radio_button_unchecked,
                                            color: kgreenPrimaryColor,
                                          ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text('Support'),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: () {
                              _radioBloc.eventIndosNoSink
                                  .add(IndosNoAction.False);
                              _errorCategoryBloc.eventResumeIssuingAuthoritySink
                                  .add(ResumeErrorIssuingAuthorityAction.False);
                            },
                            child: Row(
                              children: [
                                snapshot.data == null
                                    ? const Icon(
                                        Icons.radio_button_unchecked,
                                        color: kgreenPrimaryColor,
                                      )
                                    : _radioBloc.isedited
                                        ? const Icon(
                                            Icons.radio_button_unchecked,
                                            color: kgreenPrimaryColor,
                                          )
                                        : const Icon(
                                            Icons.radio_button_checked,
                                            color: kgreenPrimaryColor,
                                          ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text('Enquiry'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            TextBoxLabel('Contact Type')
          ],
        );
      },
    );
  }

  _displayErrorText() {
    return StreamBuilder(
      initialData: false,
      stream: _errorCategoryBloc.stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && _errorCategoryBloc.showtext) {
          return Visibility(
            visible: _errorCategoryBloc.showtext,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please select the contact type',
                  style: TextStyle(color: Colors.red[500]),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  bool checkError() {
    print('In here');
    bool data = false;

    if (_radioBloc.isedited == null) {
      data = true;
      _errorCategoryBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
    }
    return data;
  }

  void callContactUsApi() async {
    bool result = await checkConnectivity();
    if (result) {
      callNoInternetScreen(const ContactUs(), context);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');

    AsyncCallProvider asyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncCallProvider.changeAsynccall();
    }
    ContactUsProvider contactUsProvider =
        Provider.of<ContactUsProvider>(context, listen: false);

    if (!await contactUsProvider.callContactUsapi(_radioBloc.isedited ? 49 : 50,
        _messageController.text, _subjectController.text, header)) {
      if (contactUsProvider.checkJobPref) {
        displaysnackbar(
            'Please select the rank in resume builder section to complete the contact us form');
      } else {
        displaysnackbar('Something went wrong');
      }
    } else {
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      _messageController.clear();
      _subjectController.clear();
      displaysnackbar('Your response has been submitted');
    }

    asyncCallProvider.changeAsynccall();
  }
}
