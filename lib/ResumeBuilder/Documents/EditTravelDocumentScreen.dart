// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';
import 'package:smartseaman/DropdownContainer.dart';
import 'package:smartseaman/ResumeBuilder/GetValidTypeProvider.dart';
import 'package:smartseaman/ResumeBuilder/Header.dart';
import 'package:smartseaman/ResumeBuilder/ValidTillOptions.dart';

import '../../DropdownBloc.dart';
import '../../IssuingAuthorityErrorBloc.dart';
import '../../RadioButtonBloc.dart';
import '../../SearchTextProvider.dart';
import '../../TextBoxLabel.dart';
import '../../asynccallprovider.dart';
import '../../constants.dart';
import '../IssuingAuhtorityBloc.dart';
import '../PersonalInformation/ExpandedAnimation.dart';
import '../PersonalInformation/IndosNoBloc.dart';
import '../PersonalInformation/Scrollbar.dart';
import 'DeleteCDCRecordAPI.dart';
import 'DocumentScreen.dart';
import 'DocumentScreenProvider.dart';
import 'PostCDCData.dart';
import 'PostVisaData.dart';
import 'TravelDocUpdateProvider.dart';

class EditTravelDocument extends StatefulWidget {
  const EditTravelDocument({Key? key}) : super(key: key);

  @override
  _EditTravelDocumentState createState() => _EditTravelDocumentState();
}

class _EditTravelDocumentState extends State<EditTravelDocument> {
  TextEditingController passportController = TextEditingController(),
      issueDateController = TextEditingController(),
      validTillController = TextEditingController(),
      usVisaissueDateController = TextEditingController(),
      otherVisaissueDateController = TextEditingController(),
      usVisaExpiryDateController = TextEditingController(),
      otherVisaExpiryDateController = TextEditingController();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime selectedDate = DateTime.now();
  static final _formKey = GlobalKey<FormState>();
  final _passportIssuingAuthorityBloc = ResumeIssuingAuthorityBloc();
  final List<ResumeIssuingAuthorityBloc> _issuingAuthorityBloc = [];
  final List<DropdownBloc> _dropdownBloc = [],
      _visadropdownBloc = [],
      _visaOtherdropdownBloc = [];
  final _passportdropdownBloc = DropdownBloc();
  final List<ResumeErrorIssuingAuthorityBloc> _errorCountryCodeBloc = [],
      _visaValidDateErrorBloc = [],
      _cdcValidDateErrorBloc = [],
      _errorVisaSelectBloc = [],
      _errorVisaOtherSelectBloc = [];
  final _errorPassportCountryCodeBloc = ResumeErrorIssuingAuthorityBloc();
  final List<TextEditingController> _issueDateVisaController = [],
      _validTillVisaController = [],
      _issueDateCDCController = [],
      _expiryDateCDCController = [],
      cdcSeamenController = [];
  final List<String> _issuingValue = [], _visaValue = [], _visaOtherValue = [];
  String _passportissuingValue = "";
  final _passportValidDateErrorBloc = ResumeErrorIssuingAuthorityBloc();
  final RadioButtonBloc _showPassportValidDate = RadioButtonBloc(),
      _displayPassportValidDate = RadioButtonBloc();
  final List<RadioButtonBloc> _showCDCValidDate = [],
      _showVisaValidDate = [],
      _validTillOptionsBloc = [
        RadioButtonBloc(),
        RadioButtonBloc(),
        RadioButtonBloc()
      ],
      _displayVisaValidDate = [],
      _displayCDCValidDate = [],
      _displayVisaOtherCountry = [];
  final List<List<RadioButtonBloc>> _validTillOptionsVisaBloc = [],
      _validTillOptionsCDCBloc = [];
  var header;
  final _showPassportIssuingDropDownBloc = IndosNoBloc();
  List<IndosNoBloc> _showVisaIssuingDropDownBloc = [],
      _showCDCIssuingDropDownBloc = [],
      _showVisaOtherIssuingDropDownBloc = [];
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
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .visaLength;
        i++) {
      _showVisaValidDate[i].dispose();
      _displayVisaValidDate[i].dispose();
      _visaValidDateErrorBloc[i].dispose();
      _visadropdownBloc[i].dispose();
      _visaOtherdropdownBloc[i].dispose();
      _errorVisaSelectBloc[i].dispose();
      _errorVisaOtherSelectBloc[i].dispose();
      _displayVisaOtherCountry[i].dispose();
      for (int k = 0; k < 3; k++) {
        _validTillOptionsVisaBloc[i][k].dispose();
      }
      _showVisaIssuingDropDownBloc[i].dispose();
      _showVisaOtherIssuingDropDownBloc[i].dispose();
    }

    for (int i = 0; i < 3; i++) {
      _validTillOptionsBloc[i].dispose();
    }

    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .cdcLength;
        i++) {
      _issuingAuthorityBloc[i].dispose();
      _errorCountryCodeBloc[i].dispose();
      _dropdownBloc[i].dispose();
      _displayCDCValidDate[i].dispose();
      _showCDCValidDate[i].dispose();
      _cdcValidDateErrorBloc[i].dispose();
      for (int k = 0; k < 3; k++) {
        _validTillOptionsCDCBloc[i][k].dispose();
      }
      _showCDCIssuingDropDownBloc[i].dispose();
    }
    _passportValidDateErrorBloc.dispose();
    _passportIssuingAuthorityBloc.dispose();
    _passportdropdownBloc.dispose();
    _errorPassportCountryCodeBloc.dispose();
    _showPassportValidDate.dispose();
    _displayPassportValidDate.dispose();
    _showPassportIssuingDropDownBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getdata());
  }

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResumeHeader('Documents', 2, true, ""),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _displayPassportDetailsCard(),
                          _displayVisaCard(),
                          Provider.of<AsyncCallProvider>(context, listen: false)
                                  .isinasynccall
                              ? const SizedBox()
                              : _displayCDCBookCard(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  var data = false;
                                  if (_formKey.currentState!.validate()) {
                                    data = _checkError();
                                    if (!data) {
                                      _formKey.currentState!.save();
                                      callPostDocumentRecord();
                                    }
                                  } else {
                                    data = _checkError();
                                  }
                                },
                                style: buttonStyle(),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      color: kbackgroundColor,
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
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displaySubHeading(String s) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(s,
          style: TextStyle(
              color: kgreenPrimaryColor,
              fontSize: MediaQuery.of(context).size.width * 0.045,
              fontWeight: FontWeight.bold)),
    );
  }

  _buildPassportTF() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: kbackgroundColor,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
              ],
              cursorColor: kgreenPrimaryColor,
              controller: passportController,
              maxLength: 12,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter your passport number');
                } else if (value.length >= 6) {
                  removeError(
                      error: 'Please enter the correct passport number');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your passport number';
                  //addError(error: kEmailNullError);

                } else if (value.length < 6) {
                  return 'Please enter a valid passport number';
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
                  hintText: 'Enter your passport number',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Passport No')
      ],
    );
  }

  _buildPassportIssuingAuthority() {
    return Stack(
      children: [
        StreamBuilder(
          stream:
              _passportIssuingAuthorityBloc.stateResumeIssuingAuthorityStrean,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .passportId
                  .isNotEmpty) {
                if (_passportissuingValue.isEmpty) {
                  _passportissuingValue = Provider.of<ResumeDocumentProvider>(
                          context,
                          listen: false)
                      .passportPlaceofIssueName[0];
                  _passportdropdownBloc.setdropdownvalue(_passportissuingValue);
                  _passportdropdownBloc.eventDropdownSink
                      .add(DropdownAction.Update);
                }
              } else {
                _passportissuingValue =
                    _passportIssuingAuthorityBloc.countryname[0];
                _passportdropdownBloc.setdropdownvalue(_passportissuingValue);
                _passportdropdownBloc.eventDropdownSink
                    .add(DropdownAction.Update);
              }
              return StreamBuilder(
                initialData: false,
                stream: _errorPassportCountryCodeBloc
                    .stateResumeIssuingAuthorityStrean,
                builder: (context, errorsnapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.0,
                            color: errorsnapshot.hasData
                                ? _errorPassportCountryCodeBloc.showtext
                                    ? Colors.red
                                    : Colors.grey
                                : Colors.grey),
                        borderRadius: const BorderRadius.all(Radius.circular(
                                20.0) //                 <--- border radius here
                            ),
                      ),
                      child: StreamBuilder(
                        stream: _passportdropdownBloc.stateDropdownStrean,
                        builder: (context, dropdownsnapshot) {
                          return StreamBuilder(
                              stream: _showPassportIssuingDropDownBloc
                                  .stateIndosNoStrean,
                              builder: (context, dropdownsnapshot) {
                                return Column(
                                  children: [
                                    DrodpownContainer(
                                      title: _passportissuingValue.isNotEmpty
                                          ? _passportissuingValue
                                          : 'Select Issuing Authority',
                                      searchHint: 'Search Issuing Authority',
                                      showDropDownBloc:
                                          _showPassportIssuingDropDownBloc,
                                      originalList:
                                          _passportIssuingAuthorityBloc
                                              .countryname,
                                    ),
                                    ExpandedSection(
                                      expand: _showPassportIssuingDropDownBloc
                                          .isedited,
                                      height: 100,
                                      child: MyScrollbar(
                                        builder:
                                            (context, scrollController2) =>
                                                ListView.builder(
                                                    padding:
                                                        const EdgeInsets.all(0),
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
                                                            : _passportIssuingAuthorityBloc
                                                                .countryname
                                                                .length,
                                                    itemBuilder:
                                                        (context, listindex) {
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
                                                              onTap: () async {
                                                                if (!Provider.of<
                                                                            SearchChangeProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .noDataFound) {
                                                                  _showPassportIssuingDropDownBloc
                                                                      .eventIndosNoSink
                                                                      .add(IndosNoAction
                                                                          .False);
                                                                  _errorPassportCountryCodeBloc
                                                                      .eventResumeIssuingAuthoritySink
                                                                      .add(ResumeErrorIssuingAuthorityAction
                                                                          .False);
                                                                  _passportissuingValue = Provider.of<SearchChangeProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .searchList
                                                                          .isNotEmpty
                                                                      ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                          listindex]
                                                                      : _passportIssuingAuthorityBloc
                                                                              .countryname[
                                                                          listindex];

                                                                  _passportdropdownBloc
                                                                      .setdropdownvalue(
                                                                          _passportissuingValue);
                                                                  _passportdropdownBloc
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
                                                                        : _passportIssuingAuthorityBloc
                                                                            .countryname[listindex]),
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
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                    backgroundColor: kbackgroundColor,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(kgreenPrimaryColor)),
              );
            }
          },
        ),
        TextBoxLabel('Issuing Authority')
      ],
    );
  }

  _buildIssueDateTF(bool isIssue) {
    return isIssue
        ? _buildDates(isIssue)
        : StreamBuilder(
            stream: _displayPassportValidDate.stateRadioButtonStrean,
            builder: (context, snapshot) {
              if (_displayPassportValidDate.radioValue) {
                return _buildDates(isIssue);
              } else {
                return Container();
              }
            },
          );
  }

  _buildDates(bool isIssue) {
    return StreamBuilder(
      stream: _showPassportValidDate.stateRadioButtonStrean,
      builder: (context, displaysnapshot) {
        return Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Container(
                color: Colors.grey[50],
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  enabled: isIssue
                      ? true
                      : displaysnapshot.hasData &&
                              _showPassportValidDate.radioValue
                          ? true
                          : issueDateController.text.isNotEmpty
                              ? true
                              : false,
                  cursorColor: kgreenPrimaryColor,
                  controller:
                      isIssue ? issueDateController : validTillController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: kblackPrimaryColor,
                    fontFamily: 'OpenSans',
                  ),
                  onChanged: (value) {
                    if (isIssue && value.isEmpty) {
                      _showPassportValidDate.eventRadioButtonSink
                          .add(RadioButtonAction.False);
                      validTillController.clear();
                    }
                    if (value.isNotEmpty) {
                      removeError(error: 'Please select the date');
                    }
                  },
                  validator: (value) {
                    if (isIssue && value!.isEmpty) {
                      _showPassportValidDate.eventRadioButtonSink
                          .add(RadioButtonAction.False);
                    }
                    if (value!.isEmpty) {
                      return 'Please select the date';
                      //addError(error: kEmailNullError);

                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 32),
                      //floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(),
                      ),
                      suffixIcon: InkWell(
                        onTap: () => _selectDate(context, isIssue),
                        child: const Icon(
                          Icons.date_range,
                          color: kBluePrimaryColor,
                        ),
                      ),
                      hintText: isIssue
                          ? 'Enter your issue date'
                          : 'Enter the valid till date',
                      hintStyle: hintstyle),
                ),
              ),
            ),
            TextBoxLabel(isIssue ? 'Issue Date' : 'Valid Till')
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isIssue) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: isIssue
            ? DateTime(2015, 8)
            : DateTime.parse(issueDateController.text),
        lastDate: isIssue ? selectedDate : DateTime(2101));
    if (isIssue) {
      if (picked != null && picked != selectedDate) {
        issueDateController.text = formatter.format(picked);
        _showPassportValidDate.eventRadioButtonSink.add(RadioButtonAction.True);
      }
    } else {
      if (picked != null && picked != selectedDate) {
        validTillController.text = formatter.format(picked);
      }
    }
  }

  _buildVisaDateTF(int index, bool isIssue) {
    return isIssue
        ? _buildVisaDates(index, isIssue)
        : StreamBuilder(
            stream: _displayVisaValidDate[index].stateRadioButtonStrean,
            builder: (context, snapshot) {
              if (_displayVisaValidDate[index].radioValue) {
                return _buildVisaDates(index, isIssue);
              } else {
                return Container();
              }
            },
          );
  }

  _buildVisaDates(int index, bool isIssue) {
    return StreamBuilder(
      stream: _showVisaValidDate[index].stateRadioButtonStrean,
      builder: (context, displaysnapshot) {
        return Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Container(
                color: Colors.white,
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  enabled: isIssue
                      ? true
                      : displaysnapshot.hasData &&
                              _showVisaValidDate[index].radioValue
                          ? true
                          : _issueDateVisaController[index].text.isNotEmpty
                              ? true
                              : false,
                  cursorColor: kgreenPrimaryColor,
                  controller: isIssue
                      ? _issueDateVisaController[index]
                      : _validTillVisaController[index],
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: kblackPrimaryColor,
                    fontFamily: 'OpenSans',
                  ),
                  onChanged: (value) {
                    if (value.isEmpty && isIssue) {
                      _showVisaValidDate[index]
                          .eventRadioButtonSink
                          .add(RadioButtonAction.True);
                      _validTillVisaController[index].clear();
                    }
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 32),
                      //floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(),
                      ),
                      suffixIcon: InkWell(
                        onTap: () => _selectVisaDate(context, isIssue, index),
                        child: const Icon(
                          Icons.date_range,
                          color: kBluePrimaryColor,
                        ),
                      ),
                      hintText: isIssue
                          ? 'Enter your issue date'
                          : 'Enter the valid till date',
                      hintStyle: hintstyle),
                ),
              ),
            ),
            TextBoxLabel(isIssue ? 'Issue Date' : 'Valid Till')
          ],
        );
      },
    );
  }

  Future<void> _selectVisaDate(
      BuildContext context, bool isIssue, int index) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: isIssue
            ? DateTime(2015, 8)
            : DateTime.parse(_issueDateVisaController[index].text),
        lastDate: isIssue ? selectedDate : DateTime(2101));
    if (isIssue) {
      if (picked != null && picked != selectedDate) {
        _issueDateVisaController[index].text = formatter.format(picked);
        _showVisaValidDate[index]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      }
    } else {
      if (picked != null && picked != selectedDate) {
        _validTillVisaController[index].text = formatter.format(picked);
      }
    }
  }

  _displayPassportDetailsCard() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _displaySubHeading('Passport Details'),
              const SizedBox(
                height: 14,
              ),
              _buildPassportTF(),
              const SizedBox(
                height: 14,
              ),
              _buildPassportIssuingAuthority(),
              _displayerrortext(0, _errorPassportCountryCodeBloc, true),
              const SizedBox(
                height: 14,
              ),
              _buildIssueDateTF(true),
              const SizedBox(
                height: 14,
              ),
              _buildValidContainer(0, 0),
              _buildValidDateError(0, 0),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displayCDCBookCard() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _displaySubHeading('CDC/ Seamen Book'),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
              ),
              InkWell(
                onTap: () {
                  ResumeDocumentProvider documentProvider =
                      Provider.of<ResumeDocumentProvider>(context,
                          listen: false);
                  setState(() {
                    documentProvider.increaselength();
                    cleardata();

                    getdata();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.add_circle,
                        color: kgreenPrimaryColor,
                        size: 18,
                      ),
                      Text('Add CDC/Seamen Book',
                          style: TextStyle(
                              color: kBluePrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.032)),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Provider.of<AsyncCallProvider>(context, listen: false)
                      .isinasynccall
                  ? const SizedBox()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: Provider.of<ResumeDocumentProvider>(
                                  context,
                                  listen: false)
                              .cdcLength,
                          itemBuilder: (context, index) {
                            return Card(
                              color: kbackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Text(
                                            'CDC Book No. ${index + 1}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const Spacer(),
                                        _displayCDCDeleteIcon(index, false),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    _displayCDCBookCardData(index),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
            ],
          ),
        ),
      ),
    );
  }

  _displayVisaCard() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _displaySubHeading('Visa'),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
              ),
              InkWell(
                onTap: () {
                  ResumeDocumentProvider documentProvider =
                      Provider.of<ResumeDocumentProvider>(context,
                          listen: false);
                  setState(() {
                    documentProvider.increaseVisalength();
                    cleardata();

                    getdata();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.add_circle,
                        color: kgreenPrimaryColor,
                        size: 18,
                      ),
                      Text('Add Visa',
                          style: TextStyle(
                              color: kBluePrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.032)),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Provider.of<AsyncCallProvider>(context, listen: false)
                      .isinasynccall
                  ? const SizedBox()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: Provider.of<ResumeDocumentProvider>(context,
                                listen: false)
                            .visaLength,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.grey[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          'Visa No. ${index + 1}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Spacer(),
                                      _displayCDCDeleteIcon(index, true),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  _buildVisaDropdown(index),
                                  _buildVisaError(index, true),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildOtherCountryDropdown(index),
                                  _buildVisaError(index, false),
                                  _displayVisaData(index),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
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

  _displayVisaData(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        _buildVisaDateTF(index, true),
        const SizedBox(
          height: 10,
        ),
        _buildValidContainer(1, index),
        _buildValidDateError(1, index),
      ],
    );
  }

  void callPostDocumentRecord() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditTravelDocument(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    ResumeEditTravelDocUpdateProvider editTravelDocProvider =
        Provider.of<ResumeEditTravelDocUpdateProvider>(context, listen: false);
    List<PostVisaData> postVisaData = [];
    List<PostCdcData> postCdcData = [];

    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .cdcLength;
        i++) {
      String id = "";
      if (i <
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .cdcBookId
              .length) {
        id = Provider.of<ResumeDocumentProvider>(context, listen: false)
            .cdcBookId[i];
      } else {
        id = "";
      }

      String expiry = "";
      for (int k = 0; k < 3; k++) {
        if (_validTillOptionsCDCBloc[i][k].radioValue) {
          expiry = Provider.of<GetValidTypeProvider>(context, listen: false)
              .validTypeId[k];
        }
      }

      postCdcData.add(PostCdcData(
          documentNo: cdcSeamenController[i].text,
          documentType: "2",
          issuingAuthorityId: _issuingAuthorityBloc[i].countrycode[
              _issuingAuthorityBloc[i].countryname.indexOf(_issuingValue[i])],
          issueDate: _issueDateCDCController[i].text,
          validTillDate: "",
          //_expiryDateCDCController[i].text,
          validTillType: expiry,
          configurationId:
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .cdcCongigId,
          id: id));
    }

    String id = "";
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .visaLength;
        i++) {
      if (i <
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .visaId
              .length) {
        id = Provider.of<ResumeDocumentProvider>(context, listen: false)
            .visaId[i];
      } else {
        id = "";
      }
      String visaExpiry = "";
      for (int k = 0; k < 3; k++) {
        if (_validTillOptionsVisaBloc[i][k].radioValue) {
          visaExpiry = Provider.of<GetValidTypeProvider>(context, listen: false)
              .validTypeId[k];
        }
      }
      postVisaData.add(PostVisaData(
          issueDate: _issueDateVisaController[i].text,
          validTillDate: _validTillVisaController[i].text,
          validTillType: visaExpiry,
          configurationId:
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .visaConfigId[
                  Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .visaName
                      .indexOf(_visaValue[i])],
          countryId: _visaOtherValue[i].isEmpty
              ? ""
              : Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .visaCountriesId[
                  Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .visaCountries
                      .indexOf(_visaOtherValue[i])],
          id: id));
    }

    String passportExpiry = "";
    for (int k = 0; k < 3; k++) {
      if (_validTillOptionsBloc[k].radioValue) {
        passportExpiry =
            Provider.of<GetValidTypeProvider>(context, listen: false)
                .validTypeId[k];
      }
    }

    if (await editTravelDocProvider.callpostResumeTravelDocapi(
        Provider.of<ResumeDocumentProvider>(context, listen: false)
                .passportId
                .isEmpty
            ? null
            : Provider.of<ResumeDocumentProvider>(context, listen: false)
                .passportId[0],
        passportController.text,
        _passportIssuingAuthorityBloc.countrycode[_passportIssuingAuthorityBloc
            .countryname
            .indexOf(_passportissuingValue)],
        issueDateController.text,
        validTillController.text,
        passportExpiry,
        Provider.of<ResumeDocumentProvider>(context, listen: false)
            .passportConfigId,
        postVisaData,
        postCdcData,
        header)) {
      asyncProvider.changeAsynccall();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('RecordAdded', 'Record has been added successfully');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DocumentScreen()));
    } else {
      asyncProvider.changeAsynccall();
      displaysnackbar('Something went wrong');
    }
  }

  void getdata() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditTravelDocument(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }

    _passportIssuingAuthorityBloc.header = header;
    _passportIssuingAuthorityBloc.eventResumeIssuingAuthoritySink
        .add(ResumeIssuingAuthorityAction.Post);

    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .visaLength;
        i++) {
      _visaValue.add("");
      _visaOtherValue.add("");
      _visaOtherdropdownBloc.add(DropdownBloc());
      _displayVisaOtherCountry.add(RadioButtonBloc());
      _showVisaIssuingDropDownBloc.add(IndosNoBloc());
      _showVisaOtherIssuingDropDownBloc.add(IndosNoBloc());
      _visadropdownBloc.add(DropdownBloc());
      _errorVisaSelectBloc.add(ResumeErrorIssuingAuthorityBloc());
      _errorVisaOtherSelectBloc.add(ResumeErrorIssuingAuthorityBloc());
      _issueDateVisaController.add(TextEditingController());
      _validTillVisaController.add(TextEditingController());
      _showVisaValidDate.add(RadioButtonBloc());
      _displayVisaValidDate.add(RadioButtonBloc());
      _visaValidDateErrorBloc.add(ResumeErrorIssuingAuthorityBloc());
      List<RadioButtonBloc> tempValidTillDatebloc = [];
      for (int k = 0; k < 3; k++) {
        tempValidTillDatebloc.add(RadioButtonBloc());
      }
      _validTillOptionsVisaBloc.add(tempValidTillDatebloc);
      if (i <
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .visaIssueDate
              .length) {
        _issueDateVisaController[i].text =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .visaIssueDate[i];
      }
    }

    if (Provider.of<ResumeDocumentProvider>(context, listen: false)
        .passportId
        .isNotEmpty) {
      passportController.text =
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .passportNo[0];
      issueDateController.text =
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .passportIssueDate[0];
      validTillController.text =
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .passportExpiryDate[0];
    }

    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .cdcLength;
        i++) {
      _issuingAuthorityBloc.add(ResumeIssuingAuthorityBloc());
      _dropdownBloc.add(DropdownBloc());
      _showCDCIssuingDropDownBloc.add(IndosNoBloc());
      _errorCountryCodeBloc.add(ResumeErrorIssuingAuthorityBloc());
      _issueDateCDCController.add(TextEditingController());
      _expiryDateCDCController.add(TextEditingController());
      cdcSeamenController.add(TextEditingController());
      _displayCDCValidDate.add(RadioButtonBloc());
      _showCDCValidDate.add(RadioButtonBloc());
      _cdcValidDateErrorBloc.add(ResumeErrorIssuingAuthorityBloc());
      _issuingValue.add("");
      _issuingAuthorityBloc[i].header = header;
      _issuingAuthorityBloc[i]
          .eventResumeIssuingAuthoritySink
          .add(ResumeIssuingAuthorityAction.Post);
      List<RadioButtonBloc> tempValidTillDatebloc = [];
      for (int k = 0; k < 3; k++) {
        tempValidTillDatebloc.add(RadioButtonBloc());
      }
      _validTillOptionsCDCBloc.add(tempValidTillDatebloc);
      if (i <
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .cdcBookId
              .length) {
        _issueDateCDCController[i].text =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .cdcIssueDate[i];
        _expiryDateCDCController[i].text =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .cdcExpiryDate[i];
        cdcSeamenController[i].text =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .cdcBookNo[i];
      }
    }

    asyncProvider.changeAsynccall();
  }

  _displayCDCBookCardData(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCDCBookNoTF(index),
        const SizedBox(
          height: 10,
        ),
        _buildIssuingAuthority(index),
        _displayerrortext(index, _errorCountryCodeBloc, false),
        const SizedBox(
          height: 10,
        ),
        _buildCDCDatePicker(index, true),
        const SizedBox(
          height: 10,
        ),
        _buildValidContainer(2, index),
        _buildValidDateError(2, index),
      ],
    );
  }

  _buildCDCBookNoTF(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: kbackgroundColor,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
              ],
              cursorColor: kgreenPrimaryColor,
              controller: cdcSeamenController[index],
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter your cdc seamen number');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your cdc seamen number';
                  //addError(error: kEmailNullError);

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
                  hintText: 'Enter your CDC Seamen number',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('CDC Seamen No')
      ],
    );
  }

  _buildIssuingAuthority(int index) {
    return Stack(
      children: [
        StreamBuilder(
          stream:
              _issuingAuthorityBloc[index].stateResumeIssuingAuthorityStrean,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (index <
                  Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .cdcBookId
                      .length) {
                if (_issuingValue[index].isEmpty) {
                  _issuingValue[index] = Provider.of<ResumeDocumentProvider>(
                          context,
                          listen: false)
                      .cdcPlaceofIssueName[index];
                  _dropdownBloc[index].setdropdownvalue(_issuingValue[index]);
                  _dropdownBloc[index]
                      .eventDropdownSink
                      .add(DropdownAction.Update);
                }
              }
              return StreamBuilder(
                initialData: false,
                stream: _errorCountryCodeBloc[index]
                    .stateResumeIssuingAuthorityStrean,
                builder: (context, errorsnapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.0,
                            color: errorsnapshot.hasData
                                ? _errorCountryCodeBloc[index].showtext
                                    ? Colors.red
                                    : Colors.grey
                                : Colors.grey),
                        borderRadius: const BorderRadius.all(Radius.circular(
                                20.0) //                 <--- border radius here
                            ),
                      ),
                      child: StreamBuilder(
                        stream: _dropdownBloc[index].stateDropdownStrean,
                        builder: (context, dropdownsnapshot) {
                          return StreamBuilder(
                              stream: _showCDCIssuingDropDownBloc[index]
                                  .stateIndosNoStrean,
                              builder: (context, dropdownsnapshot) {
                                return Column(
                                  children: [
                                    DrodpownContainer(
                                      title: _issuingValue[index].isNotEmpty
                                          ? _issuingValue[index]
                                          : 'Select Issuing Authority',
                                      searchHint: 'Search Issuing Authority',
                                      showDropDownBloc:
                                          _showCDCIssuingDropDownBloc[index],
                                      originalList: _issuingAuthorityBloc[index]
                                          .countryname,
                                    ),
                                    ExpandedSection(
                                      expand: _showCDCIssuingDropDownBloc[index]
                                          .isedited,
                                      height: 100,
                                      child: MyScrollbar(
                                        builder:
                                            (context, scrollController2) =>
                                                ListView.builder(
                                                    padding:
                                                        const EdgeInsets.all(0),
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
                                                            : _issuingAuthorityBloc[index]
                                                                .countryname
                                                                .length,
                                                    itemBuilder:
                                                        (context, listindex) {
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
                                                              onTap: () async {
                                                                if (!Provider.of<
                                                                            SearchChangeProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .noDataFound) {
                                                                  String
                                                                      tempValue =
                                                                      "";
                                                                  _showCDCIssuingDropDownBloc[
                                                                          index]
                                                                      .eventIndosNoSink
                                                                      .add(IndosNoAction
                                                                          .False);
                                                                  _errorCountryCodeBloc[
                                                                          index]
                                                                      .eventResumeIssuingAuthoritySink
                                                                      .add(ResumeErrorIssuingAuthorityAction
                                                                          .False);

                                                                  tempValue = Provider.of<SearchChangeProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .searchList
                                                                          .isNotEmpty
                                                                      ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                          listindex]
                                                                      : _issuingAuthorityBloc[index]
                                                                              .countryname[
                                                                          listindex];

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

                                                                  _issuingValue[
                                                                          index] =
                                                                      tempValue;
                                                                  _dropdownBloc[
                                                                          index]
                                                                      .setdropdownvalue(
                                                                          _issuingValue[
                                                                              index]);
                                                                  _dropdownBloc[
                                                                          index]
                                                                      .eventDropdownSink
                                                                      .add(DropdownAction
                                                                          .Update);
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
                                                                        : _issuingAuthorityBloc[index]
                                                                            .countryname[listindex]),
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
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        TextBoxLabel('Issuing Authority')
      ],
    );
  }

  _displayerrortext(int index, var bloc, bool isPassport) {
    return StreamBuilder(
      initialData: false,
      stream: isPassport
          ? bloc.stateResumeIssuingAuthorityStrean
          : bloc[index].stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && isPassport
            ? bloc.showtext
            : bloc[index].showtext) {
          return Visibility(
            visible: isPassport ? bloc.showtext : bloc[index].showtext,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  !isPassport
                      ? bloc[index].showAlternateText
                          ? 'Please select another country'
                          : 'Please select the issuing authority'
                      : 'Please select the issuing authority',
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

  _buildCDCDatePicker(int index, bool isIssue) {
    return isIssue
        ? _buildCDCDates(index, isIssue)
        : StreamBuilder(
            stream: _displayCDCValidDate[index].stateRadioButtonStrean,
            builder: (context, snapshot) {
              if (_displayCDCValidDate[index].radioValue) {
                return _buildCDCDates(index, isIssue);
              } else {
                return Container();
              }
            },
          );
  }

  _buildCDCDates(int index, bool isIssue) {
    return StreamBuilder(
      stream: _showCDCValidDate[index].stateRadioButtonStrean,
      builder: (context, displaysnapshot) {
        return Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Container(
                color: Colors.white,
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  enabled: isIssue
                      ? true
                      : displaysnapshot.hasData &&
                              _showCDCValidDate[index].radioValue
                          ? true
                          : _issueDateCDCController[index].text.isNotEmpty
                              ? true
                              : false,
                  cursorColor: kgreenPrimaryColor,
                  controller: isIssue
                      ? _issueDateCDCController[index]
                      : _expiryDateCDCController[index],
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: kblackPrimaryColor,
                    fontFamily: 'OpenSans',
                  ),
                  onChanged: (value) {
                    if (value.isEmpty && isIssue) {
                      _showCDCValidDate[index]
                          .eventRadioButtonSink
                          .add(RadioButtonAction.False);
                      _expiryDateCDCController[index].clear();
                    }
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 32),
                      //floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(),
                      ),
                      suffixIcon: InkWell(
                        onTap: () => _selectCDCDate(context, index, isIssue),
                        child: const Icon(
                          Icons.date_range,
                          color: kBluePrimaryColor,
                        ),
                      ),
                      hintText: isIssue
                          ? 'Enter your issue date'
                          : 'Enter the expiry date',
                      hintStyle: hintstyle),
                ),
              ),
            ),
            TextBoxLabel(isIssue ? 'Issue Date' : 'Expiry Date')
          ],
        );
      },
    );
  }

  Future<void> _selectCDCDate(
      BuildContext context, int index, bool isIssue) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: isIssue ? DateTime(2015, 8) : selectedDate,
        lastDate: isIssue ? selectedDate : DateTime(2101));
    if (isIssue) {
      if (picked != null && picked != selectedDate) {
        _issueDateCDCController[index].text = formatter.format(picked);
        _showCDCValidDate[index]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      }
    } else {
      if (picked != null && picked != selectedDate) {
        _expiryDateCDCController[index].text = formatter.format(picked);
      }
    }
  }

  void _showDeleteDialog(int index, bool isVisa) {
    String title;
    isVisa
        ? title = "Delete Visa Record"
        : title = "Delete CDC/Seamen Book Record";
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: Text(title, style: const TextStyle(color: Colors.black)),
          content: const Text('Are you sure you want to delete this record?',
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
                        "Yes",
                        style: TextStyle(color: kbackgroundColor),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        deleterecord(index, isVisa);
                      }),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  color: kbackgroundColor,
                  //width: double.maxFinite,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: buttonStyle(),
                    child: const Text("Cancel"),
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
        ));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void deleterecord(int index, bool isVisa) async {
    if (index ==
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .cdcBookId
                .length &&
        !isVisa) {
      if (Provider.of<ResumeDocumentProvider>(context, listen: false)
          .cdcBookId
          .isNotEmpty) {
        deleteEmptyRecord(isVisa);
      }
    } else if (index ==
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .visaId
                .length &&
        isVisa) {
      if (Provider.of<ResumeDocumentProvider>(context, listen: false)
          .visaId
          .isNotEmpty) {
        deleteEmptyRecord(isVisa);
      }
    } else {
      if (index >
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .cdcBookId
                  .length &&
          !isVisa) {
        deleteEmptyRecord(isVisa);
      } else if (index >
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .visaId
                  .length &&
          isVisa) {
        deleteEmptyRecord(isVisa);
      } else {
        ResumeEditCdcRecordDeleteProvider cdcDeleteProvider =
            Provider.of<ResumeEditCdcRecordDeleteProvider>(context,
                listen: false);
        AsyncCallProvider asyncProvider =
            Provider.of<AsyncCallProvider>(context, listen: false);
        if (!Provider.of<AsyncCallProvider>(context, listen: false)
            .isinasynccall) asyncProvider.changeAsynccall();
        if (await cdcDeleteProvider.callpostDeleteResumeCdcRecordapi(
            isVisa
                ? Provider.of<ResumeDocumentProvider>(context, listen: false)
                    .visaId[index]
                : Provider.of<ResumeDocumentProvider>(context, listen: false)
                    .cdcBookId[index],
            header)) {
          asyncProvider.changeAsynccall();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(
              'DeleteSuccesful', 'Record has been deleted successfully');
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const DocumentScreen()));
        } else {
          asyncProvider.changeAsynccall();
          displaysnackbar('Something went wrong');
        }
      }
    }
  }

  bool _checkError() {
    var data = false;
    for (int i = 0; i < _issueDateCDCController.length; i++) {
      if (_issuingValue[i].isEmpty) {
        _errorCountryCodeBloc[i]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        data = true;
      }
    }

    List<bool> passportValid = [];
    for (int i = 0; i < 3; i++) {
      passportValid.add(_validTillOptionsBloc[i].radioValue);
    }

    if (!passportValid.contains(true)) {
      data = true;
      _passportValidDateErrorBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
    }

    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .visaLength;
        i++) {
      data = checkVisaValidDates(i);
      if (_errorVisaSelectBloc[i].showtext ||
          _errorVisaSelectBloc[i].showAlternateText) {
        data = true;
      }

      if (_visaValue[i].isEmpty) {
        _errorVisaSelectBloc[i]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        data = true;
      }
      if (_displayVisaOtherCountry[i].radioValue) {
        if (_visaOtherValue[i].isEmpty) {
          _errorVisaOtherSelectBloc[i]
              .eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.True);
        }
      }
    }

    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .cdcLength;
        i++) {
      data = checkCDCValidDates(i);
      if (checkCDCIssuingAuthorities(i)) {
        data = true;
      }
    }

    if (_passportissuingValue.isEmpty) {
      data = true;
      _errorPassportCountryCodeBloc.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
    }
    return data;
  }

  void deleteEmptyRecord(bool isVisa) {
    ResumeDocumentProvider documentProvider =
        Provider.of<ResumeDocumentProvider>(context, listen: false);
    isVisa
        ? setState(() {
            documentProvider.decreaseVisalength();
            _visadropdownBloc.removeLast();
            _visaOtherdropdownBloc.removeLast();
            _visaValue.removeLast();
            _visaOtherValue.removeLast();
            _issueDateVisaController.removeLast();
            _visaValue.add("");

            _displayVisaOtherCountry.removeLast();
            _errorVisaSelectBloc.removeLast();
            _errorVisaOtherSelectBloc.removeLast();
            _showVisaValidDate.removeLast();
            _displayVisaValidDate.removeLast();
            _visaValidDateErrorBloc.removeLast();
            _validTillOptionsVisaBloc.removeLast();
            _validTillVisaController.removeLast();
            //cleardata();

            getdata();
          })
        : setState(() {
            documentProvider.decreaselength();
            cdcSeamenController.removeLast();
            _issuingValue.removeLast();
            _issueDateCDCController.removeLast();
            _expiryDateCDCController.removeLast();
            //cleardata();
            getdata();
          });
  }

  _displayCDCDeleteIcon(int index, bool isVisa) {
    if (Provider.of<ResumeDocumentProvider>(context).cdcLength == 1 &&
        Provider.of<ResumeDocumentProvider>(context).cdcBookId.isEmpty &&
        !isVisa) {
      return const SizedBox();
    } else if (Provider.of<ResumeDocumentProvider>(context).visaLength == 1 &&
        Provider.of<ResumeDocumentProvider>(context).visaId.isEmpty &&
        isVisa) {
      return const SizedBox();
    } else {
      return InkWell(
        onTap: () => _showDeleteDialog(index, isVisa),
        child: Icon(
          Icons.cancel,
          color: Colors.red[500],
        ),
      );
    }
  }

  void cleardata() {
    cdcSeamenController.clear();
    _issuingValue.clear();
    _issueDateCDCController.clear();
    _expiryDateCDCController.clear();
  }

  _buildValidTillOptions(int radioindex, int count, int innerindex) {
    return StreamBuilder(
      stream: count == 0
          ? _validTillOptionsBloc[radioindex].stateRadioButtonStrean
          : count == 1
              ? _validTillOptionsVisaBloc[innerindex][radioindex]
                  .stateRadioButtonStrean
              : _validTillOptionsCDCBloc[innerindex][radioindex]
                  .stateRadioButtonStrean,
      builder: (context, snapshot) {
        if (count == 0) {
          checkPassportData();
        } else if (count == 1) {
          checkVisaData(innerindex);
        } else {
          checkCDCData(innerindex);
        }
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if (radioindex == 2) {
                      if (count == 0) {
                        _displayPassportValidDate.eventRadioButtonSink
                            .add(RadioButtonAction.True);
                        _displayPassportValidDate.radioValue = true;
                      } else if (count == 1) {
                        _displayVisaValidDate[innerindex]
                            .eventRadioButtonSink
                            .add(RadioButtonAction.True);
                        _displayVisaValidDate[innerindex].radioValue = true;
                      } else {
                        _displayCDCValidDate[innerindex]
                            .eventRadioButtonSink
                            .add(RadioButtonAction.True);
                        _displayCDCValidDate[innerindex].radioValue = true;
                      }
                    } else {
                      if (count == 0) {
                        _displayPassportValidDate.eventRadioButtonSink
                            .add(RadioButtonAction.False);
                        _displayPassportValidDate.radioValue = false;
                      } else if (count == 1) {
                        _displayVisaValidDate[innerindex]
                            .eventRadioButtonSink
                            .add(RadioButtonAction.False);
                        _displayVisaValidDate[innerindex].radioValue = false;
                      } else {
                        _displayCDCValidDate[innerindex]
                            .eventRadioButtonSink
                            .add(RadioButtonAction.False);
                        _displayCDCValidDate[innerindex].radioValue = false;
                      }
                    }
                    if (count == 0) {
                      _validTillOptionsBloc[radioindex]
                          .eventRadioButtonSink
                          .add(RadioButtonAction.True);
                      _validTillOptionsBloc[radioindex].radioValue = true;
                      _passportValidDateErrorBloc
                          .eventResumeIssuingAuthoritySink
                          .add(ResumeErrorIssuingAuthorityAction.False);
                      print('Data here is');
                      print(_validTillOptionsBloc[radioindex].radioValue);
                      print(radioindex);
                    } else if (count == 1) {
                      _validTillOptionsVisaBloc[innerindex][radioindex]
                          .eventRadioButtonSink
                          .add(RadioButtonAction.True);
                      _validTillOptionsVisaBloc[innerindex][radioindex]
                          .radioValue = true;
                      _visaValidDateErrorBloc[innerindex]
                          .eventResumeIssuingAuthoritySink
                          .add(ResumeErrorIssuingAuthorityAction.False);
                    } else {
                      _validTillOptionsCDCBloc[innerindex][radioindex]
                          .eventRadioButtonSink
                          .add(RadioButtonAction.True);
                      _validTillOptionsCDCBloc[innerindex][radioindex]
                          .radioValue = true;
                      _cdcValidDateErrorBloc[innerindex]
                          .eventResumeIssuingAuthoritySink
                          .add(ResumeErrorIssuingAuthorityAction.False);
                    }
                    for (int i = 0;
                        i <
                            Provider.of<GetValidTypeProvider>(context,
                                    listen: false)
                                .displayText
                                .length;
                        i++) {
                      if (i != radioindex) {
                        if (count == 0) {
                          print('Disaengaginfg');
                          print(i);
                          _validTillOptionsBloc[i]
                              .eventRadioButtonSink
                              .add(RadioButtonAction.False);
                          _validTillOptionsBloc[i].radioValue = false;
                        } else if (count == 1) {
                          _validTillOptionsVisaBloc[innerindex][i]
                              .eventRadioButtonSink
                              .add(RadioButtonAction.False);
                          _validTillOptionsVisaBloc[innerindex][i].radioValue =
                              false;
                        } else {
                          _validTillOptionsCDCBloc[innerindex][i]
                              .eventRadioButtonSink
                              .add(RadioButtonAction.False);
                          _validTillOptionsCDCBloc[innerindex][i].radioValue =
                              false;
                        }
                      }
                    }
                  });
                },
                child: ValidTillOptions(
                    radioValue: count == 0
                        ? _validTillOptionsBloc[radioindex].radioValue
                        : count == 1
                            ? _validTillOptionsVisaBloc[innerindex][radioindex]
                                .radioValue
                            : _validTillOptionsCDCBloc[innerindex][radioindex]
                                .radioValue,
                    text: Provider.of<GetValidTypeProvider>(context,
                            listen: false)
                        .displayText[radioindex]),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildValidContainer(int count, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Valid Till Date'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0;
                i <
                    Provider.of<GetValidTypeProvider>(context, listen: false)
                        .displayText
                        .length;
                i++)
              _buildValidTillOptions(i, count, index),
          ],
        ),
        count == 0
            ? _buildIssueDateTF(false)
            : count == 1
                ? _buildVisaDateTF(index, false)
                : _buildCDCDatePicker(index, false),
      ],
    );
  }

  _buildValidDateError(int i, int index) {
    return StreamBuilder(
      stream: i == 0
          ? _passportValidDateErrorBloc.stateResumeIssuingAuthorityStrean
          : i == 1
              ? _visaValidDateErrorBloc[index].stateResumeIssuingAuthorityStrean
              : _cdcValidDateErrorBloc[index].stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (i == 0
            ? _passportValidDateErrorBloc.showtext
            : i == 1
                ? _visaValidDateErrorBloc[index].showtext
                : _cdcValidDateErrorBloc[index].showtext) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Please select a valid date option',
              style: TextStyle(color: Colors.red[500]),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  bool checkVisaValidDates(int i) {
    List<bool> visaValid = [];
    for (int k = 0; k < 3; k++) {
      visaValid.add(_validTillOptionsVisaBloc[i][k].radioValue);
    }

    if (!visaValid.contains(true)) {
      _visaValidDateErrorBloc[i]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
      return true;
    } else {
      return false;
    }
  }

  bool checkCDCValidDates(int i) {
    List<bool> cdcValid = [];
    for (int k = 0; k < 3; k++) {
      cdcValid.add(_validTillOptionsCDCBloc[i][k].radioValue);
    }

    if (!cdcValid.contains(true)) {
      _cdcValidDateErrorBloc[i]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
      return true;
    } else {
      return false;
    }
  }

  bool checkCDCIssuingAuthorities(index) {
    bool isValid = false;
    for (int i = 0; i < _issuingValue.length; i++) {
      if (_issuingValue[index] == _issuingValue[i] && i != index) {
        _errorCountryCodeBloc[index]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        _errorCountryCodeBloc[index].showAlternateText = true;
        isValid = true;
      } else {
        _errorCountryCodeBloc[index]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.False);
        _errorCountryCodeBloc[index].showAlternateText = false;
      }
    }
    return isValid;
  }

  void checkPassportData() {
    bool value = false;
    for (int i = 0; i < _validTillOptionsBloc.length; i++) {
      if (_validTillOptionsBloc[i].radioValue) {
        value = true;
      }
    }
    if (!value &&
        Provider.of<ResumeDocumentProvider>(context, listen: false)
            .passportId
            .isNotEmpty) {
      if (Provider.of<ResumeDocumentProvider>(context, listen: false)
              .passportValidType ==
          lifetimeValidType) {
        _validTillOptionsBloc[0]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
        _validTillOptionsBloc[0].radioValue = true;
      } else {
        _validTillOptionsBloc[0].radioValue = false;
      }
      if (Provider.of<ResumeDocumentProvider>(context, listen: false)
              .passportValidType ==
          unlimitedValidType) {
        _validTillOptionsBloc[1]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
        _validTillOptionsBloc[1].radioValue = true;
      } else {
        _validTillOptionsBloc[1].radioValue = false;
      }
      if (Provider.of<ResumeDocumentProvider>(context, listen: false)
              .passportValidType ==
          dateValidType) {
        _validTillOptionsBloc[2]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
        _validTillOptionsBloc[2].radioValue = true;
        _displayPassportValidDate.eventRadioButtonSink
            .add(RadioButtonAction.True);
        _displayPassportValidDate.radioValue = true;
        validTillController.text =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .passportExpiryDate[0];
      } else {
        _validTillOptionsBloc[2].radioValue = false;
      }
    }
  }

  void checkVisaData(int innerindex) {
    bool value = false;
    for (int i = 0; i < _validTillOptionsVisaBloc[innerindex].length; i++) {
      if (_validTillOptionsVisaBloc[innerindex][i].radioValue) {
        value = true;
      }
    }
    if (innerindex <
        Provider.of<ResumeDocumentProvider>(context, listen: false)
            .visaExpiryDate
            .length) {
      if (!value &&
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .visaExpiryDate
              .isNotEmpty) {
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .visaValidType[innerindex] ==
            lifetimeValidType) {
          _validTillOptionsVisaBloc[innerindex][0]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _validTillOptionsVisaBloc[innerindex][0].radioValue = true;
        } else {
          _validTillOptionsVisaBloc[innerindex][0].radioValue = false;
        }
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .visaValidType[innerindex] ==
            unlimitedValidType) {
          _validTillOptionsVisaBloc[innerindex][1]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _validTillOptionsVisaBloc[innerindex][1].radioValue = true;
        } else {
          _validTillOptionsVisaBloc[innerindex][1].radioValue = false;
        }
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .visaValidType[innerindex] ==
            dateValidType) {
          _validTillOptionsVisaBloc[innerindex][2]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _validTillOptionsVisaBloc[innerindex][2].radioValue = true;
          _displayVisaValidDate[innerindex]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _displayVisaValidDate[innerindex].radioValue = true;
          _validTillVisaController[innerindex].text =
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .visaExpiryDate[innerindex];
        } else {
          _validTillOptionsVisaBloc[innerindex][2].radioValue = false;
        }
      }
    }
  }

  void checkCDCData(int innerindex) {
    bool value = false;
    for (int i = 0; i < _validTillOptionsCDCBloc[innerindex].length; i++) {
      if (_validTillOptionsCDCBloc[innerindex][i].radioValue) {
        value = true;
      }
    }
    if (!value &&
        Provider.of<ResumeDocumentProvider>(context, listen: false)
                .cdcBookId
                .length <
            innerindex) {
      if (Provider.of<ResumeDocumentProvider>(context, listen: false)
              .cdcValidTillType[innerindex] ==
          lifetimeValidType) {
        _validTillOptionsCDCBloc[innerindex][0]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
        _validTillOptionsCDCBloc[innerindex][0].radioValue = true;
      } else {
        _validTillOptionsCDCBloc[innerindex][0].radioValue = false;
      }
      if (Provider.of<ResumeDocumentProvider>(context, listen: false)
              .cdcValidTillType[innerindex] ==
          unlimitedValidType) {
        _validTillOptionsCDCBloc[innerindex][1]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
        _validTillOptionsCDCBloc[innerindex][1].radioValue = true;
      } else {
        _validTillOptionsCDCBloc[innerindex][1].radioValue = false;
      }
      if (Provider.of<ResumeDocumentProvider>(context, listen: false)
              .cdcValidTillType[innerindex] ==
          dateValidType) {
        _validTillOptionsCDCBloc[innerindex][2]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
        _validTillOptionsCDCBloc[innerindex][2].radioValue = true;
        _displayCDCValidDate[innerindex]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
        _displayCDCValidDate[innerindex].radioValue = true;
        _expiryDateCDCController[innerindex].text =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .cdcExpiryDate[innerindex];
      } else {
        _validTillOptionsCDCBloc[innerindex][2].radioValue = false;
      }
    }
  }

  _buildVisaDropdown(int index) {
    return Stack(
      children: [
        StreamBuilder(
          initialData: false,
          stream: _errorVisaSelectBloc[index].stateResumeIssuingAuthorityStrean,
          builder: (context, errorsnapshot) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.0,
                      color: errorsnapshot.hasData
                          ? _errorVisaSelectBloc[index].showtext
                              ? Colors.red
                              : Colors.grey
                          : Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(
                          20.0) //                 <--- border radius here
                      ),
                ),
                child: StreamBuilder(
                  stream: _visadropdownBloc[index].stateDropdownStrean,
                  builder: (context, dropdownsnapshot) {
                    if (_visaValue[index].isEmpty) {
                      if (index <
                          Provider.of<ResumeDocumentProvider>(context,
                                  listen: false)
                              .visaIssueDate
                              .length) {
                        _visaValue[index] = Provider.of<ResumeDocumentProvider>(
                                context,
                                listen: false)
                            .visaStaticNames[index];
                        _visadropdownBloc[index]
                            .setdropdownvalue(_visaValue[index]);
                        _visadropdownBloc[index]
                            .eventDropdownSink
                            .add(DropdownAction.Update);
                        _displayVisaOtherCountry[index]
                            .eventRadioButtonSink
                            .add(RadioButtonAction.False);
                      }
                    }
                    return StreamBuilder(
                        stream: _showVisaIssuingDropDownBloc[index]
                            .stateIndosNoStrean,
                        builder: (context, dropdownsnapshot) {
                          return Column(
                            children: [
                              DrodpownContainer(
                                title: _visaValue[index].isNotEmpty
                                    ? _visaValue[index]
                                    : 'Select Issuing Authority',
                                searchHint: 'Search Issuing Authority',
                                showDropDownBloc:
                                    _showVisaIssuingDropDownBloc[index],
                                originalList:
                                    Provider.of<ResumeDocumentProvider>(context,
                                            listen: false)
                                        .visaName,
                              ),
                              ExpandedSection(
                                expand: _showVisaIssuingDropDownBloc[index]
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
                                                  .noDataFound
                                              ? 1
                                              : Provider.of<SearchChangeProvider>(
                                                          context,
                                                          listen: false)
                                                      .searchList
                                                      .isNotEmpty
                                                  ? Provider.of<SearchChangeProvider>(
                                                          context,
                                                          listen: false)
                                                      .searchList
                                                      .length
                                                  : Provider.of<ResumeDocumentProvider>(
                                                          context,
                                                          listen: false)
                                                      .visaName
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
                                                      if (!Provider.of<
                                                                  SearchChangeProvider>(
                                                              context,
                                                              listen: false)
                                                          .noDataFound) {
                                                        _showVisaIssuingDropDownBloc[
                                                                index]
                                                            .eventIndosNoSink
                                                            .add(IndosNoAction
                                                                .False);
                                                        _errorVisaSelectBloc[
                                                                index]
                                                            .eventResumeIssuingAuthoritySink
                                                            .add(
                                                                ResumeErrorIssuingAuthorityAction
                                                                    .False);
                                                        _errorVisaSelectBloc[
                                                                    index]
                                                                .showAlternateText =
                                                            false;
                                                        _visaValue[
                                                            index] = Provider.of<
                                                                        SearchChangeProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .searchList
                                                                .isNotEmpty
                                                            ? Provider.of<SearchChangeProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .searchList[
                                                                listindex]
                                                            : Provider.of<ResumeDocumentProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .visaName[
                                                                listindex];

                                                        _visadropdownBloc[index].setdropdownvalue(Provider.of<
                                                                        SearchChangeProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .searchList
                                                                .isNotEmpty
                                                            ? Provider.of<SearchChangeProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .searchList[
                                                                listindex]
                                                            : Provider.of<ResumeDocumentProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .visaName[
                                                                listindex]);
                                                        _visadropdownBloc[index]
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
                                                        if (visaOtherId ==
                                                            Provider.of<
                                                                        ResumeDocumentProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .visaConfigId[Provider
                                                                    .of<ResumeDocumentProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                .visaName
                                                                .indexOf(
                                                                    _visaValue[
                                                                        index])]) {
                                                          _displayVisaOtherCountry[
                                                                  index]
                                                              .eventRadioButtonSink
                                                              .add(
                                                                  RadioButtonAction
                                                                      .True);
                                                        } else {
                                                          _displayVisaOtherCountry[
                                                                  index]
                                                              .eventRadioButtonSink
                                                              .add(
                                                                  RadioButtonAction
                                                                      .False);
                                                        }
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16),
                                                      child: Text(Provider.of<SearchChangeProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .noDataFound
                                                          ? 'No Data Found'
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
                                                                      .searchList[
                                                                  listindex]
                                                              : Provider.of<ResumeDocumentProvider>(
                                                                      context,
                                                                      listen: false)
                                                                  .visaName[listindex]),
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
              ),
            );
          },
        ),
        TextBoxLabel('Select Visa')
      ],
    );
  }

  _buildVisaError(int index, bool isVisa) {
    return StreamBuilder(
      stream: isVisa
          ? _errorVisaSelectBloc[index].stateResumeIssuingAuthorityStrean
          : _errorVisaOtherSelectBloc[index].stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && isVisa
            ? _errorVisaSelectBloc[index].showtext
            : _errorVisaOtherSelectBloc[index].showtext) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
                isVisa
                    ? _errorVisaSelectBloc[index].showAlternateText
                        ? 'Please select another visa'
                        : 'Please select visa'
                    : 'Please select the country',
                style: TextStyle(color: Colors.red[500])),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _buildOtherCountryDropdown(int index) {
    return StreamBuilder(
      stream: _displayVisaOtherCountry[index].stateRadioButtonStrean,
      builder: (context, snapshot) {
        if (_visaOtherValue[index].isEmpty) {
          if (index <
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .visaIssueDate
                  .length) {
            if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                    .visaStaticConfigId[index] ==
                visaOtherId) {
              _displayVisaOtherCountry[index]
                  .eventRadioButtonSink
                  .add(RadioButtonAction.True);
              _displayVisaOtherCountry[index].radioValue = true;
              _visaOtherValue[index] =
                  Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .visaCountryName[index];
              _visaOtherdropdownBloc[index]
                  .setdropdownvalue(_visaOtherValue[index]);
              _visaOtherdropdownBloc[index]
                  .eventDropdownSink
                  .add(DropdownAction.Update);
            }
          }
        }
        if (snapshot.hasData && _displayVisaOtherCountry[index].radioValue) {
          return Stack(
            children: [
              StreamBuilder(
                initialData: false,
                stream: _errorVisaOtherSelectBloc[index]
                    .stateResumeIssuingAuthorityStrean,
                builder: (context, errorsnapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.0,
                            color: errorsnapshot.hasData
                                ? _errorVisaOtherSelectBloc[index].showtext
                                    ? Colors.red
                                    : Colors.grey
                                : Colors.grey),
                        borderRadius: const BorderRadius.all(Radius.circular(
                                20.0) //                 <--- border radius here
                            ),
                      ),
                      child: StreamBuilder(
                        stream:
                            _visaOtherdropdownBloc[index].stateDropdownStrean,
                        builder: (context, dropdownsnapshot) {
                          return StreamBuilder(
                              stream: _showVisaOtherIssuingDropDownBloc[index]
                                  .stateIndosNoStrean,
                              builder: (context, dropdownsnapshot) {
                                return Column(
                                  children: [
                                    DrodpownContainer(
                                      title: _visaOtherValue[index].isNotEmpty
                                          ? _visaOtherValue[index]
                                          : 'Select Issuing Authority',
                                      searchHint: 'Search Issuing Authority',
                                      showDropDownBloc:
                                          _showVisaOtherIssuingDropDownBloc[
                                              index],
                                      originalList:
                                          Provider.of<ResumeDocumentProvider>(
                                                  context,
                                                  listen: false)
                                              .visaCountries,
                                    ),
                                    ExpandedSection(
                                      expand: _showVisaOtherIssuingDropDownBloc[
                                              index]
                                          .isedited,
                                      height: 100,
                                      child: MyScrollbar(
                                        builder:
                                            (context, scrollController2) =>
                                                ListView.builder(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    controller:
                                                        scrollController2,
                                                    shrinkWrap: true,
                                                    itemCount: Provider.of<SearchChangeProvider>(
                                                                context,
                                                                listen: false)
                                                            .noDataFound
                                                        ? 1
                                                        : Provider.of<SearchChangeProvider>(context, listen: false)
                                                                .searchList
                                                                .isNotEmpty
                                                            ? Provider.of<SearchChangeProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .searchList
                                                                .length
                                                            : Provider.of<ResumeDocumentProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .visaCountries
                                                                .length,
                                                    itemBuilder:
                                                        (context, listindex) {
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
                                                              onTap: () async {
                                                                if (Provider.of<
                                                                            SearchChangeProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .noDataFound) {
                                                                  _errorVisaOtherSelectBloc[
                                                                          index]
                                                                      .eventResumeIssuingAuthoritySink
                                                                      .add(ResumeErrorIssuingAuthorityAction
                                                                          .False);

                                                                  _showVisaOtherIssuingDropDownBloc[
                                                                          index]
                                                                      .eventIndosNoSink
                                                                      .add(IndosNoAction
                                                                          .False);
                                                                  _visaOtherValue[
                                                                      index] = Provider.of<SearchChangeProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .searchList
                                                                          .isNotEmpty
                                                                      ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                          listindex]
                                                                      : Provider.of<ResumeDocumentProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .visaCountries[listindex];

                                                                  _visaOtherdropdownBloc[
                                                                          index]
                                                                      .setdropdownvalue(
                                                                          _visaOtherValue[
                                                                              index]);
                                                                  _visaOtherdropdownBloc[
                                                                          index]
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
                                                                        : Provider.of<ResumeDocumentProvider>(context,
                                                                                listen: false)
                                                                            .visaCountries[listindex]),
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
                    ),
                  );
                },
              ),
              TextBoxLabel('Select Country')
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
