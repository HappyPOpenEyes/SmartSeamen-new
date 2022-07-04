// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../asynccallprovider.dart';
import '../constants.dart';
import 'EmailVerifyProvider.dart';
import 'MobileVerifyProvider.dart';
import 'Profile.dart';
import 'UserDetailsProvider.dart';

class VerifyOTP extends StatefulWidget {
  var email = "", phone = "";
  var isemailorphone = 0;

  VerifyOTP(this.email, this.phone, this.isemailorphone, {Key? key})
      : super(key: key);
  @override
  _VerifyOTPState createState() =>
      _VerifyOTPState(email, phone, isemailorphone);
}

class _VerifyOTPState extends State<VerifyOTP> {
  var otp = "", email = "", phone = "";
  var isemailorphone = 0;
  bool isentered = false;

  _VerifyOTPState(this.email, this.phone, this.isemailorphone);

  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
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
                          height: MediaQuery.of(context).size.height * 0.245,
                          child: Image.asset("images/login_bg.jpg")),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.05,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.065),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            'images/previous.png',
                            color: kbackgroundColor,
                            height: MediaQuery.of(context).size.height * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
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
                                    MediaQuery.of(context).size.height * 0.84,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    //left: MediaQuery.of(context).size.width * 0.32,
                                    //right: 8.0,
                                    top: MediaQuery.of(context).size.height *
                                        0.11,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Form(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'We’ve sent an email to ',
                                                      style: TextStyle(
                                                        color:
                                                            kblackPrimaryColor,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.035,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: email,
                                                      style: TextStyle(
                                                        color:
                                                            kgreenPrimaryColor,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          ' to verify your email address and activate your account.',
                                                      style: TextStyle(
                                                        color:
                                                            kblackPrimaryColor,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'This OTP in the email will be expire in 15 minutes.',
                                              style: TextStyle(
                                                color: kblackPrimaryColor,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.038,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Please enter the 4-digit verfication code we sent via Email:',
                                              style: TextStyle(
                                                color: kblackPrimaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            OTPTextField(
                                              length: 4,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  09,
                                              textFieldAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              fieldWidth: 55,
                                              fieldStyle: FieldStyle.box,
                                              style:
                                                  const TextStyle(fontSize: 17),
                                              onChanged: (pin) {
                                                print("Changed: $pin");
                                              },
                                              onCompleted: (pin) {
                                                setState(() {
                                                  otp = pin;
                                                  isentered = false;
                                                });
                                              },
                                            ),
                                            isentered
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 20),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'Please enter the OTP.',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .red[500]),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            //buildotptextfield(),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            buildresendfield(),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    style: buttonStyle(),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Previous',
                                                      style: TextStyle(
                                                          color:
                                                              kbackgroundColor),
                                                    )),
                                                const SizedBox(
                                                  width: 40,
                                                ),
                                                ElevatedButton(
                                                    style: buttonStyle(),
                                                    onPressed: () {
                                                      if (otp == null) {
                                                        setState(() {
                                                          isentered = true;
                                                        });
                                                      } else {
                                                        callotpapi();
                                                        print('otpsend');
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Submit',
                                                      style: TextStyle(
                                                          color:
                                                              kbackgroundColor),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        )),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.14,
                        ),
                        child: Center(
                            child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          height: MediaQuery.of(context).size.height * 0.16,
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

  buildresendfield() {
    return Column(
      children: [
        Text(
          'Didn\'t receive an email?',
          style: TextStyle(
            color: kblackPrimaryColor,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () => _callResendOTP(),
          child: Text(
            'Resend OTP',
            style: TextStyle(
              color: kgreenPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        ),
      ],
    );
  }

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    displaysnackbar(prefs.getString('SendOTP') ?? '');
    prefs.remove('SendOTP');
  }

  void callotpapi() async {
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    asyncProvider.changeAsynccall();
    if (isemailorphone == 0) {
      EmailOTPVerifyProvider emailOtpVerifyProvider =
          Provider.of<EmailOTPVerifyProvider>(context, listen: false);
      if (await emailOtpVerifyProvider.callEmailOtpVerifyapi(
        email,
        Provider.of<UserDetailsProvider>(context, listen: false).userid,
        otp,
        Provider.of<UserDetailsProvider>(context, listen: false).header,
      )) {
        asyncProvider.changeAsynccall();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('VerifyOTP', 'Email address changed successfully.');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ProfileScreen()));
      } else {
        asyncProvider.changeAsynccall();
        displaysnackbar('Something went wrong');
      }
    } else {
      MobileOTPVerifyProvider mobileOtpVerifyProvider =
          Provider.of<MobileOTPVerifyProvider>(context, listen: false);
      if (await mobileOtpVerifyProvider.callMobileOtpVerifyapi(
        phone,
        Provider.of<UserDetailsProvider>(context, listen: false).userid,
        otp,
        Provider.of<UserDetailsProvider>(context, listen: false).header,
      )) {
        asyncProvider.changeAsynccall();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('VerifyOTP', 'Phone number changed successfully.');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ProfileScreen()));
      } else {
        asyncProvider.changeAsynccall();
        displaysnackbar('Something went wrong');
      }
    }
  }

  _callResendOTP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider isinAsyncCall =
        Provider.of<AsyncCallProvider>(context, listen: false);

    if (isemailorphone == 0) {
      if (!isinAsyncCall.isinasynccall) isinAsyncCall.changeAsynccall();

      // ResendEmailOTPSendProvider resendEmailOtpProvider =
      //     Provider.of<ResendEmailOTPSendProvider>(context, listen: false);

      // if (!await resendEmailOtpProvider.callResendEmailOtpSendapi(
      //     Provider.of<UserDetailsProvider>(context, listen: false).userid,
      //     header)) {
      //   displaysnackbar('Something went wrong');
      // } else {
      //   displaysnackbar('Otp has been sent successfully');
      // }

      isinAsyncCall.changeAsynccall();
    } else {
      if (!isinAsyncCall.isinasynccall) isinAsyncCall.changeAsynccall();

      // ResendMobileOTPSendProvider resendMobileOtpProvider =
      //     Provider.of<ResendMobileOTPSendProvider>(context, listen: false);

      // if (!await resendMobileOtpProvider.callResendMobileOtpSendapi(
      //     Provider.of<UserDetailsProvider>(context, listen: false).userid,
      //     header)) {
      //   displaysnackbar('Something went wrong');
      // } else {
      //   displaysnackbar('Otp has been sent successfully');
      // }

      isinAsyncCall.changeAsynccall();
    }
  }
}
