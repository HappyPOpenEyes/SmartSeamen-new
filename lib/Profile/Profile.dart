// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, library_private_types_in_public_api

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:smartseaman/ResumeBuilder/PersonalInformation/IndosNoBloc.dart';

import '../AnimatedText.dart';
import '../DropdownBloc.dart';
import '../DropdownContainer.dart';
import '../EditableVerifiedContainer.dart';
import '../IssuingAuthorityErrorBloc.dart';
import '../NotVerifiedContainer.dart';
import '../Notification/BellIcon.dart';
import '../Payment/PlanScreens.dart';
import '../Payment/TransactionHistory.dart';
import '../Register/CountriesBloc.dart';
import '../ResumeBuilder/PersonalInformation/ExpandedAnimation.dart';
import '../ResumeBuilder/PersonalInformation/Scrollbar.dart';
import '../SearchTextProvider.dart';
import '../SideBar/SideBar.dart';
import '../TextBoxLabel.dart';
import '../VerifiedContainer.dart';
import '../asynccallprovider.dart';
import '../bottomnavigation.dart';
import '../constants.dart';
import 'AccountSecurityQuestionsResponse.dart';
import 'ChangePasswordProvider.dart';
import 'EditPasswordBloc.dart';
import 'EditPersonalBloc.dart';
import 'EditQuestionsBloc.dart';
import 'EmailVerifyBloc.dart';
import 'LinkedinData.dart';
import 'MobileVerifyBloc.dart';
import 'OrientationBloc.dart';
import 'PersonalInfoUpdateProvider.dart';
import 'PostQuestionsProvider.dart';
import 'PostSecurityQuestionsAPI.dart';
import 'ProfilePhotoUpdateProvider.dart';
import 'ProfilePictureBloc.dart';
import 'QuestionsGetProvider.dart';
import 'SecurityQuestionResponse.dart';
import 'SocialMediaConnectProvider.dart';
import 'SocialMediaDisconnectProvider.dart';
import 'SocialMediaStatusBloc.dart';
import 'UserDetailsProvider.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  static final FacebookLogin facebookSignIn = FacebookLogin();
  final _editpersonalBloc = EditPersonalBloc();
  final _editpasswordBloc = EditPasswordBloc();
  final _editquestionsBloc = EditQuestionsBloc();
  final _emailVerifyBloc = EmailVerifyBloc();
  final _mobileVerifyBloc = MobileVerifyBloc();
  static final _formpersonalKey = GlobalKey<FormState>();
  static final _formpasswordKey = GlobalKey<FormState>();
  static final _formsecurityQuestionKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = TextEditingController(),
      alternateemailController = TextEditingController(),
      passwordController = TextEditingController(),
      firstnameController = TextEditingController(),
      lastnameController = TextEditingController(),
      phonenumberController = TextEditingController();
  var oldpassword = "", newpassword = "", confirmpassword = "", header = "";
  List<TextEditingController> questionsController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  List<String> staticquestions = [],
      questionid = [],
      configQuestionid = [],
      configQuestions = [];
  bool obscuretext = true,
      obscurenewtext = true,
      obscureconfirmtext = true,
      isPotrait = true;
  final List<String> errors = [];
  final _oritentationBloc = ChangeOrientationBloc();
  final List<String> _answersList = [];
  final List<SocialMediaStatusBloc> _socialMediaBloc = [
    SocialMediaStatusBloc(),
    SocialMediaStatusBloc(),
    SocialMediaStatusBloc(),
    SocialMediaStatusBloc(),
    SocialMediaStatusBloc()
  ];
  String countryvalue = "";
  final List<String> _questionsValue = ["", "", "", "", ""];
  final _profilePictureBloc = ProfilePictureBloc();
  final List<DropdownBloc> _questionsDropdownBloc = [
    DropdownBloc(),
    DropdownBloc(),
    DropdownBloc(),
    DropdownBloc(),
    DropdownBloc()
  ];
  final List<ResumeErrorIssuingAuthorityBloc> _questionsErrorBloc = [
    ResumeErrorIssuingAuthorityBloc(),
    ResumeErrorIssuingAuthorityBloc(),
    ResumeErrorIssuingAuthorityBloc(),
    ResumeErrorIssuingAuthorityBloc(),
    ResumeErrorIssuingAuthorityBloc()
  ];
  final _dropdownBloc = DropdownBloc();
  final _countriesBloc = PhoneCountriesBloc();
  final _errorCountryCodeBloc = ResumeErrorIssuingAuthorityBloc();
  final String linkedInredirectUrl =
      'https://api.smartseaman.devbyopeneyes.com/public/auth';
  final String linkedInclientId = '77fxzedu13ta3n';
  final String linkedInclientSecret = 'DLNgYytiwp1Jg51Q';
  late GoogleSignInAccount _currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  late AnimationController _controller, _animationController;
  static final DateFormat formatter = DateFormat('dd MMMM, yyyy');
  final List<String> _questionIds = ["", "", "", "", ""];
  final _showCountryDropDownBloc = IndosNoBloc();
  final List<IndosNoBloc> _showQuestionsDropDownBloc = [
    IndosNoBloc(),
    IndosNoBloc(),
    IndosNoBloc(),
    IndosNoBloc(),
    IndosNoBloc()
  ];
  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void initState() {
    getdata();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _editpersonalBloc.dispose();
    _editpasswordBloc.dispose();
    _editquestionsBloc.dispose();
    _emailVerifyBloc.dispose();
    _mobileVerifyBloc.dispose();
    _profilePictureBloc.dispose();
    _countriesBloc.dispose();
    _dropdownBloc.dispose();
    _errorCountryCodeBloc.dispose();
    _oritentationBloc.dispose();
    for (int i = 0; i < 4; i++) {
      _socialMediaBloc[i].dispose();
    }
    for (int i = 0; i < 5; i++) {
      _questionsDropdownBloc[i].dispose();
      _questionsErrorBloc[i].dispose();
      _showQuestionsDropDownBloc[i].dispose();
    }
    _showCountryDropDownBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    calculateShortestSide(context);
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldkey,
        drawer: Drawer(
          child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.57,
              child: const Sidebar()),
        ),
        bottomNavigationBar: BottomNavigationClass(4),
        body: ModalProgressHUD(
            inAsyncCall: Provider.of<AsyncCallProvider>(context).isinasynccall,
            // demo of some additional parameters
            opacity: 0.5,
            progressIndicator: const CircularProgressIndicator(
                backgroundColor: kbackgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
            child: OrientationBuilder(builder: (context, orientation) {
              orientation == Orientation.portrait
                  ? _oritentationBloc.eventChangeOrientationSink
                      .add(ChangeOrientationAction.True)
                  : _oritentationBloc.eventChangeOrientationSink
                      .add(ChangeOrientationAction.False);
              return StreamBuilder(
                  initialData: true,
                  stream: _oritentationBloc.stateChangeOrientationStrean,
                  builder: (context, orientationSnapshot) {
                    return SingleChildScrollView(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Stack(
                            children: [
                              Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  SizedBox(
                                      width: double.infinity,
                                      child:
                                          Image.asset("images/login_bg.jpg")),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.065),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _scaffoldkey.currentState!
                                                .openDrawer();
                                          },
                                          child: Image.asset(
                                            'images/list.png',
                                            color: kbackgroundColor,
                                            height:
                                                orientationSnapshot.data != null
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.035
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.035,
                                          ),
                                        ),
                                        const Spacer(),
                                        BellIcon(
                                          isProfile: true,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      //left: 6.0,
                                      //right: 6.0,
                                      top: orientationSnapshot.data != null
                                          ? MediaQuery.of(context).size.height *
                                              0.205
                                          : MediaQuery.of(context).size.height *
                                              0.305,
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
                                            // height:
                                            //     MediaQuery.of(context).size.height * 0.84,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                //left: MediaQuery.of(context).size.width * 0.32,
                                                //right: 8.0,
                                                top:
                                                    orientationSnapshot.data !=
                                                            null
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.10
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.15,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Provider.of<GetQuestionsProvider>(
                                                              context,
                                                              listen: false)
                                                          .hasQuestions
                                                      ? const SizedBox()
                                                      : AnimatedText(
                                                          animationController:
                                                              _animationController,
                                                          index: 1),
                                                  StreamBuilder(
                                                    initialData: false,
                                                    stream: _editpersonalBloc
                                                        .stateEditPersonalStrean,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        if (_editpersonalBloc
                                                            .isedited) {
                                                          _countriesBloc
                                                              .eventCountriesSink
                                                              .add(
                                                                  PhoneCountriesAction
                                                                      .Post);

                                                          return _displayeditablepersonalinfo(
                                                              _oritentationBloc
                                                                  .isPotrait);
                                                        } else {
                                                          return _displayPersonalCard(
                                                              _oritentationBloc
                                                                  .isPotrait);
                                                        }
                                                      } else {
                                                        return _displayPersonalCard(
                                                            _oritentationBloc
                                                                .isPotrait);
                                                      }
                                                    },
                                                  ),
                                                  _displaysocialmediaicons(
                                                      _oritentationBloc
                                                          .isPotrait),
                                                  StreamBuilder(
                                                    initialData: false,
                                                    stream: _editpasswordBloc
                                                        .stateEditPasswordStrean,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        if (_editpasswordBloc
                                                            .isedited) {
                                                          return _displayeditablepasswordinfo();
                                                        } else {
                                                          return _displayPasswordCard(
                                                              _oritentationBloc
                                                                  .isPotrait);
                                                        }
                                                      } else {
                                                        return _displayPasswordCard(
                                                            _oritentationBloc
                                                                .isPotrait);
                                                      }
                                                    },
                                                  ),
                                                  StreamBuilder(
                                                    initialData: false,
                                                    stream: _editquestionsBloc
                                                        .stateEditQuestionsStrean,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        if (_editquestionsBloc
                                                            .isedited) {
                                                          return _displayeditablequestionsinfo();
                                                        } else {
                                                          return _displaySecurityQuestionCard(
                                                              _oritentationBloc
                                                                  .isPotrait);
                                                        }
                                                      } else {
                                                        return _displaySecurityQuestionCard(
                                                            _oritentationBloc
                                                                .isPotrait);
                                                      }
                                                    },
                                                  ),
                                                  _displayPaymentCard(
                                                      orientationSnapshot.data),
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
                                      top: MediaQuery.of(context).size.height *
                                          0.14,
                                    ),
                                    child: Center(
                                      child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          StreamBuilder(
                                            initialData: Provider.of<
                                                                GetQuestionsProvider>(
                                                            context,
                                                            listen: false)
                                                        // ignore: unnecessary_null_comparison
                                                        .photo ==
                                                    null
                                                ? false
                                                : Provider.of<GetQuestionsProvider>(
                                                            context,
                                                            listen: false)
                                                        .photo!
                                                        .isEmpty
                                                    ? false
                                                    : true,
                                            stream: _profilePictureBloc
                                                .stateProfilePictureStrean,
                                            builder: (context, snapshot) {
                                              return Container(
                                                width:
                                                    orientationSnapshot.data !=
                                                            null
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.14
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.14,
                                                height:
                                                    orientationSnapshot.data !=
                                                            null
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.14
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.14,
                                                decoration:
                                                    const ShapeDecoration(
                                                        shape: CircleBorder(),
                                                        color: Colors.white),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: DecoratedBox(
                                                    decoration: ShapeDecoration(
                                                        shape:
                                                            const CircleBorder(),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                checkImage())),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          InkWell(
                                              onTap: () {
                                                _showPickOptionsDialog(context);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: kbackgroundColor,
                                                    border: Border.all(
                                                      color: Colors.black,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: const Icon(
                                                  Icons.create,
                                                  color: kBluePrimaryColor,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            })),
      ),
    );
  }

  checkImage() {
    if (_profilePictureBloc.image == null) {
      if (Provider.of<GetQuestionsProvider>(context, listen: false).photo ==
          null) {
        return const AssetImage('images/user.jpg');
      } else {
        if (Provider.of<GetQuestionsProvider>(context, listen: false)
            .photo!
            .isEmpty) {
          return NetworkImage(
              '$imageapiurl/profile/${Provider.of<GetQuestionsProvider>(context, listen: false).photo}');
        } else {
          return const AssetImage('images/user.jpg');
        }
      }
    } else {
      FileImage(File(_profilePictureBloc.image!.path));
    }
  }

  _displayPersonalCard(bool isPotrait) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              _displaycardheader('Personal', isPotrait),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: _displaystatictext(
                          'First Name',
                          Provider.of<UserDetailsProvider>(context)
                                  .fname
                                  .isEmpty
                              ? "-"
                              : Provider.of<UserDetailsProvider>(context).fname,
                          isPotrait),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    _displaystatictext(
                        'Last Name',
                        Provider.of<UserDetailsProvider>(context).lname.isEmpty
                            ? "-"
                            : Provider.of<UserDetailsProvider>(context).lname,
                        isPotrait),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      _displaystatictext(
                          'Email',
                          Provider.of<UserDetailsProvider>(context)
                                  .email
                                  .isEmpty
                              ? "-"
                              : Provider.of<UserDetailsProvider>(context).email,
                          isPotrait),
                      const Spacer(),
                      VerifiedContainer(
                        width: MediaQuery.of(context).size.width * 0.07,
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      _displaystatictext(
                          'Phone Number',
                          Provider.of<UserDetailsProvider>(context)
                                  .phonenumber
                                  .isEmpty
                              ? "-"
                              : Provider.of<UserDetailsProvider>(context)
                                  .phonenumber,
                          isPotrait),
                      const Spacer(),
                      VerifiedContainer(
                        width: MediaQuery.of(context).size.width * 0.07,
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              Provider.of<UserDetailsProvider>(context).alternateemail != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          _displaystatictext(
                              'Alternate Email',
                              Provider.of<UserDetailsProvider>(context)
                                      .alternateemail
                                      .isEmpty
                                  ? "-"
                                  : Provider.of<UserDetailsProvider>(context)
                                      .alternateemail,
                              isPotrait),
                        ],
                      ))
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  _displayPasswordCard(bool isPotrait) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _displaycardheader('Password', isPotrait),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    _displaystatictext('Password', '*********', isPotrait),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displaySecurityQuestionCard(bool isPotrait) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              _displaycardheader('Security Questions', isPotrait),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          if (staticquestions.isEmpty) {
                            return _displaystatictext(
                                //'Security Question ' + (index + 1).toString(),
                                'Question Text ${index + 1}',
                                'Answer Text ${index + 1}',
                                isPotrait);
                          } else {
                            return _displaystatictext(
                                //'Security Question ' + (index + 1).toString(),
                                staticquestions[index],
                                _answersList.isEmpty
                                    ? 'NA'
                                    : _answersList[index],
                                isPotrait);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displaysocialmediaicons(bool isPotrait) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Connect with',
                style: TextStyle(
                    color: kBluePrimaryColor,
                    fontSize: isPotrait
                        ? checkDeviceSize(context)
                            ? MediaQuery.of(context).size.width * 0.05
                            : MediaQuery.of(context).size.width * 0.045
                        : MediaQuery.of(context).size.height * 0.055,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () => facebookLogin(0),
                          child: _displaysocialicon('facebook', 0, isPotrait),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () => linkedinLogin(1),
                          child: _displaysocialicon('linkedin', 1, isPotrait),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () => googleLogin(2),
                          child: _displaysocialicon('google', 2, isPotrait),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () => print('twitterLogin(3)'),
                          child: _displaysocialicon('twitter', 3, isPotrait),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Platform.isIOS
                  ? Center(
                      child: InkWell(
                        onTap: () => appleLogin(4),
                        child: _displaysocialicon('apple', 4, isPotrait),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  _displayicon(String s) {
    return Container(
      height: 35,
      width: 35,
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
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          'logos/$s.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  _displaycardheader(String s, bool isPotrait) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: isPotrait
            ? checkDeviceSize(context)
                ? MediaQuery.of(context).size.height * 0.033
                : MediaQuery.of(context).size.height * 0.045
            : MediaQuery.of(context).size.width * 0.032,
        child: Row(
          children: [
            Text(s,
                style: TextStyle(
                    color: kBluePrimaryColor,
                    fontSize: isPotrait
                        ? checkDeviceSize(context)
                            ? MediaQuery.of(context).size.width * 0.05
                            : MediaQuery.of(context).size.width * 0.045
                        : MediaQuery.of(context).size.height * 0.055,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              width: 10,
            ),
            const VerticalDivider(
              thickness: 1.5,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.create,
              size: MediaQuery.of(context).size.height * 0.024,
              color: kgreenPrimaryColor,
            ),
            InkWell(
              onTap: () {
                if (s == "Personal") {
                  _editpersonalBloc.eventEditPersonalSink
                      .add(EditPersonalAction.True);
                } else if (s == "Password") {
                  _editpasswordBloc.eventEditPasswordSink
                      .add(EditPasswordAction.True);
                } else if (s == "Security Questions") {
                  _editquestionsBloc.eventEditQuestionsSink
                      .add(EditQuestionsAction.True);
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PlanScreens()));
                }
              },
              child: Text(
                  s == "Current Package"
                      ? Provider.of<GetQuestionsProvider>(context,
                                  listen: false)
                              .planId
                              .isEmpty
                          ? 'Buy Plan'
                          : 'Change Plan'
                      : s != "Security Questions"
                          ? 'Edit'
                          : Provider.of<GetQuestionsProvider>(context,
                                      listen: false)
                                  .hasQuestions
                              ? 'Edit'
                              : 'Add',
                  style: TextStyle(
                      color: kgreenPrimaryColor,
                      fontSize: isPotrait
                          ? MediaQuery.of(context).size.width * 0.042
                          : MediaQuery.of(context).size.height * 0.042,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  _displaystatictext(String label, String text, bool isPotrait) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: isPotrait
                  ? MediaQuery.of(context).size.width * 0.04
                  : MediaQuery.of(context).size.height * 0.04,
              fontWeight: FontWeight.w600),
        ),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: isPotrait
                ? MediaQuery.of(context).size.width * 0.038
                : MediaQuery.of(context).size.height * 0.038,
          ),
        ),
      ],
    );
  }

  _displayeditablepersonalinfo(bool isPotrait) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formpersonalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Personal',
                      style: TextStyle(
                          color: kBluePrimaryColor,
                          fontSize: isPotrait
                              ? MediaQuery.of(context).size.width * 0.055
                              : MediaQuery.of(context).size.height * 0.055,
                          fontWeight: FontWeight.bold)),
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
                  _buildFnameTF(),
                  const SizedBox(height: 14.0),
                  _buildLnameTF(),
                  const SizedBox(height: 14.0),
                  _buildEmailTF(true),
                  StreamBuilder(
                    initialData: false,
                    stream: _emailVerifyBloc.stateEmailVerifyStrean,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 0, top: 3),
                          child: Row(
                            children: [
                              const Spacer(),
                              _displaynonverifiedContainer(0)
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(left: 35, top: 3),
                          child: Row(
                            children: [EditableVerifiedContainer()],
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 14.0),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Container(
                          //height: 80,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              child: Column(
                                children: [
                                  _buildcountrydropdown(),
                                  _displayerrortext(),
                                  _buildPhoneNumberTF(),
                                ],
                              )),
                        ),
                      ),
                      TextBoxLabel('Contact Number')
                    ],
                  ),
                  StreamBuilder(
                    initialData: false,
                    stream: _mobileVerifyBloc.stateMobileVerifyStrean,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 35, top: 2),
                          child: Row(
                            children: [_displaynonverifiedContainer(1)],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(left: 35, top: 2),
                          child: Row(
                            children: [EditableVerifiedContainer()],
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 14.0),
                  _buildEmailTF(false),
                  const SizedBox(height: 14.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        initialData: false,
                        stream: _emailVerifyBloc.stateEmailVerifyStrean,
                        builder: (context, snapshot) {
                          if (_emailVerifyBloc.emailVerifyvalue) {
                            return ElevatedButton(
                              onPressed: null,
                              style: buttonStyle(),
                              child: const Text(
                                'Save',
                                style: TextStyle(color: kbackgroundColor),
                              ),
                            );
                          } else {
                            return StreamBuilder(
                              initialData: false,
                              stream: _mobileVerifyBloc.stateMobileVerifyStrean,
                              builder: (context, snapshot) {
                                if (_mobileVerifyBloc.mobileVerifyvalue) {
                                  return ElevatedButton(
                                    onPressed: null,
                                    style: buttonStyle(),
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(color: kbackgroundColor),
                                    ),
                                  );
                                } else {
                                  return ElevatedButton(
                                    onPressed: () {
                                      if (_formpersonalKey.currentState!
                                          .validate()) {
                                        _formpersonalKey.currentState!.save();
                                        callprofileapi();
                                      }
                                    },
                                    style: buttonStyle(),
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(color: kbackgroundColor),
                                    ),
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          _editpersonalBloc.eventEditPersonalSink
                              .add(EditPersonalAction.False);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              color: kgreenPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
              ],
              cursorColor: kgreenPrimaryColor,
              controller: firstnameController,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter your first name');
                }
                return null;
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
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
              ],
              cursorColor: kgreenPrimaryColor,
              controller: lastnameController,
              keyboardType: TextInputType.name,
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

  _buildPhoneNumberTF() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        color: Colors.white,
        child: TextFormField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          ],
          cursorColor: kgreenPrimaryColor,
          maxLength: 15,
          controller: phonenumberController,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: kblackPrimaryColor,
            fontFamily: 'OpenSans',
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kPhoneNumberNullError);
            } else if (value.length > 4) {
              removeError(error: kPhoneNumberLengthError);
            }
            if (value !=
                Provider.of<UserDetailsProvider>(context, listen: false)
                    .phonenumber) {
              _mobileVerifyBloc.eventMobileVerifySink
                  .add(MobileVerifyAction.True);
            } else if (value ==
                Provider.of<UserDetailsProvider>(context, listen: false)
                    .phonenumber) {
              _mobileVerifyBloc.eventMobileVerifySink
                  .add(MobileVerifyAction.False);
            }
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return kPhoneNumberNullError;
              //addError(error: kEmailNullError);
            } else if (value.length < 4) {
              return kPhoneNumberLengthError;
              //addError(error: kInvalidEmailError);

            }
            return null;
          },
          decoration: const InputDecoration(
              counterText: "",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 28),
              border: OutlineInputBorder(
                //floatingLabelBehavior: FloatingLabelBehavior.always,
                borderSide: BorderSide(),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              hintText: 'Enter your Phone Number',
              hintStyle: hintstyle),
        ),
      ),
    );
  }

  Widget _buildEmailTF(bool isPrimary) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller:
                  isPrimary ? emailController : alternateemailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty && isPrimary) {
                  removeError(error: kEmailNullError);
                } else if (value.contains('@') &&
                    emailValidatorRegExp.hasMatch(value)) {
                  removeError(error: kInvalidEmailError);
                }
                if (isPrimary &&
                    value !=
                        Provider.of<UserDetailsProvider>(context, listen: false)
                            .email) {
                  _emailVerifyBloc.eventEmailVerifySink
                      .add(EmailVerifyAction.True);
                } else if (isPrimary &&
                    value ==
                        Provider.of<UserDetailsProvider>(context, listen: false)
                            .email) {
                  _emailVerifyBloc.eventEmailVerifySink
                      .add(EmailVerifyAction.False);
                }
                return;
              },
              validator: (value) {
                if (value!.isEmpty && isPrimary) {
                  return kEmailNullError;
                  //addError(error: kEmailNullError);

                } else if (value.contains('@') &&
                    !emailValidatorRegExp.hasMatch(value)) {
                  return kInvalidEmailError;
                  //addError(error: kInvalidEmailError);

                }
                return null;
              },
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  //floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  hintText: isPrimary
                      ? 'Enter your Email'
                      : 'Enter your alternate Email',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel(isPrimary ? 'Email' : 'Alternate Email')
      ],
    );
  }

  Widget _displayeditablepasswordinfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formpasswordKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Password',
                      style: TextStyle(
                          color: kBluePrimaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.055,
                          fontWeight: FontWeight.bold)),
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
                  _buildPasswordTF(),
                  const SizedBox(
                    height: 10,
                  ),
                  buildnewPasswordField(),
                  const SizedBox(
                    height: 10,
                  ),
                  buildConformPassFormField(),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(height: 14.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formpasswordKey.currentState!.validate()) {
                            _formpasswordKey.currentState!.save();
                            callchangepasswordapi();
                          }
                        },
                        style: buttonStyle(),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: kbackgroundColor),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          _editpasswordBloc.eventEditPasswordSink
                              .add(EditPasswordAction.False);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              color: kgreenPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildcountrydropdown() {
    return StreamBuilder(
      stream: _countriesBloc.stateCountriesStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (_countriesBloc.countryId.isNotEmpty) {
            if (Provider.of<GetQuestionsProvider>(context, listen: false)
                .countryid
                .isNotEmpty) {
              countryvalue = _countriesBloc.countrycode[_countriesBloc.countryId
                  .indexOf(
                      Provider.of<GetQuestionsProvider>(context, listen: false)
                          .countryid)];
              _dropdownBloc.setdropdownvalue(countryvalue);
              _dropdownBloc.eventDropdownSink.add(DropdownAction.Update);
            } else {
              countryvalue = _countriesBloc.countrycode[0];
              _dropdownBloc.setdropdownvalue(countryvalue);
              _dropdownBloc.eventDropdownSink.add(DropdownAction.Update);
            }
          }
          return Padding(
            padding: const EdgeInsets.all(6),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey),
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
                            title: countryvalue.isNotEmpty
                                ? countryvalue
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
                                          padding: const EdgeInsets.all(8.0),
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
                                                    countryvalue = Provider.of<
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
                                                        : _countriesBloc
                                                                .countrycode[
                                                            listindex];

                                                    _dropdownBloc.setdropdownvalue(
                                                        Provider.of<SearchChangeProvider>(
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
                                                                listindex]);
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
                                                                  listen: false)
                                                              .searchList
                                                              .isNotEmpty
                                                          ? Provider.of<SearchChangeProvider>(
                                                                      context,
                                                                      listen: false)
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
        } else {
          return const CircularProgressIndicator(
              backgroundColor: kbackgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor));
        }
      },
    );
  }

  _displayerrortext() {
    return StreamBuilder(
      initialData: false,
      stream: _errorCountryCodeBloc.stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && _errorCountryCodeBloc.showtext) {
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
      },
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
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: kPassNullError);
                } else if (value.length >= 8) {
                  removeError(error: kShortPassError);
                }
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

  buildnewPasswordField() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: TextFormField(
            obscureText: obscurenewtext,
            cursorColor: Colors.black,
            onSaved: (newValue) => newpassword = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              newpassword = value;
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
        TextBoxLabel('New Password')
      ],
    );
  }

  buildConformPassFormField() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: TextFormField(
            obscureText: obscureconfirmtext,
            onSaved: (newValue) => confirmpassword = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.isNotEmpty && newpassword == confirmpassword) {
                removeError(error: kMatchPassError);
              }
              confirmpassword = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return kPassNullError;
                //addError(error: kPassNullError);

              } else if ((newpassword != value)) {
                return kMatchPassError;
                //addError(error: kMatchPassError);

              }
              return null;
            },
            style: const TextStyle(
              color: kblackPrimaryColor,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
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
        TextBoxLabel('Confirm Password')
      ],
    );
  }

  Widget _displayeditablequestionsinfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formsecurityQuestionKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Security Questions',
                      style: TextStyle(
                          color: kBluePrimaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.055,
                          fontWeight: FontWeight.bold)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                  for (var i = 0; i < 5; i++) _buildQuestionTF(i),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formsecurityQuestionKey.currentState!
                              .validate()) {
                            _formsecurityQuestionKey.currentState!.save();
                            if (checkquestiondata()) callpostquestionsapi();
                          } else {
                            bool isValid = checkquestiondata();
                          }
                        },
                        style: buttonStyle(),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: kbackgroundColor),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          _editquestionsBloc.eventEditQuestionsSink
                              .add(EditQuestionsAction.False);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              color: kgreenPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildQuestionTF(int i) {
    return Card(
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuestionsDropdown(i),
            _buildQuestionsErrorText(i),
            Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                      ],
                      cursorColor: kgreenPrimaryColor,
                      controller: questionsController[i],
                      keyboardType: TextInputType.name,
                      style: const TextStyle(
                        color: kblackPrimaryColor,
                        fontFamily: 'OpenSans',
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: 'Please enter your answer');
                        }
                        return;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your answer';
                          //addError(error: kEmailNullError);

                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 32),
                          //floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Enter your Answer',
                          hintStyle: hintstyle),
                    ),
                  ),
                ),
                TextBoxLabel('Answer')
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header')!;

    _countriesBloc.eventCountriesSink.add(PhoneCountriesAction.Post);
    if (prefs.getString('VerifyOTP') != null) {
      displaysnackbar(prefs.getString('VerifyOTP') ?? '');
      prefs.remove('VerifyOTP');
    }
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }

    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const ProfileScreen(), context);

    GetQuestionsProvider getQuestionsProvider =
        Provider.of<GetQuestionsProvider>(context, listen: false);
    String questionresponse =
        await getQuestionsProvider.callgetAccountQuestionsApi(header);
    if (Provider.of<GetQuestionsProvider>(context, listen: false).isGoogle) {
      _socialMediaBloc[2].statusValue = true;
      _socialMediaBloc[2]
          .eventSocialMediaStatusSink
          .add(SocialMediaStatusAction.True);
    }

    if (Provider.of<GetQuestionsProvider>(context, listen: false).isFacebook) {
      _socialMediaBloc[0]
          .eventSocialMediaStatusSink
          .add(SocialMediaStatusAction.True);
    }

    if (Provider.of<GetQuestionsProvider>(context, listen: false).isLinkedin) {
      _socialMediaBloc[1]
          .eventSocialMediaStatusSink
          .add(SocialMediaStatusAction.True);
    }

    if (Provider.of<GetQuestionsProvider>(context, listen: false).isTwitter) {
      _socialMediaBloc[3]
          .eventSocialMediaStatusSink
          .add(SocialMediaStatusAction.True);
    }

    if (Provider.of<GetQuestionsProvider>(context, listen: false).isApple) {
      _socialMediaBloc[4]
          .eventSocialMediaStatusSink
          .add(SocialMediaStatusAction.True);
    }

    UserDetailsProvider userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    userDetailsProvider.changeUserDetails(
        Provider.of<GetQuestionsProvider>(context, listen: false).firstname,
        Provider.of<GetQuestionsProvider>(context, listen: false).lastname,
        Provider.of<GetQuestionsProvider>(context, listen: false).email,
        Provider.of<GetQuestionsProvider>(context, listen: false)
            .alternateemail,
        Provider.of<GetQuestionsProvider>(context, listen: false).mobile,
        Provider.of<GetQuestionsProvider>(context, listen: false).id,
        header);
    firstnameController = TextEditingController(
        text: Provider.of<GetQuestionsProvider>(context, listen: false)
            .firstname);
    lastnameController = TextEditingController(
        text:
            Provider.of<GetQuestionsProvider>(context, listen: false).lastname);
    phonenumberController = TextEditingController(
        text: Provider.of<GetQuestionsProvider>(context, listen: false).mobile);
    emailController = TextEditingController(
        text: Provider.of<GetQuestionsProvider>(context, listen: false).email);
    alternateemailController = TextEditingController(
        text: Provider.of<GetQuestionsProvider>(context, listen: false)
            .alternateemail);
    if (getQuestionsProvider.photo != null) {
      if (getQuestionsProvider.photo!.isNotEmpty) {
        _profilePictureBloc.eventProfilePictureSink
            .add(ProfilePictureAction.True);
      }
    } else {
      _profilePictureBloc.eventProfilePictureSink
          .add(ProfilePictureAction.False);
    }

    asyncProvider.changeAsynccall();

    if (prefs.getBool('HasQuestions')!) {
      AccountSecurityQuestionsResponse accountSecurityQuestionsResponse =
          accountSecurityQuestionsResponseFromJson(questionresponse);
      for (int i = 0;
          i < accountSecurityQuestionsResponse.data.getuser.length;
          i++) {
        staticquestions
            .add(accountSecurityQuestionsResponse.data.getuser[i].question);
        questionid.add(accountSecurityQuestionsResponse
            .data.getuser[i].questionId
            .toString());
        _answersList
            .add(accountSecurityQuestionsResponse.data.getuser[i].answer);
        questionsController[i].text =
            accountSecurityQuestionsResponse.data.getuser[i].answer;
        if (Provider.of<GetQuestionsProvider>(context, listen: false)
            .hasQuestions) {
          if (_questionIds[i].isEmpty) {
            _questionIds[i] =
                questionid[staticquestions.indexOf(staticquestions[i])];
            _questionsDropdownBloc[i].dropdownvalue = staticquestions[i];
            _questionsDropdownBloc[i].setdropdownvalue(staticquestions[i]);
            _questionsDropdownBloc[i]
                .eventDropdownSink
                .add(DropdownAction.Update);
            _questionsValue[i] = staticquestions[i];
          }
        }
      }
      String response =
          await Provider.of<GetQuestionsProvider>(context, listen: false)
              .callgetquestionsapi(header);
      SecurityQuestionResponse questions =
          securityQuestionResponseFromJson(response);
      for (int i = 0; i < questions.data.length; i++) {
        configQuestions.add(questions.data[i].displayText);
        configQuestionid.add(questions.data[i].id.toString());
      }
    } else {
      SecurityQuestionResponse questions =
          securityQuestionResponseFromJson(questionresponse);
      for (int i = 0; i < questions.data.length; i++) {
        configQuestions.add(questions.data[i].displayText);
        configQuestionid.add(questions.data[i].id.toString());
      }
    }
  }

  void callchangepasswordapi() async {
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    ChangePasswordProvider changeprovider =
        Provider.of<ChangePasswordProvider>(context, listen: false);
    if (await changeprovider.callchangepasswordapi(
        Provider.of<UserDetailsProvider>(context, listen: false).userid,
        passwordController.text,
        newpassword,
        header)) {
      asyncProvider.changeAsynccall();
      displaysnackbar('Password changed successfully.');
      _editpasswordBloc.eventEditPasswordSink.add(EditPasswordAction.False);
    } else {
      asyncProvider.changeAsynccall();
      displaysnackbar('Something went wrong.');
    }
  }

  void callpostquestionsapi() async {
    List<String> postanswers = [];
    for (int i = 0; i < questionsController.length; i++) {
      postanswers.add(questionsController[i].text);
    }
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    PostQuestionsProvider postQuestionsProvider =
        Provider.of<PostQuestionsProvider>(context, listen: false);

    List<Question> questionlist = [];
    print(_questionIds);
    for (int i = 0; i < 5; i++) {
      questionlist.add(Question(
          questionId: _questionIds[i], answer: questionsController[i].text));
    }
    if (await postQuestionsProvider.callpostquestionsapi(
        Provider.of<UserDetailsProvider>(context, listen: false).userid,
        questionlist,
        header)) {
      _editquestionsBloc.eventEditQuestionsSink.add(EditQuestionsAction.False);
      _editquestionsBloc.isedited = false;
      cleardata();
      getdata();
      asyncProvider.changeAsynccall();
      displaysnackbar('Security Questions sucessfully posted');
    } else {
      asyncProvider.changeAsynccall();
      displaysnackbar('Something went wrong');
    }
  }

  void callprofileapi() async {
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PersonalInfoUpdateProvider personalInfoUpdateProvider =
        Provider.of<PersonalInfoUpdateProvider>(context, listen: false);
    if (await personalInfoUpdateProvider.callpostprofileapi(
        firstnameController.text,
        lastnameController.text,
        phonenumberController.text,
        emailController.text,
        alternateemailController.text,
        Provider.of<UserDetailsProvider>(context, listen: false).userid,
        header)) {
      prefs.setString(
        'lastname',
        lastnameController.text,
      );
      prefs.setString(
        'email',
        emailController.text,
      );
      prefs.setString(
        'mobile',
        phonenumberController.text,
      );
      prefs.setString(
        'userid',
        Provider.of<UserDetailsProvider>(context, listen: false).userid,
      );

      prefs.setString(
        'firstname',
        firstnameController.text,
      );
      UserDetailsProvider userDetailsProvider =
          Provider.of<UserDetailsProvider>(context, listen: false);
      userDetailsProvider.changeUserDetails(
          firstnameController.text,
          lastnameController.text,
          emailController.text,
          alternateemailController.text,
          phonenumberController.text,
          Provider.of<UserDetailsProvider>(context, listen: false).userid,
          header);

      _editpersonalBloc.eventEditPersonalSink.add(EditPersonalAction.False);
      asyncProvider.changeAsynccall();
      displaysnackbar('Profile updated successfully.');
    } else {
      asyncProvider.changeAsynccall();
      displaysnackbar('Something went wrong');
    }
  }

  _displaysocialicon(String s, int index, bool isPotrait) {
    return StreamBuilder(
      initialData: false,
      stream: _socialMediaBloc[index].stateSocialMediaStatusStrean,
      builder: (context, snapshot) => SizedBox(
        height: isPotrait
            ? MediaQuery.of(context).size.height * 0.05
            : MediaQuery.of(context).size.width * 0.05,
        width: isPotrait
            ? MediaQuery.of(context).size.width * 0.38
            : MediaQuery.of(context).size.height * 0.38,
        child: Row(
          children: [
            _displayicon(s),
            const SizedBox(
              width: 5,
            ),
            const VerticalDivider(
              thickness: 0.4,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              snapshot.hasData && _socialMediaBloc[index].statusValue
                  ? 'Disconnect'
                  : 'Connect',
              style: TextStyle(
                  color: kblackPrimaryColor,
                  fontSize: isPotrait
                      ? MediaQuery.of(context).size.width * 0.038
                      : MediaQuery.of(context).size.height * 0.038,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  _displaynonverifiedContainer(int value) {
    return Row(
      children: [
        NotVerifiedContaier(
            value: value,
            email: emailController.text,
            phone: phonenumberController.text),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        Text('${phonenumberController.text.length} / 15')
      ],
    );
  }

  void _showPickOptionsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: kBluePrimaryColor,
                    child: ListTile(
                      leading: const Icon(
                        Icons.folder,
                        color: kbackgroundColor,
                      ),
                      title: const Text(
                        'Pick from Gallery',
                        style: TextStyle(color: kbackgroundColor),
                      ),
                      onTap: () {
                        _loadPicker(ImageSource.gallery);
                      },
                    ),
                  ),
                  const Divider(),
                  Container(
                    color: kBluePrimaryColor,
                    child: ListTile(
                      leading: const Icon(
                        Icons.camera_alt_outlined,
                        color: kbackgroundColor,
                      ),
                      title: const Text(
                        'Take a Picture',
                        style: TextStyle(color: kbackgroundColor),
                      ),
                      onTap: () {
                        _loadPicker(ImageSource.camera);
                      },
                    ),
                  ),
                ],
              ),
            ));
  }

  _loadPicker(ImageSource source) async {
    // ignore: invalid_use_of_visible_for_testing_member
    XFile? picked = await ImagePicker.platform.getImage(source: source);
    _cropImage(picked!);
    Navigator.pop(context);
  }

  _cropImage(XFile picked) async {
    CroppedFile? cropped = await ImageCropper.platform.cropImage(
      sourcePath: picked.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio4x3,
      ],
      maxWidth: 800,
    );
    _profilePictureBloc.image = cropped!;
    _profilePictureBloc.eventProfilePictureSink.add(ProfilePictureAction.True);
    String imagepath = cropped.path;
    updateprofilepic(imagepath);
  }

  void updateprofilepic(String filename) async {
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    asyncProvider.changeAsynccall();
    ProfilePictureProvider personalProfileProvider =
        Provider.of<ProfilePictureProvider>(context, listen: false);
    if (await personalProfileProvider.callProfilePictureapi(
        Provider.of<UserDetailsProvider>(context, listen: false).userid,
        filename,
        header)) {
      asyncProvider.changeAsynccall();
      displaysnackbar('Profile picture updated successfully.');
    } else {
      asyncProvider.changeAsynccall();
      displaysnackbar(personalProfileProvider.error);
    }
  }

  Future<void> facebookLogin(int index) async {
    if (_socialMediaBloc[index].statusValue) {
      _displayDisconnectConfirm(index);
    } else {
      final FacebookLoginResult result =
          await facebookSignIn.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
        FacebookPermission.userFriends
      ]);
      switch (result.status) {
        case FacebookLoginStatus.success:
          final FacebookAccessToken? accessToken = result.accessToken;
          _socialMediaBloc[index]
              .eventSocialMediaStatusSink
              .add(SocialMediaStatusAction.True);
          _socialMediaBloc[index].statusValue = true;
          SocialMediaConnectProvider connectProvider =
              Provider.of<SocialMediaConnectProvider>(context, listen: false);
          connectProvider.callSocialMediaProviderapi(
              'facebook', accessToken!.userId, header);
          break;
        case FacebookLoginStatus.cancel:
          print('Cancel');
          displaysnackbar('Login cancelled by the user.');
          break;
        case FacebookLoginStatus.error:
          print(result.error);
          displaysnackbar('Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.error}');
          break;
      }
    }
  }

  void linkedinLogin(int index) {
    if (_socialMediaBloc[index].statusValue) {
      _displayDisconnectConfirm(index);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LinkedInUserWidget(
                    redirectUrl: linkedInredirectUrl,
                    clientId: linkedInclientId,
                    clientSecret: linkedInclientSecret,
                    onGetUserProfile: (linkedInUser) {
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
                      LinkedinData linkedinData =
                          LinkedinData.fromJson(postJson);
                      _socialMediaBloc[index]
                          .eventSocialMediaStatusSink
                          .add(SocialMediaStatusAction.True);
                      _socialMediaBloc[index].statusValue = true;
                      Navigator.pop(context);
                      SocialMediaConnectProvider connectProvider =
                          Provider.of<SocialMediaConnectProvider>(context,
                              listen: false);
                      connectProvider.callSocialMediaProviderapi(
                          'linkedin', linkedinData.userId, header);
                    },
                    onError: (error) {
                      print('Error description: ${error.exception} ');
                    },
                  )));
    }
  }

  void cleardata() {
    questionid.clear();
    staticquestions.clear();
    for (int i = 0; i < 5; i++) {
      questionsController[i].clear();
    }
    _answersList.clear();
  }

  googleLogin(int index) async {
    if (_socialMediaBloc[index].statusValue) {
      _displayDisconnectConfirm(index);
    } else {
      try {
        _currentUser = (await _googleSignIn.signIn())!;
        _socialMediaBloc[index]
            .eventSocialMediaStatusSink
            .add(SocialMediaStatusAction.True);
        _socialMediaBloc[index].statusValue = true;
        SocialMediaConnectProvider connectProvider =
            Provider.of<SocialMediaConnectProvider>(context, listen: false);
        connectProvider.callSocialMediaProviderapi(
            'google', _currentUser.id, header);
      } catch (err) {
        print(err.toString());
      }
    }
  }

  appleLogin(int index) async {
    if (_socialMediaBloc[index].statusValue) {
      _displayDisconnectConfirm(index);
    } else {
      try {
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

        print(credential.authorizationCode);

        if (credential.authorizationCode == 'canceled') {
          print('Cancelled');
        } else {
          _socialMediaBloc[index]
              .eventSocialMediaStatusSink
              .add(SocialMediaStatusAction.True);
          _socialMediaBloc[index].statusValue = true;
          SocialMediaConnectProvider connectProvider =
              Provider.of<SocialMediaConnectProvider>(context, listen: false);
          connectProvider.callSocialMediaProviderapi(
              'apple', provideruesrid, header);
        }
      } catch (e) {
        String error = e.toString();
        var split = error.split('(');
        var errorsplit = split[1].split(',');
        if (errorsplit[0] == "AuthorizationErrorCode.canceled") {
          print('Cancelled');
        } else {
          displaysnackbar(e.toString());
        }
      }
    }
  }

  // twitterLogin(int index) async {
  //   final twitterLogin = TwitterLogin(

  //       /// Consumer API keys
  //       apiKey: "BktCaAkFaRVF8BgAevY9j9hb1",

  //       /// Consumer API Secret keys
  //       apiSecretKey: "3xASEesWsFEqZrT83wHfozn9GI5VfjpYGuFdxukyQgjXG3sLwl",

  //       /// Registered Callback URLs in TwitterApp
  //       /// Android is a deeplink
  //       /// iOS is a URLScheme
  //       redirectURI: "twitterkit-BktCaAkFaRVF8BgAevY9j9hb1://");
  //   if (_socialMediaBloc[index].statusValue) {
  //     _socialMediaBloc[index]
  //         .eventSocialMediaStatusSink
  //         .add(SocialMediaStatusAction.False);
  //     SocialMediaDisconnectProvider _connectProvider =
  //         Provider.of<SocialMediaDisconnectProvider>(context, listen: false);
  //     _connectProvider.callSocialMediaDisconnectProviderapi('twitter', header);
  //   } else {
  //     final authResult = await twitterLogin.login();
  //     switch (authResult.status) {
  //       case TwitterLoginStatus.loggedIn:
  //         // success
  //         _socialMediaBloc[index]
  //             .eventSocialMediaStatusSink
  //             .add(SocialMediaStatusAction.True);
  //         SocialMediaConnectProvider _connectProvider =
  //             Provider.of<SocialMediaConnectProvider>(context, listen: false);
  //         _connectProvider.callSocialMediaProviderapi(
  //             'twitter', authResult.authToken, header);
  //         break;
  //       case TwitterLoginStatus.cancelledByUser:
  //         // cancel
  //         print('====== Login cancel ======');
  //         break;
  //       case TwitterLoginStatus.error:
  //         print(authResult.errorMessage);
  //     }
  //   }
  // }

  _displayPaymentCard(data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
              _displaycardheader('Current Package', isPotrait),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Provider.of<GetQuestionsProvider>(context, listen: false)
                        .planName
                        .isEmpty
                    ? const Text('There are no plan records')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Plan Name',
                                    style: TextStyle(
                                        fontSize: isPotrait
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Provider.of<GetQuestionsProvider>(
                                                context,
                                                listen: false)
                                            .planName,
                                        style: TextStyle(
                                          fontSize: isPotrait
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.038
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.038,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Provider.of<GetQuestionsProvider>(context,
                                                      listen: false)
                                                  .planEndDate ==
                                              null
                                          ? Container()
                                          : DateTime.now().isAfter(Provider.of<
                                                          GetQuestionsProvider>(
                                                      context,
                                                      listen: false)
                                                  .planEndDate!)
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red[500],
                                                      border: Border.all(
                                                        color: Colors.red[500]!,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: const Center(
                                                    child: Text(
                                                      'Expired',
                                                      style: TextStyle(
                                                          color:
                                                              kbackgroundColor),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: _displaystatictext(
                                    'Start Date',
                                    Provider.of<GetQuestionsProvider>(context,
                                            listen: false)
                                        .planStartDate,
                                    isPotrait),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Provider.of<GetQuestionsProvider>(context,
                                              listen: false)
                                          .planEndDate ==
                                      null
                                  ? Container()
                                  : _displaystatictext(
                                      'End Date',
                                      formatter.format(
                                          Provider.of<GetQuestionsProvider>(
                                                  context,
                                                  listen: false)
                                              .planEndDate!),
                                      isPotrait),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TransactionHistory())),
                            child: Row(
                              children: [
                                const Spacer(),
                                Image.asset(
                                  'images/eye.png',
                                  color: kgreenPrimaryColor,
                                  //fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  'View Plan History',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: kgreenPrimaryColor),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _displayDisconnectConfirm(int index) {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title:
              const Text('Disconnect', style: TextStyle(color: Colors.black)),
          content: const Text(
              'Are you sure you want to Disconnect? You will not be able to login with this social media after disconnecting.',
              style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
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
                        _disconnectMedia(index);
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
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
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

  void _disconnectMedia(int index) {
    if (index == 0) {
      facebookSignIn.logOut();
      _socialMediaBloc[index]
          .eventSocialMediaStatusSink
          .add(SocialMediaStatusAction.False);
      _socialMediaBloc[index].statusValue = false;
      SocialMediaDisconnectProvider connectProvider =
          Provider.of<SocialMediaDisconnectProvider>(context, listen: false);
      connectProvider.callSocialMediaDisconnectProviderapi('facebook', header);
    } else if (index == 1) {
      _socialMediaBloc[index]
          .eventSocialMediaStatusSink
          .add(SocialMediaStatusAction.False);
      SocialMediaDisconnectProvider connectProvider =
          Provider.of<SocialMediaDisconnectProvider>(context, listen: false);
      connectProvider.callSocialMediaDisconnectProviderapi('linkedin', header);
    } else if (index == 2) {
      _googleSignIn.signOut();
      _socialMediaBloc[index]
          .eventSocialMediaStatusSink
          .add(SocialMediaStatusAction.False);
      _socialMediaBloc[index].statusValue = false;
      SocialMediaDisconnectProvider connectProvider =
          Provider.of<SocialMediaDisconnectProvider>(context, listen: false);
      connectProvider.callSocialMediaDisconnectProviderapi('google', header);
    } else if (index == 4) {
      _socialMediaBloc[index]
          .eventSocialMediaStatusSink
          .add(SocialMediaStatusAction.False);
      _socialMediaBloc[index].statusValue = false;
      SocialMediaDisconnectProvider connectProvider =
          Provider.of<SocialMediaDisconnectProvider>(context, listen: false);
      connectProvider.callSocialMediaDisconnectProviderapi('apple', header);
    }
  }

  _buildQuestionsDropdown(int index) {
    return Stack(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: StreamBuilder(
              stream:
                  _questionsErrorBloc[index].stateResumeIssuingAuthorityStrean,
              builder: (context, errorsnapshot) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0,
                        color: errorsnapshot.hasData &&
                                _questionsErrorBloc[index].showtext
                            ? Colors.red
                            : Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(
                            20.0) //                 <--- border radius here
                        ),
                  ),
                  child: StreamBuilder(
                    stream: _questionsDropdownBloc[index].stateDropdownStrean,
                    builder: (context, dropdownsnapshot) {
                      return StreamBuilder(
                        stream: _showQuestionsDropDownBloc[index]
                            .stateIndosNoStrean,
                        builder: (context, dropdownsnapshot) {
                          return Column(
                            children: [
                              DrodpownContainer(
                                title: _questionsValue[index].isNotEmpty
                                    ? _questionsValue[index]
                                    : 'Select Question',
                                originalList: configQuestions,
                                searchHint: 'Search Question',
                                showDropDownBloc:
                                    _showQuestionsDropDownBloc[index],
                              ),
                              ExpandedSection(
                                expand:
                                    _showQuestionsDropDownBloc[index].isedited,
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
                                                  : configQuestions.length,
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
                                                        bool isAlready = false;
                                                        _showQuestionsDropDownBloc[
                                                                index]
                                                            .eventIndosNoSink
                                                            .add(IndosNoAction
                                                                .False);
                                                        _questionsErrorBloc[
                                                                index]
                                                            .eventResumeIssuingAuthoritySink
                                                            .add(
                                                                ResumeErrorIssuingAuthorityAction
                                                                    .False);
                                                        for (int i = 0;
                                                            i <
                                                                _questionsValue
                                                                    .length;
                                                            i++) {
                                                          if (_questionsValue.contains(Provider.of<
                                                                          SearchChangeProvider>(
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
                                                              : configQuestions[
                                                                  listindex])) {
                                                            _questionsErrorBloc[
                                                                    index]
                                                                .eventResumeIssuingAuthoritySink
                                                                .add(
                                                                    ResumeErrorIssuingAuthorityAction
                                                                        .True);
                                                            _questionsErrorBloc[
                                                                        index]
                                                                    .showAlternateText =
                                                                true;
                                                            isAlready = true;
                                                          } else {
                                                            _questionsErrorBloc[
                                                                        index]
                                                                    .showAlternateText =
                                                                false;
                                                            isAlready = false;
                                                          }
                                                        }
                                                        if (!isAlready) {
                                                          _questionsValue[
                                                              index] = Provider.of<
                                                                          SearchChangeProvider>(
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
                                                              : configQuestions[
                                                                  listindex];
                                                          _questionIds[index] =
                                                              configQuestionid[
                                                                  configQuestions
                                                                      .indexOf(
                                                                          _questionsValue[
                                                                              index])];

                                                          _dropdownBloc
                                                              .setdropdownvalue(
                                                                  _questionsValue[
                                                                      index]);
                                                          _dropdownBloc
                                                              .eventDropdownSink
                                                              .add(
                                                                  DropdownAction
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
                                                              : configQuestions[
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
                );
              },
            )),
        TextBoxLabel('Select Question')
      ],
    );
  }

  _buildQuestionsErrorText(int index) {
    return StreamBuilder(
      initialData: false,
      stream: _questionsErrorBloc[index].stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && _questionsErrorBloc[index].showtext) {
          return Visibility(
            visible: _questionsErrorBloc[index].showtext,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _questionsErrorBloc[index].showAlternateText
                      ? 'This question already selected'
                      : 'Please select the question',
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

  bool checkquestiondata() {
    bool status = true;
    for (int i = 0; i < 5; i++) {
      if (_questionsValue[i].isEmpty) {
        _questionsErrorBloc[i]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        status = false;
      }
    }

    return status;
  }
}
