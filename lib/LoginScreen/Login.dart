// ignore: file_names
// ignore_for_file: import_of_legacy_library_into_null_safe, use_build_context_synchronously

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:smartseaman/Dashboard/Dashboard.dart';
import '../ForgotEmail/ForgotEmail.dart';
import '../ForgotPassword/ForgotPassword.dart';
import '../Profile/LinkedinData.dart';
import '../Profile/Profile.dart';
import '../Profile/UserDetailsProvider.dart';
import '../Register/Signup.dart';
import '../TextBoxLabel.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'LoginProvider.dart';
import 'SocialMediaCheckProvider.dart';
import 'UserDataProvider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final List<String> errors = [];
  var email = "",
      password = "",
      header = "",
      userid = "",
      fname = "",
      lname = "",
      username = "",
      phonenumber = "";
  bool obscuretext = true;
  static final FacebookLogin facebookSignIn = FacebookLogin();
  late GoogleSignInAccount _currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  late FirebaseMessaging _firebaseMessaging;
  final String linkedInredirectUrl =
      'https://api.smartseaman.devbyopeneyes.com/public/auth';
  final String linkedInclientId = '77fxzedu13ta3n';
  final String linkedInclientSecret = 'DLNgYytiwp1Jg51Q';
  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

//fcm_listener();
    super.initState();
    getdata();
    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   print("message recieved");
    //   print(event.notification!.body);
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: Text("Notification"),
    //           content: Text(event.notification!.body!),
    //           actions: [
    //             TextButton(
    //               child: Text("Ok"),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             )
    //           ],
    //         );
    //       });
    // });
  }

  void fcm_listener() async {
    _firebaseMessaging = FirebaseMessaging.instance;
    try {
      var token = await _firebaseMessaging.getToken();
      print("fcm token = $token");
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
      //   (
      //   onLaunch: (Map<String, dynamic> message) async {
      //     print("onLaunch $message");
      //   },
      //   onMessage: (Map<String, dynamic> message) async {
      //     print("onMessage $message");
      //   },
      //   onResume: (Map<String, dynamic> message) async {
      //     print("onResume $message");
      //   },
      // );
    } catch (e) {
      print("fcm exception");
      print(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
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
            children: [
              Stack(
                children: [
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset("images/login_bg.jpg"),
                      )
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
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              )),
                              child: SingleChildScrollView(
                                child: SizedBox(
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
                                          'Sign In',
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
                                          'Please login to continue',
                                          style: TextStyle(
                                            color: kBluePrimaryColor,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(24.0),
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                _buildEmailTF(),
                                                const SizedBox(height: 28.0),
                                                _buildPasswordTF(),
                                                const SizedBox(height: 34.0),
                                                ElevatedButton(
                                                  style: buttonStyle(),
                                                  onPressed: () {
                                                    print('login');
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      _formKey.currentState!
                                                          .save();
                                                      // if all are valid then go to success screen
                                                      callloginapi();
                                                      //Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Login',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const SizedBox(height: 20.0),
                                                _displaySocialMediaIcons(),
                                                const SizedBox(height: 20.0),
                                                _buildsignuptext(),
                                                //_buildRegisterText(),
                                                const SizedBox(height: 10.0),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.055,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      _buildForgotPasswordBtn(
                                                          0),
                                                      const VerticalDivider(
                                                        thickness: 1.5,
                                                        color:
                                                            kgreenPrimaryColor,
                                                      ),
                                                      _buildForgotPasswordBtn(
                                                          1),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
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
                          height: MediaQuery.of(context).size.height * 0.18,
                          // decoration: ShapeDecoration(
                          //     shape: CircleBorder(), color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: CircleAvatar(
                                backgroundColor: Colors.grey[50],
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.075,
                                  // decoration: ShapeDecoration(
                                  //     shape: CircleBorder(), color: Colors.white),
                                  child: Image.asset(
                                    'logos/smartsemen-logo.png',
                                  ),
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

  Widget _buildEmailTF() {
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
            child: GestureDetector(
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

                  } else if (value.length < 8) {
                    return kShortPassError;
                    //addError(error: kShortPassError);

                  }
                  return null;
                },
                style: const TextStyle(
                  color: kblackPrimaryColor,
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 32),
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
        ),
        TextBoxLabel('Password')
      ],
    );
  }

  _buildsignuptext() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = () {},
            text: 'Dont\'t have an account? ',
            style: TextStyle(
              color: kblackPrimaryColor,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Signup()));
              },
            text: 'Register',
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

  Widget _buildForgotPasswordBtn(int index) {
    return Container(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          index == 0
              ? Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ForgotPassword()))
              : Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ForgotEmail()));
        },
        child: Text(
          index == 0 ? 'Forgot Password?' : 'Forgot Email?',
          style: TextStyle(
            color: kgreenPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('verifystatus') != null) {
      displaysnackbar(prefs.getString('verifystatus') ?? '');
      prefs.remove('verifystatus');
    }
    if (prefs.getString('forgotpasswordstatus') != null) {
      displaysnackbar(prefs.getString('forgotpasswordstatus') ?? '');
      prefs.remove('forgotpasswordstatus');
    }
  }

  void callloginapi() async {
    bool result = await checkConnectivity();
    if (result) {
      callNoInternetScreen(LoginScreen(), context);
    }
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (await loginProvider.callloginapi(emailController.text,
          passwordController.text, prefs.getString('RegistrationTokenFCM'))) {
        UserDetailsProvider userDetailsProvider =
            Provider.of<UserDetailsProvider>(context, listen: false);

        userDetailsProvider.changeUserDetails(
            '', '', '', '', '', '', prefs.getString('header'));
        displaysnackbar(prefs.getString('loginstatus') ?? '');
        prefs.remove('loginstatus');
        UserDataProvider userDataProvider =
            Provider.of<UserDataProvider>(context, listen: false);
        if (await userDataProvider.callUserDataapi(prefs.getString('header'))) {
          UserDetailsProvider userDetailsProvider =
              Provider.of<UserDetailsProvider>(context, listen: false);
          
          prefs.setString('lastname',userDataProvider.lastname);
          prefs.setString('email', userDataProvider.email);
          prefs.setString('mobile', userDataProvider.mobile);
          prefs.setString('userid', userDataProvider.id);
          
          prefs.setString('firstname', userDataProvider.firstname);
          userDetailsProvider.changeUserDetails(
              userDataProvider.firstname,
              userDataProvider.lastname,
              userDataProvider.email,
              "",
              userDataProvider.mobile,
              userDataProvider.id,
              prefs.getString('header'));
          asyncProvider.changeAsynccall();

          if (userDataProvider.hasRecoveryQuestions) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Dashboard()));
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          }
        }
      } else {
        asyncProvider.changeAsynccall();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        displaysnackbar(prefs.getString('loginstatus') ?? '');
        prefs.remove('loginstatus');
      }
    } catch (e) {
      print(e);
    }
  }

  _displaySocialMediaIcons() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => facebookLogin(),
            child: _displayicon('facebook'),
          ),
          const SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () => googleLogin(),
            child: _displayicon('google'),
          ),
          const SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () => linkedinLogin(),
            child: _displayicon('linkedin'),
          ),
          const SizedBox(
            width: 20,
          ),
          _displayicon('twitter'),
          const SizedBox(
            width: 20,
          ),
          Platform.isIOS
              ? InkWell(
                  onTap: () => appleLogin(),
                  child: _displayicon('apple'),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  _displayicon(String s) {
    return Container(
      height: 45,
      width: 45,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: kbackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          'logos/$s.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Future<void> facebookLogin() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (result.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken? accessToken = result.accessToken;
        checkSocialLogin(accessToken!.userId);
        break;
      case FacebookLoginStatus.cancel:
        displaysnackbar('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        displaysnackbar('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.error}');
        break;
    }
  }

  googleLogin() async {
    try {
      _currentUser = (await _googleSignIn.signIn())!;
      checkSocialLogin(_currentUser.id);
      print(_currentUser);
    } catch (err) {
      print(err.toString());
    }
  }

  linkedinLogin() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LinkedInUserWidget(
                  redirectUrl: linkedInredirectUrl,
                  clientId: linkedInclientId,
                  clientSecret: linkedInclientSecret,
                  onGetUserProfile: (linkedInUser) async {
                    Map<String, dynamic> postJson = {
                      "user_id": linkedInUser.user.userId,
                      "email": linkedInUser.user.email!.elements!.isEmpty
                          ? null
                          : linkedInUser.user.email!.elements![0].handleDeep!
                              .emailAddress,
                      "name":
                          '${linkedInUser.user.firstName!.localized!.label} ${linkedInUser.user.lastName!.localized!.label}',
                      "token": linkedInUser.user.token.accessToken,
                      "expires_in": linkedInUser.user.token.expiresIn
                    };
                    print(postJson);
                    LinkedinData linkedinData = LinkedinData.fromJson(postJson);
                    print(linkedinData.email);
                    checkSocialLogin(linkedinData.userId);
                    Navigator.pop(context);
                  },
                  onError: (error) async {
                    print('Error description: ${error.exception} ');
                  },
                )));
  }

  appleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          //AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
          clientId: 'com.smartseaman.smartseaman.sia',
          redirectUri: Uri.parse(
            'https://smart-seamen.firebaseapp.com/__/auth/handler',
          ),
        ));
    print('Apple ID credentials');
    print(credential);
    //email = credential.email;
    //name = credential.givenName;
    String? provideruesrid = credential.userIdentifier;
    if (credential.authorizationCode == 'canceled') {
      print('Cancelled');
    } else {
      checkSocialLogin(provideruesrid);
    }
  }

  void checkSocialLogin(String? userId) async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(LoginScreen(), context);
    SocialMediaCheckProvider socialCheckProvider =
        Provider.of<SocialMediaCheckProvider>(context, listen: false);
    if (await socialCheckProvider.callSocialMediaProviderapi(userId)) {
      UserDetailsProvider userDetailsProvider =
          Provider.of<UserDetailsProvider>(context, listen: false);
      var header =
          Provider.of<SocialMediaCheckProvider>(context, listen: false).header;
      print(header);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('header', header);
      userDetailsProvider.changeUserDetails('', '', '', '', '', '', header);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileScreen()));
    } else {
      displaysnackbar('Please connect your account from profile screen.');
    }
  }
}
