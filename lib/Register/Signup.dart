// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures, library_private_types_in_public_api

import 'package:dropdown_selection/dropdown_selection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../DropdownBloc.dart';
import '../DropdownContainer.dart';
import '../IssuingAuthorityErrorBloc.dart';
import '../LoginScreen/Login.dart';
import '../RadioButtonBloc.dart';
import '../ResumeBuilder/PersonalInformation/ExpandedAnimation.dart';
import '../ResumeBuilder/PersonalInformation/IndosNoBloc.dart';
import '../ResumeBuilder/PersonalInformation/Scrollbar.dart';
import '../SearchTextProvider.dart';
import '../TextBoxLabel.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'CountriesBloc.dart';
import 'OTPScreen.dart';
import 'Register_Provider.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  static final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      firstnameController = TextEditingController(),
      lastnameController = TextEditingController(),
      contactnumberController = TextEditingController();
  final List<String> errors = [];
  var email = "",
      password = "",
      userid = "",
      fname = "",
      lname = "",
      username = "",
      phonenumber = "";
  bool obscuretext = true;
  final _countriesBloc = PhoneCountriesBloc();
  final _dropdownBloc = DropdownBloc();
  final _dropdownShowBloc = RadioButtonBloc();
  final _errorCountryCodeBloc = ResumeErrorIssuingAuthorityBloc();
  final _showCountryDropDownBloc = IndosNoBloc();
  String _countryValue = "";
  bool isStrechedDropDown = false;

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void dispose() {
    _countriesBloc.dispose();
    _errorCountryCodeBloc.dispose();
    _dropdownShowBloc.dispose();
    super.dispose();
  }

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
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<AsyncCallProvider>(context).isinasynccall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(
            backgroundColor: kbackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisSize: MainAxisSize.min,
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
                          top: MediaQuery.of(context).size.height * 0.205,
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
                                //height: MediaQuery.of(context).size.height * 0.8,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    //left: MediaQuery.of(context).size.width * 0.32,
                                    //right: 8.0,
                                    top: MediaQuery.of(context).size.height *
                                        0.12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            color: kBluePrimaryColor,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.085,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Create your Account',
                                        style: TextStyle(
                                          color: kBluePrimaryColor,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: Alignment.bottomLeft,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.18,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                            'Personal Details'),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.09,
                                                        ),
                                                        const Text('OTP')
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.07,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          TimelineTile(
                                                              isFirst: true,
                                                              indicatorStyle:
                                                                  const IndicatorStyle(
                                                                width: 20,
                                                                height: 30,
                                                                color:
                                                                    kBluePrimaryColor,
                                                              ),
                                                              beforeLineStyle:
                                                                  const LineStyle(
                                                                color:
                                                                    Colors.grey,
                                                                thickness: 6,
                                                              ),
                                                              axis: TimelineAxis
                                                                  .horizontal),
                                                          TimelineTile(
                                                              isLast: true,
                                                              indicatorStyle:
                                                                  const IndicatorStyle(
                                                                width: 20,
                                                                height: 30,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              beforeLineStyle:
                                                                  const LineStyle(
                                                                color:
                                                                    Colors.grey,
                                                                thickness: 6,
                                                              ),
                                                              axis: TimelineAxis
                                                                  .horizontal),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              _buildFnameTF(),
                                              const SizedBox(height: 14.0),
                                              _buildLnameTF(),
                                              const SizedBox(height: 14.0),
                                              Stack(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 6),
                                                    child: Container(
                                                      //height: 80,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 16,
                                                                  horizontal:
                                                                      8),
                                                          child: Column(
                                                            children: [
                                                              _buildcountrydropdown(),
                                                              _displayerrortext(),
                                                              _displayContactNumberTF(),
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                  TextBoxLabel('Contact Number')
                                                ],
                                              ),
                                              const SizedBox(height: 14.0),
                                              _buildEmailTF(),
                                              const SizedBox(height: 14.0),
                                              _buildPasswordTF(),
                                              const SizedBox(height: 14.0),
                                              GestureDetector(
                                                  onTap: () {},
                                                  child: ElevatedButton(
                                                    style:
                                                        buttonStyle(), // foreground
                                                    onPressed: () {
                                                      if (_countryValue
                                                          .isEmpty) {
                                                        _errorCountryCodeBloc
                                                            .eventResumeIssuingAuthoritySink
                                                            .add(
                                                                ResumeErrorIssuingAuthorityAction
                                                                    .True);
                                                      } else {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          _formKey.currentState!
                                                              .save();
                                                          callsignupfunction();
                                                        }
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Next',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                              const SizedBox(height: 14.0),
                                              _buildlogintext(),
                                            ],
                                          ),
                                        ),
                                      )
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
                          top: MediaQuery.of(context).size.height * 0.14,
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

  Widget _buildFnameTF() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
              ],
              cursorColor: kgreenPrimaryColor,
              controller: firstnameController,
              keyboardType: TextInputType.name,
              onSaved: (newValue) => fname = newValue!,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter your first name');
                }
                return;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your first name';
                  //addError(error: kEmailNullError);
                }
                return null;
              },
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter your First Name',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('First Name')
      ],
    );
  }

  Widget _buildLnameTF() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
              ],
              cursorColor: kgreenPrimaryColor,
              controller: lastnameController,
              keyboardType: TextInputType.name,
              onSaved: (newValue) => lname = newValue!,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter your last name');
                }
                return;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your last name';
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
                  hintText: 'Enter your Last Name',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Last Name')
      ],
    );
  }

  _displayContactNumberTF() {
    return Padding(
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

            } else if (value.isNotEmpty && value.length < 4) {
              return kPhoneNumberLengthError;
            }
            return null;
          },
          decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 34),
              //floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(),
              ),
              hintText: 'Enter your Contact Number',
              hintStyle: hintstyle),
        ),
      ),
    );
  }

  Widget _buildEmailTF() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              onSaved: (newValue) => email = newValue!,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: kEmailNullError);
                } else if (value.contains('@') &&
                    emailValidatorRegExp.hasMatch(value)) {
                  removeError(error: kInvalidEmailError);
                }
                return;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return kEmailNullError;
                  //addError(error: kEmailNullError);

                } else if (value.contains('@') &&
                    !emailValidatorRegExp.hasMatch(value)) {
                  return kInvalidEmailError;
                  //addError(error: kInvalidEmailError);

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
                  hintText: 'Enter your Email',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Email')
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            //height: 60.0,
            child: TextFormField(
              controller: passwordController,
              cursorColor: kblackPrimaryColor,
              obscureText: obscuretext,
              onSaved: (newValue) => password = newValue!,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: kPassNullError);
                } else if (value.length >= 8) {
                  removeError(error: kShortPassError);
                }
                password = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return kPassNullError;
                  //addError(error: kPassNullError);

                } else if (value.length < 6) {
                  return kShortPassError;
                  //addError(error: kShortPassError);
                } else if (value.length >= 6) {
                  if (!checkPassword(value)) return kInvalidPassError;
                }
                return null;
              },
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                  errorMaxLines: 2,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  //floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  suffixIcon: obscuretext
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              obscuretext = false;
                            });
                          },
                          child: Image.asset(
                            'images/eye.png',
                            //fit: BoxFit.cover,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              obscuretext = true;
                            });
                          },
                          child: Image.asset(
                            'images/invisible.png',
                            //fit: BoxFit.cover,
                          ),
                        ),
                  hintText: 'Enter your Password',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Password')
      ],
    );
  }

  _buildlogintext() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = () {},
            text: 'Already have an account? ',
            style: TextStyle(
              color: kblackPrimaryColor,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            text: 'Login',
            style: TextStyle(
              color: kgreenPrimaryColor,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void callsignupfunction() async {
    bool result = await checkConnectivity();
    if (result) {
      callNoInternetScreen(const Signup(), context);
    }
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    RegisterProvider registerProvider =
        Provider.of<RegisterProvider>(context, listen: false);
    try {
      if (await registerProvider.callregisterapi(
          firstnameController.text,
          lastnameController.text,
          emailController.text,
          contactnumberController.text,
          _countriesBloc.countryId[_countriesBloc.countrycode
              .indexOf(_dropdownBloc.getdropdownvalue!)],
          passwordController.text,
          userid)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('fname', firstnameController.text);
        prefs.setString('lname', lastnameController.text);
        prefs.setString('phonenumber', contactnumberController.text);
        prefs.setString('email', emailController.text);
        prefs.setString('password', passwordController.text);
        asyncProvider.changeAsynccall();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const OTPScreen()));
      } else {
        asyncProvider.changeAsynccall();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        displaysnackbar(prefs.getString('registerstatus') ?? '');
        prefs.remove('registerstatus');
      }
    } catch (e) {
      print(e);
    }
  }

  _buildcountrydropdown() {
    return StreamBuilder(
      stream: _countriesBloc.stateCountriesStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (_dropdownBloc.dropdownvalue != null) {
            if (_dropdownBloc.dropdownvalue!.isEmpty) {
              _countryValue = _countriesBloc
                  .countrycode[_countriesBloc.countryname.indexOf("India")];
              _dropdownBloc.setdropdownvalue(_countryValue);
              _dropdownBloc.eventDropdownSink.add(DropdownAction.Update);
            }
          }
          return StreamBuilder(
            initialData: false,
            stream: _errorCountryCodeBloc.stateResumeIssuingAuthorityStrean,
            builder: (context, errorsnapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0,
                        color: errorsnapshot.hasData &&
                                _errorCountryCodeBloc.showtext
                            ? Colors.red
                            : Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(
                            20.0) //                 <--- border radius here
                        ),
                  ),
                  child: StreamBuilder(
                    stream: _dropdownBloc.stateDropdownStrean,
                    builder: (context, dropdownsnapshot) {
                      return StreamBuilder(
                        stream: _showCountryDropDownBloc.stateIndosNoStrean,
                        builder: (context, dropdownsnapshot) {
                          return Column(
                            children: [
                              DrodpownContainer(
                                title: _countryValue.isNotEmpty
                                    ? _countryValue
                                    : 'Select Country',
                                showDropDownBloc: _showCountryDropDownBloc,
                                originalList: _countriesBloc.countrycode,
                                searchHint: 'Search Country',
                              ),
                              ExpandedSection(
                                expand: _showCountryDropDownBloc.isedited,
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
                                                  ? Provider.of<
                                                              SearchChangeProvider>(
                                                          context,
                                                          listen: false)
                                                      .searchList
                                                      .length
                                                  : _countriesBloc
                                                      .countrycode.length,
                                          itemBuilder: (context, listindex) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      if (!Provider.of<
                                                                  SearchChangeProvider>(
                                                              context,
                                                              listen: false)
                                                          .noDataFound) {
                                                        _showCountryDropDownBloc
                                                            .eventIndosNoSink
                                                            .add(IndosNoAction
                                                                .False);
                                                        _errorCountryCodeBloc
                                                            .eventResumeIssuingAuthoritySink
                                                            .add(
                                                                ResumeErrorIssuingAuthorityAction
                                                                    .False);
                                                        _countryValue = Provider
                                                                    .of<SearchChangeProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                .searchList
                                                                .isNotEmpty
                                                            ? Provider.of<SearchChangeProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .searchList[
                                                                listindex]
                                                            : _countriesBloc
                                                                    .countrycode[
                                                                listindex];

                                                        _dropdownBloc.setdropdownvalue(_countryValue);
                                                        _dropdownBloc
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
                                                                      listen:
                                                                          false)
                                                                  .searchList
                                                                  .isNotEmpty
                                                              ? Provider.of<SearchChangeProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .searchList[
                                                                  listindex]
                                                              : _countriesBloc
                                                                      .countrycode[
                                                                  listindex]),
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
      },
    );
  }

  _displayerrortext() {
    return StreamBuilder(
      initialData: false,
      stream: _errorCountryCodeBloc.stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return Visibility(
              visible: _errorCountryCodeBloc.showtext,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please select the country code',
                    style: TextStyle(color: Colors.red[500]),
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _countriesBloc.eventCountriesSink.add(PhoneCountriesAction.Post);
    setState(() {
      firstnameController.text = prefs.getString('fname') ?? '';
      lastnameController.text = prefs.getString('lname') ?? '';
      emailController.text = prefs.getString('email') ?? '';
      contactnumberController.text = prefs.getString('phonenumber') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      userid = prefs.getString('registeruserid') ?? '';
    });
  }

  bool checkPassword(String pass) {
    final alphanumeric = RegExp(
        '^(?=.*[0-9])(?=.*[@\$#!%*?&])(?=.*[a-zA-Z])([a-zA-Z0-9@\$#!%*?&]{6,})\$');
    //RegExp('(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@\$%^&*-])');

    return alphanumeric.hasMatch(pass);
  }
}
