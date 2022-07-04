// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartseaman/Payment/PlanCard.dart';

import '../JobScreen/JobHeader.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'PlanProvider.dart';

class PlanScreens extends StatefulWidget {
  const PlanScreens({Key? key}) : super(key: key);

  @override
  _PlanScreensState createState() => _PlanScreensState();
}

class _PlanScreensState extends State<PlanScreens> {
  var header, tokenheader;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F5FD),
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<AsyncCallProvider>(context).isinasynccall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(
            backgroundColor: kbackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JobHeader(
                isJobDetail: false,
                isPayment: true,
                isTransaction: false,
                numOfNotifications: 0,
              ),
              const SizedBox(
                height: 10,
              ),
              _displayPlanData(),
            ],
          ),
        ),
      ),
    );
  }

  _displayPlanData() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'We have different plans tailered for your needs. Choose a plan below as per your requirement. Click on View Details link below plan name to see what\'s included in plan.'),
          const SizedBox(
            height: 10,
          ),
          _displayPlanCards()
        ],
      ),
    );
  }

  _displayPlanCards() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: Provider.of<GetPlanListProvider>(context, listen: false)
              .planName
              .length,
          itemBuilder: (context, index) => PlanCard(
                index: index,
                header: header,
                scaffoldKey: _scaffoldKey,
              )),
    );
  }

  void getdata() async {
    bool result = await checkConnectivity();
    if (result) {
      callNoInternetScreen(const PlanScreens(), context);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');

    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    GetPlanListProvider planListProvider =
        Provider.of<GetPlanListProvider>(context, listen: false);

    if (!await planListProvider.callGetPlanListapi(header)) {
      displaysnackbar('Something went wrong');
    }
    asyncProvider.changeAsynccall();
  }
}
