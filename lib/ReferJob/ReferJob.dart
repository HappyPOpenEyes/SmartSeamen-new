// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../Dashboard/DashboardHeader.dart';
import '../SideBar/SideBar.dart';
import '../asynccallprovider.dart';
import '../bottomnavigation.dart';
import '../constants.dart';
import 'ReferJobDetails.dart';

class ReferJob extends StatefulWidget {
  const ReferJob({Key? key}) : super(key: key);

  @override
  _ReferJobState createState() => _ReferJobState();
}

class _ReferJobState extends State<ReferJob> {
  final GlobalKey<ScaffoldState> _scaffoldkey =  GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FD),
      key: _scaffoldkey,
      bottomNavigationBar: BottomNavigationClass(2),
      drawer: Drawer(
          child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.57,
              child: Sidebar())),
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<AsyncCallProvider>(context).isinasynccall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(
            backgroundColor: kbackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
        child: SingleChildScrollView(
          child: Column(children: [
            DashboardHeader(
              isDashboard: false,
              isEdit: false,
              isPayment: false,
              scaffoldKey: _scaffoldkey,
            ),
            _displayBulletText(
                'If you are on-board and if there are any vacate positions available on the same vessel or some another vessel of the same shipping company you may refer the job on Smart Seamen Application for the Sailors who are on vacation or who are in seek of a new opportunity to be on-board.'),
            _displayBulletText(
                'Your referred job will be reviewed, examined & authenticated by Smart Seamen. If found genuine, then it will be displayed on Smart Seamen Application.'),
            _displayBulletText(
                'Smart Seamen will act as an intermediary wherein you will be allowed to refer a job which will be posted on Smart Seamen Application and the sailors / jobseekers will be allowed to apply on your referred job. Your referred job and the job applications will be received by Smart Seamen. There will not be any direct point of contact between you and the job applicant.'),
            _displayBulletText(
                'The job applications received by the sailors / jobseekers on your referred jobs will be reviewed by Smart Seamen. The relevant applications will be scrutinized well and will be shared and communicated to you for the further perusal.'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReferJobDetails(),
                ));
              },
              style: buttonStyle(),
              child: const Text(
                'Next',
                style: TextStyle(color: kbackgroundColor),
              ),
            )
          ]),
        ),
      ),
    );
  }

  _displayBulletText(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u2022',
            style: TextStyle(
                color: kgreenPrimaryColor,
                fontSize: MediaQuery.of(context).size.width * 0.15),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              text,
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
            ),
          )
        ],
      ),
    );
  }
}
