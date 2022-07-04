// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../DropdownBloc.dart';
import '../../DropdownContainer.dart';
import '../../IssuingAuthorityErrorBloc.dart';
import '../../Profile/UserDetailsProvider.dart';
import '../../RadioButtonBloc.dart';
import '../../SearchTextProvider.dart';
import '../../TextBoxLabel.dart';
import '../../asynccallprovider.dart';
import '../../constants.dart';
import '../../singledialog.dart';
import '../Header.dart';
import 'DisplayVesselPrefBloc.dart';
import 'EditJobPreferencesProvider.dart';
import 'ExpandedAnimation.dart';
import 'GetResumeProvider.dart';
import 'IndosNoBloc.dart';
import 'OtherCountryBloc.dart';
import 'RankBloc.dart';
import 'ResumeBuilder.dart';
import 'ResumeNationalityBloc.dart';
import 'Scrollbar.dart';
import 'SecondaryRankProvider.dart';
import 'VesselBloc.dart';

class JobPreferencesEdit extends StatefulWidget {
  const JobPreferencesEdit({Key? key}) : super(key: key);

  @override
  _JobPreferencesEditState createState() => _JobPreferencesEditState();
}

class _JobPreferencesEditState extends State<JobPreferencesEdit> {
  final _radioBloc = IndosNoBloc();
  static final _formKey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd");
  final _vesselBloc = VesselBloc();
  final _rankBloc = RankBloc();
  final _nationalityBloc = ResumeNationalityBloc();
  final _rankdropdownBloc = DropdownBloc(),
      _vesseldropdownBloc = DropdownBloc(),
      _nationalitydropdownBloc = DropdownBloc(),
      _secondaryRankdropdownBloc = DropdownBloc();
  final _indosNo = IndosNoBloc(),
      _showDropDownBloc = IndosNoBloc(),
      _showRankDropDownBloc = IndosNoBloc(),
      _showSecondaryRankDropDownBloc = IndosNoBloc(),
      _showNationalityDropDownBloc = IndosNoBloc();
  final _otherCountyBloc = OtherCountryBloc();
  final _displayVesselPrefBloc = DisplayVesselPrefBloc();
  String rankvalue = "", nationalityvalue = "", secondaryRankValue = "";
  final _secondaryRankShowBloc = RadioButtonBloc();
  List<String> vesseltype = [];
  int radiovalue = 0;
  final TextEditingController indosno = TextEditingController(),
      tentativedateController = TextEditingController(),
      _countryNameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isStrechedDropDown = false;
  var header;
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final _errorVesselTypeBloc = ResumeErrorIssuingAuthorityBloc(),
      _errorRankTypeBloc = ResumeErrorIssuingAuthorityBloc(),
      _errorCountryTypeBloc = ResumeErrorIssuingAuthorityBloc(),
      _errorSecondaryRankBloc = ResumeErrorIssuingAuthorityBloc();
  final List<DropdownMenuItem> dropdownitems = [];

  final List<String> errors = [];
  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void dispose() {
    _radioBloc.dispose();
    _vesselBloc.dispose();
    _rankBloc.dispose();
    _nationalityBloc.dispose();
    _errorSecondaryRankBloc.dispose();
    _secondaryRankdropdownBloc.dispose();
    _rankdropdownBloc.dispose();
    _vesseldropdownBloc.dispose();
    _nationalitydropdownBloc.dispose();
    _indosNo.dispose();
    _otherCountyBloc.dispose();
    _displayVesselPrefBloc.dispose();
    _showDropDownBloc.dispose();
    _showRankDropDownBloc.dispose();
    _showSecondaryRankDropDownBloc.dispose();
    _showNationalityDropDownBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    clearDuplicateData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    clearDuplicateData();
    // TODO: implement build
    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ResumeHeader('Personal Information', 1, true, ""),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      color: Colors.grey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _displayheadertext('Looking for promotion?'),
                                StreamBuilder(
                                  initialData: Provider.of<GetResumeProvider>(
                                              context,
                                              listen: false)
                                          .lookingPromotion
                                          .isEmpty
                                      ? true
                                      : Provider.of<GetResumeProvider>(context,
                                                      listen: false)
                                                  .lookingPromotion ==
                                              "1"
                                          ? true
                                          : false,
                                  stream: _radioBloc.stateIndosNoStrean,
                                  builder: (context, snapshot) {
                                    if (_radioBloc.isedited) {
                                      radiovalue = 1;
                                    } else {
                                      radiovalue = 0;
                                    }
                                    if (snapshot.hasData &&
                                        _radioBloc.isedited) {
                                      return _displayradiobuttons();
                                    } else {
                                      return Column(
                                        children: [
                                          _displayradiobuttons(),
                                        ],
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                _displayRankDropdown(true),
                                _displayErrorText('Please select the rank',
                                    _errorRankTypeBloc),
                                _displayRankDropdown(false),
                                _displayErrorText('Please select the rank',
                                    _errorSecondaryRankBloc),
                                const SizedBox(
                                  height: 10,
                                ),
                                _displayVesselPreferenceDropdown(),
                                _displaychips(),
                                _displayErrorText('Please select the vessel',
                                    _errorVesselTypeBloc),
                                const SizedBox(
                                  height: 10,
                                ),
                                _displayheadertext('Tentative Available Date'),
                                const SizedBox(
                                  height: 10,
                                ),
                                _displayTentaiveCalender(),
                                const SizedBox(
                                  height: 10,
                                ),
                                _displayNationalityDropdown(),
                                _displayErrorText('Please select the country',
                                    _errorCountryTypeBloc),
                                const SizedBox(
                                  height: 10,
                                ),
                                _displayOtherCountry(),
                                _displayIndosNo(),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: buttonStyle(),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          if (!checkdata()) {
                                            _formKey.currentState!.save();
                                            callpostjobpreferencesfunction();
                                          }
                                        } else {
                                          var data = checkdata();
                                        }
                                      },
                                      child: const Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
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
                          ))))
            ],
          ),
        ),
      ),
    );
  }

  _displayheadertext(String label) {
    return Text(
      label,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.04,
          fontWeight: FontWeight.bold),
    );
  }

  _displayradiobuttons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkWell(
            onTap: () => _radioBloc.eventIndosNoSink.add(IndosNoAction.True),
            child: Row(
              children: [
                _radioBloc.isedited
                    ? const Icon(
                        Icons.radio_button_checked,
                        color: kgreenPrimaryColor,
                      )
                    : const Icon(
                        Icons.radio_button_unchecked,
                        color: kgreenPrimaryColor,
                      ),
                const SizedBox(
                  width: 5,
                ),
                const Text('Yes'),
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () => _radioBloc.eventIndosNoSink.add(IndosNoAction.False),
            child: Row(
              children: [
                _radioBloc.isedited
                    ? const Icon(
                        Icons.radio_button_unchecked,
                        color: kgreenPrimaryColor,
                      )
                    : const Icon(
                        Icons.radio_button_checked,
                        color: kgreenPrimaryColor,
                      ),
                const SizedBox(
                  width: 5,
                ),
                const Text('No'),
              ],
            ),
          )
        ],
      ),
    );
  }

  _displayNationalityDropdown() {
    return StreamBuilder(
      stream: _nationalityBloc.stateResumenatioNalityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (Provider.of<GetResumeProvider>(context, listen: false)
                  .nationality
                  .isEmpty &&
              nationalityvalue.isEmpty) {
            nationalityvalue = _nationalityBloc.nationalityname[0];
            _nationalitydropdownBloc.setdropdownvalue(nationalityvalue);
            _nationalitydropdownBloc.eventDropdownSink
                .add(DropdownAction.Update);
            _indosNo.eventIndosNoSink.add(IndosNoAction.True);
          } else if (Provider.of<GetResumeProvider>(context, listen: false)
              .nationality
              .isNotEmpty) {
            nationalityvalue =
                Provider.of<GetResumeProvider>(context, listen: false)
                    .nationality;
            _nationalitydropdownBloc.setdropdownvalue(nationalityvalue);
            _nationalitydropdownBloc.eventDropdownSink
                .add(DropdownAction.Update);
            if (Provider.of<GetResumeProvider>(context, listen: false)
                    .nationality ==
                _nationalityBloc.nationalityname[0]) {
              _indosNo.eventIndosNoSink.add(IndosNoAction.True);
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _displayheadertext('Nationality'),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: _errorCountryTypeBloc.stateResumeIssuingAuthorityStrean,
                builder: (context, errorsnapshot) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0,
                                color: errorsnapshot.hasData &&
                                        _errorCountryTypeBloc.showtext
                                    ? Colors.red
                                    : Colors.grey),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(
                                    20.0) //                 <--- border radius here
                                ),
                          ),
                          child: StreamBuilder(
                            initialData: Provider.of<GetResumeProvider>(context,
                                        listen: false)
                                    .nationality
                                    .isNotEmpty
                                ? Provider.of<GetResumeProvider>(context,
                                        listen: false)
                                    .nationality
                                : nationalityvalue,
                            stream:
                                _nationalitydropdownBloc.stateDropdownStrean,
                            builder: (context, dropdownsnapshot) {
                              return StreamBuilder(
                                stream: _showNationalityDropDownBloc
                                    .stateIndosNoStrean,
                                initialData: false,
                                builder: (context, snapshot) {
                                  return Column(
                                    children: [
                                      DrodpownContainer(
                                        title: nationalityvalue.isNotEmpty
                                            ? nationalityvalue
                                            : 'Select Country',
                                        searchHint: 'Search Country',
                                        showDropDownBloc:
                                            _showNationalityDropDownBloc,
                                        originalList:
                                            _nationalityBloc.nationalityname,
                                      ),
                                      ExpandedSection(
                                        expand: _showNationalityDropDownBloc
                                            .isedited,
                                        height: 100,
                                        child: MyScrollbar(
                                          builder:
                                              (context, scrollController2) =>
                                                  ListView.builder(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      controller:
                                                          scrollController2,
                                                      shrinkWrap: true,
                                                      itemCount: Provider.of<SearchChangeProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .noDataFound
                                                          ? 1
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
                                                                  .searchList
                                                                  .length
                                                              : _nationalityBloc
                                                                  .nationalityname
                                                                  .length,
                                                      itemBuilder: (context, listindex) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  if (!Provider.of<
                                                                              SearchChangeProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .noDataFound) {
                                                                    _showNationalityDropDownBloc
                                                                        .eventIndosNoSink
                                                                        .add(IndosNoAction
                                                                            .False);
                                                                    _errorCountryTypeBloc
                                                                        .eventResumeIssuingAuthoritySink
                                                                        .add(ResumeErrorIssuingAuthorityAction
                                                                            .False);
                                                                    nationalityvalue = Provider.of<SearchChangeProvider>(context, listen: false)
                                                                            .searchList
                                                                            .isNotEmpty
                                                                        ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                            listindex]
                                                                        : _nationalityBloc
                                                                            .nationalityname[listindex];

                                                                    _nationalitydropdownBloc.setdropdownvalue(Provider.of<SearchChangeProvider>(context, listen: false)
                                                                            .searchList
                                                                            .isNotEmpty
                                                                        ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                            listindex]
                                                                        : _nationalityBloc
                                                                            .nationalityname[listindex]);
                                                                    _nationalitydropdownBloc
                                                                        .eventDropdownSink
                                                                        .add(DropdownAction
                                                                            .Update);
                                                                    Provider.of<SearchChangeProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .searchKeyword = "";
                                                                    Provider.of<SearchChangeProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .searchList = [];
                                                                    if (nationalityvalue ==
                                                                        _nationalityBloc
                                                                            .nationalityname[0]) {
                                                                      _indosNo
                                                                          .eventIndosNoSink
                                                                          .add(IndosNoAction
                                                                              .True);
                                                                    } else {
                                                                      _indosNo
                                                                          .eventIndosNoSink
                                                                          .add(IndosNoAction
                                                                              .False);
                                                                    }

                                                                    if (_nationalityBloc.nationalitycode[_nationalityBloc
                                                                            .nationalityname
                                                                            .indexOf(nationalityvalue)] ==
                                                                        otherNationalityId) {
                                                                      _otherCountyBloc
                                                                          .eventOtherCountrySink
                                                                          .add(OtherCountryAction
                                                                              .True);
                                                                    } else {
                                                                      _otherCountyBloc
                                                                          .eventOtherCountrySink
                                                                          .add(OtherCountryAction
                                                                              .False);
                                                                    }
                                                                  }
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16),
                                                                  child: Text(Provider.of<SearchChangeProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .noDataFound
                                                                      ? 'No Data Found'
                                                                      : Provider.of<SearchChangeProvider>(context, listen: false)
                                                                              .searchList
                                                                              .isNotEmpty
                                                                          ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                              listindex]
                                                                          : _nationalityBloc
                                                                              .nationalityname[listindex]),
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
                      ),
                      TextBoxLabel('Select Country')
                    ],
                  );
                },
              )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
                backgroundColor: kbackgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
          );
        }
      },
    );
  }

  _displayVesselPreferenceDropdown() {
    return StreamBuilder(
      stream: _vesselBloc.stateVesselStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (Provider.of<GetResumeProvider>(context, listen: false)
              .vesselType
              .isNotEmpty) {
            List<String> vesseltypeid =
                Provider.of<GetResumeProvider>(context, listen: false)
                    .vesselType;
            for (int i = 0; i < vesseltypeid.length; i++) {
              vesseltype.add(_vesselBloc
                  .vesselname[_vesselBloc.vesselid.indexOf(vesseltypeid[i])]);
            }
            _displayVesselPrefBloc.eventDisplayVesselPrefSink
                .add(DisplayVesselPrefAction.True);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _displayheadertext('Vessel Preference'),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: _errorVesselTypeBloc.stateResumeIssuingAuthorityStrean,
                builder: (context, errorsnapshot) {
                  return Stack(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0,
                                  color: errorsnapshot.hasData &&
                                          _errorVesselTypeBloc.showtext
                                      ? Colors.red
                                      : Colors.grey),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                      20.0) //                 <--- border radius here
                                  ),
                            ),
                            child: showVesselDropdown(),
                          )),
                      TextBoxLabel('Vessel Type')
                    ],
                  );
                },
              )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
                backgroundColor: kbackgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
          );
        }
      },
    );
  }

  _displayRankDropdown(bool isPrimary) {
    return isPrimary
        ? _rankDropdown()
        : StreamBuilder(
            stream: _secondaryRankShowBloc.stateRadioButtonStrean,
            builder: (context, snapshot) {
              if (_secondaryRankShowBloc.radioValue) {
                return _secondaryRankDropdown();
              } else {
                return Container();
              }
            },
          );
  }

  _rankDropdown() {
    return StreamBuilder(
      stream: _rankBloc.stateRankStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (Provider.of<GetResumeProvider>(context, listen: false)
                  .rankName
                  .isNotEmpty &&
              rankvalue.isNotEmpty) {
            rankvalue =
                Provider.of<GetResumeProvider>(context, listen: false).rankName;
            _secondaryRankShowBloc.eventRadioButtonSink
                .add(RadioButtonAction.True);
            _secondaryRankShowBloc.radioValue = true;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _displayheadertext('Application for the rank'),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: _errorRankTypeBloc.stateResumeIssuingAuthorityStrean,
                builder: (context, errorsnapshot) {
                  clearDuplicateData();
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0,
                                color: errorsnapshot.hasData &&
                                        _errorRankTypeBloc.showtext
                                    ? Colors.red
                                    : Colors.grey),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(
                                    20.0) //                 <--- border radius here
                                ),
                          ),
                          child: StreamBuilder(
                            initialData: Provider.of<GetResumeProvider>(context,
                                            listen: false)
                                        .rankName !=
                                    ""
                                ? Provider.of<GetResumeProvider>(context,
                                        listen: false)
                                    .rankName
                                : "",
                            stream: _rankdropdownBloc.stateDropdownStrean,
                            builder: (context, dropdownsnapshot) {
                              return StreamBuilder(
                                stream:
                                    _showRankDropDownBloc.stateIndosNoStrean,
                                initialData: false,
                                builder: (context, snapshot) {
                                  return Column(
                                    children: [
                                      DrodpownContainer(
                                        title: rankvalue.isNotEmpty
                                            ? rankvalue
                                            : 'Select Rank',
                                        searchHint: 'Search Rank',
                                        showDropDownBloc: _showRankDropDownBloc,
                                        originalList: _rankBloc.rankname,
                                      ),
                                      ExpandedSection(
                                        expand: _showRankDropDownBloc.isedited,
                                        height: 100,
                                        child: MyScrollbar(
                                          builder:
                                              (context, scrollController2) =>
                                                  ListView.builder(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      controller:
                                                          scrollController2,
                                                      shrinkWrap: true,
                                                      itemCount: Provider.of<SearchChangeProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .noDataFound
                                                          ? 1
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
                                                                  .searchList
                                                                  .length
                                                              : _rankBloc
                                                                  .rankname
                                                                  .length,
                                                      itemBuilder: (context, listindex) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  if (!Provider.of<
                                                                              SearchChangeProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .noDataFound) {
                                                                    _showRankDropDownBloc
                                                                        .eventIndosNoSink
                                                                        .add(IndosNoAction
                                                                            .False);
                                                                    _errorRankTypeBloc
                                                                        .eventResumeIssuingAuthoritySink
                                                                        .add(ResumeErrorIssuingAuthorityAction
                                                                            .False);
                                                                    rankvalue = Provider.of<SearchChangeProvider>(context, listen: false)
                                                                            .searchList
                                                                            .isNotEmpty
                                                                        ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                            listindex]
                                                                        : _rankBloc
                                                                            .rankname[listindex];

                                                                    _rankdropdownBloc.setdropdownvalue(Provider.of<SearchChangeProvider>(context, listen: false)
                                                                            .searchList
                                                                            .isNotEmpty
                                                                        ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                            listindex]
                                                                        : _rankBloc
                                                                            .rankname[listindex]);
                                                                    _rankdropdownBloc
                                                                        .eventDropdownSink
                                                                        .add(DropdownAction
                                                                            .Update);
                                                                    Provider.of<SearchChangeProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .searchKeyword = "";
                                                                    Provider.of<SearchChangeProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .searchList = [];
                                                                    _errorRankTypeBloc
                                                                        .eventResumeIssuingAuthoritySink
                                                                        .add(ResumeErrorIssuingAuthorityAction
                                                                            .False);

                                                                    if (await Provider.of<SecondaryRankProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .callSecondaryRankapi(
                                                                            _rankBloc.rankid[_rankBloc.rankname.indexOf(rankvalue)],
                                                                            header)) {
                                                                      setState(
                                                                          () {
                                                                        _secondaryRankShowBloc
                                                                            .eventRadioButtonSink
                                                                            .add(RadioButtonAction.True);
                                                                        _secondaryRankShowBloc.radioValue =
                                                                            true;
                                                                      });
                                                                    }
                                                                    // Future.delayed(const Duration(
                                                                    //         seconds:
                                                                    //             1))
                                                                    //     .then((value) =>
                                                                    //         setState(
                                                                    //             () {
                                                                    //           clearDuplicateData();
                                                                    //         }));
                                                                  }
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16),
                                                                  child: Text(Provider.of<SearchChangeProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .noDataFound
                                                                      ? 'No Data Found'
                                                                      : Provider.of<SearchChangeProvider>(context, listen: false)
                                                                              .searchList
                                                                              .isNotEmpty
                                                                          ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                              listindex]
                                                                          : _rankBloc
                                                                              .rankname[listindex]),
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
                      ),
                      TextBoxLabel('Rank Name')
                    ],
                  );
                },
              )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
                backgroundColor: kbackgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
          );
        }
      },
    );
  }

  _displayTentaiveCalender() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller: tentativedateController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please select the date');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please select the date';
                  //addError(error: kEmailNullError);

                }
                return null;
              },
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 34),
                  //floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  suffixIcon: InkWell(
                    onTap: () => _selectDate(context),
                    child: const Icon(
                      Icons.date_range,
                      color: kBluePrimaryColor,
                    ),
                  ),
                  hintText: 'Enter your tentaive date',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Tentative Available Date')
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      tentativedateController.text = formatter.format(picked);
    }
  }

  void callpostjobpreferencesfunction() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const JobPreferencesEdit(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    ResumeJobPreferencesUpdateProvider resumeJobPreferencesUpdateProvider =
        Provider.of<ResumeJobPreferencesUpdateProvider>(context, listen: false);
    Object nationality;
    if (nationalityvalue == "Others") {
      nationality = 1;
    } else {
      nationality = _nationalityBloc.nationalitycode[
          _nationalityBloc.nationalityname.indexOf(nationalityvalue)];
    }
    List<String> postVesselId = [];
    for (int i = 0; i < vesseltype.length; i++) {
      postVesselId.add(
          _vesselBloc.vesselid[_vesselBloc.vesselname.indexOf(vesseltype[i])]);
    }
    var secondaryRankId = "";
    if (Provider.of<SecondaryRankProvider>(context, listen: false)
        .secondaryrankid
        .isNotEmpty) {
      secondaryRankId =
          Provider.of<SecondaryRankProvider>(context, listen: false)
                  .secondaryrankid[
              Provider.of<SecondaryRankProvider>(context, listen: false)
                  .secondaryrankname
                  .indexOf(secondaryRankValue)];
    }
    if (await resumeJobPreferencesUpdateProvider
        .callpostResumeJobPreferencesapi(
            radiovalue,
            _rankBloc.rankid[_rankBloc.rankname.indexOf(rankvalue)],
            secondaryRankId,
            postVesselId,
            tentativedateController.text,
            nationality,
            indosno.text,
            _countryNameController.text,
            Provider.of<UserDetailsProvider>(context, listen: false).userid,
            header)) {
      asyncProvider.changeAsynccall();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('ResumeUpdateSuccess', 'Resume updated successfully');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ResumeBuilder()));
    } else {
      asyncProvider.changeAsynccall();
      displaysnackbar(Provider.of<ResumeJobPreferencesUpdateProvider>(context,
              listen: false)
          .error);
    }
  }

  _displayIndosNo() {
    return StreamBuilder(
      initialData: false,
      stream: _indosNo.stateIndosNoStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && _indosNo.isedited) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _displayheadertext('Indos Number'),
              const SizedBox(
                height: 10,
              ),
              _displayIndosNoTF(),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  _displayIndosNoTF() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
              ],
              maxLength: 8,
              cursorColor: kgreenPrimaryColor,
              controller: indosno,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter your indos number');
                } else if (value.length == 8) {
                  removeError(error: 'Please enter a valid indos number');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your indos number';
                  //addError(error: kEmailNullError);

                } else if (value.length < 8) {
                  return 'Please enter a valid indos number';
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
                  hintText: 'Enter your indos number',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Indos Number')
      ],
    );
  }

  _displayErrorText(String s, var bloc) {
    return StreamBuilder(
      initialData: false,
      stream: bloc.stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && bloc.showtext) {
          return Visibility(
            visible: bloc.showtext,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  s,
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

  void getdata() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const JobPreferencesEdit(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    _rankBloc.header = _vesselBloc.header = _nationalityBloc.header = header;
    _vesselBloc.eventVesselSink.add(VesselAction.Post);
    _nationalityBloc.eventResumeNationalitySink
        .add(ResumeNationalityAction.Post);
    _rankBloc.eventRankSink.add(RankAction.Post);
    tentativedateController.text =
        Provider.of<GetResumeProvider>(context, listen: false)
            .tentativejoiningdate;
    if (Provider.of<GetResumeProvider>(context, listen: false)
        .nationalityid
        .isNotEmpty) {
      nationalityvalue =
          Provider.of<GetResumeProvider>(context, listen: false).nationality;
      _nationalitydropdownBloc.setdropdownvalue(nationalityvalue);
      _nationalitydropdownBloc.eventDropdownSink.add(DropdownAction.Update);
    }

    if (Provider.of<GetResumeProvider>(context, listen: false)
        .countryid
        .isNotEmpty) {
      rankvalue =
          Provider.of<GetResumeProvider>(context, listen: false).rankName;
      _rankdropdownBloc.setdropdownvalue(nationalityvalue);
      _rankdropdownBloc.eventDropdownSink.add(DropdownAction.Update);
    }
    if (Provider.of<GetResumeProvider>(context, listen: false)
        .rankId
        .isNotEmpty) {
      Provider.of<SecondaryRankProvider>(context, listen: false)
          .callSecondaryRankapi(
              Provider.of<GetResumeProvider>(context, listen: false).rankId,
              header);
      _secondaryRankShowBloc.eventRadioButtonSink.add(RadioButtonAction.True);
      _secondaryRankShowBloc.radioValue = true;
      secondaryRankValue =
          Provider.of<GetResumeProvider>(context, listen: false).secondaryRank;
      _secondaryRankdropdownBloc.setdropdownvalue(secondaryRankValue);
      _secondaryRankdropdownBloc.eventDropdownSink.add(DropdownAction.Update);
    }

    if (Provider.of<GetResumeProvider>(context, listen: false).nationalityid ==
        indianNationalityId) _indosNo.eventIndosNoSink.add(IndosNoAction.True);
    indosno.text =
        Provider.of<GetResumeProvider>(context, listen: false).indosno;
    if (Provider.of<GetResumeProvider>(context, listen: false).nationalityid ==
        otherNationalityId) {
      _otherCountyBloc.eventOtherCountrySink.add(OtherCountryAction.True);
      _countryNameController.text =
          Provider.of<GetResumeProvider>(context, listen: false)
              .othernationality;
    }
    clearDuplicateData();

    asyncProvider.changeAsynccall();
  }

  _displayOtherCountry() {
    return StreamBuilder(
      initialData: false,
      stream: _otherCountyBloc.stateOtherCountryStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && _otherCountyBloc.isedited) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _displayheadertext('Other'),
              const SizedBox(
                height: 10,
              ),
              _displayOtherCountryTF(),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  _displayOtherCountryTF() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
              ],
              maxLength: 8,
              cursorColor: kgreenPrimaryColor,
              controller: _countryNameController,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter the country name');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the country name';
                  //addError(error: kEmailNullError);

                }
                return null;
              },
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 34),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter the country',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Others')
      ],
    );
  }

  bool checkdata() {
    bool isValid = false;
    if (Provider.of<SecondaryRankProvider>(context, listen: false)
        .secondaryrankname
        .isNotEmpty) {
      if (secondaryRankValue.isEmpty) {
        isValid = true;
        _errorSecondaryRankBloc.eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
      } else if (secondaryRankValue.isEmpty) {
        isValid = true;
        _errorSecondaryRankBloc.eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
      }
    }
    if (rankvalue.isEmpty) {
      isValid = true;
      _errorRankTypeBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
    }
    if (vesseltype.isEmpty) {
      isValid = true;
      _errorVesselTypeBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
    }
    if (nationalityvalue.isEmpty) {
      isValid = true;
      _errorCountryTypeBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
    }

    return isValid;
  }

  _displaychips() {
    clearDuplicateData();
    return StreamBuilder(
      initialData: false,
      stream: _displayVesselPrefBloc.stateDisplayVesselPrefStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && _displayVesselPrefBloc.isedited) {
          clearDuplicateData();
          return Wrap(
            direction: Axis.horizontal,
            children: [
              vesseltype.isNotEmpty ? showchips(0) : const SizedBox(),
              vesseltype.length > 1 ? showchips(1) : const SizedBox(),
              vesseltype.length > 2 ? showchips(2) : const SizedBox(),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void showLimitdialog(String errormsg) {
    BlurryDialogSingle alert = BlurryDialogSingle("Error", errormsg);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  clearDuplicateData() {
    final ids = <dynamic>{};
    vesseltype.retainWhere((x) => ids.add(x));
  }

  showVesselDropdown() {
    clearDuplicateData();
    return Column(
      children: [
        DrodpownContainer(
          title: 'Select Vessel Type',
          showDropDownBloc: _showDropDownBloc,
          searchHint: 'Search Vessel Type',
          originalList: [],
          showSearch: false,
        ),
        StreamBuilder(
          stream: _showDropDownBloc.stateIndosNoStrean,
          initialData: false,
          builder: (context, snapshot) {
            return ExpandedSection(
              expand: _showDropDownBloc.isedited,
              height: 100,
              child: MyScrollbar(
                builder: (context, scrollController2) => ListView.builder(
                    padding: const EdgeInsets.all(0),
                    controller: scrollController2,
                    shrinkWrap: true,
                    itemCount: _vesselBloc.itemVessel.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _vesselBloc.itemVessel[index].type ==
                                    "ItemClass.FIRST_LEVEL"
                                ? Text(_vesselBloc.itemVessel[index].name,
                                    style: const TextStyle(color: Colors.grey))
                                : InkWell(
                                    onTap: () {
                                      if (vesseltype.length >= 3) {
                                        showLimitdialog(
                                            'You cannot select more than 3 vessel preferences.');
                                      } else {
                                        if (vesseltype.contains(_vesselBloc
                                            .itemVessel[index].name)) {
                                          showLimitdialog(
                                              'You have already selected this vessel.');
                                        } else {
                                          if (!vesseltype.contains(_vesselBloc
                                              .itemVessel[index].name)) {
                                            Provider.of<GetResumeProvider>(
                                                    context,
                                                    listen: false)
                                                .increaselength();
                                            vesseltype.add(_vesselBloc
                                                .itemVessel[index].name);
                                            _displayVesselPrefBloc
                                                .eventDisplayVesselPrefSink
                                                .add(DisplayVesselPrefAction
                                                    .True);
                                            _errorVesselTypeBloc
                                                .eventResumeIssuingAuthoritySink
                                                .add(
                                                    ResumeErrorIssuingAuthorityAction
                                                        .False);
                                          }
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                          _vesselBloc.itemVessel[index].name),
                                    ),
                                  )
                          ],
                        ),
                      );
                    }),
              ),
            );
          },
        )
      ],
    );
  }

  showchips(int index) {
    return Chip(
      elevation: 8,
      padding: const EdgeInsets.all(8),
      backgroundColor: kBluePrimaryColor,
      shadowColor: Colors.black,
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
        color: kbackgroundColor,
      ),
      onDeleted: () {
        vesseltype.removeAt(index);
        Provider.of<GetResumeProvider>(context, listen: false).decreaselength();
        _displayVesselPrefBloc.eventDisplayVesselPrefSink
            .add(DisplayVesselPrefAction.True);
        if (vesseltype.isEmpty) {
          _errorVesselTypeBloc.eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.True);
        }
      },
      label: Text(
        vesseltype[index],
        style: const TextStyle(fontSize: 16, color: kbackgroundColor),
      ), //Text
    );
  }

  void assignPrimaryValue(value) {
    rankvalue = value;
    if (value != null) {
      _errorRankTypeBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.False);
      Provider.of<SecondaryRankProvider>(context, listen: false)
          .callSecondaryRankapi(
              _rankBloc.rankid[_rankBloc.rankname.indexOf(value)], header);
      _secondaryRankShowBloc.eventRadioButtonSink.add(RadioButtonAction.True);
      _secondaryRankShowBloc.radioValue = true;
      Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
            clearDuplicateData();
          }));
    } else {
      _errorSecondaryRankBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.False);
      _errorRankTypeBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
      _secondaryRankShowBloc.eventRadioButtonSink.add(RadioButtonAction.False);
      _secondaryRankShowBloc.radioValue = false;
    }
    clearDuplicateData();
    _rankdropdownBloc.setdropdownvalue(value);
    _rankdropdownBloc.eventDropdownSink.add(DropdownAction.Update);
  }

  _secondaryRankDropdown() {
    print('In secondaty rank');
    return Provider.of<SecondaryRankProvider>(context, listen: false)
            .secondaryrankname
            .isEmpty
        ? Container()
        : StreamBuilder(
            stream: _errorSecondaryRankBloc.stateResumeIssuingAuthorityStrean,
            builder: (context, errorsnapshot) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.0,
                            color: errorsnapshot.hasData &&
                                    _errorSecondaryRankBloc.showtext
                                ? Colors.red
                                : Colors.grey),
                        borderRadius: const BorderRadius.all(Radius.circular(
                                20.0) //                 <--- border radius here
                            ),
                      ),
                      child: StreamBuilder(
                        initialData: Provider.of<GetResumeProvider>(context,
                                    listen: false)
                                .secondaryRank
                                .isNotEmpty
                            ? Provider.of<GetResumeProvider>(context,
                                    listen: false)
                                .secondaryRank
                            : secondaryRankValue,
                        stream: _nationalitydropdownBloc.stateDropdownStrean,
                        builder: (context, dropdownsnapshot) {
                          return Column(
                            children: [
                              DrodpownContainer(
                                title: secondaryRankValue.isNotEmpty
                                    ? secondaryRankValue
                                    : 'Select Secondary Rank',
                                searchHint: 'Search Rank',
                                showDropDownBloc:
                                    _showSecondaryRankDropDownBloc,
                                originalList:
                                    Provider.of<SecondaryRankProvider>(context,
                                            listen: false)
                                        .secondaryrankname,
                                showSearch: false,
                              ),
                              StreamBuilder(
                                stream: _showSecondaryRankDropDownBloc
                                    .stateIndosNoStrean,
                                initialData: false,
                                builder: (context, snapshot) {
                                  return ExpandedSection(
                                    expand:
                                        _showSecondaryRankDropDownBloc.isedited,
                                    height: 100,
                                    child: MyScrollbar(
                                      builder: (context, scrollController2) =>
                                          ListView.builder(
                                              padding: const EdgeInsets.all(0),
                                              controller: scrollController2,
                                              shrinkWrap: true,
                                              itemCount: Provider.of<
                                                          SecondaryRankProvider>(
                                                      context,
                                                      listen: false)
                                                  .secondaryrankname
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          secondaryRankValue =
                                                              Provider.of<SecondaryRankProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .secondaryrankname[index];
                                                          _secondaryRankdropdownBloc
                                                              .setdropdownvalue(Provider.of<
                                                                          SecondaryRankProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .secondaryrankname[index]);
                                                          _secondaryRankdropdownBloc
                                                              .eventDropdownSink
                                                              .add(
                                                                  DropdownAction
                                                                      .Update);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Text(Provider
                                                                  .of<SecondaryRankProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .secondaryrankname[index]),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                    ),
                                  );
                                },
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  TextBoxLabel('Select Secondary Rank')
                ],
              );
            },
          );
  }
}
