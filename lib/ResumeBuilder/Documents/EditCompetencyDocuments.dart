// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, prefer_final_fields

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';
import 'package:smartseaman/ResumeBuilder/Documents/DocumentScreenProvider.dart';
import 'package:smartseaman/ResumeBuilder/GetValidTypeProvider.dart';
import 'package:smartseaman/ResumeBuilder/PersonalInformation/ExpandedAnimation.dart';
import '../../DropdownBloc.dart';
import '../../DropdownContainer.dart';
import '../../IssuingAuthorityErrorBloc.dart';
import '../../RadioButtonBloc.dart';
import '../../SearchTextProvider.dart';
import '../../TextBoxLabel.dart';
import '../../asynccallprovider.dart';
import '../../constants.dart';
import '../Header.dart';
import '../IssuingAuhtorityBloc.dart';
import '../PersonalInformation/IndosNoBloc.dart';
import '../PersonalInformation/Scrollbar.dart';
import '../ValidTillOptions.dart';
import 'CompetencydocUpdateProvider.dart';
import 'DeleteCompetencyRecord.dart';
import 'DocumentScreen.dart';
import 'PostCompetencyData.dart';

class EditCompetencyDocuments extends StatefulWidget {
  const EditCompetencyDocuments({Key? key}) : super(key: key);

  @override
  _EditCompetencyDocumentsState createState() =>
      _EditCompetencyDocumentsState();
}

class _EditCompetencyDocumentsState extends State<EditCompetencyDocuments> {
  var header;
  static final _mandatoryformKey = GlobalKey<FormState>();
  static final _optionalformKey = GlobalKey<FormState>();
  bool mandatoryCall = false;
  final List<TextEditingController> _mandatoryIssueDateController = [],
      _mandatoryExpiryDateController = [],
      _mandatorySeamenBookNoController = [],
      _optionalIssueDateController = [],
      _optionalExpiryDateController = [],
      _optionalSeamenBookNoController = [];
  DateTime signOnselectedDate = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  List<String> _mandatoryIssuingValue = [],
      _optionalIssuingValue = [],
      _mandatoryDocValue = [],
      _optionalDocValue = [],
      _mandatoryTempCompetencyDocName = [],
      _mandatoryTempCertificateNo = [],
      _mandatoryTempIssuingValue = [],
      _mandatoryTempIssueDate = [],
      _mandatoryTempRadioValue = [],
      _mandatoryTempValidTillText = [],
      _optionalTempCompetencyDocName = [],
      _optionalTempCertificateNo = [],
      _optionalTempIssuingValue = [],
      _optionalTempIssueDate = [],
      _optionalTempRadioValue = [],
      _optionalTempValidTillText = [];
  final ResumeErrorIssuingAuthorityBloc _selectMandatoryDocError =
      ResumeErrorIssuingAuthorityBloc();
  final List<ResumeErrorIssuingAuthorityBloc> _mandatoryErrorComptencyDocName =
          [],
      _optionalErrorComptencyDocName = [],
      _mandatoryErrorCountryCodeBloc = [],
      _optionalErrorCountryCodeBloc = [],
      _mandatoryCompetencyValidDateErrorBloc = [],
      _optionalCompetencyValidDateErrorBloc = [];
  final List<ResumeIssuingAuthorityBloc> _mandatoryissuingAuthorityBloc = [],
      _optionalissuingAuthorityBloc = [];
  final List<RadioButtonBloc> _mandatoryShowValidTillDate = [],
      _mandatoryDisplayCompetencyValidDate = [],
      _optionalShowValidTillDate = [],
      _optionalDisplayCompetencyValidDate = [];
  final List<List<RadioButtonBloc>> _mandatoryValidTillOptionsCompetencyBloc =
          [],
      _optionalValidTillOptionsCompetencyBloc = [];
  final List<DropdownBloc> _mandatoryDocDropdownBloc = [],
      _optionalDocDropdownBloc = [],
      _mandatoryIssuingAuthoritydropdownBloc = [],
      _optionalIssuingAuthoritydropdownBloc = [];
  final List<IndosNoBloc> _showMandatoryDropDownBloc = [],
      _showOptionalDropDownBloc = [],
      _showMandatoryIssuingDropDownBloc = [],
      _showOptionalIssuingDropDownBloc = [];
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
    _selectMandatoryDocError.dispose();
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyMandatoryLength;
        i++) {
      _mandatoryErrorCountryCodeBloc[i].dispose();
      _mandatoryissuingAuthorityBloc[i].dispose();
      _mandatoryErrorComptencyDocName[i].dispose();
      _mandatoryDocDropdownBloc[i].dispose();
      _mandatoryIssuingAuthoritydropdownBloc[i].dispose();
      _mandatoryShowValidTillDate[i].dispose();
      _mandatoryCompetencyValidDateErrorBloc[i].dispose();
      _mandatoryDisplayCompetencyValidDate[i].dispose();
      for (int k = 0; k < 3; k++) {
        _mandatoryValidTillOptionsCompetencyBloc[i][k].dispose();
      }
      _showMandatoryDropDownBloc[i].dispose();
      _showMandatoryIssuingDropDownBloc[i].dispose();
    }
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyOptionalLength;
        i++) {
      _optionalErrorCountryCodeBloc[i].dispose();
      _optionalissuingAuthorityBloc[i].dispose();
      _optionalDocDropdownBloc[i].dispose();
      _optionalIssuingAuthoritydropdownBloc[i].dispose();
      _optionalErrorComptencyDocName[i].dispose();
      _optionalShowValidTillDate[i].dispose();
      _optionalCompetencyValidDateErrorBloc[i].dispose();
      _optionalDisplayCompetencyValidDate[i].dispose();
      for (int k = 0; k < 3; k++) {
        _optionalValidTillOptionsCompetencyBloc[i][k].dispose();
      }
      _showOptionalDropDownBloc[i].dispose();
      _showOptionalIssuingDropDownBloc[i].dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            children: [
              ResumeHeader('Documents', 2, true, ""),
              _displayExtensions(true),
              _displayExtensions(false),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        bool result = true;
                        if (_mandatoryformKey.currentState!.validate()) {
                          _mandatoryformKey.currentState!.save();
                          if (checkError()) {
                            result = false;
                          }
                        } else {
                          result = false;
                          checkError();
                        }
                        if (_optionalformKey.currentState!.validate()) {
                          _optionalformKey.currentState!.save();
                          if (checkOptionalData()) {
                            result = false;
                          }
                        } else {
                          result = false;
                          checkOptionalData();
                        }
                        print(result);
                        if (result) callPostCompetencyRecords();
                      },
                      style: buttonStyle(),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            color: kbackgroundColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      if (!checkMandatoryDocAvailability()) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: kgreenPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _displayCompetencyCard(bool isMandatory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAddCompetencyOption(isMandatory),
        isMandatory ? _buildErrorDocDisplay() : Container(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: isMandatory
                      ? Provider.of<ResumeDocumentProvider>(context,
                              listen: false)
                          .competencyMandatoryLength
                      : Provider.of<ResumeDocumentProvider>(context,
                              listen: false)
                          .competencyOptionalLength,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    'Competency Document No. ${index + 1}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Spacer(),
                                _displayCompetencyDeleteIcon(
                                    index, isMandatory),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildDocNameDropdown(index, isMandatory),
                            _buildDocErrorDropdown(index, isMandatory),
                            const SizedBox(
                              height: 10,
                            ),
                            _displayCompetencyCardData(index, isMandatory),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _displayCompetencyCardData(int index, bool isMandatory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        _buildSeamenBookTF(index, isMandatory),
        const SizedBox(
          height: 10,
        ),
        _buildIssuingAuthority(index, isMandatory),
        _displayerrortext(index, isMandatory),
        const SizedBox(
          height: 10,
        ),
        _buildDateTF(index, true, isMandatory),
        const SizedBox(
          height: 10,
        ),
        _buildValidContainer(index, isMandatory),
        _buildValidDateError(index, isMandatory),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  _buildValidContainer(int index, bool isMandatory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Expiry Date'),
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
              _buildValidTillOptions(i, index, isMandatory),
          ],
        ),
        _buildDateTF(index, false, isMandatory),
      ],
    );
  }

  _buildValidTillOptions(int radioindex, int innerindex, bool isMandatory) {
    return StreamBuilder(
      stream: isMandatory
          ? _mandatoryValidTillOptionsCompetencyBloc[innerindex][radioindex]
              .stateRadioButtonStrean
          : _optionalValidTillOptionsCompetencyBloc[innerindex][radioindex]
              .stateRadioButtonStrean,
      builder: (context, snapshot) {
        if (isMandatory) {
          checkMandatoryValidTillData(innerindex);
        } else {
          checkOptionalValidTillData(innerindex);
        }
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if (isMandatory) {
                      checkMandatoryValidTill(radioindex, innerindex);
                    } else {
                      checkOptionalValidTill(radioindex, innerindex);
                    }  
                  });
                  
                },
                child: ValidTillOptions(
                    radioValue: isMandatory
                        ? _mandatoryValidTillOptionsCompetencyBloc[innerindex]
                                    [radioindex]
                                .radioValue
                            ? true
                            : false
                        : _optionalValidTillOptionsCompetencyBloc[innerindex]
                                    [radioindex]
                                .radioValue
                            ? true
                            : false,
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

  _buildValidDateError(int index, bool isMandatory) {
    return StreamBuilder(
      stream: isMandatory
          ? _mandatoryCompetencyValidDateErrorBloc[index]
              .stateResumeIssuingAuthorityStrean
          : _optionalCompetencyValidDateErrorBloc[index]
              .stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (isMandatory
            ? _mandatoryCompetencyValidDateErrorBloc[index].showtext
            : _optionalCompetencyValidDateErrorBloc[index].showtext) {
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

  _buildSeamenBookTF(int index, bool isMandatory) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller: isMandatory
                  ? _mandatorySeamenBookNoController[index]
                  : _optionalSeamenBookNoController[index],
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter the certificate no');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the certificate no';
                  //addError(error: kEmailNullError);

                }
                return null;
              },
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  //floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter your Certificate No',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Certificate No')
      ],
    );
  }

  _buildDateTF(int index, bool isSignOn, bool isMandatory) {
    return isSignOn
        ? _buildCompetencyDates(index, isSignOn, isMandatory)
        : StreamBuilder(
            stream: isMandatory
                ? _mandatoryDisplayCompetencyValidDate[index]
                    .stateRadioButtonStrean
                : _optionalDisplayCompetencyValidDate[index]
                    .stateRadioButtonStrean,
            builder: (context, snapshot) {
              if (isMandatory
                  ? _mandatoryDisplayCompetencyValidDate[index].radioValue
                  : _optionalDisplayCompetencyValidDate[index].radioValue) {
                return _buildCompetencyDates(index, isSignOn, isMandatory);
              } else {
                return Container();
              }
            },
          );
  }

  _buildCompetencyDates(int index, bool isSignOn, bool isMandatory) {
    return StreamBuilder(
      stream: isMandatory
          ? _mandatoryShowValidTillDate[index].stateRadioButtonStrean
          : _optionalShowValidTillDate[index].stateRadioButtonStrean,
      builder: (context, displaysnapshot) {
        return Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Container(
                color: Colors.white,
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  enabled: isSignOn
                      ? true
                      : displaysnapshot.hasData && displaysnapshot.hasData
                          ? true
                          : isMandatory
                              ? _mandatoryIssueDateController[index]
                                      .text
                                      .isEmpty
                                  ? false
                                  : true
                              : _optionalIssueDateController[index].text.isEmpty
                                  ? false
                                  : true,
                  cursorColor: kgreenPrimaryColor,
                  controller: isSignOn
                      ? isMandatory
                          ? _mandatoryIssueDateController[index]
                          : _optionalIssueDateController[index]
                      : isMandatory
                          ? _mandatoryExpiryDateController[index]
                          : _optionalExpiryDateController[index],
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: kblackPrimaryColor,
                    fontFamily: 'OpenSans',
                  ),
                  onChanged: (value) {
                    if (isSignOn && value.isEmpty) {
                      if (isMandatory) {
                        _mandatoryShowValidTillDate[index]
                            .eventRadioButtonSink
                            .add(RadioButtonAction.False);
                        _mandatoryExpiryDateController[index].clear();
                      } else {
                        _optionalShowValidTillDate[index]
                            .eventRadioButtonSink
                            .add(RadioButtonAction.False);
                        _optionalExpiryDateController[index].clear();
                      }
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
                        onTap: () =>
                            _selectDate(context, index, isSignOn, isMandatory),
                        child: const Icon(
                          Icons.date_range,
                          color: kBluePrimaryColor,
                        ),
                      ),
                      hintText: isSignOn
                          ? 'Enter your issue Date'
                          : 'Enter your expiry date',
                      hintStyle: hintstyle),
                ),
              ),
            ),
            TextBoxLabel(isSignOn ? 'Issue Date' : 'Expiry Date')
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, int index, bool isSignOn, bool isMandatory) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: signOnselectedDate,
      firstDate: isSignOn
          ? DateTime(2015, 8)
          : DateTime.parse(isMandatory
              ? _mandatoryIssueDateController[index].text
              : _optionalIssueDateController[index].text),
      lastDate: isSignOn ? signOnselectedDate : DateTime(2101),
    );
    if (isSignOn) {
      if (picked != null && picked != signOnselectedDate) {
        if (isMandatory) {
          _mandatoryIssueDateController[index].text = formatter.format(picked);
          _mandatoryShowValidTillDate[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
        } else {
          _optionalIssueDateController[index].text = formatter.format(picked);
          _optionalShowValidTillDate[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
        }
      }
    } else {
      if (picked != null && picked != signOnselectedDate) {
        if (isMandatory) {
          _mandatoryExpiryDateController[index].text = formatter.format(picked);
        } else {
          _optionalExpiryDateController[index].text = formatter.format(picked);
        }
      }
    }
  }

  _buildIssuingAuthority(int index, bool isMandatory) {
    return Stack(
      children: [
        StreamBuilder(
          initialData: true,
          stream: isMandatory
              ? _mandatoryissuingAuthorityBloc[index]
                  .stateResumeIssuingAuthorityStrean
              : _optionalissuingAuthorityBloc[index]
                  .stateResumeIssuingAuthorityStrean,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (isMandatory) {
                if (index <
                    Provider.of<ResumeDocumentProvider>(context, listen: false)
                        .competencyDocName
                        .length) {
                  if (Provider.of<ResumeDocumentProvider>(context,
                          listen: false)
                      .competencyPlaceofIssueName[index]
                      .isNotEmpty) {
                    if (_mandatoryIssuingValue[index].isEmpty) {
                      _mandatoryIssuingValue[index] =
                          Provider.of<ResumeDocumentProvider>(context,
                                  listen: false)
                              .competencyPlaceofIssueName[index];
                      _mandatoryIssuingAuthoritydropdownBloc[index]
                          .setdropdownvalue(_mandatoryIssuingValue[index]);
                      _mandatoryIssuingAuthoritydropdownBloc[index]
                          .eventDropdownSink
                          .add(DropdownAction.Update);
                    }
                  } else {
                    _mandatoryIssuingValue[index] =
                        _mandatoryissuingAuthorityBloc[index].countryname[0];
                    _mandatoryIssuingAuthoritydropdownBloc[index]
                        .setdropdownvalue(_mandatoryIssuingValue[index]);
                    _mandatoryIssuingAuthoritydropdownBloc[index]
                        .eventDropdownSink
                        .add(DropdownAction.Update);
                  }
                }
              } else {
                if (index <
                    Provider.of<ResumeDocumentProvider>(context, listen: false)
                        .displayOptionalcompetencyCertificateNo
                        .length) {
                  if (Provider.of<ResumeDocumentProvider>(context,
                          listen: false)
                      .displayOptionalcompetencyPlaceofIssueName[index]
                      .isNotEmpty) {
                    if (_optionalIssuingValue[index].isEmpty) {
                      _optionalIssuingValue[index] =
                          Provider.of<ResumeDocumentProvider>(context,
                                  listen: false)
                              .displayOptionalcompetencyPlaceofIssueName[index];
                      _optionalIssuingAuthoritydropdownBloc[index]
                          .setdropdownvalue(_optionalIssuingValue[index]);
                      _optionalIssuingAuthoritydropdownBloc[index]
                          .eventDropdownSink
                          .add(DropdownAction.Update);
                    }
                  } else {
                    _optionalIssuingValue[index] =
                        _optionalissuingAuthorityBloc[index].countryname[0];
                    _optionalIssuingAuthoritydropdownBloc[index]
                        .setdropdownvalue(_optionalIssuingValue[index]);
                    _optionalIssuingAuthoritydropdownBloc[index]
                        .eventDropdownSink
                        .add(DropdownAction.Update);
                  }
                }
              }
              return StreamBuilder(
                initialData: false,
                stream: isMandatory
                    ? _mandatoryErrorCountryCodeBloc[index]
                        .stateResumeIssuingAuthorityStrean
                    : _optionalErrorCountryCodeBloc[index]
                        .stateResumeIssuingAuthorityStrean,
                builder: (context, errorsnapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.0,
                            color: checkColor(isMandatory, index,
                                _mandatoryErrorCountryCodeBloc)),
                        borderRadius: const BorderRadius.all(Radius.circular(
                                20.0) //                 <--- border radius here
                            ),
                      ),
                      child: StreamBuilder(
                        stream: _mandatoryIssuingAuthoritydropdownBloc[index]
                            .stateDropdownStrean,
                        builder: (context, dropdownsnapshot) {
                          return StreamBuilder(
                            stream: isMandatory
                                ? _showMandatoryIssuingDropDownBloc[index]
                                    .stateIndosNoStrean
                                : _showOptionalIssuingDropDownBloc[index]
                                    .stateIndosNoStrean,
                            initialData: false,
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  DrodpownContainer(
                                    title: isMandatory
                                        ? _mandatoryIssuingValue[index]
                                                .isNotEmpty
                                            ? _mandatoryIssuingValue[index]
                                            : 'Select Issuing Authority'
                                        : _optionalIssuingValue[index]
                                                .isNotEmpty
                                            ? _optionalIssuingValue[index]
                                            : 'Select Issuing Authority',
                                    searchHint: 'Search Issuing Authority',
                                    showDropDownBloc: isMandatory
                                        ? _showMandatoryIssuingDropDownBloc[
                                            index]
                                        : _showOptionalIssuingDropDownBloc[
                                            index],
                                    originalList: isMandatory
                                        ? _mandatoryissuingAuthorityBloc[index]
                                            .countryname
                                        : _optionalissuingAuthorityBloc[index]
                                            .countryname,
                                  ),
                                  ExpandedSection(
                                    expand: isMandatory
                                        ? _showMandatoryIssuingDropDownBloc[
                                                index]
                                            .isedited
                                        : _showOptionalIssuingDropDownBloc[
                                                index]
                                            .isedited,
                                    height: 100,
                                    child: MyScrollbar(
                                      builder: (context, scrollController2) =>
                                          ListView.builder(
                                              padding: const EdgeInsets.all(0),
                                              controller: scrollController2,
                                              shrinkWrap: true,
                                              itemCount: Provider.of<SearchChangeProvider>(
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
                                                      : isMandatory
                                                          ? _mandatoryissuingAuthorityBloc[index]
                                                              .countryname
                                                              .length
                                                          : _optionalissuingAuthorityBloc[index]
                                                              .countryname
                                                              .length,
                                              itemBuilder:
                                                  (context, listindex) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                                                  listen: false)
                                                              .noDataFound) {
                                                            if (isMandatory) {
                                                              _showMandatoryIssuingDropDownBloc[
                                                                      index]
                                                                  .eventIndosNoSink
                                                                  .add(IndosNoAction
                                                                      .False);
                                                              checkMandatoryIssuingAuthority(
                                                                  index,
                                                                  listindex);
                                                            } else {
                                                              _showOptionalIssuingDropDownBloc[
                                                                      index]
                                                                  .eventIndosNoSink
                                                                  .add(IndosNoAction
                                                                      .False);
                                                              changeOptionalIssuingAuthority(
                                                                  index,
                                                                  listindex);
                                                            }
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Text(Provider.of<
                                                                          SearchChangeProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .noDataFound
                                                              ? 'No Data Found'
                                                              : Provider.of<SearchChangeProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .searchList
                                                                      .isNotEmpty
                                                                  ? Provider.of<
                                                                              SearchChangeProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .searchList[listindex]
                                                                  : isMandatory
                                                                      ? _mandatoryissuingAuthorityBloc[index].countryname[listindex]
                                                                      : _optionalissuingAuthorityBloc[index].countryname[listindex]),
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

  checkColor(isMandatory, index, bloc) {
    bool result = false;

    result = bloc[index].showtext;

    return result ? Colors.red : Colors.grey;
  }

  _displayerrortext(int index, bool isMandatory) {
    return StreamBuilder(
      initialData: false,
      stream: isMandatory
          ? _mandatoryErrorCountryCodeBloc[index]
              .stateResumeIssuingAuthorityStrean
          : _optionalErrorCountryCodeBloc[index]
              .stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && isMandatory
            ? _mandatoryErrorCountryCodeBloc[index].showtext
            : _optionalErrorCountryCodeBloc[index].showtext) {
          return Visibility(
            visible: isMandatory
                ? _mandatoryErrorCountryCodeBloc[index].showtext
                : _optionalErrorCountryCodeBloc[index].showtext,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isMandatory
                      ? _mandatoryErrorCountryCodeBloc[index].showAlternateText
                          ? 'Please select another country'
                          : 'Please select the issuing authority'
                      : _optionalErrorCountryCodeBloc[index].showAlternateText
                          ? 'Please select another country'
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

  void getdata() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditCompetencyDocuments(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    addDefaultCompetencyMandatoryData();
    addDefaultCompetencyOptionalData();

    asyncProvider.changeAsynccall();
  }

  void callPostCompetencyRecords() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditCompetencyDocuments(), context);
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    ResumeEditCompetencyDocUpdateProvider competecyProvider =
        Provider.of<ResumeEditCompetencyDocUpdateProvider>(context,
            listen: false);
    List<PostCompetencyData> postMandatoryCompetencyData = [],
        postOptionalCompetencyData = [];

    postMandatoryCompetencyData = callPostMandatoryRecords();

    postOptionalCompetencyData = callPostOptionalRecords();

    if (await competecyProvider.callpostResumeCompetencyDocapi(
        postMandatoryCompetencyData, postOptionalCompetencyData, header)) {
      asyncProvider.changeAsynccall();
      Provider.of<ResumeEditCompetencyRecordDeleteProvider>(context,
              listen: false)
          .isMandatoryDelete = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('RecordAdded', 'Record has been added successfully');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DocumentScreen()));
    } else {
      asyncProvider.changeAsynccall();
      displaysnackbar('Something went wrong');
    }
  }

  bool checkError() {
    bool data = false;
    data = checkMandatoryDocAvailability();
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyMandatoryLength;
        i++) {
      if (checkMandatoryIssuingAuthorities(i)) {
        data = true;
      }
    }
    print('mandate');
    print(data);
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyMandatoryLength;
        i++) {
      if (checkCompetencyValidDates(i, true)) {
        data = true;
      }
      if (_mandatoryDocValue[i].isEmpty) {
        _mandatoryErrorComptencyDocName[i]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        data = true;
      } else {
        if (_mandatoryDocValue[i].isEmpty) {
          _mandatoryErrorComptencyDocName[i]
              .eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.True);
          data = true;
        }
      }

      if (_mandatoryIssuingValue[i].isEmpty) {
        _mandatoryErrorCountryCodeBloc[i]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        data = true;
      } else {
        if (_mandatoryIssuingValue[i].isEmpty) {
          _mandatoryErrorCountryCodeBloc[i]
              .eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.True);
          data = true;
        }
      }
    }

    print('data is');
    print(data);
    return data;
  }

  bool checkOptionalData() {
    bool data = false;
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyOptionalLength;
        i++) {
      if (checkCompetencyValidDates(i, false)) {
        data = true;
      }
      if (_optionalDocValue[i].isEmpty) {
        _optionalErrorComptencyDocName[i]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        data = true;
      } else if (_optionalDocValue[i].isEmpty) {
        _optionalErrorComptencyDocName[i]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        data = true;
      } else {}

      if (_optionalIssuingValue[i].isEmpty) {
        _optionalErrorCountryCodeBloc[i]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        data = true;
      } else {
        if (_optionalIssuingValue[i].isEmpty) {
          _optionalErrorCountryCodeBloc[i]
              .eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.True);
          data = true;
        }
      }
    }

    return data;
  }

  bool checkCompetencyValidDates(int i, bool isMandatory) {
    bool data = false;
    List<bool> competencyValid = [];
    for (int k = 0; k < 3; k++) {
      competencyValid.add(isMandatory
          ? _mandatoryValidTillOptionsCompetencyBloc[i][k].radioValue
          : _optionalValidTillOptionsCompetencyBloc[i][k].radioValue);
    }

    if (!competencyValid.contains(true)) {
      isMandatory
          ? _mandatoryCompetencyValidDateErrorBloc[i]
              .eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.True)
          : _optionalCompetencyValidDateErrorBloc[i]
              .eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.True);
      data = true;
    }
    return data;
  }

  _displayExtensions(bool isMandatory) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: isMandatory ? _mandatoryformKey : _optionalformKey,
            child: Column(
              children: [
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: _displayCardHeader(
                        isMandatory ? 'Mandatory' : 'Optional'),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isMandatory
                          ? _displayCompetencyCard(isMandatory)
                          : _displayCompetencyCard(isMandatory),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _displayCardHeader(String s) {
    return Text(s,
        style: TextStyle(
            color: kBluePrimaryColor,
            fontSize: checkDeviceSize(context)
                ? MediaQuery.of(context).size.width * 0.05
                : MediaQuery.of(context).size.width * 0.045,
            fontWeight: FontWeight.bold));
  }

  _buildDocNameDropdown(int index, bool isMandatory) {
    return Stack(
      children: [
        StreamBuilder(
          initialData: false,
          stream: isMandatory
              ? _mandatoryErrorComptencyDocName[index]
                  .stateResumeIssuingAuthorityStrean
              : _optionalErrorComptencyDocName[index]
                  .stateResumeIssuingAuthorityStrean,
          builder: (context, errorsnapshot) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.0,
                      color: checkColor(
                          isMandatory, index, _mandatoryErrorComptencyDocName)),
                  borderRadius: const BorderRadius.all(Radius.circular(
                          20.0) //                 <--- border radius here
                      ),
                ),
                child: StreamBuilder(
                  stream: isMandatory
                      ? _mandatoryDocDropdownBloc[index].stateDropdownStrean
                      : _optionalDocDropdownBloc[index].stateDropdownStrean,
                  builder: (context, dropdownsnapshot) {
                    return StreamBuilder(
                      stream: isMandatory
                          ? _showMandatoryDropDownBloc[index].stateIndosNoStrean
                          : _showOptionalDropDownBloc[index].stateIndosNoStrean,
                      initialData: false,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            DrodpownContainer(
                              title: isMandatory
                                  ? _mandatoryDocValue[index].isNotEmpty
                                      ? _mandatoryDocValue[index]
                                      : 'Select Competency Document'
                                  : _optionalDocValue[index].isNotEmpty
                                      ? _optionalDocValue[index]
                                      : 'Select Competency Document',
                              searchHint: 'Search Document',
                              showDropDownBloc: isMandatory
                                  ? _showMandatoryDropDownBloc[index]
                                  : _showOptionalDropDownBloc[index],
                              originalList: isMandatory
                                  ? Provider.of<ResumeDocumentProvider>(context,
                                          listen: false)
                                      .competencyMandatoryDocName
                                  : Provider.of<ResumeDocumentProvider>(context,
                                          listen: false)
                                      .competencyOptionalDocName,
                            ),
                            ExpandedSection(
                              expand: isMandatory
                                  ? _showMandatoryDropDownBloc[index].isedited
                                  : _showOptionalDropDownBloc[index].isedited,
                              height: 100,
                              child: MyScrollbar(
                                builder: (context, scrollController2) =>
                                    ListView.builder(
                                        padding: const EdgeInsets.all(0),
                                        controller: scrollController2,
                                        shrinkWrap: true,
                                        itemCount: Provider.of<SearchChangeProvider>(context, listen: false)
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
                                                : isMandatory
                                                    ? Provider.of<ResumeDocumentProvider>(
                                                            context,
                                                            listen: false)
                                                        .competencyMandatoryDocName
                                                        .length
                                                    : Provider.of<ResumeDocumentProvider>(
                                                            context,
                                                            listen: false)
                                                        .competencyOptionalDocName
                                                        .length,
                                        itemBuilder: (context, listindex) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                                      if (isMandatory) {
                                                        changeMandatoryValue(
                                                            index, listindex);
                                                      } else {
                                                        changeOptionalValue(
                                                            index, listindex);
                                                      }
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16),
                                                    child: Text(Provider.of<SearchChangeProvider>(context,
                                                                listen: false)
                                                            .noDataFound
                                                        ? 'No Data Found'
                                                        : Provider.of<SearchChangeProvider>(context,
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
                                                            : isMandatory
                                                                ? Provider.of<ResumeDocumentProvider>(
                                                                        context,
                                                                        listen: false)
                                                                    .competencyMandatoryDocName[listindex]
                                                                : Provider.of<ResumeDocumentProvider>(context, listen: false).competencyOptionalDocName[listindex]),
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
            );
          },
        ),
        TextBoxLabel('Select Competency')
      ],
    );
  }

  changeMandatoryValue(index, listindex) {
    String tempValue = "";
    tempValue = Provider.of<SearchChangeProvider>(context, listen: false)
            .searchList
            .isNotEmpty
        ? Provider.of<SearchChangeProvider>(context, listen: false)
            .searchList[listindex]
        : Provider.of<ResumeDocumentProvider>(context, listen: false)
            .competencyMandatoryDocName[listindex];
    _showMandatoryDropDownBloc[index].eventIndosNoSink.add(IndosNoAction.False);
    int count = 0;
    for (int i = 0; i < _mandatoryDocValue.length; i++) {
      if (_mandatoryDocValue[i] == tempValue && i != index) {
        count++;
      }
    }
    if (count == 3) {
      _mandatoryErrorComptencyDocName[index]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
      _mandatoryErrorComptencyDocName[index].showAlternateText = true;
    } else {
      _mandatoryErrorComptencyDocName[index]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.False);
      _mandatoryDocValue[index] = tempValue;
      _mandatoryDocDropdownBloc[index].setdropdownvalue(tempValue);
      _mandatoryDocDropdownBloc[index]
          .eventDropdownSink
          .add(DropdownAction.Update);
    }

    Provider.of<SearchChangeProvider>(context, listen: false).searchKeyword =
        "";
    Provider.of<SearchChangeProvider>(context, listen: false).searchList = [];
  }

  changeOptionalValue(index, listindex) {
    String tempValue = "";
    tempValue = Provider.of<SearchChangeProvider>(context, listen: false)
            .searchList
            .isNotEmpty
        ? Provider.of<SearchChangeProvider>(context, listen: false)
            .searchList[listindex]
        : Provider.of<ResumeDocumentProvider>(context, listen: false)
            .competencyOptionalDocName[listindex];
    _showOptionalDropDownBloc[index].eventIndosNoSink.add(IndosNoAction.False);
    int count = 0;
    for (int i = 0; i < _optionalDocValue.length; i++) {
      if (_optionalDocValue[i] == tempValue && i != index) {
        count++;
      }
    }
    if (count == 3) {
      _optionalErrorComptencyDocName[index]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
      _optionalErrorComptencyDocName[index].showAlternateText = true;
    } else {
      _optionalDocValue[index] = tempValue;
      _optionalDocDropdownBloc[index].setdropdownvalue(tempValue);
      _optionalDocDropdownBloc[index]
          .eventDropdownSink
          .add(DropdownAction.Update);
      _optionalErrorComptencyDocName[index]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.False);
    }
    Provider.of<SearchChangeProvider>(context, listen: false).searchKeyword =
        "";
    Provider.of<SearchChangeProvider>(context, listen: false).searchList = [];
  }

  _buildAddCompetencyOption(bool isMandatory) {
    return InkWell(
      onTap: () {
        mandatoryCall = isMandatory;
        cleardata();

        ResumeDocumentProvider documentProvider =
            Provider.of<ResumeDocumentProvider>(context, listen: false);
        setState(() {
          isMandatory
              ? documentProvider.increaseMandatoryCompetencylength()
              : documentProvider.increaseOptionalCompetencylength();

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
            Text(
                isMandatory
                    ? 'Add Mandatory Competency Document'
                    : 'Add Optional Competency Document',
                style: TextStyle(
                    color: kBluePrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.032)),
          ],
        ),
      ),
    );
  }

  _buildDocErrorDropdown(int index, bool isMandatory) {
    return StreamBuilder(
      stream: isMandatory
          ? _mandatoryErrorComptencyDocName[index]
              .stateResumeIssuingAuthorityStrean
          : _optionalErrorComptencyDocName[index]
              .stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (isMandatory
            ? _mandatoryErrorComptencyDocName[index].showtext
            : _optionalErrorComptencyDocName[index].showtext) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              isMandatory
                  ? _mandatoryErrorComptencyDocName[index].showAlternateText
                      ? 'You can select upto 3 COC'
                      : 'Please select competency document'
                  : 'Please select competency document',
              style: TextStyle(color: Colors.red[500]),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void checkMandatoryValidTill(int radioindex, int innerindex) {
    
      if (radioindex == 2) {
        _mandatoryDisplayCompetencyValidDate[innerindex]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
        _mandatoryDisplayCompetencyValidDate[innerindex].radioValue = true;
      } else {
        _mandatoryDisplayCompetencyValidDate[innerindex]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _mandatoryDisplayCompetencyValidDate[innerindex].radioValue = false;
      }
      _mandatoryValidTillOptionsCompetencyBloc[innerindex][radioindex]
          .eventRadioButtonSink
          .add(RadioButtonAction.True);
      _mandatoryValidTillOptionsCompetencyBloc[innerindex][radioindex]
          .radioValue = true;
      _mandatoryCompetencyValidDateErrorBloc[innerindex]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.False);
      for (int i = 0;
          i <
              Provider.of<GetValidTypeProvider>(context, listen: false)
                  .displayText
                  .length;
          i++) {
        if (i != radioindex) {
          _mandatoryValidTillOptionsCompetencyBloc[innerindex][i]
              .eventRadioButtonSink
              .add(RadioButtonAction.False);
          _mandatoryValidTillOptionsCompetencyBloc[innerindex][i].radioValue =
              false;
        }
      }
    
  }

  void checkOptionalValidTill(int radioindex, int innerindex) {
    if (radioindex == 2) {
      _optionalDisplayCompetencyValidDate[innerindex]
          .eventRadioButtonSink
          .add(RadioButtonAction.True);
      _optionalDisplayCompetencyValidDate[innerindex].radioValue = true;
    } else {
      _optionalExpiryDateController[innerindex].clear();
      _optionalDisplayCompetencyValidDate[innerindex]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
      _optionalDisplayCompetencyValidDate[innerindex].radioValue = false;
    }
    _optionalValidTillOptionsCompetencyBloc[innerindex][radioindex]
        .eventRadioButtonSink
        .add(RadioButtonAction.True);
    _optionalValidTillOptionsCompetencyBloc[innerindex][radioindex].radioValue =
        true;
    _optionalCompetencyValidDateErrorBloc[innerindex]
        .eventResumeIssuingAuthoritySink
        .add(ResumeErrorIssuingAuthorityAction.False);
    for (int i = 0;
        i <
            Provider.of<GetValidTypeProvider>(context, listen: false)
                .displayText
                .length;
        i++) {
      if (i != radioindex) {
        _optionalValidTillOptionsCompetencyBloc[innerindex][i]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _optionalValidTillOptionsCompetencyBloc[innerindex][i].radioValue =
            false;
      }
    }
  }

  _buildErrorDocDisplay() {
    return StreamBuilder(
      stream: _selectMandatoryDocError.stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && _selectMandatoryDocError.showtext) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              'Please select mandatory documents.',
              style: TextStyle(color: Colors.red[500]),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void cleardata() {
    _mandatoryTempCompetencyDocName = [];
    _mandatoryTempCertificateNo = [];
    _mandatoryTempIssuingValue = [];
    _mandatoryTempIssueDate = [];
    _mandatoryTempRadioValue = [];
    _mandatoryTempValidTillText = [];

    _optionalTempCompetencyDocName = [];
    _optionalTempCertificateNo = [];
    _optionalTempIssuingValue = [];
    _optionalTempIssueDate = [];
    _optionalTempRadioValue = [];
    _optionalTempValidTillText = [];
    if (mandatoryCall) {
      for (int i = 0;
          i <
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .competencyMandatoryLength;
          i++) {
        _mandatoryTempCompetencyDocName.add(_mandatoryDocValue[i]);
        _mandatoryTempCertificateNo
            .add(_mandatorySeamenBookNoController[i].text);
        _mandatoryTempIssuingValue.add(_mandatoryIssuingValue[i]);
        _mandatoryTempIssueDate.add(_mandatoryIssueDateController[i].text);
        _mandatoryTempValidTillText.add(_mandatoryExpiryDateController[i].text);
      }

      _mandatoryDocValue.clear();
      _mandatorySeamenBookNoController.clear();
      _mandatoryIssuingValue.clear();
      _mandatoryIssueDateController.clear();
      _mandatoryExpiryDateController.clear();
    } else {
      for (int i = 0;
          i <
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .competencyOptionalLength;
          i++) {
        _optionalTempCompetencyDocName.add(_optionalDocValue[i]);
        _optionalTempCertificateNo.add(_optionalSeamenBookNoController[i].text);
        _optionalTempIssuingValue.add(_optionalIssuingValue[i]);
        _optionalTempIssueDate.add(_optionalIssueDateController[i].text);
        _optionalTempValidTillText.add(_optionalExpiryDateController[i].text);
      }

      _optionalDocValue.clear();
      _optionalSeamenBookNoController.clear();
      _optionalIssuingValue.clear();
      _optionalIssueDateController.clear();
      _optionalExpiryDateController.clear();
    }
  }

  void _assignTempData(bool isMandatory) {
    if (isMandatory) {
      print('Adding');
      print(_mandatoryTempCompetencyDocName.length);
      print('================');
      for (int i = 0; i < _mandatoryTempCompetencyDocName.length; i++) {
        _mandatoryDocValue[i] = _mandatoryTempCompetencyDocName[i];
        _mandatorySeamenBookNoController[i].text =
            _mandatoryTempCertificateNo[i];
        _mandatoryIssuingValue[i] = _mandatoryTempIssuingValue[i];
        _mandatoryIssueDateController[i].text = _mandatoryTempIssueDate[i];
        _mandatoryExpiryDateController[i].text = _mandatoryTempValidTillText[i];
      }

      _mandatoryTempCompetencyDocName.clear();
      _mandatoryTempCertificateNo.clear();
      _mandatoryTempIssuingValue.clear();
      _mandatoryTempIssueDate.clear();
      _mandatoryTempValidTillText.clear();
    } else {
      for (int i = 0;
          i <
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .competencyOptionalLength;
          i++) {
        _optionalDocValue[i] = _optionalTempCompetencyDocName[i];
        _optionalSeamenBookNoController[i].text = _optionalTempCertificateNo[i];
        _optionalIssuingValue[i] = _optionalTempIssuingValue[i];
        _optionalIssueDateController[i].text = _optionalTempIssueDate[i];
        _optionalExpiryDateController[i].text = _optionalTempValidTillText[i];
      }

      _optionalTempCompetencyDocName.clear();
      _optionalTempCertificateNo.clear();
      _optionalTempIssuingValue.clear();
      _optionalTempIssueDate.clear();
      _optionalTempValidTillText.clear();
    }
  }

  void checkMandatoryIssuingAuthority(index, listindex) {
    bool isValid = false;
    String tempValue = "";
    tempValue = Provider.of<SearchChangeProvider>(context, listen: false)
            .searchList
            .isNotEmpty
        ? Provider.of<SearchChangeProvider>(context, listen: false)
            .searchList[listindex]
        : _mandatoryissuingAuthorityBloc[index].countryname[listindex];

    if (!isValid) {
      _mandatoryIssuingValue[index] = tempValue;
      _mandatoryIssuingAuthoritydropdownBloc[index].setdropdownvalue(tempValue);
      _mandatoryIssuingAuthoritydropdownBloc[index]
          .eventDropdownSink
          .add(DropdownAction.Update);
      _mandatoryErrorCountryCodeBloc[index]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.False);
    }
  }

  void changeOptionalIssuingAuthority(index, listindex) {
    bool isValid = false;
    String tempValue = "";
    tempValue = Provider.of<SearchChangeProvider>(context, listen: false)
            .searchList
            .isNotEmpty
        ? Provider.of<SearchChangeProvider>(context, listen: false)
            .searchList[listindex]
        : _optionalissuingAuthorityBloc[index].countryname[listindex];
    for (int i = 0; i < _optionalDocValue.length - 1; i++) {
      if ((_optionalDocValue[i] == _optionalDocValue[index]) &&
          _optionalIssuingValue[i] == tempValue) {
        _optionalErrorCountryCodeBloc[index]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        _optionalErrorCountryCodeBloc[index].showAlternateText = true;
        isValid = true;
      }
    }
    if (!isValid) {
      _optionalIssuingValue[index] = tempValue;
      _optionalIssuingAuthoritydropdownBloc[index].setdropdownvalue(tempValue);
      _optionalIssuingAuthoritydropdownBloc[index]
          .eventDropdownSink
          .add(DropdownAction.Update);
      _optionalErrorCountryCodeBloc[index]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.False);
    }
  }

  void checkMandatoryValidTillData(int innerindex) {
    bool value = false;
    for (int i = 0;
        i < _mandatoryValidTillOptionsCompetencyBloc[innerindex].length;
        i++) {
      if (_mandatoryValidTillOptionsCompetencyBloc[innerindex][i].radioValue) {
        value = true;
      }
    }
    if (innerindex <
        Provider.of<ResumeDocumentProvider>(context, listen: false)
            .competencyExpiryDate
            .length) {
      if (!value &&
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .competencyExpiryDate
              .isNotEmpty) {
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyMandatoryValidTillTypeId[innerindex] ==
            lifetimeValidType) {
          _mandatoryValidTillOptionsCompetencyBloc[innerindex][0]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _mandatoryValidTillOptionsCompetencyBloc[innerindex][0].radioValue =
              true;
        } else {
          _mandatoryValidTillOptionsCompetencyBloc[innerindex][0].radioValue =
              false;
        }
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyMandatoryValidTillTypeId[innerindex] ==
            unlimitedValidType) {
          _mandatoryValidTillOptionsCompetencyBloc[innerindex][1]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _mandatoryValidTillOptionsCompetencyBloc[innerindex][1].radioValue =
              true;
        } else {
          _mandatoryValidTillOptionsCompetencyBloc[innerindex][1].radioValue =
              false;
        }
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyMandatoryValidTillTypeId[innerindex] ==
            dateValidType) {
          _mandatoryValidTillOptionsCompetencyBloc[innerindex][2]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _mandatoryValidTillOptionsCompetencyBloc[innerindex][2].radioValue =
              true;
          _mandatoryDisplayCompetencyValidDate[innerindex]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _mandatoryDisplayCompetencyValidDate[innerindex].radioValue = true;
          _mandatoryExpiryDateController[innerindex].text =
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .competencyExpiryDate[innerindex];
        } else {
          _mandatoryValidTillOptionsCompetencyBloc[innerindex][2].radioValue =
              false;
        }
      }
    }
  }

  void checkOptionalValidTillData(int innerindex) {
    bool value = false;
    for (int i = 0;
        i < _optionalValidTillOptionsCompetencyBloc[innerindex].length;
        i++) {
      if (_optionalValidTillOptionsCompetencyBloc[innerindex][i].radioValue) {
        value = true;
      }
    }
    if (innerindex <
        Provider.of<ResumeDocumentProvider>(context, listen: false)
            .displayOptionalcompetencyExpiryDate
            .length) {
      if (!value &&
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .displayOptionalcompetencyExpiryDate
              .isNotEmpty) {
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyOptionalValidTillTypeId[innerindex] ==
            lifetimeValidType) {
          _optionalValidTillOptionsCompetencyBloc[innerindex][0]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _optionalValidTillOptionsCompetencyBloc[innerindex][0].radioValue =
              true;
        } else {
          _optionalValidTillOptionsCompetencyBloc[innerindex][0].radioValue =
              false;
        }
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyOptionalValidTillTypeId[innerindex] ==
            unlimitedValidType) {
          _optionalValidTillOptionsCompetencyBloc[innerindex][1]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _optionalValidTillOptionsCompetencyBloc[innerindex][1].radioValue =
              true;
        } else {
          _optionalValidTillOptionsCompetencyBloc[innerindex][1].radioValue =
              false;
        }
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyOptionalValidTillTypeId[innerindex] ==
            dateValidType) {
          _optionalValidTillOptionsCompetencyBloc[innerindex][2]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _optionalValidTillOptionsCompetencyBloc[innerindex][2].radioValue =
              true;
          _optionalDisplayCompetencyValidDate[innerindex]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _optionalDisplayCompetencyValidDate[innerindex].radioValue = true;
          _optionalExpiryDateController[innerindex].text =
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .displayOptionalcompetencyExpiryDate[innerindex];
        } else {
          _optionalValidTillOptionsCompetencyBloc[innerindex][2].radioValue =
              false;
        }
      }
    }
  }

  List<PostCompetencyData> callPostMandatoryRecords() {
    List<PostCompetencyData> postMandatoryCompetencyData = [];
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyMandatoryLength;
        i++) {
      String expiry = "";
      for (int k = 0; k < 3; k++) {
        if (_mandatoryValidTillOptionsCompetencyBloc[i][k].radioValue) {
          expiry = Provider.of<GetValidTypeProvider>(context, listen: false)
              .validTypeId[k];
        }
      }
      String id = "";
      if (i <
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .competencyUserId
              .length) {
        print('Getting id');
        id = Provider.of<ResumeDocumentProvider>(context, listen: false)
            .competencyUserId[i];
      } else {
        id = "";
      }
      postMandatoryCompetencyData.add(PostCompetencyData(
        certificateNo: _mandatorySeamenBookNoController[i].text,
        issuingAuthorityId: _mandatoryissuingAuthorityBloc[i].countrycode[
            _mandatoryissuingAuthorityBloc[i]
                .countryname
                .indexOf(_mandatoryIssuingValue[i])],
        id: id,
        rankDocumentId:
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                    .competencyMandatoryDocId[
                Provider.of<ResumeDocumentProvider>(context, listen: false)
                    .competencyMandatoryDocName
                    .indexOf(_mandatoryDocValue[i])],
        issueDate: _mandatoryIssueDateController[i].text,
        validTillDate: _mandatoryExpiryDateController[i].text,
        validTillType: expiry,
      ));
    }

    for (int i = 0; i < postMandatoryCompetencyData.length; i++) {
      print(postMandatoryCompetencyData[i].rankDocumentId);
    }

    return postMandatoryCompetencyData;
  }

  List<PostCompetencyData> callPostOptionalRecords() {
    List<PostCompetencyData> postOptionalCompetencyData = [];
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyOptionalLength;
        i++) {
      String expiry = "";
      for (int k = 0; k < 3; k++) {
        if (_optionalValidTillOptionsCompetencyBloc[i][k].radioValue) {
          expiry = Provider.of<GetValidTypeProvider>(context, listen: false)
              .validTypeId[k];
        }
      }
      String id = "";
      if (i <
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .competencyOptionalUserId
              .length) {
        id = Provider.of<ResumeDocumentProvider>(context, listen: false)
            .competencyOptionalUserId[i];
      } else {
        id = "";
      }
      postOptionalCompetencyData.add(PostCompetencyData(
        certificateNo: _optionalSeamenBookNoController[i].text,
        issuingAuthorityId: _optionalissuingAuthorityBloc[i].countrycode[
            _optionalissuingAuthorityBloc[i]
                .countryname
                .indexOf(_optionalIssuingValue[i])],
        id: id,
        rankDocumentId:
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                    .competencyOptionalDocId[
                Provider.of<ResumeDocumentProvider>(context, listen: false)
                    .competencyOptionalDocName
                    .indexOf(_optionalDocValue[i])],
        issueDate: _optionalIssueDateController[i].text,
        validTillDate: _optionalExpiryDateController[i].text,
        validTillType: expiry,
      ));
    }

    return postOptionalCompetencyData;
  }

  bool checkMandatoryDocAvailability() {
    bool data = false;
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyMandatoryDocName
                .length;
        i++) {
      if (!_mandatoryDocValue.contains(
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .competencyMandatoryDocName[i])) {
        data = true;
        _selectMandatoryDocError.eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        _selectMandatoryDocError.showtext = true;
      }
    }
    if (Provider.of<ResumeDocumentProvider>(context, listen: false)
            .competencyMandatoryLength ==
        0) {
      _selectMandatoryDocError.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
      _selectMandatoryDocError.showtext = true;
      data = true;
    } else if (!data) {
      _selectMandatoryDocError.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.False);
      _selectMandatoryDocError.showtext = false;
    }

    return data;
  }

  bool checkMandatoryIssuingAuthorities(int index) {
    bool isValid = false;
    for (int i = 0; i < _mandatoryDocValue.length; i++) {
      if (_mandatoryDocValue[index].isEmpty) {
        _mandatoryErrorComptencyDocName[index]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        _mandatoryErrorComptencyDocName[index].showtext = true;
      } else {
        _mandatoryErrorComptencyDocName[index]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.False);
        _mandatoryErrorComptencyDocName[index].showtext = false;
        print('===========================');
        print('Index');
        print(index);
        print(Provider.of<ResumeDocumentProvider>(context, listen: false)
            .competencyMandatoryDocName);
        print(_mandatoryDocValue[i]);
        print(i);

        if ((Provider.of<ResumeDocumentProvider>(context, listen: false)
                        .competencyMandatoryDocId[
                    Provider.of<ResumeDocumentProvider>(context, listen: false)
                        .competencyMandatoryDocName
                        .indexOf(_mandatoryDocValue[i])] ==
                Provider.of<ResumeDocumentProvider>(context, listen: false)
                        .competencyMandatoryDocId[
                    Provider.of<ResumeDocumentProvider>(context, listen: false)
                        .competencyMandatoryDocName
                        .indexOf(_mandatoryDocValue[index])]) &&
            _mandatoryIssuingValue[index] == _mandatoryIssuingValue[i] &&
            i != index) {
          print(index);
          print("lets check");
          print(i);
          _mandatoryErrorCountryCodeBloc[index]
              .eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.True);
          _mandatoryErrorCountryCodeBloc[index].showAlternateText = true;
          isValid = true;
        } else {
          _mandatoryErrorCountryCodeBloc[index]
              .eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.False);
          _mandatoryErrorCountryCodeBloc[index].showAlternateText = false;
        }
      }
    }
    return isValid;
  }

  void addDefaultCompetencyMandatoryData() {
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyMandatoryLength;
        i++) {
      _mandatoryissuingAuthorityBloc.add(ResumeIssuingAuthorityBloc());
      _mandatoryErrorCountryCodeBloc.add(ResumeErrorIssuingAuthorityBloc());
      _mandatoryIssuingAuthoritydropdownBloc.add(DropdownBloc());
      _mandatoryErrorComptencyDocName.add(ResumeErrorIssuingAuthorityBloc());
      _mandatoryDocDropdownBloc.add(DropdownBloc());
      _mandatoryShowValidTillDate.add(RadioButtonBloc());
      _showMandatoryDropDownBloc.add(IndosNoBloc());
      _showMandatoryIssuingDropDownBloc.add(IndosNoBloc());
      _mandatoryDocValue.add("");
      _mandatoryIssuingValue.add("");
      _mandatoryissuingAuthorityBloc[i].header = header;
      _mandatoryissuingAuthorityBloc[i]
          .eventResumeIssuingAuthoritySink
          .add(ResumeIssuingAuthorityAction.Post);
      _mandatoryExpiryDateController.add(TextEditingController());
      _mandatoryDisplayCompetencyValidDate.add(RadioButtonBloc());
      _mandatoryIssueDateController.add(TextEditingController());
      _mandatorySeamenBookNoController.add(TextEditingController());
      _mandatoryCompetencyValidDateErrorBloc
          .add(ResumeErrorIssuingAuthorityBloc());
      List<RadioButtonBloc> tempValidTillDatebloc = [];
      for (int k = 0; k < 3; k++) {
        tempValidTillDatebloc.add(RadioButtonBloc());
      }
      _mandatoryValidTillOptionsCompetencyBloc.add(tempValidTillDatebloc);
    }

    if (_mandatoryTempCompetencyDocName.isNotEmpty) {
      _assignTempData(true);
    }
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyDocName
                .length;
        i++) {
      _mandatorySeamenBookNoController[i].text =
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .competencyCertificateNo[i];
      _mandatoryIssueDateController[i].text =
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .competencyIssueDate[i];
      _mandatoryExpiryDateController[i].text =
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .competencyExpiryDate[i];
      _mandatoryDocValue[i] =
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .displaycompetencyDocName[i];
    }
  }

  void addDefaultCompetencyOptionalData() {
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyOptionalLength;
        i++) {
      _optionalissuingAuthorityBloc.add(ResumeIssuingAuthorityBloc());
      _optionalErrorCountryCodeBloc.add(ResumeErrorIssuingAuthorityBloc());
      _optionalIssuingAuthoritydropdownBloc.add(DropdownBloc());
      _optionalErrorComptencyDocName.add(ResumeErrorIssuingAuthorityBloc());
      _optionalDocDropdownBloc.add(DropdownBloc());
      _optionalShowValidTillDate.add(RadioButtonBloc());
      _showOptionalDropDownBloc.add(IndosNoBloc());
      _showOptionalIssuingDropDownBloc.add(IndosNoBloc());
      _optionalDocValue.add("");
      _optionalIssuingValue.add("");
      _optionalissuingAuthorityBloc[i].header = header;
      _optionalissuingAuthorityBloc[i]
          .eventResumeIssuingAuthoritySink
          .add(ResumeIssuingAuthorityAction.Post);
      _optionalExpiryDateController.add(TextEditingController());
      _optionalDisplayCompetencyValidDate.add(RadioButtonBloc());
      _optionalIssueDateController.add(TextEditingController());
      _optionalSeamenBookNoController.add(TextEditingController());
      _optionalCompetencyValidDateErrorBloc
          .add(ResumeErrorIssuingAuthorityBloc());
      List<RadioButtonBloc> tempValidTillDatebloc = [];
      for (int k = 0; k < 3; k++) {
        tempValidTillDatebloc.add(RadioButtonBloc());
      }
      _optionalValidTillOptionsCompetencyBloc.add(tempValidTillDatebloc);
    }

    if (_optionalTempCompetencyDocName.isNotEmpty) {
      _assignTempData(false);
    }

    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .displayOptionalcompetencyCertificateNo
                .length;
        i++) {
      _optionalSeamenBookNoController[i].text =
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .displayOptionalcompetencyCertificateNo[i];
      _optionalIssueDateController[i].text =
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .displayOptionalcompetencyIssueDate[i];
      _optionalExpiryDateController[i].text =
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .displayOptionalcompetencyExpiryDate[i];
      _optionalDocValue[i] =
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .displayOptionalcompetencyDocName[i];
    }
  }

  _displayCompetencyDeleteIcon(int index, bool isMandatory) {
    if (isMandatory) {
      if (Provider.of<ResumeDocumentProvider>(context)
                  .competencyMandatoryLength ==
              1 &&
          Provider.of<ResumeDocumentProvider>(context)
              .competencyCertificateNo
              .isEmpty) {
        return const SizedBox();
      } else {
        return InkWell(
          onTap: () => _showDeleteDialog(index, isMandatory),
          child: Icon(
            Icons.cancel,
            color: Colors.red[500],
          ),
        );
      }
    } else {
      if (Provider.of<ResumeDocumentProvider>(context)
                  .competencyOptionalLength ==
              1 &&
          Provider.of<ResumeDocumentProvider>(context)
              .displayOptionalcompetencyCertificateNo
              .isEmpty) {
        return const SizedBox();
      } else {
        return InkWell(
          onTap: () => _showDeleteDialog(index, isMandatory),
          child: Icon(
            Icons.cancel,
            color: Colors.red[500],
          ),
        );
      }
    }
  }

  _showDeleteDialog(int index, bool isMandatory) {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: const Text('Delete Competency Record',
              style: TextStyle(color: Colors.black)),
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
                        deleterecord(index, isMandatory);
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
                    style: bluebuttonStyle(),
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

  void deleterecord(int index, bool isMandatory) async {
    if (isMandatory) {
      if (index ==
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .competencyCertificateNo
              .length) {
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
            .competencyCertificateNo
            .isNotEmpty) {
          print('1');
          deleteEmptyRecord(isMandatory);
        }
      } else {
        if (index >
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyCertificateNo
                .length) {
          print('2');
          deleteEmptyRecord(isMandatory);
        } else {
          ResumeEditCompetencyRecordDeleteProvider cdcDeleteProvider =
              Provider.of<ResumeEditCompetencyRecordDeleteProvider>(context,
                  listen: false);
          AsyncCallProvider asyncProvider =
              Provider.of<AsyncCallProvider>(context, listen: false);
          if (!Provider.of<AsyncCallProvider>(context, listen: false)
              .isinasynccall) asyncProvider.changeAsynccall();
          if (await cdcDeleteProvider.callpostDeleteResumeCompetencyRecordapi(
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .competencyUserId[index],
              header)) {
            print('3');
            asyncProvider.changeAsynccall();
            delteIndexRecord(index);
            if (checkMandatoryDocAvailability()) {
              Provider.of<ResumeEditCompetencyRecordDeleteProvider>(context,
                      listen: false)
                  .isMandatoryDelete = true;
            }
            displaysnackbar('Record has been deleted successfully');
          } else {
            asyncProvider.changeAsynccall();
            displaysnackbar('Something went wrong');
          }
        }
      }
    } else {
      if (index ==
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .displayOptionalcompetencyCertificateNo
              .length) {
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
            .displayOptionalcompetencyCertificateNo
            .isNotEmpty) {
          deleteEmptyRecord(isMandatory);
        } else if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .competencyOptionalLength >
            1) {
          deleteindexEmptyRecord(isMandatory, index);
        }
      } else {
        if (index >
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .displayOptionalcompetencyCertificateNo
                .length) {
          if (index ==
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .competencyOptionalLength -
                  1) {
            deleteEmptyRecord(isMandatory);
          } else {
            deleteindexEmptyRecord(isMandatory, index);
          }
        } else if (index ==
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .displayOptionalcompetencyCertificateNo
                .length) {
          deleteindexEmptyRecord(isMandatory, index);
        } else {
          ResumeEditCompetencyRecordDeleteProvider cdcDeleteProvider =
              Provider.of<ResumeEditCompetencyRecordDeleteProvider>(context,
                  listen: false);
          AsyncCallProvider asyncProvider =
              Provider.of<AsyncCallProvider>(context, listen: false);
          if (!Provider.of<AsyncCallProvider>(context, listen: false)
              .isinasynccall) asyncProvider.changeAsynccall();
          if (await cdcDeleteProvider.callpostDeleteResumeCompetencyRecordapi(
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .competencyOptionalUserId[index],
              header)) {
            asyncProvider.changeAsynccall();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(
                'DeleteSuccesful', 'Record has been deleted successfully');
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const DocumentScreen()));
          } else {
            asyncProvider.changeAsynccall();
            displaysnackbar('Something went wrong');
          }
        }
      }
    }
    print('Length is');
    print(Provider.of<ResumeDocumentProvider>(context, listen: false)
        .competencyMandatoryLength);
  }

  void deleteEmptyRecord(bool isMandatory) {
    ResumeDocumentProvider documentProvider =
        Provider.of<ResumeDocumentProvider>(context, listen: false);
    isMandatory
        ? setState(() {
            documentProvider.decreaseMandatoryCompetencylength();
            _mandatoryCompetencyValidDateErrorBloc.removeLast();
            _mandatoryDisplayCompetencyValidDate.removeLast();
            _mandatoryDocDropdownBloc.removeLast();
            _mandatoryDocValue.removeLast();
            _mandatoryErrorComptencyDocName.removeLast();
            _mandatoryErrorCountryCodeBloc.removeLast();
            _mandatoryExpiryDateController.removeLast();
            _mandatoryIssueDateController.removeLast();
            _mandatoryIssuingAuthoritydropdownBloc.removeLast();
            _mandatoryIssuingValue.removeLast();
            _mandatorySeamenBookNoController.removeLast();
            _mandatoryShowValidTillDate.removeLast();
            _mandatoryissuingAuthorityBloc.removeLast();

            cleardata();

            getdata();
          })
        : setState(() {
            documentProvider.decreaseOptionalCompetencylength();
            _optionalCompetencyValidDateErrorBloc.removeLast();
            _optionalDisplayCompetencyValidDate.removeLast();
            _optionalDocDropdownBloc.removeLast();
            _optionalDocValue.removeLast();
            _optionalErrorComptencyDocName.removeLast();
            _optionalErrorCountryCodeBloc.removeLast();
            _optionalExpiryDateController.removeLast();
            _optionalIssueDateController.removeLast();
            _optionalIssuingAuthoritydropdownBloc.removeLast();
            _optionalIssuingValue.removeLast();
            _optionalSeamenBookNoController.removeLast();
            _optionalShowValidTillDate.removeLast();
            _optionalissuingAuthorityBloc.removeLast();
            cleardata();
            getdata();
          });
  }

  void delteIndexRecord(int index) {
    ResumeDocumentProvider documentProvider =
        Provider.of<ResumeDocumentProvider>(context, listen: false);
    setState(() {
      documentProvider.decreaseMandatoryIndexCompetencylength(index);
      _mandatoryCompetencyValidDateErrorBloc.removeAt(index);
      _mandatoryDisplayCompetencyValidDate.removeAt(index);
      _mandatoryDocDropdownBloc.removeAt(index);
      _mandatoryDocValue.removeAt(index);
      _mandatoryErrorComptencyDocName.removeAt(index);
      _mandatoryErrorCountryCodeBloc.removeAt(index);
      _mandatoryExpiryDateController.removeAt(index);
      _mandatoryIssueDateController.removeAt(index);
      _mandatoryIssuingAuthoritydropdownBloc.removeAt(index);
      _mandatoryIssuingValue.removeAt(index);
      _mandatorySeamenBookNoController.removeAt(index);
      _mandatoryShowValidTillDate.removeAt(index);
      _mandatoryissuingAuthorityBloc.removeAt(index);

      cleardata();

      getdata();
    });
  }

  void deleteindexEmptyRecord(bool isMandatory, int index) {
    ResumeDocumentProvider documentProvider =
        Provider.of<ResumeDocumentProvider>(context, listen: false);
    isMandatory
        ? setState(() {
            documentProvider.decreaseMandatoryCompetencylength();
            _mandatoryCompetencyValidDateErrorBloc.removeAt(index);
            _mandatoryDisplayCompetencyValidDate.removeAt(index);
            _mandatoryDocDropdownBloc.removeAt(index);
            _mandatoryDocValue.removeAt(index);
            _mandatoryErrorComptencyDocName.removeAt(index);
            _mandatoryErrorCountryCodeBloc.removeAt(index);
            _mandatoryExpiryDateController.removeAt(index);
            _mandatoryIssueDateController.removeAt(index);
            _mandatoryIssuingAuthoritydropdownBloc.removeAt(index);
            _mandatoryIssuingValue.removeAt(index);
            _mandatorySeamenBookNoController.removeAt(index);
            _mandatoryShowValidTillDate.removeAt(index);
            _mandatoryissuingAuthorityBloc.removeAt(index);

            cleardata();

            getdata();
          })
        : setState(() {
            documentProvider.decreaseOptionalCompetencylength();
            _optionalCompetencyValidDateErrorBloc.removeAt(index);
            _optionalDisplayCompetencyValidDate.removeAt(index);
            _optionalDocDropdownBloc.removeAt(index);
            _optionalDocValue.removeAt(index);
            _optionalErrorComptencyDocName.removeAt(index);
            _optionalErrorCountryCodeBloc.removeAt(index);
            _optionalExpiryDateController.removeAt(index);
            _optionalIssueDateController.removeAt(index);
            _optionalIssuingAuthoritydropdownBloc.removeAt(index);
            _optionalIssuingValue.removeAt(index);
            _optionalSeamenBookNoController.removeAt(index);
            _optionalShowValidTillDate.removeAt(index);
            _optionalissuingAuthorityBloc.removeAt(index);
            cleardata();
            getdata();
          });
  }
}
