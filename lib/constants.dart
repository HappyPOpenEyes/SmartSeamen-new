import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'DeviceProvider.dart';
import 'NoInternet.dart';

const kbackgroundColor = Colors.white;
const kblackPrimaryColor = Color(0xFF393939);
const kgreenPrimaryColor = Color(0xFF3BBA9C);
const kBluePrimaryColor = Color(0xFF01126E);

const stripePublishableKey =
    "pk_test_51KjNHHSHRxIGre3WZpXwlbtiWhVbOWHyMbV7prZZ3EmA5F7uEHnwCT5DlzTUcQ2fqAHgZdCjOyiWBZtX2r1FbUH600GkkW5ZmH";

ButtonStyle buttonStyle() {
  return ElevatedButton.styleFrom(
      primary: kgreenPrimaryColor, // background
      onPrimary: kbackgroundColor);
}

ButtonStyle greybuttonStyle() {
  return ElevatedButton.styleFrom(
      primary: Colors.grey, // background
      onPrimary: kbackgroundColor);
}

ButtonStyle bluebuttonStyle() {
  return ElevatedButton.styleFrom(
      primary: kBluePrimaryColor, // background
      onPrimary: kbackgroundColor);
}

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp passwordValidatorRegExp =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
const String kEmailNullError = "Please enter your email";
const String kInvalidEmailError = "Please enter Valid Email";
const String kPassNullError = "Please enter your password";
const String kShortPassError = "Password must be 6 characters or more";
const String kMatchPassError = "Passwords don't match";
const String kInvalidPassError =
    "Password should have at least 1 alphabet, 1 number and 1 special character .";
const String kNamelNullError = "Please enter your name";
const String kPhoneNumberNullError = "Please enter your phone number";
const String kPhoneNumberLengthError = "Please enter a valid phone number";
const String kAddressNullError = "Please enter your address";

//Dev URLS
const apiurl = 'https://api.smartseaman.devbyopeneyes.com/public/api';
const imageapiurl = 'https://api.smartseaman.devbyopeneyes.com/public';

//Uat URLS
// const apiurl = 'https://api.smartseamen.uatbyopeneyes.com/public/api';
// const imageapiurl = 'https://api.smartseamen.uatbyopeneyes.com/public';

const indianNationalityId = "de8d6ee0-2698-11ec-b056-af049af35ecd";
const otherNationalityId = "1";

const String mandatoryCompetencyDoc = "23";
const String optionalCompetencyDoc = "24";

const String passportConfigValue = "2";
const String cdcConfigValue = "1";

const String lifetimeValidType = "37";
const String unlimitedValidType = "38";
const String dateValidType = "39";

const String visaOtherId = "45";

const String starterPlanId = "0fa2bf20-276e-11ec-810e-a131295728d4";

const hintstyle = TextStyle(
  color: Colors.grey,
  fontFamily: 'OpenSans',
);

displayHeightSizedBox(value) {
  return SizedBox(
    height: value,
  );
}

displayWidthSizedBox(value) {
  return SizedBox(
    width: value,
  );
}

callNoInternetScreen(className, BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => NoInternet(className: className)));
}

Future<bool> checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return false;
    // I am connected to a mobile network.
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return false;
    // I am connected to a wifi network.
  } else {
    return true;
  }
}

displaysnackbar(String s) {
  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    snackStyle: SnackStyle.FLOATING,
    messageText: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        s,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    titleText: Container(),
    margin: const EdgeInsets.only(
        bottom: kBottomNavigationBarHeight, left: 8, right: 8),
    padding: const EdgeInsets.only(bottom: 4, left: 16, right: 16),
    borderRadius: 4,
    backgroundColor: kblackPrimaryColor,
    colorText: Colors.white,
  );
}

void calculateShortestSide(BuildContext context) {
  var shortestSide = MediaQuery.of(context).size.shortestSide;
  Provider.of<DeviceProvider>(context, listen: false).isMobile =
      shortestSide < 550;
}

bool checkDeviceSize(BuildContext context) {
  return Provider.of<DeviceProvider>(context, listen: false).isMobile;
}
