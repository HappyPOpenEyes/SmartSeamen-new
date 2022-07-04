// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../Dashboard/DashboardHeader.dart';
import '../DropdownBloc.dart';
import '../IssuingAuthorityErrorBloc.dart';
import '../RadioButtonBloc.dart';
import '../ResumeBuilder/PersonalInformation/ExpandedAnimation.dart';
import '../ResumeBuilder/PersonalInformation/IndosNoBloc.dart';
import '../ResumeBuilder/PersonalInformation/ResumeNationalityBloc.dart';
import '../ResumeBuilder/PersonalInformation/Scrollbar.dart';
import '../ResumeBuilder/PersonalInformation/VesselBloc.dart';
import '../TextBoxLabel.dart';
import '../asynccallprovider.dart';
import '../constants.dart';
import 'GetDecNavigationProvider.dart';
import 'GetEngineRankProvider.dart';
import 'JobPreview.dart';
import 'ReferJobProvider.dart';

class ReferJobDetails extends StatefulWidget {
  const ReferJobDetails({Key? key}) : super(key: key);

  @override
  _ReferJobDetailsState createState() => _ReferJobDetailsState();
}

class _ReferJobDetailsState extends State<ReferJobDetails> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController(),
      _shipNameController = TextEditingController(),
      _imoNumberController = TextEditingController(),
      _shipRegisteredFlagController = TextEditingController(),
      _joiningPortController = TextEditingController(),
      _contactCallController = TextEditingController(),
      _contactWhatsappController = TextEditingController(),
      _contactEmailController = TextEditingController(),
      _tentativeDateController = TextEditingController();
  final RadioButtonBloc _showLengthBloc = RadioButtonBloc();
  final _referJobRadioBloc = IndosNoBloc(),
      _referJobProfileRadioBloc = IndosNoBloc(),
      _disclaimerCheckBoxRadioBloc = IndosNoBloc();
  final _dropdownVesselShowBloc = IndosNoBloc();
  final ResumeErrorIssuingAuthorityBloc _errorReferJobBloc =
          ResumeErrorIssuingAuthorityBloc(),
      _errorRankName = ResumeErrorIssuingAuthorityBloc(),
      _errorVesselTypeBloc = ResumeErrorIssuingAuthorityBloc(),
      _errorCountryTypeBloc = ResumeErrorIssuingAuthorityBloc(),
      _errorDisclaimerBloc = ResumeErrorIssuingAuthorityBloc(),
      _errorCommunicationBloc = ResumeErrorIssuingAuthorityBloc();
  final VesselBloc _vesselBloc = VesselBloc();
  bool isStrechedDropDown = false;
  List<bool> isRankStrechedDropDown = [false, false, false, false];
  final List<String> _deckRankName = [],
      _engineRankName = [],
      _cookRankName = [],
      nationalityvalue = [];
  final List<IndosNoBloc> _dropdownShowBloc = [
    IndosNoBloc(),
    IndosNoBloc(),
    IndosNoBloc(),
    IndosNoBloc(),
  ];
  final List<IndosNoBloc> _deckRankListBloc = [],
      _engineRankListBloc = [],
      _cookRankListBloc = [],
      _nationalityListBloc = [];
  final DropdownBloc _vesselDropdownBloc = DropdownBloc();
  var header;
  String _vesselValue = "";
  final ResumeNationalityBloc _nationalityBloc = ResumeNationalityBloc();
  DateTime selectedDate = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');

  List<String> errors = [];
  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void dispose() {
    _referJobRadioBloc.dispose();
    _referJobProfileRadioBloc.dispose();
    _errorReferJobBloc.dispose();
    _disclaimerCheckBoxRadioBloc.dispose();
    _vesselBloc.dispose();
    _errorVesselTypeBloc.dispose();
    _dropdownVesselShowBloc.dispose();
    _vesselDropdownBloc.dispose();
    _errorRankName.dispose();
    _errorCountryTypeBloc.dispose();
    _errorDisclaimerBloc.dispose();
    _errorCommunicationBloc.dispose();
    _showLengthBloc.dispose();
    for (int i = 0; i < 4; i++) {
      _dropdownShowBloc[i].dispose();
    }
    for (int i = 0;
        i <
            Provider.of<GetDeckNavigationProvider>(context, listen: false)
                .deckNavigationName
                .length;
        i++) {
      _deckRankListBloc[i].dispose();
    }
    for (int i = 0;
        i <
            Provider.of<GetEngineRankProvider>(context, listen: false)
                .engineRankName
                .length;
        i++) {
      _engineRankListBloc[i].dispose();
    }
    for (int i = 0;
        i <
            Provider.of<GetEngineRankProvider>(context, listen: false)
                .cookRankName
                .length;
        i++) {
      _cookRankListBloc[i].dispose();
    }
    _nationalityBloc.dispose();
    for (int i = 0; i < _nationalityBloc.nationalityname.length; i++) {
      _nationalityListBloc[i].dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  getdata() async {
    bool result = await checkConnectivity();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    _dropdownVesselShowBloc.isedited = false;
    _vesselBloc.header = _nationalityBloc.header = header;
    _vesselBloc.eventVesselSink.add(VesselAction.Post);
    _nationalityBloc.eventResumeNationalitySink
        .add(ResumeNationalityAction.Post);
    GetDeckNavigationProvider deckNavigationProvider =
        Provider.of<GetDeckNavigationProvider>(context, listen: false);

    if (!await deckNavigationProvider.callgetDeckNavigationapi(header)) {
      displaysnackbar('Something went wrong');
    }

    GetEngineRankProvider engineRankProvider =
        Provider.of<GetEngineRankProvider>(context, listen: false);

    if (!await engineRankProvider.callgetEngingeRankapi(header)) {
      displaysnackbar('Something went wrong');
    }

    for (int i = 0; i < 4; i++) {
      isRankStrechedDropDown[i] = false;
      _dropdownShowBloc[i].isedited = false;
    }

    for (int i = 0;
        i <
            Provider.of<GetDeckNavigationProvider>(context, listen: false)
                .deckNavigationName
                .length;
        i++) {
      _deckRankListBloc.add(IndosNoBloc());
      _deckRankListBloc[i].isedited = false;
    }
    for (int i = 0;
        i <
            Provider.of<GetEngineRankProvider>(context, listen: false)
                .engineRankName
                .length;
        i++) {
      _engineRankListBloc.add(IndosNoBloc());
      _engineRankListBloc[i].isedited = false;
    }
    for (int i = 0;
        i <
            Provider.of<GetEngineRankProvider>(context, listen: false)
                .cookRankName
                .length;
        i++) {
      _cookRankListBloc.add(IndosNoBloc());
      _cookRankListBloc[i].isedited = false;
    }
    asyncProvider.changeAsynccall();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FD),
      key: _scaffoldkey,
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
              DashboardHeader(
                isDashboard: false,
                isEdit: true,
                isPayment: false,
                scaffoldKey: _scaffoldkey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.grey[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCompanyOrShipOrIMONameTF(0),
                            const SizedBox(height: 10),
                            _buildCompanyOrShipOrIMONameTF(1),
                            const SizedBox(height: 10),
                            _buildCompanyOrShipOrIMONameTF(2),
                            const SizedBox(height: 10),
                            _buildCompanyOrShipOrIMONameTF(3),
                            const SizedBox(height: 10),
                            Provider.of<AsyncCallProvider>(context,
                                        listen: false)
                                    .isinasynccall
                                ? Container()
                                : _buildVesselType(),
                            _displayError(0),
                            const SizedBox(height: 10),
                            _buildCompanyOrShipOrIMONameTF(4),
                            const SizedBox(height: 10),
                            _buildRankContainer(),
                            const SizedBox(height: 5),
                            _displayError(1),
                            const SizedBox(height: 10),
                            _buildTentativeDate(),
                            const SizedBox(height: 10),
                            _buildDeckNavigationDropdown(3),
                            //_buildNationalityDropdown(),
                            _displayError(2),
                            const SizedBox(height: 10),
                            _buildReferJobRadio(),
                            _displayError(3),
                            const SizedBox(height: 10),
                            _buildModeOfCommunicationBloc(),
                            const SizedBox(height: 5),
                            _displayError(4),
                            const SizedBox(height: 10),
                            _builDisclaimerBox(),
                            _displayError(5),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    print('Form Value right');
                                    if (!checkError()) {
                                      showPreviewDialog();
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const JobPreview(),
                                      ));
                                    }
                                  } else {
                                    var data = checkError();
                                  }
                                },
                                style: buttonStyle(),
                                child: const Text(
                                  'Post Job',
                                  style: TextStyle(color: kbackgroundColor),
                                ),
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildCompanyOrShipOrIMONameTF(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                index == 3
                    ? FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                    : FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
              ],
              cursorColor: kgreenPrimaryColor,
              controller: index == 0
                  ? _companyNameController
                  : index == 1
                      ? _shipNameController
                      : index == 2
                          ? _imoNumberController
                          : index == 3
                              ? _shipRegisteredFlagController
                              : _joiningPortController,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (index == 0) {
                  if (value.isNotEmpty) {
                    removeError(error: 'Please enter your company name');
                  }
                } else if (index == 1) {
                  if (value.isNotEmpty) {
                    removeError(error: 'Please enter your ship name');
                  }
                } else if (index == 2) {
                  if (value.isNotEmpty) {
                    removeError(error: 'Please enter your imo number');
                  }
                } else if (index == 3) {
                  if (value.isNotEmpty) {
                    removeError(error: 'Please enter ship registered flag');
                  }
                } else {
                  if (value.isNotEmpty) {
                    removeError(error: 'Please enter your joining port name');
                  }
                }
                return;
              },
              validator: (value) {
                if (index == 0) {
                  if (value!.isEmpty) {
                    return 'Please enter your company name';
                    //addError(error: kEmailNullError);

                  }
                } else if (index == 1) {
                  if (value!.isEmpty) {
                    return 'Please enter your ship name';
                    //addError(error: kEmailNullError);

                  }
                } else if (index == 2) {
                  if (value!.isEmpty) {
                    return 'Please enter your imo number';
                    //addError(error: kEmailNullError);

                  }
                } else if (index == 3) {
                  if (value!.isEmpty) {
                    return 'Please enter ship registered flag';
                    //addError(error: kEmailNullError);

                  }
                } else {
                  if (value!.isEmpty) {
                    return 'Please enter your joining port name';
                    //addError(error: kEmailNullError);

                  }
                }
                return null;
              },
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  hintText: index == 0
                      ? 'Enter your company name'
                      : index == 1
                          ? 'Enter your ship name'
                          : index == 2
                              ? 'Enter your ship imo number'
                              : index == 3
                                  ? 'Enter your ship registered flag'
                                  : 'Enter your joining port name',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel(index == 0
            ? 'Company Name'
            : index == 1
                ? 'Ship Name'
                : index == 2
                    ? 'Ship IMO Number'
                    : index == 3
                        ? 'Ship Registered Flag'
                        : 'Joining Port Name')
      ],
    );
  }

  _buildRankContainer() {
    return StreamBuilder(
      stream: _errorRankName.stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: snapshot.hasData && _errorRankName.showtext
                  ? Colors.red
                  : kbackgroundColor,
            ),
            boxShadow: [
              BoxShadow(
                color: snapshot.hasData && _errorRankName.showtext
                    ? Colors.red
                    : Colors.black,
                blurRadius: 0.5,
              ),
            ],
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15.0),
          ),

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rank Selection',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                _buildDeckNavigationDropdown(0),
                const SizedBox(height: 10),
                _buildDeckNavigationDropdown(1),
                const SizedBox(height: 10),
                Provider.of<GetEngineRankProvider>(context, listen: false)
                        .cookRankName
                        .isEmpty
                    ? Container()
                    : _buildDeckNavigationDropdown(2),
              ],
            ),
          ),
          //),
        );
      },
    );
  }

  _buildDeckNavigationDropdown(int dropdownIndex) {
    return dropdownIndex == 3
        ? StreamBuilder(
            stream: _nationalityBloc.stateResumenatioNalityStrean,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (_nationalityBloc.isFirst) {
                  for (int i = 0;
                      i < _nationalityBloc.nationalityname.length;
                      i++) {
                    _nationalityListBloc.add(IndosNoBloc());
                    _nationalityListBloc[i].isedited = false;
                  }
                  _nationalityBloc.isFirst = false;
                }
                return _showDropdown(dropdownIndex);
              } else {
                return Container();
              }
            },
          )
        : _showDropdown(dropdownIndex);
  }

  _showDropdown(int dropdownIndex) {
    return Stack(
      children: [
        StreamBuilder(
          stream: _showLengthBloc.stateRadioButtonStrean,
          builder: (context, lengthsnapshot) {
            return StreamBuilder(
              stream: _dropdownShowBloc[dropdownIndex].stateIndosNoStrean,
              builder: (context, lengthsnapshot) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: dropdownIndex == 3 ? 6 : 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(right: 10),
                            constraints: const BoxConstraints(
                              minHeight: 45,
                              minWidth: double.infinity,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            dropdownIndex == 3 ? 32 : 20,
                                        vertical: 10),
                                    child: Text(
                                      dropdownIndex == 0
                                          ? _deckRankName.isEmpty
                                              ? 'Select Deck Department'
                                              : '${_deckRankName.length} Rank Selected'
                                          : dropdownIndex == 1
                                              ? _engineRankName.isEmpty
                                                  ? 'Select Engine Department'
                                                  : '${_engineRankName.length} Rank Selected'
                                              : dropdownIndex == 2
                                                  ? _cookRankName.isEmpty
                                                      ? 'Select Galley Department'
                                                      : '${_cookRankName.length} Rank Selected'
                                                  : nationalityvalue.isEmpty
                                                      ? 'Select Country'
                                                      : '${nationalityvalue.length} Country Selected',
                                    ),
                                  ),
                                ),
                                InkWell(
                                    onTap: () {
                                      if (_dropdownShowBloc[dropdownIndex]
                                          .isedited) {
                                        _dropdownShowBloc[dropdownIndex]
                                            .eventIndosNoSink
                                            .add(IndosNoAction.False);
                                      } else {
                                        _dropdownShowBloc[dropdownIndex]
                                            .eventIndosNoSink
                                            .add(IndosNoAction.True);
                                      }
                                    },
                                    child: Icon(
                                        isRankStrechedDropDown[dropdownIndex]
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward))
                              ],
                            )),
                        StreamBuilder(
                          stream: _dropdownShowBloc[dropdownIndex]
                              .stateIndosNoStrean,
                          initialData: false,
                          builder: (context, snapshot) {
                            return ExpandedSection(
                              expand: _dropdownShowBloc[dropdownIndex].isedited,
                              height: 100,
                              child: MyScrollbar(
                                builder: (context, scrollController2) =>
                                    ListView.builder(
                                        padding: const EdgeInsets.all(0),
                                        controller: scrollController2,
                                        shrinkWrap: true,
                                        itemCount: dropdownIndex == 0
                                            ? Provider.of<
                                                        GetDeckNavigationProvider>(
                                                    context,
                                                    listen: false)
                                                .deckNavigationName
                                                .length
                                            : dropdownIndex == 1
                                                ? Provider.of<
                                                            GetEngineRankProvider>(
                                                        context,
                                                        listen: false)
                                                    .engineRankName
                                                    .length
                                                : dropdownIndex == 2
                                                    ? Provider.of<
                                                                GetEngineRankProvider>(
                                                            context,
                                                            listen: false)
                                                        .cookRankName
                                                        .length
                                                    : _nationalityBloc
                                                        .nationalityname.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16),
                                                  child: Row(
                                                    children: [
                                                      StreamBuilder(
                                                        initialData: false,
                                                        stream: dropdownIndex ==
                                                                0
                                                            ? _deckRankListBloc[
                                                                    index]
                                                                .stateIndosNoStrean
                                                            : dropdownIndex == 1
                                                                ? _engineRankListBloc[
                                                                        index]
                                                                    .stateIndosNoStrean
                                                                : dropdownIndex ==
                                                                        2
                                                                    ? _cookRankListBloc[
                                                                            index]
                                                                        .stateIndosNoStrean
                                                                    : _nationalityListBloc[
                                                                            index]
                                                                        .stateIndosNoStrean,
                                                        builder: (context,
                                                            snapshot) {
                                                          return Checkbox(
                                                              materialTapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap,
                                                              value: dropdownIndex ==
                                                                      0
                                                                  ? _deckRankListBloc[
                                                                          index]
                                                                      .isedited
                                                                  : dropdownIndex ==
                                                                          1
                                                                      ? _engineRankListBloc[
                                                                              index]
                                                                          .isedited
                                                                      : dropdownIndex ==
                                                                              2
                                                                          ? _cookRankListBloc[index]
                                                                              .isedited
                                                                          : _nationalityListBloc[index]
                                                                              .isedited,
                                                              onChanged:
                                                                  (value) {
                                                                changeRankValues(
                                                                    dropdownIndex,
                                                                    index);
                                                              });
                                                        },
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          changeRankValues(
                                                              dropdownIndex,
                                                              index);
                                                        },
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          child: Text(dropdownIndex ==
                                                                  0
                                                              ? Provider.of<GetDeckNavigationProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .deckNavigationName[
                                                                      index] 
                                                              : dropdownIndex ==
                                                                      1
                                                                  ? Provider.of<GetEngineRankProvider>(context, listen: false).engineRankName[
                                                                          index] 
                                                                  : dropdownIndex ==
                                                                          2
                                                                      ? Provider.of<GetEngineRankProvider>(context, listen: false).cookRankName[
                                                                              index] 
                                                                      : _nationalityBloc
                                                                              .nationalityname[index] ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        dropdownIndex == 3 ? TextBoxLabel('Select Country') : Container()
      ],
    );
  }

  changeRankValues(int dropdownIndex, int index) {
    if (dropdownIndex == 0) {
      if (_deckRankListBloc[index].isedited) {
        _deckRankListBloc[index].eventIndosNoSink.add(IndosNoAction.False);
        _deckRankName.removeAt(_deckRankName.indexOf(
            Provider.of<GetDeckNavigationProvider>(context, listen: false)
                .deckNavigationName[index]));
        _showLengthBloc.eventRadioButtonSink.add(RadioButtonAction.False);
      } else {
        if (!_deckRankName.contains(
            Provider.of<GetDeckNavigationProvider>(context, listen: false)
                .deckNavigationName[index])) {
          _errorRankName.eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.False);
          _deckRankListBloc[index].eventIndosNoSink.add(IndosNoAction.True);
          _deckRankName.add(
              Provider.of<GetDeckNavigationProvider>(context, listen: false)
                  .deckNavigationName[index]);
          _showLengthBloc.eventRadioButtonSink.add(RadioButtonAction.True);
        }
      }
    } else if (dropdownIndex == 1) {
      if (_engineRankListBloc[index].isedited) {
        _engineRankListBloc[index].eventIndosNoSink.add(IndosNoAction.False);
        _engineRankName.removeAt(_engineRankName.indexOf(
            Provider.of<GetEngineRankProvider>(context, listen: false)
                .engineRankName[index]));
        _showLengthBloc.eventRadioButtonSink.add(RadioButtonAction.False);
      } else {
        if (!_engineRankName.contains(
            Provider.of<GetEngineRankProvider>(context, listen: false)
                .engineRankName[index])) {
          _errorRankName.eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.False);
          _engineRankListBloc[index].eventIndosNoSink.add(IndosNoAction.True);
          _engineRankName.add(
              Provider.of<GetEngineRankProvider>(context, listen: false)
                  .engineRankName[index]);
          _showLengthBloc.eventRadioButtonSink.add(RadioButtonAction.True);
        }
      }
    } else if (dropdownIndex == 2) {
      if (_cookRankListBloc[index].isedited) {
        _cookRankListBloc[index].eventIndosNoSink.add(IndosNoAction.False);
        _cookRankName.removeAt(_cookRankName.indexOf(
            Provider.of<GetEngineRankProvider>(context, listen: false)
                .cookRankName[index]));
        _showLengthBloc.eventRadioButtonSink.add(RadioButtonAction.False);
      } else {
        if (!_cookRankName.contains(
            Provider.of<GetEngineRankProvider>(context, listen: false)
                .cookRankName[index])) {
          _errorRankName.eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.False);
          _cookRankListBloc[index].eventIndosNoSink.add(IndosNoAction.True);
          _cookRankName.add(
              Provider.of<GetEngineRankProvider>(context, listen: false)
                  .cookRankName[index]);
          _showLengthBloc.eventRadioButtonSink.add(RadioButtonAction.True);
        }
      }
    } else if (dropdownIndex == 3) {
      if (_nationalityListBloc[index].isedited) {
        _nationalityListBloc[index].eventIndosNoSink.add(IndosNoAction.False);
        nationalityvalue.removeAt(
            nationalityvalue.indexOf(_nationalityBloc.nationalityname[index]));
        _showLengthBloc.eventRadioButtonSink.add(RadioButtonAction.False);
      } else {
        if (!nationalityvalue
            .contains(_nationalityBloc.nationalityname[index])) {
          _errorCountryTypeBloc.eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.False);
          _nationalityListBloc[index].eventIndosNoSink.add(IndosNoAction.True);
          nationalityvalue.add(_nationalityBloc.nationalityname[index]);
          _showLengthBloc.eventRadioButtonSink.add(RadioButtonAction.True);
        }
      }
    }
  }

  _buildTentativeDate() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller: _tentativeDateController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please select the date');
                }
                return;
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
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
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
                  hintText: 'Enter your tentative joining date',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Tentaive Joining Date')
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
      _tentativeDateController.text = formatter.format(picked);
    }
  }

  _buildReferJobRadio() {
    return Stack(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: StreamBuilder(
              stream: _errorReferJobBloc.stateResumeIssuingAuthorityStrean,
              builder: (context, errorsnapshot) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: errorsnapshot.hasData &&
                                  _errorReferJobBloc.showtext
                              ? Colors.red
                              : Colors.grey),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: _referJobRadioBloc.stateIndosNoStrean,
                          builder: (context, snapshot) {
                            return InkWell(
                              onTap: () {
                                _referJobRadioBloc.eventIndosNoSink
                                    .add(IndosNoAction.True);
                                _errorReferJobBloc
                                    .eventResumeIssuingAuthoritySink
                                    .add(ResumeErrorIssuingAuthorityAction
                                        .False);
                                _referJobProfileRadioBloc.eventIndosNoSink
                                    .add(IndosNoAction.False);
                              },
                              child: Row(
                                children: [
                                  _referJobRadioBloc.isedited
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
                                  const Text('With my profile identity'),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        StreamBuilder(
                            stream:
                                _referJobProfileRadioBloc.stateIndosNoStrean,
                            builder: (context, snapshot) {
                              return InkWell(
                                onTap: () {
                                  _errorReferJobBloc
                                      .eventResumeIssuingAuthoritySink
                                      .add(ResumeErrorIssuingAuthorityAction
                                          .False);
                                  _referJobProfileRadioBloc.eventIndosNoSink
                                      .add(IndosNoAction.True);
                                  _referJobRadioBloc.eventIndosNoSink
                                      .add(IndosNoAction.False);
                                },
                                child: Row(
                                  children: [
                                    _referJobProfileRadioBloc.isedited
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
                                    const Text('Without my profile identity'),
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                );
              },
            )),
        TextBoxLabel('Refer a Job')
      ],
    );
  }

  _displayError(int index) {
    return StreamBuilder(
      initialData: false,
      stream: index == 0
          ? _errorVesselTypeBloc.stateResumeIssuingAuthorityStrean
          : index == 1
              ? _errorRankName.stateResumeIssuingAuthorityStrean
              : index == 2
                  ? _errorCountryTypeBloc.stateResumeIssuingAuthorityStrean
                  : index == 3
                      ? _errorReferJobBloc.stateResumeIssuingAuthorityStrean
                      : index == 4
                          ? _errorCommunicationBloc
                              .stateResumeIssuingAuthorityStrean
                          : _errorDisclaimerBloc
                              .stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && index == 0
            ? _errorVesselTypeBloc.showtext
            : index == 1
                ? _errorRankName.showtext
                : index == 2
                    ? _errorCountryTypeBloc.showtext
                    : index == 3
                        ? _errorReferJobBloc.showtext
                        : index == 4
                            ? _errorCommunicationBloc.showtext
                            : _errorDisclaimerBloc.showtext) {
          return Visibility(
            visible: index == 0
                ? _errorVesselTypeBloc.showtext
                : index == 1
                    ? _errorRankName.showtext
                    : index == 2
                        ? _errorCountryTypeBloc.showtext
                        : index == 3
                            ? _errorReferJobBloc.showtext
                            : index == 4
                                ? _errorCommunicationBloc.showtext
                                : _errorDisclaimerBloc.showtext,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  index == 0
                      ? 'Please select the vessel type'
                      : index == 1
                          ? 'Please select a rank'
                          : index == 2
                              ? 'Please select country'
                              : index == 3
                                  ? 'Please select the radio value'
                                  : index == 4
                                      ? 'Please select atleast one mode of communication'
                                      : 'Please accept the terms and conditions',
                  style: TextStyle(color: Colors.red[500]),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  bool checkError() {
    bool data = false;
    //Check Refer Job value
    if (_referJobRadioBloc.isedited == false &&
        _referJobProfileRadioBloc.isedited == false) {
      data = true;
      _errorReferJobBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
    }

    //Check Vessel Entry
    if (_vesselDropdownBloc.dropdownvalue == null) {
      data = true;
      _errorVesselTypeBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
    } else if (_vesselDropdownBloc.dropdownvalue!.isEmpty) {
      data = true;
      _errorVesselTypeBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
    }

    //Check Rank Selection
    if (_deckRankName.isEmpty &&
        _engineRankName.isEmpty &&
        _cookRankName.isEmpty) {
      data = true;
      _errorRankName.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
    }

    //Check Nationality Dropdown
    if (nationalityvalue.isEmpty) {
      _errorCountryTypeBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
      data = true;
    }

    //Check Disclaimer
    if (_disclaimerCheckBoxRadioBloc.isedited == null) {
      data = true;
      _errorDisclaimerBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
    } else if (_disclaimerCheckBoxRadioBloc.isedited == false) {
      data = true;
      _errorDisclaimerBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
    }

    //Check Communication
    if (_contactCallController.text.isEmpty &&
        _contactWhatsappController.text.isEmpty &&
        _contactEmailController.text.isEmpty) {
      data = true;
      _errorCommunicationBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
    }

    print(data);

    return data;
  }

  _buildModeOfCommunicationBloc() {
    return StreamBuilder(
      stream: _errorCommunicationBloc.stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: snapshot.hasData && _errorCommunicationBloc.showtext
                  ? Colors.red
                  : kbackgroundColor,
            ),
            boxShadow: [
              BoxShadow(
                color: snapshot.hasData && _errorCommunicationBloc.showtext
                    ? Colors.red
                    : Colors.black,
                blurRadius: 0.5,
              ),
            ],
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mode of communication',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                _buildContactTF(0),
                const SizedBox(height: 10),
                _buildContactTF(1),
                const SizedBox(height: 10),
                _buildContactTF(2),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildContactTF(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: [
                index == 2
                    ? FilteringTextInputFormatter.deny(RegExp(r'\s'))
                    : FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              ],
              keyboardType: index == 2
                  ? TextInputType.emailAddress
                  : TextInputType.number,
              cursorColor: kgreenPrimaryColor,
              controller: index == 0
                  ? _contactCallController
                  : index == 1
                      ? _contactWhatsappController
                      : _contactEmailController,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (index == 2) {
                  if (value.contains('@') &&
                      emailValidatorRegExp.hasMatch(value)) {
                    removeError(error: kInvalidEmailError);
                  }
                } else {
                  if (value.isNotEmpty && value.length > 4) {
                    removeError(error: 'Please enter a valid number');
                  }
                }
              },
              validator: (value) {
                if (index == 2) {
                  if (!value!.contains('@') &&
                      !emailValidatorRegExp.hasMatch(value) &&
                      value.isNotEmpty) {
                    return kInvalidEmailError;
                    //addError(error: kInvalidEmailError);

                  } else if (value.isEmpty) {
                    removeError(error: kInvalidEmailError);
                  }
                } else {
                  if (value!.length < 4 && value.isNotEmpty) {
                    return 'Please enter a valid number';
                  }
                }
                return null;
              },
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  hintText: index == 2 ? 'Enter email' : 'Enter number',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel(index == 0
            ? 'By Call'
            : index == 1
                ? 'By Whatsapp'
                : 'By Email')
      ],
    );
  }

  _builDisclaimerBox() {
    return Row(
      children: [
        StreamBuilder(
          stream: _disclaimerCheckBoxRadioBloc.stateIndosNoStrean,
          builder: (context, snapshot) {
            return Checkbox(
              value: snapshot.hasData
                  ? _disclaimerCheckBoxRadioBloc.isedited
                  : false,
              checkColor: kbackgroundColor,
              activeColor: kBluePrimaryColor,
              onChanged: (value) {
                if (value!) {
                  _errorDisclaimerBloc.eventResumeIssuingAuthoritySink
                      .add(ResumeErrorIssuingAuthorityAction.False);
                  _disclaimerCheckBoxRadioBloc.eventIndosNoSink
                      .add(IndosNoAction.True);
                } else {
                  _errorDisclaimerBloc.eventResumeIssuingAuthoritySink
                      .add(ResumeErrorIssuingAuthorityAction.True);
                  _disclaimerCheckBoxRadioBloc.eventIndosNoSink
                      .add(IndosNoAction.False);
                }
              },
            );
          },
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: const Text(
                'I agree to the terms and conditions.I agree to the terms and conditions.'))
      ],
    );
  }

  _buildVesselType() {
    return StreamBuilder(
      stream: _vesselBloc.stateVesselStrean,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
      },
    );
  }

  showVesselDropdown() {
    return Column(
      children: [
        StreamBuilder(
            stream: _dropdownVesselShowBloc.stateIndosNoStrean,
            builder: (context, vesselSnapshot) {
              return StreamBuilder(
                stream: _vesselDropdownBloc.stateDropdownStrean,
                builder: (context, vesselSnapshot) {
                  return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(right: 10),
                      constraints: const BoxConstraints(
                        minHeight: 45,
                        minWidth: double.infinity,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 10),
                              child: Text(
                                vesselSnapshot.hasData
                                    ? _vesselDropdownBloc.dropdownvalue!
                                    : 'Select vessel type',
                                style: TextStyle(
                                    color: vesselSnapshot.hasData
                                        ? kblackPrimaryColor
                                        : Colors.grey),
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                if (_dropdownVesselShowBloc.isedited) {
                                  _dropdownVesselShowBloc.eventIndosNoSink
                                      .add(IndosNoAction.False);
                                } else {
                                  _dropdownVesselShowBloc.eventIndosNoSink
                                      .add(IndosNoAction.True);
                                }
                              },
                              child: Icon(isStrechedDropDown
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward))
                        ],
                      ));
                },
              );
            }),
        StreamBuilder(
          stream: _dropdownVesselShowBloc.stateIndosNoStrean,
          initialData: false,
          builder: (context, snapshot) {
            return ExpandedSection(
              expand: _dropdownVesselShowBloc.isedited,
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
                                      _vesselValue =
                                          _vesselBloc.itemVessel[index].name;
                                      _vesselDropdownBloc.dropdownvalue =
                                          _vesselBloc.itemVessel[index].name;
                                      _vesselDropdownBloc.eventDropdownSink
                                          .add(DropdownAction.Update);
                                      _dropdownVesselShowBloc.eventIndosNoSink
                                          .add(IndosNoAction.False);
                                      _errorVesselTypeBloc
                                          .eventResumeIssuingAuthoritySink
                                          .add(ResumeErrorIssuingAuthorityAction
                                              .False);
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
                key: const Key(""),
                scrollController: ScrollController(),
              ),
            );
          },
        )
      ],
    );
  }

  void showPreviewDialog() async {
    print('In show Dialog');
    String nationalities = "", deckRanks = "", engineRanks = "", cookRanks = "";
    nationalities = getValues(nationalityvalue);
    deckRanks = getValues(_deckRankName);
    engineRanks = getValues(_engineRankName);
    cookRanks = getValues(_cookRankName);

    List<String> vesselType = [],
        nationalityId = [],
        postDeckRanks = [],
        postEngineRanks = [],
        postCookRanks = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Nationalities', nationalities);
    prefs.setString('DeckRanks', deckRanks);
    prefs.setString('EngineRanks', engineRanks);
    prefs.setString('CookRanks', cookRanks);
    prefs.setString('Expiration', _tentativeDateController.text);
    prefs.setString('Vessel', _vesselValue);
    prefs.setString('CompanyName', _companyNameController.text);

    for (int i = 0; i < nationalityvalue.length; i++) {
      nationalityId.add(_nationalityBloc.nationalitycode[
          _nationalityBloc.nationalityname.indexOf(nationalityvalue[i])]);
    }

    vesselType.add(
        _vesselBloc.vesselid[_vesselBloc.vesselname.indexOf(_vesselValue)]);

    for (int i = 0; i < _deckRankName.length; i++) {
      postDeckRanks.add(
          Provider.of<GetDeckNavigationProvider>(context, listen: false)
                  .deckNavigationId[
              Provider.of<GetDeckNavigationProvider>(context, listen: false)
                  .deckNavigationName
                  .indexOf(_deckRankName[i])]);
    }

    for (int i = 0; i < _engineRankName.length; i++) {
      postEngineRanks.add(
          Provider.of<GetEngineRankProvider>(context, listen: false)
                  .engineRankId[
              Provider.of<GetEngineRankProvider>(context, listen: false)
                  .engineRankName
                  .indexOf(_engineRankName[i])]);
    }

    for (int i = 0; i < _cookRankName.length; i++) {
      postCookRanks.add(
          Provider.of<GetEngineRankProvider>(context, listen: false).cookRankId[
              Provider.of<GetEngineRankProvider>(context, listen: false)
                  .cookRankName
                  .indexOf(_cookRankName[i])]);
    }

    Provider.of<PostReferJobProvider>(context, listen: false).deckRanks =
        postDeckRanks;
    Provider.of<PostReferJobProvider>(context, listen: false).engineRanks =
        postEngineRanks;
    Provider.of<PostReferJobProvider>(context, listen: false).cookRanks =
        postCookRanks;
    Provider.of<PostReferJobProvider>(context, listen: false).nationalityId =
        nationalityId;
    Provider.of<PostReferJobProvider>(context, listen: false).vesselType =
        vesselType;
    Provider.of<PostReferJobProvider>(context, listen: false).companyName =
        _companyNameController.text;
    Provider.of<PostReferJobProvider>(context, listen: false).shipName =
        _shipNameController.text;
    Provider.of<PostReferJobProvider>(context, listen: false).imoNumber =
        _imoNumberController.text;
    Provider.of<PostReferJobProvider>(context, listen: false)
        .shipRegisteredFlag = _shipRegisteredFlagController.text;
    Provider.of<PostReferJobProvider>(context, listen: false).joiningPort =
        _joiningPortController.text;
    Provider.of<PostReferJobProvider>(context, listen: false)
        .tentativeJoiningDate = _tentativeDateController.text;
    if (_referJobRadioBloc.isedited) {
      Provider.of<PostReferJobProvider>(context, listen: false).referJobValue =
          1;
    } else {
      Provider.of<PostReferJobProvider>(context, listen: false).referJobValue =
          0;
    }
    Provider.of<PostReferJobProvider>(context, listen: false).contactNumber =
        _contactCallController.text;
    Provider.of<PostReferJobProvider>(context, listen: false).whatsappNumber =
        _contactWhatsappController.text;
    Provider.of<PostReferJobProvider>(context, listen: false).email =
        _contactEmailController.text;
  }

  String getValues(List<String> list) {
    String returnString = "";
    for (int i = 0; i < list.length; i++) {
      if (list.length - 1 == i) {
        returnString = returnString + list[i];
      } else {
        returnString = "$returnString${list[i]}, ";
      }
    }

    return returnString;
  }
}
