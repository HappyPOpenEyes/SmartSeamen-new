// ignore_for_file: file_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../DropdownBloc.dart';
import '../DropdownContainer.dart';
import '../IssuingAuthorityErrorBloc.dart';
import '../RadioButtonBloc.dart';
import '../ResumeBuilder/PersonalInformation/ExpandedAnimation.dart';
import '../ResumeBuilder/PersonalInformation/IndosNoBloc.dart';
import '../ResumeBuilder/PersonalInformation/Scrollbar.dart';
import '../SearchTextProvider.dart';
import '../TextBoxLabel.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'ForgotEmailPostData.dart';
import 'GetUserQuestionProvider.dart';
import 'QuestionSubmitProvider.dart';
import 'VerifyMobileProvider.dart';

class ForgotEmail extends StatefulWidget {
  @override
  _ForgotEmailState createState() => _ForgotEmailState();
}

class _ForgotEmailState extends State<ForgotEmail> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController contactnumberController = new TextEditingController();
  final List<String> errors = [], _answerList = ["", ""];
  List<IndosNoBloc> _showDropDownBloc = [IndosNoBloc(), IndosNoBloc()];
  List<TextEditingController> answerController = [
    TextEditingController(),
    TextEditingController()
  ];
  final _showErrorMsg = IndosNoBloc();
  final List<ResumeErrorIssuingAuthorityBloc> _errorQuestionBloc = [
    ResumeErrorIssuingAuthorityBloc(),
    ResumeErrorIssuingAuthorityBloc()
  ];
  final List<DropdownBloc> _dropdownBloc = [DropdownBloc(), DropdownBloc()];
  final RadioButtonBloc _showQuestionsBloc = RadioButtonBloc();
  final _showForgotEmailDataBloc = IndosNoBloc();

  List<String> _questionIds = ["", ""];
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
    for (int i = 0; i < 2; i++) {
      _dropdownBloc[i].dispose();
      _errorQuestionBloc[i].dispose();
    }
    _showForgotEmailDataBloc.dispose();
    _showQuestionsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<AsyncCallProvider>(context).isinasynccall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(
            backgroundColor: kbackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Stack(
                children: [
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset("images/login_bg.jpg")),
                    ],
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          //left: 6.0,
                          //right: 6.0,
                          top: MediaQuery.of(context).size.height * 0.19,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                              margin: const EdgeInsets.all(0),
                              color: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(45.0),
                                topRight: Radius.circular(45.0),
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              )),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    //left: MediaQuery.of(context).size.width * 0.32,
                                    //right: 8.0,
                                    top: MediaQuery.of(context).size.height *
                                        0.1,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Forgot Email',
                                        style: TextStyle(
                                            color: kBluePrimaryColor,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.085,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      _displayForgotEmailData(),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          //left: MediaQuery.of(context).size.width * 0.32,
                          //right: 8.0,
                          top: MediaQuery.of(context).size.height * 0.12,
                        ),
                        child: Center(
                            child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          height: MediaQuery.of(context).size.height * 0.16,
                          // decoration: ShapeDecoration(
                          //     shape: CircleBorder(), color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: CircleAvatar(
                                backgroundColor: Colors.grey[50],
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.26,
                                  // decoration: ShapeDecoration(
                                  //     shape: CircleBorder(), color: Colors.white),
                                  child:
                                      Image.asset('logos/smartsemen-logo.png'),
                                )),
                          ),
                        )),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildLogintext() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pop(context);
              },
            text: 'Back to Login',
            style: TextStyle(
              color: kgreenPrimaryColor,
              fontSize: MediaQuery.of(context).size.width * 0.038,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _displayquestioncard() {
    return StreamBuilder(
      stream: _showQuestionsBloc.stateRadioButtonStrean,
      builder: (context, snapshot) {
        if (_showQuestionsBloc.radioValue) {
          return Card(
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Card(
                              color: Colors.grey[50],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Question ${index + 1}',
                                        style: TextStyle(
                                            color: kBluePrimaryColor,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      _buildQuestionsDropdown(index),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      _buildAnswerTF(index),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            index == 0
                                ? const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    child: Divider(
                                      thickness: 0.5,
                                      color: Colors.grey,
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // if all are valid then go to success screen
                        forgotemailSubmitapicall();
                        //Navigator.pushNamed(context, CompleteProfileScreen.routeName);
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
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  buildphoneNumberTF() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              ],
              cursorColor: kgreenPrimaryColor,
              maxLength: 15,
              controller: contactnumberController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter the contact number');
                } else if (value.length > 4) {
                  removeError(error: kPhoneNumberLengthError);
                }
                return;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the contact number';
                  //addError(error: kEmailNullError);
                  return "";
                } else if (value.isNotEmpty && value.length < 4) {
                  return kPhoneNumberLengthError;
                }
                return null;
              },
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  //floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter your phone number',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Phone Number')
      ],
    );
  }

  _buildQuestionsDropdown(int index) {
    if (Provider.of<UserQuestionProvider>(context, listen: false).showIssue) {
      return StreamBuilder(
        initialData: false,
        stream: _errorQuestionBloc[index].stateResumeIssuingAuthorityStrean,
        builder: (context, errorsnapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1.0,
                    color: errorsnapshot.hasData &&
                            _errorQuestionBloc[index].showtext
                        ? Colors.red
                        : Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(
                        20.0) //                 <--- border radius here
                    ),
              ),
              child: StreamBuilder(
                stream: _dropdownBloc[index].stateDropdownStrean,
                builder: (context, dropdownsnapshot) {
                  return StreamBuilder(
                    stream: _showDropDownBloc[index].stateIndosNoStrean,
                    initialData: false,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          DrodpownContainer(
                            title: _answerList[index].isNotEmpty
                                ? _answerList[index]
                                : 'Select Question',
                            searchHint: 'Search Question',
                            showSearch: false,
                            showDropDownBloc: _showDropDownBloc[index],
                            originalList: Provider.of<UserQuestionProvider>(
                                    context,
                                    listen: false)
                                .questionsname,
                          ),
                          ExpandedSection(
                            expand: _showDropDownBloc[index].isedited,
                            height: 100,
                            child: MyScrollbar(
                              builder: (context, scrollController2) =>
                                  ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      controller: scrollController2,
                                      shrinkWrap: true,
                                      itemCount: Provider.of<
                                                      SearchChangeProvider>(
                                                  context,
                                                  listen: false)
                                              .noDataFound
                                          ? 1
                                          : Provider.of<SearchChangeProvider>(
                                                      context,
                                                      listen: false)
                                                  .searchList
                                                  .isNotEmpty
                                              ? Provider.of<SearchChangeProvider>(
                                                      context,
                                                      listen: false)
                                                  .searchList
                                                  .length
                                              : Provider.of<UserQuestionProvider>(
                                                      context,
                                                      listen: false)
                                                  .questionsname
                                                  .length,
                                      itemBuilder: (context, listindex) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (!Provider.of<
                                                              SearchChangeProvider>(
                                                          context,
                                                          listen: false)
                                                      .noDataFound) {
                                                    _showDropDownBloc[index]
                                                        .eventIndosNoSink
                                                        .add(IndosNoAction
                                                            .False);
                                                    _errorQuestionBloc[index]
                                                        .eventResumeIssuingAuthoritySink
                                                        .add(
                                                            ResumeErrorIssuingAuthorityAction
                                                                .False);

                                                    _answerList[
                                                        index] = Provider.of<
                                                                    SearchChangeProvider>(
                                                                context,
                                                                listen: false)
                                                            .searchList
                                                            .isNotEmpty
                                                        ? Provider.of<SearchChangeProvider>(
                                                                    context,
                                                                    listen: false)
                                                                .searchList[
                                                            listindex]
                                                        : Provider.of<UserQuestionProvider>(
                                                                    context,
                                                                    listen: false)
                                                                .questionsname[
                                                            listindex];
                                                    _questionIds[
                                                        index] = Provider.of<
                                                                UserQuestionProvider>(
                                                            context,
                                                            listen: false)
                                                        .questionscode[Provider
                                                            .of<UserQuestionProvider>(
                                                                context,
                                                                listen: false)
                                                        .questionsname
                                                        .indexOf(_answerList[
                                                            index])];
                                                    _dropdownBloc[index]
                                                        .setdropdownvalue(
                                                            _answerList[index]);
                                                    _dropdownBloc[index]
                                                        .eventDropdownSink
                                                        .add(DropdownAction
                                                            .Update);
                                                    Provider.of<SearchChangeProvider>(
                                                            context,
                                                            listen: false)
                                                        .searchKeyword = "";
                                                    Provider.of<SearchChangeProvider>(
                                                            context,
                                                            listen: false)
                                                        .searchList = [];
                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16),
                                                  child: Text(Provider.of<
                                                                  SearchChangeProvider>(
                                                              context,
                                                              listen: false)
                                                          .noDataFound
                                                      ? 'No Data Found'
                                                      : Provider.of<SearchChangeProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .searchList
                                                              .isNotEmpty
                                                          ? Provider.of<SearchChangeProvider>(
                                                                      context,
                                                                      listen: false)
                                                                  .searchList[
                                                              listindex]
                                                          : Provider.of<UserQuestionProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .questionsname[listindex]),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    } else {
      return const SizedBox();
    }
  }

  getdata() async {
    AsyncCallProvider asyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);

    if (!asyncCallProvider.isinasynccall) asyncCallProvider.changeAsynccall();

    asyncCallProvider.changeAsynccall();
  }

  void forgotemailVerifyapicall() async {
    AsyncCallProvider asyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);

    if (!asyncCallProvider.isinasynccall) asyncCallProvider.changeAsynccall();

    ForgotEmailMobileVerifyProvider forgotEmailVerifyProvider =
        Provider.of<ForgotEmailMobileVerifyProvider>(context, listen: false);

    if (!await forgotEmailVerifyProvider
        .callMobileVerifyapi(contactnumberController.text)) {
      if (Provider.of<ForgotEmailMobileVerifyProvider>(context, listen: false)
              .statusCode ==
          422) {
        displaysnackbar('Mobile number did not match.');
      } else {
        displaysnackbar('Something went wrong');
      }
    } else {
      UserQuestionProvider _userQuestionProvider =
          Provider.of<UserQuestionProvider>(context, listen: false);
      if (await _userQuestionProvider
          .callUserQuestionapi(forgotEmailVerifyProvider.userid)) {
        print('It is getting true');
        _showQuestionsBloc.eventRadioButtonSink.add(RadioButtonAction.True);
        _showQuestionsBloc.radioValue = true;
        _showErrorMsg.eventIndosNoSink.add(IndosNoAction.False);
        _showErrorMsg.isedited = false;
      } else {
        _showErrorMsg.eventIndosNoSink.add(IndosNoAction.True);
        _showErrorMsg.isedited = true;
      }
    }

    asyncCallProvider.changeAsynccall();
  }

  _buildAnswerTF(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        child: TextFormField(
          cursorColor: kgreenPrimaryColor,
          controller: answerController[index],
          style: const TextStyle(
            color: kblackPrimaryColor,
            fontFamily: 'OpenSans',
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: 'Please enter the answer');
            }
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter the answer';
              //addError(error: kEmailNullError);

            }
            return null;
          },
          decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 32),
              //floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(),
              ),
              hintText: 'Enter your answer',
              hintStyle: hintstyle),
        ),
      ),
    );
  }

  void forgotemailSubmitapicall() async {
    AsyncCallProvider asyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);

    if (!asyncCallProvider.isinasynccall) asyncCallProvider.changeAsynccall();

    ForgotEmailQuestionsSubmitProvider forgotEmailSubmitQuestionsProvider =
        Provider.of<ForgotEmailQuestionsSubmitProvider>(context, listen: false);
    List<ForgotEmailPostData> questionList = [];
    for (int i = 0; i < 2; i++) {
      questionList.add(ForgotEmailPostData(
          questionId: _questionIds[i], answer: answerController[i].text));
    }

    if (!await forgotEmailSubmitQuestionsProvider
        .callForgotEmailQuestionsSubmitapi(
            Provider.of<ForgotEmailMobileVerifyProvider>(context, listen: false)
                .userid,
            questionList)) {
      if (forgotEmailSubmitQuestionsProvider.statusCode == 422) {
        displaysnackbar('Your Answer Does Not Match, Please Try Again.');
      } else {
        displaysnackbar('Something went wrong.');
      }
    } else {
      print('It is shown');

      _showForgotEmailDataBloc.eventIndosNoSink.add(IndosNoAction.True);
      _showForgotEmailDataBloc.isedited = true;
    }

    asyncCallProvider.changeAsynccall();
  }

  _displayForgotEmailData() {
    return StreamBuilder(
      stream: _showForgotEmailDataBloc.stateIndosNoStrean,
      builder: (context, snapshot) {
        if (_showForgotEmailDataBloc.isedited) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your email address is ${Provider.of<ForgotEmailQuestionsSubmitProvider>(context, listen: false).email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                const SizedBox(
                  height: 10,
                ),
                buildLogintext(),
              ],
            ),
          );
        } else {
          return Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  children: [
                    buildphoneNumberTF(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          buildLogintext(),
                          const Spacer(),
                          ElevatedButton(
                            style: buttonStyle(),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                // if all are valid then go to success screen
                                forgotemailVerifyapicall();
                                //Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                              }
                            },
                            child: const Text(
                              'Verify',
                              style: TextStyle(color: kbackgroundColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _displayquestioncard(),
                    _displayQuestionNotFound(),
                  ],
                ),
              ));
        }
      },
    );
  }

  _displayQuestionNotFound() {
    return StreamBuilder(
      stream: _showErrorMsg.stateIndosNoStrean,
      builder: (context, snapshot) {
        if (_showErrorMsg.isedited) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'You have not added security questions in your account.',
                  style: TextStyle(color: Colors.red),
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
}
