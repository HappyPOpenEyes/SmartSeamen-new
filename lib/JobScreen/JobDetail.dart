// ignore_for_file: must_be_immutable, library_private_types_in_public_api, no_logic_in_create_state, use_build_context_synchronously

import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DropdownBloc.dart';
import '../DropdownContainer.dart';
import '../GreenBullet.dart';
import '../IssuingAuthorityErrorBloc.dart';
import '../LoginScreen/UserDataProvider.dart';
import '../RadioButtonBloc.dart';
import '../ResumeBuilder/PersonalInformation/ExpandedAnimation.dart';
import '../ResumeBuilder/PersonalInformation/IndosNoBloc.dart';
import '../ResumeBuilder/PersonalInformation/Scrollbar.dart';
import '../SearchTextProvider.dart';
import '../TextBoxLabel.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'ApplyRankProvider.dart';
import 'GetJobListProvider.dart';
import 'GetRankProvider.dart';
import 'JobDetailProvider.dart';
import 'JobHeader.dart';
import 'JobList.dart';

class JobDetail extends StatefulWidget {
  String companyId;

  JobDetail({Key? key, required this.companyId}) : super(key: key);
  @override
  _JobDetailState createState() => _JobDetailState(companyId: companyId);
}

class _JobDetailState extends State<JobDetail> {
  String companyId;
  final RadioButtonBloc _showDialogBloc = RadioButtonBloc(),
      _dropdownShowBloc = RadioButtonBloc(),
      _displaySelectedItemBloc = RadioButtonBloc();
  final List<RadioButtonBloc> _ranksListBloc = [], _applyTextBloc = [];
  List<String> selectedranks = [];
  bool isStrechedDropDown = false;
  _JobDetailState({required this.companyId});

  var header;
  final List<String> _labelList = [
    "Tentaive Joining",
    "Expiration",
    "Nationality"
  ];
  CarouselController buttonCarouselController = CarouselController();
  final _dropdownBloc = DropdownBloc();
  final _errorRankBloc = ResumeErrorIssuingAuthorityBloc();
  String rankValue = "";
  final _showDropdown = IndosNoBloc ();
  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _showDialogBloc.dispose();
    _dropdownShowBloc.dispose();
    _displaySelectedItemBloc.dispose();
    _dropdownBloc.dispose();
    _showDropdown.dispose();
    for (int i = 0;
        i <
            Provider.of<GetJobDetailProvider>(context, listen: false)
                .isApplied
                .length;
        i++) {
      _applyTextBloc[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FD),
      bottomNavigationBar:
          Provider.of<GetJobDetailProvider>(context, listen: false)
                      .tentaiveJoiningDate
                      .length !=
                  1
              ? Provider.of<GetJobDetailProvider>(context, listen: false)
                      .tentaiveJoiningDate
                      .isEmpty
                  ? const SizedBox()
                  : _displayBottomNavigationButtons(
                      Provider.of<GetJobDetailProvider>(context, listen: false)
                          .currentIndex)
              : const SizedBox(),
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
                isJobDetail: true,
                isPayment: false,
                isTransaction: false,
                numOfNotifications: 0,
              ),
              const SizedBox(
                height: 2,
              ),
              CarouselSlider.builder(
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.78,
                  initialPage: 0,
                  viewportFraction: 1,
                  enableInfiniteScroll:
                      Provider.of<GetJobDetailProvider>(context, listen: false)
                                  .tentaiveJoiningDate
                                  .length !=
                              1
                          ? true
                          : false,
                  reverse: false,
                  autoPlay:
                      Provider.of<GetJobDetailProvider>(context, listen: false)
                                  .tentaiveJoiningDate
                                  .length !=
                              1
                          ? false
                          : false,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                itemCount:
                    Provider.of<GetJobDetailProvider>(context, listen: false)
                        .tentaiveJoiningDate
                        .length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        _displayJOBS(itemIndex),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displayCompanyName() {
    return Container(
      color: kbackgroundColor,
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.14,
            height: MediaQuery.of(context).size.width * 0.14,
            decoration: const ShapeDecoration(
                shape: CircleBorder(), color: Colors.white),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/user.jpg'))),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            child: Text(
              Provider.of<GetJobDetailProvider>(context, listen: false)
                  .companyName,
              style: TextStyle(
                  color: kBluePrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.045),
            ),
          ),
          const Spacer(),
          Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall
              ? const SizedBox()
              : _buildApplyText(),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  _displayRankDialog() {
    var alert = SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              title: const Text(
                'Select Ranks',
                style: TextStyle(color: Colors.black),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _displayRankCondition(),
                  _displayErrorText(),
                ],
              ),
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
                          child: const Text("OK"),
                          onPressed: () {
                            print(rankValue);
                            if (rankValue != null) {
                              if (rankValue.isEmpty) {
                                _errorRankBloc.eventResumeIssuingAuthoritySink
                                    .add(
                                        ResumeErrorIssuingAuthorityAction.True);
                              } else {
                                _callApplyJob();
                                Navigator.of(context).pop();
                              }
                            }
                          }),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            )));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _displayRankDropDown() {
    //clearDuplicateData();
    return Stack(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: StreamBuilder(
              initialData: false,
              stream: _errorRankBloc.stateResumeIssuingAuthorityStrean,
              builder: (context, errorsnapshot) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0,
                        color:
                            _errorRankBloc.showtext ? Colors.red : Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(
                            20.0) //                 <--- border radius here
                        ),
                  ),
                  child: StreamBuilder(
                    stream: _dropdownBloc.stateDropdownStrean,
                    builder: (context, dropdownsnapshot) {
                      return StreamBuilder(
                        stream: _showDropdown
                            .stateIndosNoStrean,
                        builder: (context, dropdownsnapshot) {
                          return Column(
                            children: [
                              DrodpownContainer(
                                title: rankValue.isNotEmpty
                                    ? rankValue
                                    : 'Select Rank',
                                searchHint: 'Search Rank',
                                showDropDownBloc:
                                    _showDropdown,
                                originalList:
                                    Provider.of<GetApplyRankProvider>(
                                      context,
                                      listen: false)
                                  .rankName,
                                showSearch: false,
                              ),
                              ExpandedSection(
                                expand: _showDropdown
                                    .isedited,
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
                                                  .searchList
                                                  .isNotEmpty
                                              ? Provider.of<
                                                          SearchChangeProvider>(
                                                      context,
                                                      listen: false)
                                                  .searchList
                                                  .length
                                              : Provider.of<GetApplyRankProvider>(
                                      context,
                                      listen: false)
                                  .rankName
                                                  .length,
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
                                                      _showDropdown.eventIndosNoSink
                                                          .add(IndosNoAction
                                                              .False);
                                                      _errorRankBloc.eventResumeIssuingAuthoritySink
                                                          .add(
                                                              ResumeErrorIssuingAuthorityAction
                                                                  .False);
                                                      rankValue = Provider.of<
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
                                                          : Provider.of<GetApplyRankProvider>(
                                      context,
                                      listen: false)
                                  .rankName[listindex];

                                                      _dropdownBloc.setdropdownvalue(rankValue);
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
                                                      
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16),
                                                      child: Text(Provider.of<
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
                                                          : Provider.of<GetApplyRankProvider>(
                                      context,
                                      listen: false)
                                  .rankName[listindex]),
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
                        });
                    
                    },
                  ),
                );
              },
            )),
        TextBoxLabel('Select Rank')
      ],
    );
  }

  void _getRanks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    GetApplyRankProvider applyProvider =
        Provider.of<GetApplyRankProvider>(context, listen: false);
    if (await applyProvider.callGetApplyRankapi(
        Provider.of<GetJobDetailProvider>(context, listen: false).jobId[
            Provider.of<GetJobDetailProvider>(context, listen: false)
                .currentIndex],
        header)) {
      for (int i = 0;
          i <
              Provider.of<GetApplyRankProvider>(context, listen: false)
                  .rankName
                  .length;
          i++) {
        _ranksListBloc.add(RadioButtonBloc());
        _ranksListBloc[i].eventRadioButtonSink.add(RadioButtonAction.False);
        _ranksListBloc[i].radioValue = false;
      }
      _showDialogBloc.eventRadioButtonSink.add(RadioButtonAction.True);
    }
    Provider.of<AsyncCallProvider>(context, listen: false).changeAsynccall();
  }

  _displayRankCondition() {
    return StreamBuilder(
      stream: _showDialogBloc.stateRadioButtonStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && _showDialogBloc.radioValue) {
          return _displayRankDropDown();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void _callApplyJob() async {
    bool result = await checkConnectivity();
    if (result) {
      callNoInternetScreen(
          JobDetail(
            companyId: companyId,
          ),
          context);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider asyncCallProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);

    asyncCallProvider.changeAsynccall();

    ApplyJobProvider applyJobProvider =
        Provider.of<ApplyJobProvider>(context, listen: false);
    if (!await applyJobProvider.callApplyJobapi(
        Provider.of<GetJobDetailProvider>(context, listen: false).jobId[
            Provider.of<GetJobDetailProvider>(context, listen: false)
                .currentIndex],
        Provider.of<GetApplyRankProvider>(context, listen: false).rankId[
            Provider.of<GetApplyRankProvider>(context, listen: false)
                .rankName
                .indexOf(rankValue)],
        Provider.of<GetJobDetailProvider>(context, listen: false).companyId,
        header)) {
      displaysnackbar('Something went wrong');
    } else {
      displaysnackbar('Job application submitted successfully');
      _applyTextBloc[Provider.of<GetJobDetailProvider>(context, listen: false)
              .currentIndex]
          .eventRadioButtonSink
          .add(RadioButtonAction.True);
      Provider.of<GetJobDetailProvider>(context, listen: false).isApplied[
          Provider.of<GetJobDetailProvider>(context, listen: false)
              .currentIndex] = true;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const JobList()));
    }

    asyncCallProvider.changeAsynccall();
  }

  _buildApplyText() {
    return StreamBuilder(
      stream: _applyTextBloc[
              Provider.of<GetJobDetailProvider>(context, listen: false)
                  .currentIndex]
          .stateRadioButtonStrean,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          if (Provider.of<GetJobDetailProvider>(context, listen: false)
                  .isApplied[
              Provider.of<GetJobDetailProvider>(context, listen: false)
                  .currentIndex]) {
            _applyTextBloc[
                    Provider.of<GetJobDetailProvider>(context, listen: false)
                        .currentIndex]
                .eventRadioButtonSink
                .add(RadioButtonAction.True);
          } else {
            _applyTextBloc[
                    Provider.of<GetJobDetailProvider>(context, listen: false)
                        .currentIndex]
                .eventRadioButtonSink
                .add(RadioButtonAction.False);
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                if (!_applyTextBloc[Provider.of<GetJobDetailProvider>(context,
                            listen: false)
                        .currentIndex]
                    .radioValue) {
                  if (Provider.of<UserDataProvider>(context, listen: false)
                          .jobAppPerDay <=
                      Provider.of<GetJobListProvider>(context, listen: false)
                          .numOfJobsApplied) {
                    _displayApplyLimitDialog();
                  } else {
                    if (!Provider.of<AsyncCallProvider>(context, listen: false)
                        .isinasynccall) {
                      Provider.of<AsyncCallProvider>(context, listen: false)
                          .changeAsynccall();
                    }
                    _getRanks();

                    _displayRankDialog();
                  }
                }
              },
              style: snapshot.hasData &&
                      _applyTextBloc[Provider.of<GetJobDetailProvider>(context,
                                  listen: false)
                              .currentIndex]
                          .radioValue
                  ? greybuttonStyle()
                  : buttonStyle(),
              child: Text(
                snapshot.hasData &&
                        _applyTextBloc[Provider.of<GetJobDetailProvider>(
                                    context,
                                    listen: false)
                                .currentIndex]
                            .radioValue
                    ? 'Applied'
                    : 'Apply Now',
                style: const TextStyle(color: kbackgroundColor),
              ),
            ),
            // Text(
            //   '* Buy Package to apply',
            //   style: TextStyle(color: kBluePrimaryColor),
            // )
          ],
        );
      },
    );
  }

  _displayCardData(int currentIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _labelList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.38,
                              child: _displayLabel(
                                  index != 2
                                      ? Icons.calendar_today
                                      : Icons.flag,
                                  _labelList[index]),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.48,
                              child: Text(
                                index == 0
                                    ? Provider.of<GetJobDetailProvider>(context,
                                            listen: false)
                                        .tentaiveJoiningDate[currentIndex]
                                    : index == 1
                                        ? Provider.of<GetJobDetailProvider>(
                                                context,
                                                listen: false)
                                            .jobExpirationDate[currentIndex]
                                        : Provider.of<GetJobDetailProvider>(
                                                context,
                                                listen: false)
                                            .nationality[currentIndex],
                                style: TextStyle(
                                  fontSize: checkDeviceSize(context)
                                      ? MediaQuery.of(context).size.width *
                                          0.035
                                      : MediaQuery.of(context).size.width *
                                          0.0245,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _displayLabel(IconData calendarToday, String s) {
    return Padding(
      padding: s == _labelList[2]
          ? const EdgeInsets.only(bottom: 0.0)
          : const EdgeInsets.only(bottom: 0.0),
      child: Row(
        children: [
          Icon(
            calendarToday,
            size: checkDeviceSize(context)
                ? MediaQuery.of(context).size.width * 0.045
                : MediaQuery.of(context).size.width * 0.04,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            s,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void getdata() async {
    bool result = await checkConnectivity();
    if (result) {
      callNoInternetScreen(
          JobDetail(
            companyId: companyId,
          ),
          context);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    print(companyId);
    _dropdownShowBloc.radioValue = false;
    _showDialogBloc.eventRadioButtonSink.add(RadioButtonAction.False);
    _showDialogBloc.radioValue = false;

    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    GetJobDetailProvider jobDetailProvider =
        Provider.of<GetJobDetailProvider>(context, listen: false);
    if (await jobDetailProvider.callGetJobDetailapi(companyId, header)) {
      print('Api call done');
    }

    for (int i = 0;
        i <
            Provider.of<GetJobDetailProvider>(context, listen: false)
                .isApplied
                .length;
        i++) {
      print('Inside apply');
      _applyTextBloc.add(RadioButtonBloc());
      print(
          Provider.of<GetJobDetailProvider>(context, listen: false).isApplied);
      if (Provider.of<GetJobDetailProvider>(context, listen: false)
          .isApplied[i]) {
        _applyTextBloc[i].eventRadioButtonSink.add(RadioButtonAction.True);
        _applyTextBloc[i].radioValue = true;
      } else {
        _applyTextBloc[i].eventRadioButtonSink.add(RadioButtonAction.False);
        _applyTextBloc[i].radioValue = false;
      }
    }

    asyncProvider.changeAsynccall();
  }

  _displayRankData(int currentIndex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
              Row(
                children: const [
                  Text(
                    'Ranks',
                    style: TextStyle(
                        color: kBluePrimaryColor, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(
                    Icons.location_on,
                    size: 14,
                  ),
                  Text(' - COC Issuing Authority'),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              _displaySubRankData(true, currentIndex),
              _displaySubRankData(
                false,
                currentIndex,
              )
            ],
          ),
        ),
      ),
    );
  }

  _displaySubRankData(bool isDeck, int currentIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Card(
        elevation: 3,
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isDeck ? 'Deck/Navigation' : 'Engine',
                style: const TextStyle(
                    color: kblackPrimaryColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: isDeck
                      ? Provider.of<GetJobDetailProvider>(context,
                              listen: false)
                          .deckRankDetail[currentIndex]
                          .length
                      : Provider.of<GetJobDetailProvider>(context,
                              listen: false)
                          .navigationRankDetail[currentIndex]
                          .length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: GreenBullet(),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                isDeck
                                    ? Provider.of<GetJobDetailProvider>(context,
                                            listen: false)
                                        .deckRankDetail[currentIndex][index]
                                    : Provider.of<GetJobDetailProvider>(context,
                                                listen: false)
                                            .navigationRankDetail[currentIndex]
                                        [index],
                                style:
                                    const TextStyle(color: kBluePrimaryColor),
                              ),
                              const Spacer(),
                              const Text('Exp:'),
                              Text(
                                isDeck
                                    ? '${Provider.of<GetJobDetailProvider>(context, listen: false).deckexperienceYears[currentIndex][index]} years'
                                    : '${Provider.of<GetJobDetailProvider>(context, listen: false).navexperienceYears[currentIndex][index]} years',
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                ),
                                _displayCountries(isDeck
                                    ? Provider.of<GetJobDetailProvider>(context,
                                            listen: false)
                                        .deckCountries[0][currentIndex]
                                    : Provider.of<GetJobDetailProvider>(context,
                                            listen: false)
                                        .navigationCountries[0][currentIndex]),
                              ],
                            ),
                          ),
                          isDeck
                              ? index ==
                                      Provider.of<GetJobDetailProvider>(context,
                                                  listen: false)
                                              .deckRankDetail[currentIndex]
                                              .length -
                                          1
                                  ? const SizedBox()
                                  : _showDivider()
                              : index ==
                                      Provider.of<GetJobDetailProvider>(context,
                                                  listen: false)
                                              .navigationRankDetail[
                                                  currentIndex]
                                              .length -
                                          1
                                  ? const SizedBox()
                                  : _showDivider(),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displayVesselData(int currentIndex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
              const Text(
                'Vessel Types',
                style: TextStyle(
                    color: kBluePrimaryColor, fontWeight: FontWeight.bold),
              ),
              _displayVesselTypes(currentIndex),
            ],
          ),
        ),
      ),
    );
  }

  _displayDescription(int currentIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        Provider.of<GetJobDetailProvider>(context, listen: false)
            .description[currentIndex],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  _displayVesselTypes(int currentIndex) {
    List<Widget> vesselTypeList = [];
    for (int i = 0;
        i <
            Provider.of<GetJobDetailProvider>(context, listen: false)
                .vesselType[currentIndex]
                .length;
        i++) {
      vesselTypeList.add(Wrap(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: GreenBullet(),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(Provider.of<GetJobDetailProvider>(context, listen: false)
              .vesselType[currentIndex][i]),
          const SizedBox(
            width: 25,
          ),
        ],
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Wrap(
          children: vesselTypeList,
        ),
      ),
    );
  }

  _displayBottomNavigationButtons(int currentIndex) {
    return Container(
      color: kbackgroundColor,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, bottom: 12, top: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Other jobs from this company'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    buttonCarouselController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear);
                  },
                  style: buttonStyle(),
                  child: const Text(
                    'Previous',
                    style: TextStyle(color: kbackgroundColor),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    buttonCarouselController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear);
                  },
                  style: buttonStyle(),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: kbackgroundColor),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _displayCountries(List<String> list) {
    print('In List');
    List<Widget> rankCountryList = [];
    for (int i = 0; i < list.length; i++) {
      rankCountryList.add(Wrap(
        children: [Text(list[i]), Text(i == list.length - 1 ? '' : ', ')],
      ));
    }

    return Wrap(
      children: rankCountryList,
    );
  }

  _showDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Divider(
        thickness: 0.2,
        color: Colors.grey,
      ),
    );
  }

  _displayJobDetailData(int currentIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _displayCompanyName(),
        const SizedBox(
          height: 5,
        ),
        Provider.of<AsyncCallProvider>(context).isinasynccall
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _displayCardData(currentIndex),
                  _displayRankData(currentIndex),
                  _displayVesselData(currentIndex),
                  _displayDescription(currentIndex),
                ],
              )
      ],
    );
  }

  _displayJOBS(int itemIndex) {
    Provider.of<GetJobDetailProvider>(context, listen: false).currentIndex =
        itemIndex;
    return Container(child: _displayJobDetailData(itemIndex));
  }

  void _displayApplyLimitDialog() {
    var alert = SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              title: const Text(
                'Plan error',
                style: TextStyle(color: Colors.black),
              ),
              content: const Text('You have reached your plan limit'),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: kbackgroundColor,
                      //width: double.maxFinite,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: bluebuttonStyle(),
                        child: const Text("OK"),
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
            )));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _displayErrorText() {
    return StreamBuilder(
      initialData: false,
      stream: _errorRankBloc.stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && _errorRankBloc.showtext) {
          return Visibility(
            visible: _errorRankBloc.showtext,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please select the rank',
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
}
