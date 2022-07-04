// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartseaman/LoginScreen/Login.dart';
import 'package:smartseaman/Profile/QuestionsGetProvider.dart';

import '../ContactUs/ContactUs.dart';
import '../Profile/Profile.dart';
import '../Profile/UserDetailsProvider.dart';
import '../constants.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  var imageurl;
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          //color: kbackgroundColor,
          height: (MediaQuery.of(context).size.height * 0.157),
          child: DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * 0.1,
                          width: MediaQuery.of(context).size.width * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).primaryColor,
                            image: DecorationImage(
                                fit: BoxFit.fill, image: checkImage()),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${Provider.of<UserDetailsProvider>(context).fname} ${Provider.of<UserDetailsProvider>(context).lname}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: kblackPrimaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileScreen()));
                                },
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.remove_red_eye_outlined,
                                      size: 12,
                                    ),
                                    Text(
                                      'View Profile',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
        const Divider(
          thickness: 0.5,
          color: kblackPrimaryColor,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          //height: MediaQuery.of(context).size.height * 0.35,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          color: Colors.white,
          child: Wrap(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Get In Touch',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
                child: Row(
                  children: [
                    Image.asset('images/help.png'),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(onTap: () {}, child: const Text('Help')),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
                child: Row(
                  children: [
                    Image.asset('images/contact_us.png'),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ContactUs())),
                        child: const Text('Contact Us')),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: Row(
                  children: [
                    Image.asset('images/t&c.png'),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () async {
                          print('Tap');
                          // await launch(
                          //     'https://decideit.uatbyopeneyes.com/termsConditions',
                          //     forceSafariVC: false);
                        },
                        child: const Text('Terms and Conditions')),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: Row(
                  children: [
                    Image.asset('images/privacy_policy.png'),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        print('Tap');
                        // await launch(
                        //     'https://decideit.uatbyopeneyes.com/privacyPolicy',
                        //     forceSafariVC: false);
                      },
                      child: const Text(
                        'Privacy Policy',
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  showLogoutDialog();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 15),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/logout.png',
                        height: 19,
                        width: 19,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text('Logout'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 0.5,
          color: kblackPrimaryColor,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: RichText(
            text: const TextSpan(
              text: 'Copyright © 2020-2021  ',
              style: TextStyle(color: Colors.black, fontSize: 12),
              children: <TextSpan>[
                TextSpan(
                    text: 'OpenEyes Technologies',
                    style: TextStyle(
                        color: kgreenPrimaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        )
      ],
    );
  }

  checkImage() {
    if (Provider.of<GetQuestionsProvider>(context, listen: false).photo ==
        null) {
      return const AssetImage('images/user.jpg');
    } else {
      return NetworkImage(
          '$imageapiurl/profile/${Provider.of<GetQuestionsProvider>(context, listen: false).photo}');
    }
  }

  void getuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imageurl = prefs.getString('imageurl');
    });
  }

  void showLogoutDialog() {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.black),
          ),
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
                    child: const Text("Yes"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      callLogoutMethod();
                    },
                  ),
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
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
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

  void callLogoutMethod() async {
    UserDetailsProvider userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    userDetailsProvider.changeUserDetails('', '', '', '', '', '', '');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
