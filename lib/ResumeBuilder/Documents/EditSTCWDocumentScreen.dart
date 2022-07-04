// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, prefer_final_fields

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../DropdownBloc.dart';
import '../../DropdownContainer.dart';
import '../../IssuingAuthorityErrorBloc.dart';
import '../../RadioButtonBloc.dart';
import '../../SearchTextProvider.dart';
import '../../TextBoxLabel.dart';
import '../../asynccallprovider.dart';
import '../../constants.dart';
import '../GetValidTypeProvider.dart';
import '../Header.dart';
import 'package:intl/intl.dart';

import '../PersonalInformation/ExpandedAnimation.dart';
import '../PersonalInformation/IndosNoBloc.dart';
import '../PersonalInformation/Scrollbar.dart';
import '../ValidTillOptions.dart';
import 'DeleteSTCWRecord.dart';
import 'DocumentScreen.dart';
import 'DocumentScreenProvider.dart';
import 'PostSTCWData.dart';
import 'STCWDocUpdateProvider.dart';

class EditSTCWDocumentScreen extends StatefulWidget {
  const EditSTCWDocumentScreen({Key? key}) : super(key: key);

  @override
  _EditSTCWDocumentScreenState createState() => _EditSTCWDocumentScreenState();
}

class _EditSTCWDocumentScreenState extends State<EditSTCWDocumentScreen> {
  final List<TextEditingController> _stcwMandatoryCertificateNo = [],
      _stcwMandatoryIssueDate = [],
      _stcwMandatoryExpiryDate = [],
      _stcwOptionalCertificateNo = [],
      _stcwOptionalExpiryDate = [],
      _stcwOptionalIssueDate = [];
  static final _formKey = GlobalKey<FormState>();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime selectedDate = DateTime.now();
  final List<List<RadioButtonBloc>> _mandatoryValidTillOptionsStcwBloc = [],
      _optionalValidTillOptionsStcwBloc = [];
  final List<RadioButtonBloc> _displayStcwMandatoryValidDate = [],
      _displayStcwOptionalValidDate = [],
      _mandatoryShowValidTillDate = [],
      _optionalShowValidTillDate = [];
  final List<ResumeErrorIssuingAuthorityBloc> _stcwMandatoryValidDateErrorBloc =
          [],
      _stcwOptionalValidDateErrorBloc = [];
  List<String> _mandatoryDocValue = [],
      _optionalDocValue = [],
      _mandatoryTempStcwDocName = [],
      _mandatoryTempCertificateNo = [],
      _mandatoryTempIssueDate = [],
      _mandatoryTempValidTillText = [],
      _optionalTempStcwDocName = [],
      _optionalTempCertificateNo = [],
      _optionalTempIssueDate = [],
      _optionalTempValidTillText = [];
  List<List<bool>> _mandatoryTempRadioValue = [], _optionalTempRadioValue = [];
  final List<ResumeErrorIssuingAuthorityBloc> _mandatoryErrorSTCWDocName = [],
      _optionalErrorSTCWDocName = [];
  final List<DropdownBloc> _mandatoryDocDropdownBloc = [],
      _optionalDocDropdownBloc = [];
  final ResumeErrorIssuingAuthorityBloc _selectMandatoryDocError =
      ResumeErrorIssuingAuthorityBloc();
  bool mandatoryCall = false;
  var header;
  final List<IndosNoBloc> _showMandatoryDropDownBloc = [],
      _showOptionalDropDownBloc = [];
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
    // TODO: implement dispose
    _selectMandatoryDocError.dispose();
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwMandatoryLength;
        i++) {
      _displayStcwMandatoryValidDate[i].dispose();
      _mandatoryShowValidTillDate[i].dispose();
      _stcwMandatoryValidDateErrorBloc[i].dispose();
      for (int k = 0; k < 3; k++) {
        _mandatoryValidTillOptionsStcwBloc[i][k].dispose();
      }
      _showMandatoryDropDownBloc[i].dispose();
    }
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalLength;
        i++) {
      _displayStcwOptionalValidDate[i].dispose();
      _optionalShowValidTillDate[i].dispose();
      _stcwOptionalValidDateErrorBloc[i].dispose();
      for (int k = 0; k < 3; k++) {
        _optionalValidTillOptionsStcwBloc[i][k].dispose();
      }
      _showOptionalDropDownBloc[i].dispose();
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
          child: Form(
            key: _formKey,
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
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (!checkError()) callPostSTCWRecords();
                          } else {
                            bool checkerror = checkError();
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
          child: Column(
            children: [
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: _displaySubHeading(
                      isMandatory ? 'Mandatory' : 'Optional'),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _displaySTCWCard(
                        isMandatory,
                        Provider.of<ResumeDocumentProvider>(context,
                                    listen: false)
                                .stcwExpiryDate
                                .isEmpty
                            ? Provider.of<ResumeDocumentProvider>(context,
                                    listen: false)
                                .stcwMandatoryDocName
                            : Provider.of<ResumeDocumentProvider>(context,
                                    listen: false)
                                .stcwOptionalDocName),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displaySTCWCard(bool isMandatory, List<String> docName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAddSTCWOption(isMandatory),
        isMandatory ? _buildErrorDocDisplay() : Container(),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: isMandatory
                  ? Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .stcwMandatoryLength
                  : Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .stcwOptionalLength,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[50],
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'STCW Document No. ${index + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Spacer(),
                            _displaySTCWDeleteIcon(index, isMandatory),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Provider.of<AsyncCallProvider>(context, listen: false)
                                .isinasynccall
                            ? Container()
                            : _buildDocNameDropdown(index, isMandatory),
                        _buildDocErrorDropdown(index, isMandatory),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildSTCWCardData(index, isMandatory)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  _displaySTCWDeleteIcon(int index, bool isMandatory) {
    if (isMandatory) {
      if (Provider.of<ResumeDocumentProvider>(context).stcwMandatoryLength ==
              1 &&
          Provider.of<ResumeDocumentProvider>(context)
              .stcwValidTillType
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
      if (Provider.of<ResumeDocumentProvider>(context).stcwOptionalLength ==
              1 &&
          Provider.of<ResumeDocumentProvider>(context)
              .stcwOptionalValidTillType
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
          title: const Text('Delete STCW Record',
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

  void deleterecord(int index, bool isMandatory) async {
    if (isMandatory) {
      if (index ==
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .stcwValidTillType
              .length) {
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
            .stcwValidTillType
            .isNotEmpty) {
          deleteEmptyRecord(isMandatory);
        }
      } else {
        if (index >
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwValidTillType
                .length) {
          deleteEmptyRecord(isMandatory);
        } else {
          ResumeEditSTCWRecordDeleteProvider stcwDeleteProvider =
              Provider.of<ResumeEditSTCWRecordDeleteProvider>(context,
                  listen: false);
          AsyncCallProvider asyncProvider =
              Provider.of<AsyncCallProvider>(context, listen: false);
          if (!Provider.of<AsyncCallProvider>(context, listen: false)
              .isinasynccall) asyncProvider.changeAsynccall();
          if (await stcwDeleteProvider.callpostDeleteResumeSTCWRecordapi(
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .stcwUserId[index],
              header)) {
            asyncProvider.changeAsynccall();
            delteIndexRecord(index);
            if (checkMandatoryDocAvailability()) {
              Provider.of<ResumeEditSTCWRecordDeleteProvider>(context,
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
              .stcwValidTillType
              .length) {
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
            .stcwValidTillType
            .isNotEmpty) {
          deleteEmptyRecord(isMandatory);
        } else if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalLength >
            1) {
          deleteindexEmptyRecord(isMandatory, index);
        }
      } else {
        if (index >
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalValidTillType
                .length) {
          if (index ==
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .stcwOptionalLength -
                  1) {
            deleteEmptyRecord(isMandatory);
          } else {
            deleteindexEmptyRecord(isMandatory, index);
          }
        } else if (index ==
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalExpiryDate
                .length) {
          deleteindexEmptyRecord(isMandatory, index);
        } else {
          ResumeEditSTCWRecordDeleteProvider stcwDeleteProvider =
              Provider.of<ResumeEditSTCWRecordDeleteProvider>(context,
                  listen: false);
          AsyncCallProvider asyncProvider =
              Provider.of<AsyncCallProvider>(context, listen: false);
          if (!Provider.of<AsyncCallProvider>(context, listen: false)
              .isinasynccall) asyncProvider.changeAsynccall();
          if (await stcwDeleteProvider.callpostDeleteResumeSTCWRecordapi(
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .stcwOptionalUserId[index],
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
  }

  void deleteEmptyRecord(bool isMandatory) {
    ResumeDocumentProvider documentProvider =
        Provider.of<ResumeDocumentProvider>(context, listen: false);
    isMandatory
        ? setState(() {
            documentProvider.decreaseMandatorySTCWlength();
            _stcwMandatoryValidDateErrorBloc.removeLast();
            _displayStcwMandatoryValidDate.removeLast();
            _mandatoryDocDropdownBloc.removeLast();
            _mandatoryDocValue.removeLast();
            _mandatoryErrorSTCWDocName.removeLast();
            _stcwMandatoryExpiryDate.removeLast();

            //cleardata();

            getdata();
          })
        : setState(() {
            documentProvider.decreaseOptionalSTCWlength();
            _stcwOptionalValidDateErrorBloc.removeLast();
            _displayStcwOptionalValidDate.removeLast();
            _optionalDocDropdownBloc.removeLast();
            _optionalDocValue.removeLast();
            _optionalErrorSTCWDocName.removeLast();
            _stcwOptionalExpiryDate.removeLast();
            //cleardata();
            getdata();
          });
  }

  void deleteindexEmptyRecord(bool isMandatory, int index) {
    ResumeDocumentProvider documentProvider =
        Provider.of<ResumeDocumentProvider>(context, listen: false);
    isMandatory
        ? setState(() {
            documentProvider.decreaseMandatorySTCWlength();
            _stcwMandatoryValidDateErrorBloc.removeAt(index);
            _displayStcwMandatoryValidDate.removeAt(index);
            _mandatoryDocDropdownBloc.removeAt(index);
            _mandatoryDocValue.removeAt(index);
            _mandatoryErrorSTCWDocName.removeAt(index);
            _stcwMandatoryExpiryDate.removeAt(index);

            //cleardata();

            getdata();
          })
        : setState(() {
            documentProvider.decreaseOptionalSTCWlength();
            _stcwOptionalValidDateErrorBloc.removeAt(index);
            _displayStcwOptionalValidDate.removeAt(index);
            _optionalDocDropdownBloc.removeAt(index);
            _optionalDocValue.removeAt(index);
            _optionalErrorSTCWDocName.removeAt(index);
            _stcwOptionalExpiryDate.removeAt(index);
            //cleardata();
            getdata();
          });
  }

  void delteIndexRecord(int index) {
    ResumeDocumentProvider documentProvider =
        Provider.of<ResumeDocumentProvider>(context, listen: false);
    setState(() {
      documentProvider.decreaseMandatoryIndexSTCWlength(index);
      _stcwMandatoryValidDateErrorBloc.removeAt(index);
      _displayStcwMandatoryValidDate.removeAt(index);
      _mandatoryDocDropdownBloc.removeAt(index);
      _mandatoryDocValue.removeAt(index);
      _mandatoryErrorSTCWDocName.removeAt(index);
      _stcwMandatoryExpiryDate.removeAt(index);

      //cleardata();

      getdata();
    });
  }

  _buildDocNameDropdown(int index, bool isMandatory) {
    return Stack(
      children: [
        StreamBuilder(
          initialData: false,
          stream: isMandatory
              ? _mandatoryErrorSTCWDocName[index]
                  .stateResumeIssuingAuthorityStrean
              : _optionalErrorSTCWDocName[index]
                  .stateResumeIssuingAuthorityStrean,
          builder: (context, errorsnapshot) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.0, color: checkColor(isMandatory, index)),
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
                                      : 'Select STCW Document'
                                  : _optionalDocValue[index].isNotEmpty
                                      ? _optionalDocValue[index]
                                      : 'Select STCW Document',
                              searchHint: 'Search Document',
                              showDropDownBloc: isMandatory
                                  ? _showMandatoryDropDownBloc[index]
                                  : _showOptionalDropDownBloc[index],
                              originalList: isMandatory
                                  ? Provider.of<ResumeDocumentProvider>(context,
                                          listen: false)
                                      .stcwMandatoryDocName
                                  : Provider.of<ResumeDocumentProvider>(context,
                                          listen: false)
                                      .stcwOptionalDocName,
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
                                                        .stcwMandatoryDocName
                                                        .length
                                                    : Provider.of<ResumeDocumentProvider>(
                                                            context,
                                                            listen: false)
                                                        .stcwOptionalDocName
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
                                                                    .stcwMandatoryDocName[listindex]
                                                                : Provider.of<ResumeDocumentProvider>(context, listen: false).stcwOptionalDocName[listindex]),
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
        TextBoxLabel('Select STCW')
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
            .stcwMandatoryDocName[listindex];
    _showMandatoryDropDownBloc[index].eventIndosNoSink.add(IndosNoAction.False);
    if (_mandatoryDocValue.contains(tempValue) &&
        _mandatoryDocValue.indexOf(tempValue) != index) {
      _mandatoryErrorSTCWDocName[index]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
      _mandatoryErrorSTCWDocName[index].showAlternateText = true;
    } else {
      _mandatoryErrorSTCWDocName[index]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.False);
      _mandatoryErrorSTCWDocName[index].showAlternateText = false;
      _mandatoryDocValue[index] = tempValue;
    }
  }

  changeOptionalValue(index, listindex) {
    String tempValue = "";
    tempValue = Provider.of<SearchChangeProvider>(context, listen: false)
            .searchList
            .isNotEmpty
        ? Provider.of<SearchChangeProvider>(context, listen: false)
            .searchList[listindex]
        : Provider.of<ResumeDocumentProvider>(context, listen: false)
            .stcwOptionalDocName[listindex];
    _showOptionalDropDownBloc[index].eventIndosNoSink.add(IndosNoAction.False);

    _optionalDocValue[index] = tempValue;
    _optionalDocDropdownBloc[index].setdropdownvalue(tempValue);
    _optionalDocDropdownBloc[index]
        .eventDropdownSink
        .add(DropdownAction.Update);
  }

  checkColor(isMandatory, index) {
    bool result = false;
    if (isMandatory) {
      result = _mandatoryErrorSTCWDocName[index].showtext;
    } else {
      result = _optionalErrorSTCWDocName[index].showtext;
    }
    return result ? Colors.red : Colors.grey;
  }

  _buildDocErrorDropdown(int index, bool isMandatory) {
    return StreamBuilder(
      stream: isMandatory
          ? _mandatoryErrorSTCWDocName[index].stateResumeIssuingAuthorityStrean
          : _optionalErrorSTCWDocName[index].stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (isMandatory
            ? _mandatoryErrorSTCWDocName[index].showtext
            : _optionalErrorSTCWDocName[index].showtext) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              isMandatory
                  ? _mandatoryErrorSTCWDocName[index].showAlternateText
                      ? 'Please select another document'
                      : 'Please select stcw document'
                  : _optionalErrorSTCWDocName[index].showAlternateText
                      ? 'Please select another document'
                      : 'Please select stcw document',
              style: TextStyle(color: Colors.red[500]),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _buildSTCWCardData(int index, bool isMandatory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _displaySTCWCardData(index, isMandatory),
      ],
    );
  }

  _displaySubHeading(String category) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(
        category,
        style: TextStyle(
            color: kgreenPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.045),
      ),
    );
  }

  _displaySTCWCardData(int index, bool isMandatory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCertificateNoTF(index, isMandatory),
        const SizedBox(
          height: 14,
        ),
        _buildExpiryDateTF(index, true, isMandatory),
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
        _buildExpiryDateTF(index, false, isMandatory),
      ],
    );
  }

  _buildValidTillOptions(int radioindex, int innerindex, bool isMandatory) {
    return StreamBuilder(
      stream: isMandatory
          ? _mandatoryValidTillOptionsStcwBloc[innerindex][radioindex]
              .stateRadioButtonStrean
          : _optionalValidTillOptionsStcwBloc[innerindex][radioindex]
              .stateRadioButtonStrean,
      builder: (context, snapshot) {
        isMandatory
            ? checkInitialData(
                _mandatoryValidTillOptionsStcwBloc[innerindex][radioindex]
                    .radioValue,
                innerindex)
            : checkInitialOptionalData(
                _optionalValidTillOptionsStcwBloc[innerindex][radioindex]
                    .radioValue,
                innerindex);
        if (isMandatory) {
          if (innerindex < _mandatoryTempRadioValue.length) {
            checkInitialTempData(snapshot, innerindex, isMandatory);
          }
        } else {
          if (innerindex < _optionalTempRadioValue.length) {
            checkInitialTempData(snapshot, innerindex, isMandatory);
          }
        }
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  isMandatory
                      ? setMandatoryDates(radioindex, innerindex)
                      : setOptionalDates(radioindex, innerindex);
                },
                child: ValidTillOptions(
                    radioValue: isMandatory
                        ? _mandatoryValidTillOptionsStcwBloc[innerindex]
                                    [radioindex]
                                .radioValue
                            ? true
                            : false
                        : _optionalValidTillOptionsStcwBloc[innerindex]
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

  setMandatoryDates(int radioindex, int innerindex) {
    setState(() {
      if (radioindex == 2) {
        _displayStcwMandatoryValidDate[innerindex]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
        _displayStcwMandatoryValidDate[innerindex].radioValue = true;
      } else {
        _displayStcwMandatoryValidDate[innerindex]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _displayStcwMandatoryValidDate[innerindex].radioValue = false;
      }
      _mandatoryValidTillOptionsStcwBloc[innerindex][radioindex]
          .eventRadioButtonSink
          .add(RadioButtonAction.True);
      _mandatoryValidTillOptionsStcwBloc[innerindex][radioindex].radioValue =
          true;
      _stcwMandatoryValidDateErrorBloc[innerindex]
          .eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.False);
      for (int i = 0;
          i <
              Provider.of<GetValidTypeProvider>(context, listen: false)
                  .displayText
                  .length;
          i++) {
        if (i != radioindex) {
          _mandatoryValidTillOptionsStcwBloc[innerindex][i]
              .eventRadioButtonSink
              .add(RadioButtonAction.False);
          _mandatoryValidTillOptionsStcwBloc[innerindex][i].radioValue = false;
        }
      }
    });
  }

  setOptionalDates(int radioindex, int innerindex) {
    if (radioindex == 2) {
      _displayStcwOptionalValidDate[innerindex]
          .eventRadioButtonSink
          .add(RadioButtonAction.True);
    } else {
      _displayStcwOptionalValidDate[innerindex]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
    }
    _optionalValidTillOptionsStcwBloc[innerindex][radioindex]
        .eventRadioButtonSink
        .add(RadioButtonAction.True);
    _stcwOptionalValidDateErrorBloc[innerindex]
        .eventResumeIssuingAuthoritySink
        .add(ResumeErrorIssuingAuthorityAction.False);
    for (int i = 0;
        i <
            Provider.of<GetValidTypeProvider>(context, listen: false)
                .displayText
                .length;
        i++) {
      if (i != radioindex) {
        _optionalValidTillOptionsStcwBloc[innerindex][i]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
      }
    }
  }

  _buildValidDateError(int index, bool isMandatory) {
    return StreamBuilder(
      stream: isMandatory
          ? _stcwMandatoryValidDateErrorBloc[index]
              .stateResumeIssuingAuthorityStrean
          : _stcwOptionalValidDateErrorBloc[index]
              .stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (isMandatory
            ? _stcwMandatoryValidDateErrorBloc[index].showtext
            : _stcwOptionalValidDateErrorBloc[index].showtext) {
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

  _buildCertificateNoTF(int index, bool isMandatory) {
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
                  ? _stcwMandatoryCertificateNo[index]
                  : _stcwOptionalCertificateNo[index],
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  //floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter your certificate No',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Certificate No')
      ],
    );
  }

  _buildExpiryDateTF(int index, bool isSignOn, bool isMandatory) {
    return isSignOn
        ? _buildDates(index, isSignOn, isMandatory)
        : StreamBuilder(
            stream: isMandatory
                ? _displayStcwMandatoryValidDate[index].stateRadioButtonStrean
                : _displayStcwOptionalValidDate[index].stateRadioButtonStrean,
            builder: (context, snapshot) {
              if (isMandatory
                  ? _displayStcwMandatoryValidDate[index].radioValue
                  : _displayStcwOptionalValidDate[index].radioValue) {
                return _buildDates(index, isSignOn, isMandatory);
              } else {
                return Container();
              }
            },
          );
  }

  _buildDates(int index, bool isSignOn, bool isMandatory) {
    return StreamBuilder(
      stream: isMandatory
          ? _mandatoryShowValidTillDate[index].stateRadioButtonStrean
          : _optionalShowValidTillDate[index].stateRadioButtonStrean,
      builder: (context, snapshot) {
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
                      : snapshot.hasData && snapshot.hasData
                          ? true
                          : isMandatory
                              ? _stcwMandatoryIssueDate[index].text.isEmpty
                                  ? false
                                  : true
                              : _stcwOptionalIssueDate[index].text.isEmpty
                                  ? false
                                  : true,
                  cursorColor: kgreenPrimaryColor,
                  controller: isSignOn
                      ? isMandatory
                          ? _stcwMandatoryIssueDate[index]
                          : _stcwOptionalIssueDate[index]
                      : isMandatory
                          ? _stcwMandatoryExpiryDate[index]
                          : _stcwOptionalExpiryDate[index],
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
                        _stcwMandatoryExpiryDate[index].clear();
                      } else {
                        _optionalShowValidTillDate[index]
                            .eventRadioButtonSink
                            .add(RadioButtonAction.False);
                        _stcwOptionalExpiryDate[index].clear();
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
                          ? 'Enter your Issue Date'
                          : 'Enter your Expiry Date',
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
      initialDate: selectedDate,
      firstDate: isSignOn
          ? DateTime(2015, 8)
          : DateTime.parse(isMandatory
              ? _stcwMandatoryIssueDate[index].text
              : _stcwOptionalIssueDate[index].text),
      lastDate: isSignOn ? selectedDate : DateTime(2101),
    );
    if (isSignOn) {
      if (picked != null && picked != selectedDate) {
        if (isMandatory) {
          _stcwMandatoryIssueDate[index].text = formatter.format(picked);
          _mandatoryShowValidTillDate[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
        } else {
          _stcwOptionalIssueDate[index].text = formatter.format(picked);
          _optionalShowValidTillDate[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
        }
      }
    } else {
      if (picked != null && picked != selectedDate) {
        if (isMandatory) {
          _stcwMandatoryExpiryDate[index].text = formatter.format(picked);
        } else {
          _stcwOptionalExpiryDate[index].text = formatter.format(picked);
        }
      }
    }
  }

  void getdata() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditSTCWDocumentScreen(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    addDefaultSTCWRecords();
    addDefaultOptionalSTCWRecords();
    asyncProvider.changeAsynccall();
  }

  void callPostSTCWRecords() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditSTCWDocumentScreen(), context);

    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    List<PostStcwData> postMandatorySTCWData = [], postOptionalSTCWData = [];

    postMandatorySTCWData = callPostMandatoryRecords();
    postOptionalSTCWData = callPostOptionalRecords();

    ResumeEditSTCWDocUpdateProvider stcwProvider =
        Provider.of<ResumeEditSTCWDocUpdateProvider>(context, listen: false);
    if (await stcwProvider.callpostResumeSTCWDocapi(
        postMandatorySTCWData, postOptionalSTCWData, header)) {
      asyncProvider.changeAsynccall();
      Provider.of<ResumeEditSTCWRecordDeleteProvider>(context, listen: false)
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

  List<PostStcwData> callPostMandatoryRecords() {
    List<PostStcwData> postMandatoryStcwData = [];
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwMandatoryLength;
        i++) {
      String expiry = "";
      for (int k = 0; k < 3; k++) {
        if (_mandatoryValidTillOptionsStcwBloc[i][k].radioValue) {
          expiry = Provider.of<GetValidTypeProvider>(context, listen: false)
              .validTypeId[k];
        }
      }
      String id = "";
      if (i <
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .stcwUserId
              .length) {
        id = Provider.of<ResumeDocumentProvider>(context, listen: false)
            .stcwUserId[i];
      } else {
        id = "";
      }
      postMandatoryStcwData.add(PostStcwData(
        certificateNo: _stcwMandatoryCertificateNo[i].text,
        id: id,
        documentId: Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwMandatoryDocId[
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwMandatoryDocName
                .indexOf(_mandatoryDocValue[i])],
        issueDate: _stcwMandatoryIssueDate[i].text,
        validDate: _stcwMandatoryExpiryDate[i].text,
        validType: expiry,
      ));
    }

    return postMandatoryStcwData;
  }

  void checkInitialData(bool value, int innerindex) {
    if (!value &&
        Provider.of<ResumeDocumentProvider>(context, listen: false)
            .stcwValidTillTypeId
            .isNotEmpty) {
      if (innerindex <
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .stcwValidTillTypeId
              .length) {
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwValidTillTypeId[innerindex] ==
            lifetimeValidType) {
          _mandatoryValidTillOptionsStcwBloc[innerindex][0]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _mandatoryValidTillOptionsStcwBloc[innerindex][0].radioValue = true;
        } else {
          _mandatoryValidTillOptionsStcwBloc[innerindex][0].radioValue = false;
        }
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwValidTillTypeId[innerindex] ==
            unlimitedValidType) {
          _mandatoryValidTillOptionsStcwBloc[innerindex][1]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _mandatoryValidTillOptionsStcwBloc[innerindex][1].radioValue = true;
        } else {
          _mandatoryValidTillOptionsStcwBloc[innerindex][1].radioValue = false;
        }
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwValidTillTypeId[innerindex] ==
            dateValidType) {
          _mandatoryValidTillOptionsStcwBloc[innerindex][2]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _mandatoryValidTillOptionsStcwBloc[innerindex][2].radioValue = true;
          _displayStcwMandatoryValidDate[innerindex]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _displayStcwMandatoryValidDate[innerindex].radioValue = true;
        } else {
          _mandatoryValidTillOptionsStcwBloc[innerindex][2].radioValue = false;
        }
      }
    }
  }

  void checkInitialOptionalData(bool value, int innerindex) {
    if (!value &&
        Provider.of<ResumeDocumentProvider>(context, listen: false)
            .stcwOptionalValidTillTypeId
            .isNotEmpty) {
      if (innerindex <
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .stcwOptionalValidTillTypeId
              .length) {
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalValidTillTypeId[innerindex] ==
            lifetimeValidType) {
          _optionalValidTillOptionsStcwBloc[innerindex][0]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _optionalValidTillOptionsStcwBloc[innerindex][0].radioValue = true;
        } else {
          _optionalValidTillOptionsStcwBloc[innerindex][0].radioValue = false;
        }
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalValidTillTypeId[innerindex] ==
            unlimitedValidType) {
          _optionalValidTillOptionsStcwBloc[innerindex][1]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _optionalValidTillOptionsStcwBloc[innerindex][1].radioValue = true;
        } else {
          _optionalValidTillOptionsStcwBloc[innerindex][1].radioValue = false;
        }
        if (Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalValidTillTypeId[innerindex] ==
            dateValidType) {
          _optionalValidTillOptionsStcwBloc[innerindex][2]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _optionalValidTillOptionsStcwBloc[innerindex][2].radioValue = true;
          _displayStcwOptionalValidDate[innerindex]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _displayStcwOptionalValidDate[innerindex].radioValue = true;
        } else {
          _optionalValidTillOptionsStcwBloc[innerindex][2].radioValue = false;
        }
      }
    }
  }

  void checkInitialTempData(
      AsyncSnapshot snapshot, int innerindex, bool isMandatory) {
    if (isMandatory) {
      if (!snapshot.hasData) {
        if (_mandatoryTempRadioValue[innerindex][0] == true) {
          _mandatoryValidTillOptionsStcwBloc[innerindex][0]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _mandatoryValidTillOptionsStcwBloc[innerindex][0].radioValue = true;
        } else {
          _mandatoryValidTillOptionsStcwBloc[innerindex][0].radioValue = false;
        }
        if (_mandatoryTempRadioValue[innerindex][1] == true) {
          _mandatoryValidTillOptionsStcwBloc[innerindex][1]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _mandatoryValidTillOptionsStcwBloc[innerindex][1].radioValue = true;
        } else {
          _mandatoryValidTillOptionsStcwBloc[innerindex][1].radioValue = false;
        }
        if (_mandatoryTempRadioValue[innerindex][2] == true) {
          _mandatoryValidTillOptionsStcwBloc[innerindex][2]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _mandatoryValidTillOptionsStcwBloc[innerindex][2].radioValue = true;
          _displayStcwMandatoryValidDate[innerindex]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _displayStcwMandatoryValidDate[innerindex].radioValue = true;
        } else {
          _mandatoryValidTillOptionsStcwBloc[innerindex][2].radioValue = false;
        }
      }
    } else {
      if (!snapshot.hasData) {
        if (_optionalTempRadioValue[innerindex][0] == true) {
          _optionalValidTillOptionsStcwBloc[innerindex][0]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _optionalValidTillOptionsStcwBloc[innerindex][0].radioValue = true;
        } else {
          _optionalValidTillOptionsStcwBloc[innerindex][0].radioValue = false;
        }
        if (_optionalTempRadioValue[innerindex][1] == true) {
          _optionalValidTillOptionsStcwBloc[innerindex][1]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _optionalValidTillOptionsStcwBloc[innerindex][1].radioValue = true;
        } else {
          _optionalValidTillOptionsStcwBloc[innerindex][1].radioValue = false;
        }
        if (_optionalTempRadioValue[innerindex][2] == true) {
          _optionalValidTillOptionsStcwBloc[innerindex][2]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _optionalValidTillOptionsStcwBloc[innerindex][2].radioValue = true;
          _displayStcwOptionalValidDate[innerindex]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _displayStcwOptionalValidDate[innerindex].radioValue = true;
        } else {
          _optionalValidTillOptionsStcwBloc[innerindex][2].radioValue = false;
        }
      }
    }
  }

  _buildAddSTCWOption(bool isMandatory) {
    return InkWell(
      onTap: () {
        mandatoryCall = isMandatory;
        cleardata();

        ResumeDocumentProvider documentProvider =
            Provider.of<ResumeDocumentProvider>(context, listen: false);
        setState(() {
          isMandatory
              ? documentProvider.increaseMandatorySTCWlength()
              : documentProvider.increaseOptionalSTCWlength();

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
                    ? 'Add Mandatory STCW Document'
                    : 'Add Optional STCW Document',
                style: TextStyle(
                    color: kBluePrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.032)),
          ],
        ),
      ),
    );
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
    _mandatoryTempStcwDocName = [];
    _mandatoryTempCertificateNo = [];
    _mandatoryTempIssueDate = [];
    _mandatoryTempRadioValue = [];
    _mandatoryTempValidTillText = [];

    _optionalTempStcwDocName = [];
    _optionalTempCertificateNo = [];
    _optionalTempIssueDate = [];
    _optionalTempRadioValue = [];
    _optionalTempValidTillText = [];
    if (mandatoryCall) {
      for (int i = 0;
          i <
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .stcwMandatoryLength;
          i++) {
        _mandatoryTempStcwDocName.add(_mandatoryDocValue[i]);
        _mandatoryTempCertificateNo.add(_stcwMandatoryCertificateNo[i].text);
        _mandatoryTempIssueDate.add(_stcwMandatoryIssueDate[i].text);
        _mandatoryTempValidTillText.add(_stcwMandatoryExpiryDate[i].text);
        List<bool> tempList = [];
        for (int k = 0; k < 3; k++) {
          if (_mandatoryValidTillOptionsStcwBloc[i][k].radioValue) {
            tempList.add(true);
          } else {
            tempList.add(false);
          }
        }
        _mandatoryTempRadioValue.add(tempList);
      }

      _mandatoryDocValue.clear();
      _stcwMandatoryCertificateNo.clear();
      _stcwMandatoryIssueDate.clear();
      _stcwMandatoryExpiryDate.clear();
    } else {
      for (int i = 0;
          i <
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                  .competencyOptionalLength;
          i++) {
        _optionalTempStcwDocName.add(_optionalDocValue[i]);
        _optionalTempCertificateNo.add(_stcwOptionalCertificateNo[i].text);
        _optionalTempIssueDate.add(_stcwOptionalIssueDate[i].text);
        _optionalTempValidTillText.add(_stcwOptionalExpiryDate[i].text);
        List<bool> tempList = [];
        for (int k = 0; k < 3; k++) {
          if (_optionalValidTillOptionsStcwBloc[i][k].radioValue) {
            tempList.add(true);
          } else {
            tempList.add(false);
          }
        }
        _optionalTempRadioValue.add(tempList);
      }

      _optionalDocValue.clear();
      _stcwOptionalCertificateNo.clear();
      _stcwOptionalIssueDate.clear();
      _stcwOptionalExpiryDate.clear();
    }
  }

  void addDefaultSTCWRecords() {
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwMandatoryLength;
        i++) {
      _mandatoryShowValidTillDate.add(RadioButtonBloc());
      _stcwMandatoryIssueDate.add(TextEditingController());
      _stcwMandatoryCertificateNo.add(TextEditingController());
      _stcwMandatoryExpiryDate.add(TextEditingController());
      _stcwMandatoryValidDateErrorBloc.add(ResumeErrorIssuingAuthorityBloc());
      _displayStcwMandatoryValidDate.add(RadioButtonBloc());
      _showMandatoryDropDownBloc.add(IndosNoBloc());
      _mandatoryErrorSTCWDocName.add(ResumeErrorIssuingAuthorityBloc());
      _mandatoryDocDropdownBloc.add(DropdownBloc());
      _mandatoryDocValue.add("");
      List<RadioButtonBloc> tempValidTillDatebloc = [];
      for (int k = 0; k < 3; k++) {
        tempValidTillDatebloc.add(RadioButtonBloc());
      }
      _mandatoryValidTillOptionsStcwBloc.add(tempValidTillDatebloc);

      if (i <
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .stcwExpiryDate
              .length) {
        _stcwMandatoryCertificateNo[i].text =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwCertificateNo[i];
        _stcwMandatoryExpiryDate[i].text =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwExpiryDate[i];
        _stcwMandatoryIssueDate[i].text =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwIssueDate[i];
        _mandatoryDocValue[i] =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwDocumentName[i];
      }
    }

    if (_mandatoryTempStcwDocName.isNotEmpty) {
      _assignTempData(true);
    }
  }

  void addDefaultOptionalSTCWRecords() {
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalLength;
        i++) {
      _optionalShowValidTillDate.add(RadioButtonBloc());
      _stcwOptionalIssueDate.add(TextEditingController());
      _stcwOptionalCertificateNo.add(TextEditingController());
      _stcwOptionalExpiryDate.add(TextEditingController());
      _stcwOptionalValidDateErrorBloc.add(ResumeErrorIssuingAuthorityBloc());
      _displayStcwOptionalValidDate.add(RadioButtonBloc());
      _optionalErrorSTCWDocName.add(ResumeErrorIssuingAuthorityBloc());
      _optionalDocDropdownBloc.add(DropdownBloc());
      _showMandatoryDropDownBloc.add(IndosNoBloc());
      _optionalDocValue.add("");
      List<RadioButtonBloc> tempValidTillDatebloc = [];
      for (int k = 0; k < 3; k++) {
        tempValidTillDatebloc.add(RadioButtonBloc());
      }
      _optionalValidTillOptionsStcwBloc.add(tempValidTillDatebloc);

      if (i <
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .stcwOptionalExpiryDate
              .length) {
        _stcwOptionalCertificateNo[i].text =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalCertificateNo[i];
        _stcwOptionalExpiryDate[i].text =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalExpiryDate[i];
        _stcwOptionalIssueDate[i].text =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalIssueDate[i];
        _optionalDocValue[i] =
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalDocumentName[i];
      }
    }
    if (_optionalTempStcwDocName.isNotEmpty) {
      _assignTempData(false);
    }
  }

  bool checkError() {
    bool data = false;
    data = checkMandatoryDocAvailability();
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwMandatoryLength;
        i++) {
      bool tempData = checkValidTillDates(i, true);
      if (!tempData && data) {
        data = true;
      } else {
        data = tempData;
      }
      if (_mandatoryDocValue[i].isEmpty) {
        _mandatoryErrorSTCWDocName[i]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        data = true;
      } else {
        if (_mandatoryDocValue[i].isEmpty) {
          _mandatoryErrorSTCWDocName[i]
              .eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.True);
          data = true;
        }
      }
    }

    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalLength;
        i++) {
      data = checkValidTillDates(i, false);
      if (_optionalDocValue[i].isEmpty) {
        _optionalErrorSTCWDocName[i]
            .eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
        data = true;
      } else {
        if (_optionalDocValue[i].isEmpty) {
          _optionalErrorSTCWDocName[i]
              .eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.True);
          data = true;
        }
      }
    }
    return data;
  }

  bool checkMandatoryDocAvailability() {
    bool data = false;
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwMandatoryDocName
                .length;
        i++) {
      if (!_mandatoryDocValue.contains(
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .stcwMandatoryDocName[i])) {
        data = true;
        _selectMandatoryDocError.eventResumeIssuingAuthoritySink
            .add(ResumeErrorIssuingAuthorityAction.True);
      }
    }
    if (Provider.of<ResumeDocumentProvider>(context, listen: false)
            .stcwMandatoryLength ==
        0) {
      _selectMandatoryDocError.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.True);
      data = true;
    } else if (!data) {
      _selectMandatoryDocError.eventResumeIssuingAuthoritySink
          .add(ResumeErrorIssuingAuthorityAction.False);
    }

    return data;
  }

  bool checkValidTillDates(int i, bool isMandatory) {
    List<bool> stcwValid = [];
    for (int k = 0; k < 3; k++) {
      stcwValid.add(isMandatory
          ? _mandatoryValidTillOptionsStcwBloc[i][k].radioValue
          : _optionalValidTillOptionsStcwBloc[i][k].radioValue);
    }

    if (!stcwValid.contains(true)) {
      isMandatory
          ? _stcwMandatoryValidDateErrorBloc[i]
              .eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.True)
          : _stcwOptionalValidDateErrorBloc[i]
              .eventResumeIssuingAuthoritySink
              .add(ResumeErrorIssuingAuthorityAction.True);
      return true;
    } else {
      return false;
    }
  }

  List<PostStcwData> callPostOptionalRecords() {
    List<PostStcwData> postStcwData = [];
    for (int i = 0;
        i <
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalLength;
        i++) {
      String expiry = "";
      for (int k = 0; k < 3; k++) {
        if (_optionalValidTillOptionsStcwBloc[i][k].radioValue) {
          expiry = Provider.of<GetValidTypeProvider>(context, listen: false)
              .validTypeId[k];
        }
      }
      String id = "";
      if (i <
          Provider.of<ResumeDocumentProvider>(context, listen: false)
              .stcwOptionalUserId
              .length) {
        id = Provider.of<ResumeDocumentProvider>(context, listen: false)
            .stcwOptionalUserId[i];
      } else {
        id = "";
      }
      postStcwData.add(PostStcwData(
        certificateNo: _stcwOptionalCertificateNo[i].text,
        id: id,
        documentId: Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalDocId[
            Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalDocName
                .indexOf(_optionalDocValue[i])],
        validDate: _stcwOptionalExpiryDate[i].text,
        issueDate: _stcwOptionalIssueDate[i].text,
        validType: expiry,
      ));
    }

    return postStcwData;
  }

  void _assignTempData(bool isMandatory) {
    if (isMandatory) {
      for (int i = 0;
          i <
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .stcwMandatoryLength -
                  1;
          i++) {
        _mandatoryDocValue[i] = _mandatoryTempStcwDocName[i];
        _stcwMandatoryCertificateNo[i].text = _mandatoryTempCertificateNo[i];
        _stcwMandatoryIssueDate[i].text = _mandatoryTempIssueDate[i];
        _stcwMandatoryExpiryDate[i].text = _mandatoryTempValidTillText[i];
      }

      _mandatoryTempStcwDocName.clear();
      _mandatoryTempCertificateNo.clear();
      _mandatoryTempIssueDate.clear();
      _mandatoryTempValidTillText.clear();
    } else {
      for (int i = 0;
          i <
              Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .stcwOptionalLength -
                  1;
          i++) {
        _optionalDocValue[i] = _optionalTempStcwDocName[i];
        _stcwOptionalCertificateNo[i].text = _optionalTempCertificateNo[i];
        _stcwOptionalIssueDate[i].text = _optionalTempIssueDate[i];
        _stcwOptionalExpiryDate[i].text = _optionalTempValidTillText[i];
      }

      _optionalTempStcwDocName.clear();
      _optionalTempCertificateNo.clear();
      _optionalTempIssueDate.clear();
      _optionalTempValidTillText.clear();
    }
  }
}
