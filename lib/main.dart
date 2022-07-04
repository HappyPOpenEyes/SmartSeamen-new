import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartseaman/Dashboard/Dashboard.dart';
import 'package:smartseaman/JobScreen/JobList.dart';
import 'package:smartseaman/ResumeBuilder/PersonalInformation/GetResumeProvider.dart';
import 'package:smartseaman/ResumeBuilder/PersonalInformation/ResumeBuilder.dart';

import 'ContactUs/ContactUsProvider.dart';
import 'Dashboard/DashboardStatusProvider.dart';
import 'Dashboard/GetDashboardCountDataProvider.dart';
import 'Dashboard/GetDashboardDataProvider.dart';
import 'Dashboard/GetDashboardNotificationProvider.dart';
import 'Dashboard/GetExpiredDataProvider.dart';
import 'DeviceProvider.dart';
import 'ForgotEmail/GetUserQuestionProvider.dart';
import 'ForgotEmail/QuestionSubmitProvider.dart';
import 'ForgotEmail/VerifyMobileProvider.dart';
import 'ForgotPassword/ForgotPasswordProvider.dart';
import 'JobScreen/ApplyRankProvider.dart';
import 'JobScreen/FeatureJobProvider.dart';
import 'JobScreen/GetAdvancedSearchProvider.dart';
import 'JobScreen/GetJobListProvider.dart';
import 'JobScreen/GetRankProvider.dart';
import 'JobScreen/JobDetailProvider.dart';
import 'JobScreen/JobLoaderProvider.dart';
import 'JobScreen/SelectFiltersProvider.dart';
import 'JobScreen/SortValueProvider.dart';
import 'LoginScreen/Login.dart';
import 'LoginScreen/LoginProvider.dart';
import 'LoginScreen/SocialMediaCheckProvider.dart';
import 'LoginScreen/UserDataProvider.dart';
import 'Notification/ChangeStatusProvider.dart';
import 'Notification/ClearNotificationsProvider.dart';
import 'Notification/DeleteNotificationProvider.dart';
import 'Notification/NotificationProvider.dart';
import 'Notification/NotificationService.dart';
import 'Notification/RemoveNotificationProvider.dart';
import 'Notification/ShowAllNotificationsProvider.dart';
import 'Payment/CalculatePlanProvider.dart';
import 'Payment/CreatePaymentEntryProvider.dart';
import 'Payment/CreatePaymentProvider.dart';
import 'Payment/PaymentRedirectUrlProvider.dart';
import 'Payment/PaymentStripe.dart';
import 'Payment/PlanHistoryProvider.dart';
import 'Payment/PlanProvider.dart';
import 'Profile/ChangePasswordProvider.dart';
import 'Profile/EmailOTPSendProvider.dart';
import 'Profile/EmailVerifyProvider.dart';
import 'Profile/GetProfileProvider.dart';
import 'Profile/MobileOTPSendProvider.dart';
import 'Profile/MobileVerifyProvider.dart';
import 'Profile/PersonalInfoUpdateProvider.dart';
import 'Profile/PostQuestionsProvider.dart';
import 'Profile/Profile.dart';
import 'Profile/ProfilePhotoUpdateProvider.dart';
import 'Profile/QuestionsGetProvider.dart';
import 'Profile/SocialMediaConnectProvider.dart';
import 'Profile/SocialMediaDisconnectProvider.dart';
import 'Profile/UserDetailsProvider.dart';
import 'ReferJob/GetDecNavigationProvider.dart';
import 'ReferJob/GetEngineRankProvider.dart';
import 'ReferJob/ReferJobProvider.dart';
import 'Register/OTPScreenProvider.dart';
import 'Register/Register_Provider.dart';
import 'Register/ResendOTPProvider.dart';
import 'ResumeBuilder/DangerousCargoEndorsment/DangerousCargoProvider.dart';
import 'ResumeBuilder/DangerousCargoEndorsment/EditDangerousCargoProvider.dart';
import 'ResumeBuilder/Documents/CompetencydocUpdateProvider.dart';
import 'ResumeBuilder/Documents/DeleteCDCRecordAPI.dart';
import 'ResumeBuilder/Documents/DeleteCompetencyRecord.dart';
import 'ResumeBuilder/Documents/DeleteSTCWRecord.dart';
import 'ResumeBuilder/Documents/DocumentScreenProvider.dart';
import 'ResumeBuilder/Documents/MedicalDocUpdateProvider.dart';
import 'ResumeBuilder/Documents/STCWDocUpdateProvider.dart';
import 'ResumeBuilder/Documents/TravelDocUpdateProvider.dart';
import 'ResumeBuilder/GeneratePDFProvider.dart';
import 'ResumeBuilder/GetValidTypeProvider.dart';
import 'ResumeBuilder/IssuingAuthorityProvider.dart';
import 'ResumeBuilder/PersonalInformation/EditJobPreferencesProvider.dart';
import 'ResumeBuilder/PersonalInformation/EditPermanentAdressProvider.dart';
import 'ResumeBuilder/PersonalInformation/EditPersonalProvider.dart';
import 'ResumeBuilder/PersonalInformation/ResendEmailProvider.dart';
import 'ResumeBuilder/PersonalInformation/ResendMobileOtpProvider.dart';
import 'ResumeBuilder/PersonalInformation/SecondaryRankProvider.dart';
import 'ResumeBuilder/PreviousEmployeeReference.dart/EditEmployerProvider.dart';
import 'ResumeBuilder/PreviousEmployeeReference.dart/EmployerDeleteProvider.dart';
import 'ResumeBuilder/PreviousEmployeeReference.dart/PreviousEmplyeeProvider.dart';
import 'ResumeBuilder/PublishResumeProvider.dart';
import 'ResumeBuilder/SeaServiceRecord/DeleteSeaServiceRecord.dart';
import 'ResumeBuilder/SeaServiceRecord/EditSeaServiceProvider.dart';
import 'ResumeBuilder/SeaServiceRecord/SeaServiceProvider.dart';
import 'SearchTextProvider.dart';
import 'asynccallprovider.dart';
import 'constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var header = prefs.getString('header');
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();

  late FirebaseMessaging messaging;
  messaging = FirebaseMessaging.instance;
  messaging.getToken().then((value) {
    print('Value is');
    prefs.setString('RegistrationTokenFCM', value ?? '');
    print(value);
  });
  FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? message) async {
    print('Received');
    await NotificationService().init();
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    bool isExpired = false;
    print(message.notification!.body);
    print('data');
    print(message.data);
    if (message.data.isNotEmpty) {
      if (message.data["noti_type"] == 1) {
        isExpired = true;
      }
    }

    runApplication(prefs, true, isExpired);
  });

  runApplication(prefs, false, false);
}

runApplication(prefs, bool isNotification, bool isExpired) {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AsyncCallProvider()),
      ChangeNotifierProvider(create: (_) => RegisterProvider()),
      ChangeNotifierProvider(create: (_) => OTPScreenProvider()),
      ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
      ChangeNotifierProvider(create: (_) => LoginProvider()),
      ChangeNotifierProvider(create: (_) => GetProfileProvider()),
      ChangeNotifierProvider(create: (_) => PersonalInfoUpdateProvider()),
      ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
      ChangeNotifierProvider(create: (_) => GetQuestionsProvider()),
      ChangeNotifierProvider(create: (_) => PostQuestionsProvider()),
      ChangeNotifierProvider(create: (_) => UserDetailsProvider()),
      ChangeNotifierProvider(create: (_) => EmailOTPSendProvider()),
      ChangeNotifierProvider(create: (_) => MobileOTPSendProvider()),
      ChangeNotifierProvider(create: (_) => EmailOTPVerifyProvider()),
      ChangeNotifierProvider(create: (_) => MobileOTPVerifyProvider()),
      ChangeNotifierProvider(create: (_) => GetResumeProvider()),
      ChangeNotifierProvider(
          create: (_) => ResumeJobPreferencesUpdateProvider()),
      ChangeNotifierProvider(create: (_) => ResumePersonalInfoUpdateProvider()),
      ChangeNotifierProvider(create: (_) => ResumeAddressUpdateProvider()),
      ChangeNotifierProvider(create: (_) => ResumeIssuingAuthorityProvider()),
      ChangeNotifierProvider(
          create: (_) => ResumeEditDangerousCargoUpdateProvider()),
      ChangeNotifierProvider(create: (_) => ResumeDangerousCargoProvider()),
      ChangeNotifierProvider(create: (_) => ResumeSeaServiceProvider()),
      ChangeNotifierProvider(
          create: (_) => ResumeEditSeaServiceUpdateProvider()),
      ChangeNotifierProvider(
          create: (_) => ResumeEditSeaServiceDeleteProvider()),
      ChangeNotifierProvider(create: (_) => ResumeEmployerProvider()),
      ChangeNotifierProvider(create: (_) => ResumeEditEmployerUpdateProvider()),
      ChangeNotifierProvider(create: (_) => ResumeEmployerDeleteProvider()),
      ChangeNotifierProvider(create: (_) => ProfilePictureProvider()),
      ChangeNotifierProvider(create: (_) => ResumeDocumentProvider()),
      ChangeNotifierProvider(
          create: (_) => ResumeEditTravelDocUpdateProvider()),
      ChangeNotifierProvider(
          create: (_) => ResumeEditCdcRecordDeleteProvider()),
      ChangeNotifierProvider(
          create: (_) => ResumeEditMedicalDocUpdateProvider()),
      ChangeNotifierProvider(
          create: (_) => ResumeEditCompetencyDocUpdateProvider()),
      ChangeNotifierProvider(create: (_) => ResumeEditSTCWDocUpdateProvider()),
      ChangeNotifierProvider(create: (_) => ResumePublishStatusProvider()),
      ChangeNotifierProvider(create: (_) => SocialMediaConnectProvider()),
      ChangeNotifierProvider(create: (_) => SocialMediaDisconnectProvider()),
      ChangeNotifierProvider(create: (_) => SocialMediaCheckProvider()),
      ChangeNotifierProvider(create: (_) => GetJobListProvider()),
      ChangeNotifierProvider(create: (_) => GetJobDetailProvider()),
      ChangeNotifierProvider(create: (_) => GetAdvancedSearchProvider()),
      ChangeNotifierProvider(create: (_) => GetApplyRankProvider()),
      ChangeNotifierProvider(create: (_) => GetSelectedFiltersProvider()),
      ChangeNotifierProvider(create: (_) => GetSortOrderProvider()),
      ChangeNotifierProvider(create: (_) => GetPlanListProvider()),
      ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ChangeNotifierProvider(create: (_) => JobLoaderProvider()),
      ChangeNotifierProvider(create: (_) => PaymentRedirectUrlProvider()),
      ChangeNotifierProvider(create: (_) => GetDashboardDataProvider()),
      ChangeNotifierProvider(create: (_) => GetDashboardExpiredDataProvider()),
      ChangeNotifierProvider(create: (_) => GetDashboardCountDataProvider()),
      ChangeNotifierProvider(create: (_) => GetDashboardNotificationProvider()),
      ChangeNotifierProvider(create: (_) => DashboardStatusProvider()),
      ChangeNotifierProvider(create: (_) => PlanHistoryProvider()),
      ChangeNotifierProvider(create: (_) => ApplyJobProvider()),
      ChangeNotifierProvider(create: (_) => RemoveNotificationsProvider()),
      ChangeNotifierProvider(create: (_) => ClearNotificationsProvider()),
      ChangeNotifierProvider(
          create: (_) => ChangeStatusNotificationsProvider()),
      ChangeNotifierProvider(create: (_) => DeleteNotificationsProvider()),
      ChangeNotifierProvider(create: (_) => ShowAllNotificationsProvider()),
      ChangeNotifierProvider(create: (_) => ForgotEmailMobileVerifyProvider()),
      ChangeNotifierProvider(
          create: (_) => ForgotEmailQuestionsSubmitProvider()),
      ChangeNotifierProvider(create: (_) => ResendOTPSendProvider()),
      ChangeNotifierProvider(create: (_) => ResendEmailOTPSendProvider()),
      ChangeNotifierProvider(create: (_) => ResendMobileOTPSendProvider()),
      ChangeNotifierProvider(create: (_) => GeneratePDFProvider()),
      ChangeNotifierProvider(create: (_) => DeviceProvider()),
      ChangeNotifierProvider(create: (_) => GetValidTypeProvider()),
      ChangeNotifierProvider(
          create: (_) => ResumeEditCompetencyRecordDeleteProvider()),
      ChangeNotifierProvider(
          create: (_) => ResumeEditSTCWRecordDeleteProvider()),
      ChangeNotifierProvider(create: (_) => SecondaryRankProvider()),
      ChangeNotifierProvider(create: (_) => GetPlanCalculationProvider()),
      ChangeNotifierProvider(create: (_) => PaymentStripe()),
      ChangeNotifierProvider(create: (_) => CreatePayment()),
      ChangeNotifierProvider(create: (_) => CreatePaymentEntry()),
      ChangeNotifierProvider(create: (_) => GetDeckNavigationProvider()),
      ChangeNotifierProvider(create: (_) => GetEngineRankProvider()),
      ChangeNotifierProvider(create: (_) => PostReferJobProvider()),
      ChangeNotifierProvider(create: (_) => FeatureJobListProvider()),
      ChangeNotifierProvider(create: (_) => ContactUsProvider()),
      ChangeNotifierProvider(create: (_) => SearchChangeProvider()),
      ChangeNotifierProvider(create: (_) => UserQuestionProvider()),
      ChangeNotifierProvider(create: (_) => UserDataProvider()),
    ],
    child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "SmartSeamen",
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Color(0xff6058F7),
            secondary: Color(0xff6058F7),
          ),
          primaryColor: Colors.white,
          appBarTheme: const AppBarTheme(elevation: 1),
        ),
        home: isNotification
            ? prefs.getString('header') == null
                ? LoginScreen()
                : isExpired
                    ? ResumeBuilder()
                    : JobList()
            : prefs.getString('header') == null
                ? LoginScreen()
                : prefs.getBool("RecoveryQuestions") == null
                    ? const ProfileScreen()
                    : prefs.getBool("RecoveryQuestions")
                        ? const Dashboard()
                        : const ProfileScreen()),
  ));
}

class SmartSeamen extends StatelessWidget {
  const SmartSeamen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Smart Seamen",
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: kbackgroundColor),
      home: LoginScreen(),
    );
  }
}
