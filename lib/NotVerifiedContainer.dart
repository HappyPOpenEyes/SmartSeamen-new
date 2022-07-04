import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Profile/EmailOTPSendProvider.dart';
import 'Profile/MobileOTPSendProvider.dart';
import 'Profile/UserDetailsProvider.dart';
import 'Profile/VerifyOTP.dart';
import 'asynccallprovider.dart';
import 'constants.dart';

class NotVerifiedContaier extends StatelessWidget {
  var email, phone, value;

  NotVerifiedContaier({this.value, this.email, this.phone});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(children: [
      Container(
        height: MediaQuery.of(context).size.height * 0.02,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.02,
              color: Colors.red[500],
              child: Center(
                child: Text(
                  'Not Verified',
                  style: TextStyle(color: kbackgroundColor),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            VerticalDivider(
              thickness: 1.5,
              color: Colors.grey,
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () async {
                AsyncCallProvider _asyncProvider =
                    Provider.of<AsyncCallProvider>(context, listen: false);
                if (!Provider.of<AsyncCallProvider>(context, listen: false)
                    .isinasynccall) _asyncProvider.changeAsynccall();
                if (value == 0) {
                  EmailOTPSendProvider _emailOtpSendProvider =
                      Provider.of<EmailOTPSendProvider>(context, listen: false);
                  if (await _emailOtpSendProvider.callEmailOtpSendapi(
                      email,
                      Provider.of<UserDetailsProvider>(context, listen: false)
                          .userid,
                      Provider.of<UserDetailsProvider>(context, listen: false)
                          .header)) {
                    _asyncProvider.changeAsynccall();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString(
                        'SendOTP', 'Otp has been sent to your email address');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => VerifyOTP(email, phone, 0)));
                  } else {
                    _asyncProvider.changeAsynccall();
                    displaysnackbar('Something went wrong');
                  }
                } else {
                  MobileOTPSendProvider _mobileOtpSendProvider =
                      Provider.of<MobileOTPSendProvider>(context,
                          listen: false);
                  if (await _mobileOtpSendProvider.callMobileOtpSendapi(
                      phone,
                      Provider.of<UserDetailsProvider>(context, listen: false)
                          .userid,
                      Provider.of<UserDetailsProvider>(context, listen: false)
                          .header)) {
                    _asyncProvider.changeAsynccall();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString(
                        'SendOTP', 'Otp has been sent to your email address');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => VerifyOTP(email, phone, 1)));
                  } else {
                    _asyncProvider.changeAsynccall();
                    displaysnackbar('Something went wrong');
                  }
                }
              },
              child: Text(
                'Verify Now',
                style: TextStyle(
                    color: kgreenPrimaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
