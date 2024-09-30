// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:smartseaman/DropdownContainer.dart';
import '../../DropdownBloc.dart';
import '../../IssuingAuthorityErrorBloc.dart';
import '../../RadioButtonBloc.dart';
import '../../SearchTextProvider.dart';
import '../../SwitchButtonBloc.dart';
import '../../TextBoxLabel.dart';
import '../../asynccallprovider.dart';
import '../../constants.dart';
import '../GetValidTypeProvider.dart';
import '../Header.dart';
import '../IssuingAuhtorityBloc.dart';
import '../PersonalInformation/ExpandedAnimation.dart';
import '../PersonalInformation/IndosNoBloc.dart';
import '../PersonalInformation/Scrollbar.dart';
import '../ValidTillOptions.dart';
import 'DangerourCargo.dart';
import 'DangerousCargoProvider.dart';
import 'EditDangerousCargoProvider.dart';
import 'PostDangerousCargo.dart';

class EditDangerousCargo extends StatefulWidget {
  const EditDangerousCargo({Key? key}) : super(key: key);

  @override
  _EditDangerousCargoState createState() => _EditDangerousCargoState();
}

class _EditDangerousCargoState extends State<EditDangerousCargo> {
  final List<DropdownBloc> _dropdownBloc = [];
  final List<ResumeErrorIssuingAuthorityBloc> _errorIssuingAuthorityBloc = [],
      _dangerousValidDateErrorBloc = [],
      _dangerousIssueDateErrorBloc = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> issuingvalue = [];
  final List<TextEditingController> _expirycontroller = [],
      _issueController = [];
  DateTime selectedDate = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final List<bool> _hasDocument = [];
  final List<String> errors = [];
  final List<SwitchButtonBloc> _switchButtonBloc = [
    SwitchButtonBloc(),
    SwitchButtonBloc(),
    SwitchButtonBloc()
  ];
  final List<IndosNoBloc> _showIssuingAuthorityDropDownBloc = [
    IndosNoBloc(),
    IndosNoBloc(),
    IndosNoBloc(),
  ];
  final List<ResumeIssuingAuthorityBloc> _issuingBloc = [];
  var header;

  final List<List<RadioButtonBloc>> _validTillOptionsDangerousBloc = [];
  final List<RadioButtonBloc> _displayDangerousValidDate = [];
  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < _dropdownBloc.length; i++) {
      _dropdownBloc[i].dispose();
      _issuingBloc[i].dispose();
    }
    for (int i = 0; i < 3; i++) {
      for (int k = 0; k < 3; k++) {
        _validTillOptionsDangerousBloc[i][k].dispose();
      }
      _displayDangerousValidDate[i].dispose();
      _dangerousValidDateErrorBloc[i].dispose();
      _dangerousIssueDateErrorBloc[i].dispose();
      _showIssuingAuthorityDropDownBloc[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
              ResumeHeader('Dangerous Cargo Endorsements', 3, true, ""),
              const SizedBox(
                height: 20,
              ),
              _displayDangerousCargoCard(),
            ],
          ),
        ),
      ),
    );
  }

  _displayDangerousCargoCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: Provider.of<ResumeDangerousCargoProvider>(
                              context,
                              listen: false)
                          .document_name
                          .length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _displaySubHeading(
                                    Provider.of<ResumeDangerousCargoProvider>(
                                            context)
                                        .document_name[index]),
                                const SizedBox(
                                  width: 15,
                                ),
                                Provider.of<AsyncCallProvider>(context,
                                            listen: false)
                                        .isinasynccall
                                    ? const SizedBox()
                                    : _displayHasEndorsementSwitch(index),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            _displayCompetencyCardData(index),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          bool checkissuing = false;
                          for (int i = 0;
                              i <
                                  Provider.of<ResumeDangerousCargoProvider>(
                                          context,
                                          listen: false)
                                      .document_name
                                      .length;
                              i++) {
                            if (_hasDocument[i]) {
                              checkissuing = checkerror(i);
                              if (issuingvalue[i].isEmpty) {
                                print(i);
                                checkissuing = true;
                                _errorIssuingAuthorityBloc[i]
                                    .eventResumeIssuingAuthoritySink
                                    .add(
                                        ResumeErrorIssuingAuthorityAction.True);
                              }
                            }
                          }
                          print(checkissuing);
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (!checkissuing) callpostDangerousCargoFunction();
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _displaySubHeading(String category) {
    return Wrap(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.22,
          child: Text(
            category,
            style: TextStyle(
                color: kgreenPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.045),
          ),
        )
      ],
    );
  }

  _displayCompetencyCardData(int index) {
    return Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall
        ? const SizedBox()
        : StreamBuilder(
            initialData: Provider.of<ResumeDangerousCargoProvider>(context,
                    listen: false)
                .has_document[index],
            stream: _switchButtonBloc[index].stateSwitchButtonStrean,
            builder: (context, snapshot) {
              if (_switchButtonBloc[index].switchValue) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIssuingAuthority(index),
                    _buildIssuingAuthorityErrorText(index),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildExpiringDateTF(true, index),
                    _buildValidDateError(true, index),
                    _buildValidContainer(index),
                    _buildValidDateError(false, index),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          );
  }

  _buildValidContainer(int index) {
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
              _buildValidTillOptions(i, index),
          ],
        ),
        _buildExpiringDateTF(false, index),
      ],
    );
  }

  _buildValidTillOptions(int radioindex, int innerindex) {
    return StreamBuilder(
      stream: _validTillOptionsDangerousBloc[innerindex][radioindex]
          .stateRadioButtonStrean,
      builder: (context, snapshot) {
        if (checkRadioValue(innerindex)) {
          checkInitialData(
              _validTillOptionsDangerousBloc[innerindex][radioindex].radioValue,
              innerindex);
        }
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if (radioindex == 2) {
                      _displayDangerousValidDate[innerindex]
                          .eventRadioButtonSink
                          .add(RadioButtonAction.True);
                      _displayDangerousValidDate[innerindex].radioValue = true;
                    } else {
                      _displayDangerousValidDate[innerindex]
                          .eventRadioButtonSink
                          .add(RadioButtonAction.False);
                      _displayDangerousValidDate[innerindex].radioValue = false;
                    }
                    _validTillOptionsDangerousBloc[innerindex][radioindex]
                        .eventRadioButtonSink
                        .add(RadioButtonAction.True);
                    _validTillOptionsDangerousBloc[innerindex][radioindex]
                        .radioValue = true;

                    _dangerousValidDateErrorBloc[innerindex]
                        .eventResumeIssuingAuthoritySink
                        .add(ResumeErrorIssuingAuthorityAction.False);
                    for (int i = 0;
                        i <
                            Provider.of<GetValidTypeProvider>(context,
                                    listen: false)
                                .displayText
                                .length;
                        i++) {
                      if (i != radioindex) {
                        print(i);
                        print('Index');
                        print(innerindex);
                        _validTillOptionsDangerousBloc[innerindex][i]
                            .eventRadioButtonSink
                            .add(RadioButtonAction.False);
                        _validTillOptionsDangerousBloc[innerindex][i]
                            .radioValue = false;
                      } else {
                        _validTillOptionsDangerousBloc[innerindex][i]
                            .eventRadioButtonSink
                            .add(RadioButtonAction.True);
                        _validTillOptionsDangerousBloc[innerindex][i]
                            .radioValue = true;
                      }
                    }
                  });
                },
                child: ValidTillOptions(
                    radioValue: _validTillOptionsDangerousBloc[innerindex]
                            [radioindex]
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

  bool checkRadioValue(int innerindex) {
    bool result = true;
    for (int i = 0; i < 3; i++) {
      if (_validTillOptionsDangerousBloc[innerindex][i].radioValue) {
        result = false;
      }
    }

    return result;
  }

  _buildValidDateError(bool isSignOn, int index) {
    return StreamBuilder(
      stream: isSignOn
          ? _dangerousIssueDateErrorBloc[index]
              .stateResumeIssuingAuthorityStrean
          : _dangerousValidDateErrorBloc[index]
              .stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && isSignOn
            ? _dangerousIssueDateErrorBloc[index].showtext
            : _dangerousValidDateErrorBloc[index].showtext) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              isSignOn
                  ? 'Please enter the issue date'
                  : 'Please select a valid date option',
              style: TextStyle(color: Colors.red[500]),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _displayHasEndorsementSwitch(int index) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: StreamBuilder(
          initialData:
              Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
                  .has_document[index],
          stream: _switchButtonBloc[index].stateSwitchButtonStrean,
          builder: (context, snapshot) {
            return FlutterSwitch(
              height: 20,
              width: MediaQuery.of(context).size.height * 0.06,
              value: _switchButtonBloc[index].switchValue,
              onToggle: (val) {
                _hasDocument[index] = val;
                if (val) {
                  _issuingBloc[index].header = header;
                  _issuingBloc[index]
                      .eventResumeIssuingAuthoritySink
                      .add(ResumeIssuingAuthorityAction.Post);
                  _switchButtonBloc[index]
                      .eventSwitchButtonSink
                      .add(SwitchButtonAction.True);
                } else {
                  _switchButtonBloc[index]
                      .eventSwitchButtonSink
                      .add(SwitchButtonAction.False);
                }
              },
            );
          },
        ));
  }

  _buildIssuingAuthority(int index) {
    if (Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      return const SizedBox();
    } else {
      return StreamBuilder(
        stream: _issuingBloc[index].stateResumeIssuingAuthorityStrean,
        builder: (context, snapshot) {
          if (_issuingBloc[index].countrycode.isNotEmpty) {
            if (Provider.of<ResumeDangerousCargoProvider>(context,
                    listen: false)
                .docIndex
                .contains(index)) {
              if (Provider.of<ResumeDangerousCargoProvider>(context,
                      listen: false)
                  .editissuingAuthorityName[index]
                  .isNotEmpty) {
                issuingvalue[index] = Provider.of<ResumeDangerousCargoProvider>(
                        context,
                        listen: false)
                    .editissuingAuthorityName[index];
                _dropdownBloc[index].setdropdownvalue(issuingvalue[index]);
                _dropdownBloc[index]
                    .eventDropdownSink
                    .add(DropdownAction.Update);
              } else {
                issuingvalue[index] = _issuingBloc[index].countryname[0];
                _dropdownBloc[index].setdropdownvalue(issuingvalue[index]);
                _dropdownBloc[index]
                    .eventDropdownSink
                    .add(DropdownAction.Update);
              }
            } else {
              issuingvalue[index] = _issuingBloc[index].countryname[0];
              _dropdownBloc[index].setdropdownvalue(issuingvalue[index]);
              _dropdownBloc[index].eventDropdownSink.add(DropdownAction.Update);
            }
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: StreamBuilder(
                    initialData: false,
                    stream: _errorIssuingAuthorityBloc[index]
                        .stateResumeIssuingAuthorityStrean,
                    builder: (context, errorsnapshot) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: _errorIssuingAuthorityBloc[index].showtext
                                  ? Colors.red
                                  : Colors.grey),
                          borderRadius: const BorderRadius.all(Radius.circular(
                                  20.0) //                 <--- border radius here
                              ),
                        ),
                        child: StreamBuilder(
                          stream: _dropdownBloc[index].stateDropdownStrean,
                          builder: (context, dropdownsnapshot) {
                            return StreamBuilder(
                              stream: _showIssuingAuthorityDropDownBloc[index]
                                  .stateIndosNoStrean,
                              builder: (context, dropdownsnapshot) {
                                return Column(
                                  children: [
                                    DrodpownContainer(
                                      title: issuingvalue[index].isNotEmpty
                                          ? issuingvalue[index]
                                          : 'Select Issuing Authority',
                                      searchHint: 'Search Issuing Authority',
                                      originalList:
                                          _issuingBloc[index].countryname,
                                      showDropDownBloc:
                                          _showIssuingAuthorityDropDownBloc[
                                              index],
                                    ),
                                    ExpandedSection(
                                      expand: _showIssuingAuthorityDropDownBloc[
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
                                                            : _issuingBloc[index]
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
                                                                  _showIssuingAuthorityDropDownBloc[
                                                                          index]
                                                                      .eventIndosNoSink
                                                                      .add(IndosNoAction
                                                                          .False);
                                                                  _errorIssuingAuthorityBloc[
                                                                          index]
                                                                      .eventResumeIssuingAuthoritySink
                                                                      .add(ResumeErrorIssuingAuthorityAction
                                                                          .False);

                                                                  issuingvalue[
                                                                      index] = Provider.of<SearchChangeProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .searchList
                                                                          .isNotEmpty
                                                                      ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                          listindex]
                                                                      : _issuingBloc[index]
                                                                              .countryname[
                                                                          listindex];

                                                                  _dropdownBloc[index].setdropdownvalue(Provider.of<SearchChangeProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .searchList
                                                                          .isNotEmpty
                                                                      ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                          listindex]
                                                                      : _issuingBloc[index]
                                                                              .countryname[
                                                                          listindex]);
                                                                  _dropdownBloc[
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
                                                                        : _issuingBloc[index]
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
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                _issuingBloc[index].countrycode.isNotEmpty
                    ? TextBoxLabel('Issuing Authority')
                    : Container()
              ],
            );
          } else {
            return const CircularProgressIndicator(
                backgroundColor: kbackgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor));
          }
        },
      );
    }
  }

  _buildExpiringDateTF(bool isIssue, int index) {
    return isIssue
        ? _buildDates(isIssue, index)
        : StreamBuilder(
            stream: _displayDangerousValidDate[index].stateRadioButtonStrean,
            builder: (context, snapshot) {
              if (_displayDangerousValidDate[index].radioValue) {
                return _buildDates(isIssue, index);
              } else {
                return Container();
              }
            },
          );
  }

  _buildDates(bool isIssue, int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller:
                  isIssue ? _issueController[index] : _expirycontroller[index],
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
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  //floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  suffixIcon: InkWell(
                    onTap: () => _selectDate(context, index, isIssue),
                    child: const Icon(
                      Icons.date_range,
                      color: kBluePrimaryColor,
                    ),
                  ),
                  hintText: isIssue
                      ? 'Enter your Issue Date'
                      : 'Enter your Expiry Date',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel(isIssue ? 'Issue Date' : 'Expiry Date')
      ],
    );
  }

  Future<void> _selectDate(
      BuildContext context, int index, bool isIssue) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: isIssue
            ? DateTime(2015, 8)
            : DateTime.parse(_issueController[index].text),
        lastDate: isIssue ? selectedDate : DateTime(2101));
    if (isIssue) {
      if (picked != null && picked != selectedDate) {
        _issueController[index].text = formatter.format(picked);
      }
    } else {
      if (picked != null && picked != selectedDate) {
        _expirycontroller[index].text = formatter.format(picked);
      }
    }
  }

  void getdata() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditDangerousCargo(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    AsyncCallProvider asyncProvider;
    asyncProvider = Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    for (int i = 0;
        i <
            Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
                .document_name
                .length;
        i++) {
      issuingvalue.add("");
      _hasDocument.add(false);
      _issuingBloc.add(ResumeIssuingAuthorityBloc());
      _dangerousValidDateErrorBloc.add(ResumeErrorIssuingAuthorityBloc());
      _dangerousIssueDateErrorBloc.add(ResumeErrorIssuingAuthorityBloc());
      _displayDangerousValidDate.add(RadioButtonBloc());
      List<RadioButtonBloc> tempValidTillDatebloc = [];
      for (int k = 0; k < 3; k++) {
        tempValidTillDatebloc.add(RadioButtonBloc());
      }
      _validTillOptionsDangerousBloc.add(tempValidTillDatebloc);
      _expirycontroller.add(TextEditingController());
      _issueController.add(TextEditingController());
      _dropdownBloc.add(DropdownBloc());
      _errorIssuingAuthorityBloc.add(ResumeErrorIssuingAuthorityBloc());

      if (Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
          .docIndex
          .contains(i)) {
        //iscompleted = await callIssuingAPI(i);
        _issuingBloc[i].header = header;
        _issuingBloc[i]
            .eventResumeIssuingAuthoritySink
            .add(ResumeIssuingAuthorityAction.Post);
        _switchButtonBloc[i].eventSwitchButtonSink.add(SwitchButtonAction.True);
        _switchButtonBloc[i].switchValue = true;
        _hasDocument[i] = true;
        _expirycontroller[i].text =
            Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
                .editexpiryDate[i];
        _issueController[i].text =
            Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
                .editissueDate[i];
      }
    }

    asyncProvider.changeAsynccall();
  }

  _buildIssuingAuthorityErrorText(int index) {
    return StreamBuilder(
      stream:
          _errorIssuingAuthorityBloc[index].stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && _errorIssuingAuthorityBloc[index].showtext) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Please select the issuing authority',
                style: TextStyle(color: Colors.red[500]),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void callpostDangerousCargoFunction() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditDangerousCargo(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    ResumeEditDangerousCargoUpdateProvider resumeDangerousCargoUpdateProvider =
        Provider.of<ResumeEditDangerousCargoUpdateProvider>(context,
            listen: false);
    List<PosttDangerousCargoResponse> postList = [];
    for (int i = 0;
        i <
            Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
                .document_name
                .length;
        i++) {
      if (_hasDocument[i]) {
        String expiry = "";
        for (int k = 0; k < 3; k++) {
          if (_validTillOptionsDangerousBloc[i][k].radioValue) {
            expiry = Provider.of<GetValidTypeProvider>(context, listen: false)
                .validTypeId[k];
          }
        }
        if (issuingvalue[i].isNotEmpty) {
          postList.add(PosttDangerousCargoResponse(
              dangerousCargoName: Provider.of<ResumeDangerousCargoProvider>(
                      context,
                      listen: false)
                  .document_name[i],
              documentId: Provider.of<ResumeDangerousCargoProvider>(context,
                      listen: false)
                  .document_id[i],
              hasDocument: _hasDocument[i],
              id: Provider.of<ResumeDangerousCargoProvider>(context,
                      listen: false)
                  .docUserId[i],
              issueName: issuingvalue[i],
              issuingAuthorityId: _issuingBloc[i].countrycode[
                  _issuingBloc[i].countryname.indexOf(issuingvalue[i])],
              issueDate: _issueController[i].text,
              validTillDate: _expirycontroller[i].text,
              validTillType: expiry));
        }
      } else if (!_hasDocument[i] &&
          Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
              .has_document[i]) {
        postList.add(PosttDangerousCargoResponse(
            dangerousCargoName: Provider.of<ResumeDangerousCargoProvider>(
                    context,
                    listen: false)
                .document_name[i],
            documentId: Provider.of<ResumeDangerousCargoProvider>(context,
                    listen: false)
                .document_id[i],
            hasDocument: _hasDocument[i],
            id: Provider.of<ResumeDangerousCargoProvider>(context,
                    listen: false)
                .docUserId[i],
            issueName: "",
            issueDate: "",
            issuingAuthorityId: "",
            validTillDate: "",
            validTillType: ""));
      }
    }

    if (postList.isEmpty) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DangerousCargo()));
    } else {
      if (await resumeDangerousCargoUpdateProvider.callpostResumeAddressapi(
          postList, header)) {
        asyncProvider.changeAsynccall();
        Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
            .isComplete = true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('DangeousCargoUpdateSuccess',
            'Dangerous Cargo updated successfully');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DangerousCargo()));
      } else {
        displaysnackbar('Something went wrong');
        asyncProvider.changeAsynccall();
      }
    }
  }

  bool checkerror(int i) {
    List<bool> dangerousValid = [];
    bool data = false;
    for (int k = 0; k < 3; k++) {
      dangerousValid.add(_validTillOptionsDangerousBloc[i][k].radioValue);
    }

    if (!dangerousValid.contains(true)) {
      _dangerousValidDateErrorBloc[i]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);

      data = true;
    }

    if (_issueController[i].text.isEmpty) {
      _dangerousIssueDateErrorBloc[i]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
      _dangerousIssueDateErrorBloc[i].showtext = true;
      data = true;
    }

    return data;
  }

  void checkInitialData(bool radioValue, int innerindex) {
    if (!radioValue &&
        Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
                .validTillTypeId[innerindex] !=
            null) {
      print(radioValue);
      print(innerindex);
      print('It is not null');
      if (Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
              .validTillTypeId[innerindex] ==
          lifetimeValidType) {
        _validTillOptionsDangerousBloc[innerindex][0]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
        _validTillOptionsDangerousBloc[innerindex][0].radioValue = true;
      } else {
        _validTillOptionsDangerousBloc[innerindex][0].radioValue = false;
      }
      if (Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
              .validTillTypeId[innerindex] ==
          unlimitedValidType) {
        _validTillOptionsDangerousBloc[innerindex][1]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
        _validTillOptionsDangerousBloc[innerindex][1].radioValue = true;
      } else {
        print('Changing');
        _validTillOptionsDangerousBloc[innerindex][1].radioValue = false;
      }
      if (Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
              .validTillTypeId[innerindex] ==
          dateValidType) {
        _validTillOptionsDangerousBloc[innerindex][2]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
        _validTillOptionsDangerousBloc[innerindex][2].radioValue = true;
        _displayDangerousValidDate[innerindex]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
        _displayDangerousValidDate[innerindex].radioValue = true;
        _expirycontroller[innerindex].text =
            Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
                .expiryDate[innerindex];
      } else {
        _validTillOptionsDangerousBloc[innerindex][2].radioValue = false;
      }
    }
  }
}
