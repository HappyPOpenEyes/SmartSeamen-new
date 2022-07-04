// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../LoginScreen/Login.dart';
import '../Register/Signup.dart';
import '../TextBoxLabel.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'ForgotPasswordProvider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  double height = 0;

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
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
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
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
                                        'Forgot Password',
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
                                      Form(
                                          key: _formKey,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16,
                                                      vertical: 10),
                                                  child: buildemailTF(),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                ElevatedButton(
                                                  style: buttonStyle(),
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      _formKey.currentState!
                                                          .save();
                                                      // if all are valid then go to success screen
                                                      forgotpasswordapicall();
                                                      //Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Submit',
                                                    style: TextStyle(
                                                        color:
                                                            kbackgroundColor),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                buildLogintext(),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                _buildRegisterText(),
                                              ],
                                            ),
                                          )),
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
            recognizer: TapGestureRecognizer()..onTap = () {},
            text: 'Already have an account? ',
            style: TextStyle(
              color: kblackPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.035,
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
              fontSize: MediaQuery.of(context).size.width * 0.038,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _buildRegisterText() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = () {},
            text: 'Don\'t have an account? ',
            style: TextStyle(
              color: kblackPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.035,
            ),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Signup()));
              },
            text: 'Register',
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

  buildemailTF() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              child: TextFormField(
                cursorColor: kgreenPrimaryColor,
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: kblackPrimaryColor,
                  fontFamily: 'OpenSans',
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: kEmailNullError);
                  } else if (emailValidatorRegExp.hasMatch(value)) {
                    removeError(error: kInvalidEmailError);
                  }
                  return;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return kEmailNullError;

                    //addError(error: kEmailNullError);
                  } else if (!emailValidatorRegExp.hasMatch(value)) {
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
                  hintStyle: TextStyle(
                    color: kblackPrimaryColor,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            ),
          ),
        ),
        TextBoxLabel(
          "Email",
        )
      ],
    );
  }

  void forgotpasswordapicall() async {
    bool result = await checkConnectivity();
    if (result) {
      callNoInternetScreen(ForgotPassword(), context);
    }
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    ForgotPasswordProvider otpScreenProvider =
        Provider.of<ForgotPasswordProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    try {
      if (await otpScreenProvider.callforgotpasswordapi(emailcontroller.text)) {
        asyncProvider.changeAsynccall();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        asyncProvider.changeAsynccall();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        displaysnackbar(prefs.getString('forgotpasswordstatus') ?? '');
        prefs.remove('forgotpasswordstatus');
      }
    } catch (e) {
      print(e);
    }
  }
}
