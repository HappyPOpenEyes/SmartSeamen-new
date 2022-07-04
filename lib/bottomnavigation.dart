// ignore_for_file: import_of_legacy_library_into_null_safe, must_be_immutable

import 'dart:ui';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartseaman/asynccallprovider.dart';
import 'Dashboard/Dashboard.dart';
import 'JobScreen/JobList.dart';
import 'LoginScreen/UserDataProvider.dart';
import 'Profile/Profile.dart';
import 'ReferJob/ReferJob.dart';
import 'ResumeBuilder/PersonalInformation/ResumeBuilder.dart';
import 'constants.dart';

class BottomNavigationClass extends StatelessWidget {
  late int _currentIndex;
  BottomNavigationClass(index, {Key? key}) : super(key: key) {
    _currentIndex = index;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomNavyBar(
        showElevation: true,
        selectedIndex:
            _currentIndex, // Use this to update the Bar giving a position
        onItemSelected: (index) {
          if (!Provider.of<AsyncCallProvider>(context, listen: false)
              .isinasynccall) {
            if (index == 3 && _currentIndex != 3) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const ResumeBuilder()));
            } else if (index == 4 && _currentIndex != 4) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const ProfileScreen()));
            } else if (index == 1 && _currentIndex != 1) {
              Provider.of<UserDataProvider>(context, listen: false).jobViews
                  ? Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const JobList()))
                  : _displayPlanError(context);
            } else if (index == 0 && _currentIndex != 0) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Dashboard()));
            } else if (index == 2 && _currentIndex != 2) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ReferJob()));
            }
          }
        },
        items: [
          BottomNavyBarItem(
              title: Text(
                'Dashboard',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.016,
                    fontWeight: FontWeight.w600),
              ),
              icon: const Icon(Icons.dashboard_customize)),
          BottomNavyBarItem(
              title: Text(
                'Jobs',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.016,
                    fontWeight: FontWeight.w600),
              ),
              icon: Image.asset(
                'images/suitcase.png',
                color: Colors.blue,
                height: 24,
              )),
          BottomNavyBarItem(
              title: Text(
                'Refer Job',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.016,
                    fontWeight: FontWeight.w600),
              ),
              icon: const Icon(Icons.folder)),
          BottomNavyBarItem(
              title: Text(
                'Resume',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.016,
                    fontWeight: FontWeight.w600),
              ),
              icon: const Icon(Icons.article)),
          BottomNavyBarItem(
              title: Text(
                'Profile',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.016,
                    fontWeight: FontWeight.w600),
              ),
              icon: const Icon(Icons.person)),
        ]);
  }

  _displayPlanError(BuildContext context) {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: const Text('Error', style: TextStyle(color: Colors.black)),
          content: const Text(
              'Please upgrade your plan to access this feature  .',
              style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: kbackgroundColor,
                  //width: double.maxFinite,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      style: buttonStyle(),
                      child: const Text(
                        "OK",
                        style: TextStyle(color: kbackgroundColor),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
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
}
