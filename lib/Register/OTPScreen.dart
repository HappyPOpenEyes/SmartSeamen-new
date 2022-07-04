import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../DropdownBloc.dart';
import '../LoginScreen/Login.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'OTPScreenProvider.dart';
import 'ResendOTPProvider.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final List<String> errors = [];
  final _formKey = GlobalKey<FormState>();
  var userid, otp, email;
  bool isentered = false;
  final _dropdownBloc = DropdownBloc();
  late AppLifecycleState _notification;

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dropdownBloc.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;

      if (state == AppLifecycleState.detached) {
        clearsharedpreferencedata();
      }
    });
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
          child: Stack(
            alignment: Alignment.bottomCenter,
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset("images/login_bg.jpg")),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 48),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.04,
                              child: Image.asset(
                                'images/previous.png',
                                color: kbackgroundColor,
                              ),
                            )),
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(45.0),
                                topRight: Radius.circular(45.0),
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              )),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.92,
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
                                                0.035,
                                      ),
                                      Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.24),
                                            child: Row(
                                              children: [
                                                const Text('Personal Details'),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.09,
                                                ),
                                                const Text('OTP')
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.072,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TimelineTile(
                                                      isFirst: true,
                                                      indicatorStyle:
                                                          IndicatorStyle(
                                                        width: 20,
                                                        height: 30,
                                                        color:
                                                            kgreenPrimaryColor,
                                                        iconStyle: IconStyle(
                                                            color: Colors.white,
                                                            iconData:
                                                                Icons.check),
                                                      ),
                                                      beforeLineStyle:
                                                          const LineStyle(
                                                        color:
                                                            kBluePrimaryColor,
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
                                                            kBluePrimaryColor,
                                                      ),
                                                      beforeLineStyle:
                                                          const LineStyle(
                                                        color:
                                                            kBluePrimaryColor,
                                                        thickness: 6,
                                                      ),
                                                      axis: TimelineAxis
                                                          .horizontal),
                                                ],
                                              )),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Form(
                                            key: _formKey,
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
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  fieldWidth: 55,
                                                  fieldStyle: FieldStyle.box,
                                                  style: const TextStyle(
                                                      fontSize: 17),
                                                  onChanged: (pin) {},
                                                  onCompleted: (pin) {
                                                    setState(() {
                                                      otp = pin;
                                                      isentered = false;
                                                    });
                                                  },
                                                ),
                                                isentered
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10.0,
                                                                horizontal: 20),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
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
                                                        style:
                                                            buttonStyle(), // foreground

                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
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
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              _formKey
                                                                  .currentState!
                                                                  .save();
                                                              // if all are valid then go to success screen
                                                              callotpapi();
                                                              //Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                                                            }
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

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    displaysnackbar(prefs.getString('registerstatus') ?? '');
    prefs.remove('registerstatus');
    setState(() {
      userid = prefs.getString('registeruserid');
      email = prefs.getString('email');
    });
  }

  void showsnackbar(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s),
    ));
  }

  void clearsharedpreferencedata() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
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
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () => _callResendOTPApi(),
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

  void callotpapi() async {
    AsyncCallProvider _asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    OTPScreenProvider _otpScreenProvider =
        Provider.of<OTPScreenProvider>(context, listen: false);
    _asyncProvider.changeAsynccall();
    try {
      if (await _otpScreenProvider.callotpverifyapi(otp.toString(), userid)) {
        _asyncProvider.changeAsynccall();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        _asyncProvider.changeAsynccall();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        displaysnackbar(prefs.getString('verifystatus') ?? '');
        prefs.remove('verifystatus');
      }
    } catch (e) {
      print(e);
    }
  }

  _callResendOTPApi() async {
    AsyncCallProvider _asyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);

    if (!_asyncCallProvider.isinasynccall) _asyncCallProvider.changeAsynccall();

    ResendOTPSendProvider _resendOtpProvider =
        Provider.of<ResendOTPSendProvider>(context, listen: false);

    if (!await _resendOtpProvider.callResendOtpSendapi(userid))
      displaysnackbar('Something went wrong');
    else
      displaysnackbar('Otp send sucessfully');

    _asyncCallProvider.changeAsynccall();
  }
}
