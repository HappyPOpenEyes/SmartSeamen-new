// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartseaman/DropdownContainer.dart';
import 'package:smartseaman/SearchTextProvider.dart';

import '../../DropdownBloc.dart';
import '../../IssuingAuthorityErrorBloc.dart';
import '../../RadioButtonBloc.dart';
import '../../TextBoxLabel.dart';
import '../../asynccallprovider.dart';
import '../../constants.dart';
import '../Header.dart';
import '../PersonalInformation/ExpandedAnimation.dart';
import '../PersonalInformation/IndosNoBloc.dart';
import '../PersonalInformation/RankBloc.dart';
import '../PersonalInformation/Scrollbar.dart';
import '../PersonalInformation/VesselBloc.dart';
import 'DeleteSeaServiceRecord.dart';
import 'EditSeaServiceProvider.dart';
import 'EngineBloc.dart';
import 'PostSeaServiceRecord.dart';
import 'SeaServiceProvider.dart';
import 'SeaServiceRecord.dart';
import 'ShowEngineBloc.dart';

class EditSeaServiceRecord extends StatefulWidget {
  const EditSeaServiceRecord({Key? key}) : super(key: key);

  @override
  _EditSeaServiceRecordState createState() => _EditSeaServiceRecordState();
}

class _EditSeaServiceRecordState extends State<EditSeaServiceRecord> {
  List<TextEditingController> _vessenameController = [],
      _grossTonnController = [],
      _signOnDateController = [],
      _signOffDateController = [],
      _imoNumberController = [],
      _companyNameController = [];
  List<String> _selectedvesseltype = [],
      _selectedEngine = [],
      _selectedRank = [];
  final List<DropdownBloc> _vesseltypedropdownBloc = [],
      _enginedropdownBloc = [],
      _rankdropdownBloc = [];
  final List<VesselBloc> _vesselBloc = [];
  final List<EngineBloc> _engineBloc = [];
  final List<RankBloc> _rankBloc = [];
  final List<ShowEngineBloc> _showEngineBloc = [];
  static final _formKey = GlobalKey<FormState>();
  final List<ResumeErrorIssuingAuthorityBloc> _errorVehicleTypeBloc = [],
      _errorEngineBloc = [],
      _errorRankBloc = [];
  var header;
  final List<FocusNode> _vesselNameFocus = [];
  DateTime signOnselectedDate = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final List<RadioButtonBloc> _showSignoffDate = [],
      _showVesselBloc = [],
      _displaySeaServiceValidDate = [];
  List<bool> isStrechedDropDown = [];
  final List<IndosNoBloc> _showdropdownShowBloc = [],
      _showRankDropDownBloc = [],
      _showEngineDropDownBloc = [];

  @override
  void initState() {
    getdata();
    super.initState();
  }

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
    // TODO: implement dispose
    for (int i = 0;
        i <
            Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                .length;
        i++) {
      _engineBloc[i].dispose();
      _rankBloc[i].dispose();
      _vesselBloc[i].dispose();
      _enginedropdownBloc[i].dispose();
      _rankdropdownBloc[i].dispose();
      _vesseltypedropdownBloc[i].dispose();
      _showEngineBloc[i].dispose();
      _showSignoffDate[i].dispose();
      _showVesselBloc[i].dispose();
      _showRankDropDownBloc[i].dispose();
      _showdropdownShowBloc[i].dispose();
      _showEngineDropDownBloc[i].dispose();
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
              ResumeHeader('Sea Service Record', 4, true, ""),
              InkWell(
                onTap: () {
                  ResumeSeaServiceProvider seaServiceProvider =
                      Provider.of<ResumeSeaServiceProvider>(context,
                          listen: false);
                  setState(() {
                    seaServiceProvider.increaselength();
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
                      ),
                      Text('Add Vessel',
                          style: TextStyle(
                              color: kBluePrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035)),
                    ],
                  ),
                ),
              ),
              Provider.of<AsyncCallProvider>(context, listen: false)
                      .isinasynccall
                  ? const SizedBox()
                  : _displayEditSeaServiceCard(),
            ],
          ),
        ),
      ),
    );
  }

  _displayEditSeaServiceCard() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        //color: kgreenPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: Provider.of<ResumeSeaServiceProvider>(context,
                            listen: false)
                        .length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          _displayVesselPreferencesData(index),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // ignore: unnecessary_statements
                          for (int i = 0; i < _selectedvesseltype.length; i++) {
                            if (_selectedvesseltype[i].isEmpty) {
                              _errorVehicleTypeBloc[i]
                                  .eventResumeIssuingAuthoritySink
                                  .add(ResumeErrorIssuingAuthorityAction.True);
                            }
                          }
                          for (int i = 0; i < _selectedEngine.length; i++) {
                            if (_showEngineBloc[i].showEngine) {
                              if (_selectedEngine[i].isEmpty) {
                                _errorEngineBloc[i]
                                    .eventResumeIssuingAuthoritySink
                                    .add(
                                        ResumeErrorIssuingAuthorityAction.True);
                              }
                            } else {
                              _errorEngineBloc[i]
                                  .eventResumeIssuingAuthoritySink
                                  .add(ResumeErrorIssuingAuthorityAction.False);
                            }
                          }
                          for (int i = 0; i < _selectedRank.length; i++) {
                            if (_selectedRank[i].isEmpty) {
                              _errorRankBloc[i]
                                  .eventResumeIssuingAuthoritySink
                                  .add(ResumeErrorIssuingAuthorityAction.True);
                            }
                          }
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            callPostSeaServiceRecord();
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

  _displayVesselPreferencesData(int index) {
    return Card(
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
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Vessel ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => _showDeleteDialog(index),
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red[500],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _displayVesselNameTF(true, index),
            const SizedBox(
              height: 10,
            ),
            _displayVesselTypeDropdown(index),
            _displayErrorText(
                index, 'Please select the vehicle type', _errorVehicleTypeBloc),
            const SizedBox(
              height: 10,
            ),
            _displayVesselNameTF(false, index),
            const SizedBox(
              height: 10,
            ),
            _displayGrossTonTF(index),
            const SizedBox(
              height: 10,
            ),
            _displayImoNumberTF(index),
            const SizedBox(
              height: 10,
            ),
            _displayRankDropdown(index),
            _displayErrorText(index, 'Please select the rank', _errorRankBloc),
            const SizedBox(
              height: 10,
            ),
            _displayEngineDropdown(index),
            _displayErrorText(
                index, 'Please select the engine', _errorEngineBloc),
            const SizedBox(
              height: 10,
            ),
            _displaySignOnDate(index, true),
            const SizedBox(
              height: 10,
            ),
            _displaySignOnDate(index, false),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _displayVesselNameTF(bool isVessel, int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
              ],
              focusNode: isVessel ? _vesselNameFocus[index] : FocusNode(),
              cursorColor: kgreenPrimaryColor,
              controller: isVessel
                  ? _vessenameController[index]
                  : _companyNameController[index],
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (isVessel) {
                  if (value.isNotEmpty) {
                    removeError(error: 'Please enter the vessel name');
                  }
                } else {
                  if (value.isNotEmpty) {
                    removeError(error: 'Please enter the company name');
                  }
                }
              },
              validator: (value) {
                if (isVessel) {
                  if (value!.isEmpty) {
                    return 'Please enter the vessel name';
                    //addError(error: kEmailNullError);

                  }
                } else {
                  if (value!.isEmpty) {
                    return 'Please enter the company name';
                    //addError(error: kEmailNullError);

                  }
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
                  hintText: isVessel
                      ? 'Enter your Vessel Name'
                      : 'Enter your Company Name',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel(isVessel ? 'Vessel Name' : 'Company Name')
      ],
    );
  }

  _displayVesselTypeDropdown(int index) {
    if (Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      return const SizedBox();
    } else {
      return StreamBuilder(
        stream: _vesselBloc[index].stateVesselStrean,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                .vesselTypeName
                .isNotEmpty) {
              if (index !=
                  Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                      .vesselTypeName
                      .length) {
                _vesseltypedropdownBloc[index].setdropdownvalue(
                    _selectedvesseltype[index] =
                        Provider.of<ResumeSeaServiceProvider>(context,
                                listen: false)
                            .vesselTypeName[index]);
                _vesseltypedropdownBloc[index]
                    .eventDropdownSink
                    .add(DropdownAction.Update);
              }
            }
            return Stack(
              children: [
                StreamBuilder(
                  initialData: false,
                  stream: _errorVehicleTypeBloc[index]
                      .stateResumeIssuingAuthorityStrean,
                  builder: (context, errorsnapshot) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: _errorVehicleTypeBloc[index].showtext
                                  ? Colors.red
                                  : Colors.grey),
                          borderRadius: const BorderRadius.all(Radius.circular(
                                  20.0) //                 <--- border radius here
                              ),
                        ),
                        child: showVesselDropdown(index),
                      ),
                    );
                  },
                ),
                TextBoxLabel('Vessel Type')
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      );
    }
  }

  _displayGrossTonTF(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              ],
              cursorColor: kgreenPrimaryColor,
              controller: _grossTonnController[index],
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter the gross tonnage');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the gross tonnage';
                  //addError(error: kEmailNullError);

                }
                return null;
              },
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 34),
                  //floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter your Gross Tonnage',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Gross Tonnage')
      ],
    );
  }

  _displayEngineDropdown(int index) {
    if (Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      return const SizedBox();
    } else {
      return StreamBuilder(
        initialData: Provider.of<ResumeSeaServiceProvider>(context,
                    listen: false)
                .ranktype
                .isEmpty
            ? true
            : index <
                    Provider.of<ResumeSeaServiceProvider>(context,
                            listen: false)
                        .ranktype
                        .length
                ? Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                            .ranktype[index] ==
                        "14"
                    ? false
                    : true
                : true,
        stream: _showEngineBloc[index].stateShowEngineStrean,
        builder: (context, enginesnapshot) {
          if (_showEngineBloc[index].showEngine) {
            return StreamBuilder(
              stream: _engineBloc[index].stateEngineStrean,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (Provider.of<ResumeSeaServiceProvider>(context,
                          listen: false)
                      .engine_name
                      .isNotEmpty) {
                    if (index !=
                        Provider.of<ResumeSeaServiceProvider>(context,
                                listen: false)
                            .engine_name
                            .length) {
                      if (_selectedEngine[index] == "") {
                        _enginedropdownBloc[index].setdropdownvalue(
                            _selectedEngine[index] =
                                Provider.of<ResumeSeaServiceProvider>(context,
                                        listen: false)
                                    .engine_name[index]);
                        _enginedropdownBloc[index]
                            .eventDropdownSink
                            .add(DropdownAction.Update);
                      }
                    }
                  }
                  return Stack(
                    children: [
                      StreamBuilder(
                        initialData: false,
                        stream: _errorEngineBloc[index]
                            .stateResumeIssuingAuthorityStrean,
                        builder: (context, snapshot) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0,
                                    color: _errorEngineBloc[index].showtext
                                        ? Colors.red
                                        : Colors.grey),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                        20.0) //                 <--- border radius here
                                    ),
                              ),
                              child: StreamBuilder(
                                stream: _enginedropdownBloc[index]
                                    .stateDropdownStrean,
                                builder: (context, dropdownsnapshot) {
                                  return StreamBuilder(
                                    stream: _showEngineDropDownBloc[index]
                                        .stateIndosNoStrean,
                                    initialData: false,
                                    builder: (context, snapshot) {
                                      return Column(
                                        children: [
                                          DrodpownContainer(
                                            title: _selectedEngine[index]
                                                    .isNotEmpty
                                                ? _selectedEngine[index]
                                                : 'Select Engine',
                                            searchHint: 'Search Engine',
                                            showDropDownBloc:
                                                _showEngineDropDownBloc[index],
                                            originalList:
                                                _engineBloc[index].enginename,
                                          ),
                                          ExpandedSection(
                                            expand:
                                                _showEngineDropDownBloc[index]
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
                                                                      listen:
                                                                          false)
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
                                                                  : _engineBloc[index]
                                                                      .enginename
                                                                      .length,
                                                          itemBuilder: (context,
                                                              listindex) {
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
                                                                      if (!Provider.of<SearchChangeProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .noDataFound) {
                                                                        _showEngineDropDownBloc[index]
                                                                            .eventIndosNoSink
                                                                            .add(IndosNoAction.False);

                                                                        _selectedEngine[
                                                                            index] = Provider.of<SearchChangeProvider>(context, listen: false)
                                                                                .searchList
                                                                                .isNotEmpty
                                                                            ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[listindex]
                                                                            : _engineBloc[index].enginename[listindex];

                                                                        _enginedropdownBloc[index].setdropdownvalue(Provider.of<SearchChangeProvider>(context, listen: false).searchList.isNotEmpty
                                                                            ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[listindex]
                                                                            : _engineBloc[index].enginename[listindex]);
                                                                        _enginedropdownBloc[index]
                                                                            .eventDropdownSink
                                                                            .add(DropdownAction.Update);
                                                                        Provider.of<SearchChangeProvider>(context,
                                                                                listen: false)
                                                                            .searchKeyword = "";
                                                                        Provider.of<SearchChangeProvider>(context,
                                                                                listen: false)
                                                                            .searchList = [];
                                                                        _errorEngineBloc[index]
                                                                            .eventResumeIssuingAuthoritySink
                                                                            .add(ResumeErrorIssuingAuthorityAction.False);
                                                                      }
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      child: Text(Provider.of<SearchChangeProvider>(context, listen: false)
                                                                              .noDataFound
                                                                          ? 'No Data Found'
                                                                          : Provider.of<SearchChangeProvider>(context, listen: false).searchList.isNotEmpty
                                                                              ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[listindex]
                                                                              : _engineBloc[index].enginename[listindex]),
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
                      TextBoxLabel('Engine')
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          } else {
            return const SizedBox();
          }
        },
      );
    }
  }

  _displayRankDropdown(int index) {
    if (Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      return const SizedBox();
    } else {
      return StreamBuilder(
        stream: _rankBloc[index].stateRankStrean,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (index <
                Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                    .rank_name
                    .length) {
              _rankdropdownBloc[index].setdropdownvalue(_selectedRank[index] =
                  Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                      .rank_name[index]);
              _rankdropdownBloc[index]
                  .eventDropdownSink
                  .add(DropdownAction.Update);
            }
            return Stack(
              children: [
                StreamBuilder(
                  initialData: false,
                  stream:
                      _errorRankBloc[index].stateResumeIssuingAuthorityStrean,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: _errorRankBloc[index].showtext
                                  ? Colors.red
                                  : Colors.grey),
                          borderRadius: const BorderRadius.all(Radius.circular(
                                  20.0) //                 <--- border radius here
                              ),
                        ),
                        child: StreamBuilder(
                          stream: _rankdropdownBloc[index].stateDropdownStrean,
                          builder: (context, dropdownsnapshot) {
                            return StreamBuilder(
                              stream: _showRankDropDownBloc[index]
                                  .stateIndosNoStrean,
                              initialData: false,
                              builder: (context, snapshot) {
                                return Column(
                                  children: [
                                    DrodpownContainer(
                                      title: _selectedRank[index].isNotEmpty
                                          ? _selectedRank[index]
                                          : 'Select Rank',
                                      searchHint: 'Search Rank',
                                      showDropDownBloc:
                                          _showRankDropDownBloc[index],
                                      originalList: _rankBloc[index].rankname,
                                    ),
                                    ExpandedSection(
                                      expand:
                                          _showRankDropDownBloc[index].isedited,
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
                                                            : _rankBloc[index]
                                                                .rankname
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
                                                                  _showRankDropDownBloc[
                                                                          index]
                                                                      .eventIndosNoSink
                                                                      .add(IndosNoAction
                                                                          .False);
                                                                  _errorRankBloc[
                                                                          index]
                                                                      .eventResumeIssuingAuthoritySink
                                                                      .add(ResumeErrorIssuingAuthorityAction
                                                                          .False);
                                                                  _selectedRank[
                                                                      index] = Provider.of<SearchChangeProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .searchList
                                                                          .isNotEmpty
                                                                      ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                          listindex]
                                                                      : _rankBloc[index]
                                                                              .rankname[
                                                                          listindex];

                                                                  _rankdropdownBloc[index].setdropdownvalue(Provider.of<SearchChangeProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .searchList
                                                                          .isNotEmpty
                                                                      ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                          listindex]
                                                                      : _rankBloc[index]
                                                                              .rankname[
                                                                          listindex]);
                                                                  _rankdropdownBloc[
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
                                                                  _errorRankBloc[
                                                                          index]
                                                                      .eventResumeIssuingAuthoritySink
                                                                      .add(ResumeErrorIssuingAuthorityAction
                                                                          .False);
                                                                  if (_rankBloc[
                                                                              index]
                                                                          .ranktype[_rankBloc[
                                                                              index]
                                                                          .rankname
                                                                          .indexOf(
                                                                              _rankBloc[index].rankname[listindex])] ==
                                                                      "14") {
                                                                    _showEngineBloc[
                                                                            index]
                                                                        .eventShowEngineSink
                                                                        .add(ShowEngineAction
                                                                            .False);
                                                                  } else {
                                                                    _engineBloc[
                                                                            index]
                                                                        .eventEngineSink
                                                                        .add(EngineAction
                                                                            .Post);
                                                                    _showEngineBloc[
                                                                            index]
                                                                        .eventShowEngineSink
                                                                        .add(ShowEngineAction
                                                                            .True);
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
                                                                        : _rankBloc[index]
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
                    );
                  },
                ),
                TextBoxLabel('Rank')
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      );
    }
  }

  _displaySignOnDate(int index, bool isSignOn) {
    return StreamBuilder(
      stream: _showSignoffDate[index].stateRadioButtonStrean,
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
                      : _signOnDateController[index].text.isNotEmpty
                          ? true
                          : false,
                  cursorColor: kgreenPrimaryColor,
                  controller: isSignOn
                      ? _signOnDateController[index]
                      : _signOffDateController[index],
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: kblackPrimaryColor,
                    fontFamily: 'OpenSans',
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: 'Please select the date');
                    }
                    if (value.isEmpty && isSignOn) {
                      _showSignoffDate[index]
                          .eventRadioButtonSink
                          .add(RadioButtonAction.True);
                      _signOffDateController[index].clear();
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
                        onTap: () => _selectDate(context, index, isSignOn),
                        child: const Icon(
                          Icons.date_range,
                          color: kBluePrimaryColor,
                        ),
                      ),
                      hintText: isSignOn
                          ? 'Enter your Sign on Date'
                          : 'Enter your Sign off Date',
                      hintStyle: hintstyle),
                ),
              ),
            ),
            TextBoxLabel(isSignOn ? 'Sign on Date' : 'Sign off Date')
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, int index, bool isSignOn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: signOnselectedDate,
      firstDate: isSignOn
          ? DateTime(2015, 8)
          : DateTime.parse(_signOnDateController[index].text),
      lastDate: isSignOn ? signOnselectedDate : DateTime(2101),
    );
    if (isSignOn) {
      if (picked != null && picked != signOnselectedDate) {
        _signOnDateController[index].text = formatter.format(picked);
        setState(() {
          _showSignoffDate[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _showSignoffDate[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.False);
          _showSignoffDate[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _showSignoffDate[index].radioValue = true;
        });
      }
    } else {
      if (picked != null && picked != signOnselectedDate) {
        _signOffDateController[index].text = formatter.format(picked);
      }
    }
  }

  void getdata() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditSeaServiceRecord(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    asyncProvider.changeAsynccall();

    var focuscount = 0;
    for (int i = 0;
        i <
            Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                .length;
        i++) {
      _showRankDropDownBloc.add(IndosNoBloc());
      _showEngineDropDownBloc.add(IndosNoBloc());
      isStrechedDropDown.add(false);
      _showdropdownShowBloc.add(IndosNoBloc());
      _showSignoffDate.add(RadioButtonBloc());
      _showVesselBloc.add(RadioButtonBloc());
      _showEngineBloc.add(ShowEngineBloc());
      _vesselBloc.add(VesselBloc());
      _engineBloc.add(EngineBloc());
      _rankBloc.add(RankBloc());
      _displaySeaServiceValidDate.add(RadioButtonBloc());
      _vesselBloc[i].header =
          _engineBloc[i].header = _rankBloc[i].header = header;
      _vesselBloc[i].eventVesselSink.add(VesselAction.Post);
      _engineBloc[i].eventEngineSink.add(EngineAction.Post);
      _rankBloc[i].eventRankSink.add(RankAction.Post);
      _enginedropdownBloc.add(DropdownBloc());
      _rankdropdownBloc.add(DropdownBloc());
      _vesseltypedropdownBloc.add(DropdownBloc());
      _vesselNameFocus.add(FocusNode());
      _vessenameController.add(TextEditingController());
      _imoNumberController.add(TextEditingController());
      _grossTonnController.add(TextEditingController());
      _companyNameController.add(TextEditingController());
      _signOnDateController.add(TextEditingController());

      _signOffDateController.add(TextEditingController());

      _selectedvesseltype.add("");
      _selectedEngine.add("");
      _selectedRank.add("");

      _errorVehicleTypeBloc.add(ResumeErrorIssuingAuthorityBloc());
      _errorEngineBloc.add(ResumeErrorIssuingAuthorityBloc());
      _errorRankBloc.add(ResumeErrorIssuingAuthorityBloc());
      if (Provider.of<ResumeSeaServiceProvider>(context, listen: false)
          .vessel_name
          .isNotEmpty) {
        if (i !=
            Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                .vessel_name
                .length) {
          if (Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                  .ranktype[i] ==
              "14") {
            _showEngineBloc[i].showEngine = false;
          }
          _companyNameController[i].text =
              Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                  .companyName[i];
          _vessenameController[i].text =
              Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                  .vessel_name[i];
          _imoNumberController[i].text =
              Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                  .imo_number[i];
          _grossTonnController[i].text =
              Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                  .gross_tonnage[i];
          _signOnDateController[i].text =
              Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                  .signondate[i];
          _signOffDateController[i].text =
              Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                  .signoffdate[i];
        } else {
          focuscount = 1;
        }
      }
      if (focuscount == 1) {
        _vesselNameFocus[
                Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                        .length -
                    1]
            .requestFocus();
      }
    }
    asyncProvider.changeAsynccall();
  }

  _displayErrorText(int index, String s, var bloc) {
    return StreamBuilder(
      initialData: false,
      stream: bloc[index].stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && bloc[index].showtext) {
          return Visibility(
            visible: bloc[index].showtext,
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

  void _showDeleteDialog(int index) {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: const Text('Delete Sea Service Record',
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
                        deleterecord(index);
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

  void deleterecord(int index) async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditSeaServiceRecord(), context);
    if (index >=
        Provider.of<ResumeSeaServiceProvider>(context, listen: false)
            .vesselTypeName
            .length) {
      if (Provider.of<ResumeSeaServiceProvider>(context, listen: false)
              .vesselTypeName
              .isNotEmpty ||
          index != 0) {
        ResumeSeaServiceProvider seaServiceProvider =
            Provider.of<ResumeSeaServiceProvider>(context, listen: false);
        setState(() {
          seaServiceProvider.decreaselength();
          _vessenameController.removeLast();
          _imoNumberController.removeLast();
          _grossTonnController.removeLast();
          _signOnDateController.removeLast();
          _signOffDateController.removeLast();
          _selectedvesseltype.removeLast();
          _selectedEngine.removeLast();
          _selectedRank.removeLast();
          cleardata();
          getdata();
        });
      }
    } else {
      ResumeEditSeaServiceDeleteProvider seaDelteServiceProvider =
          Provider.of<ResumeEditSeaServiceDeleteProvider>(context,
              listen: false);
      AsyncCallProvider asyncProvider =
          Provider.of<AsyncCallProvider>(context, listen: false);

      if (!Provider.of<AsyncCallProvider>(context, listen: false)
          .isinasynccall) {
        asyncProvider.changeAsynccall();
      }
      if (await seaDelteServiceProvider.callpostDeleteResumeSeaServiceapi(
          Provider.of<ResumeSeaServiceProvider>(context, listen: false)
              .vesselId[index],
          header)) {
        asyncProvider.changeAsynccall();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'DeleteSuccesful', 'Record has been deleted successfully');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SeaServiceRecord()));
      } else {
        asyncProvider.changeAsynccall();
        displaysnackbar('Something went wrong');
      }
    }
  }

  void cleardata() {
    _vessenameController = [];
    _imoNumberController = [];
    _grossTonnController = [];
    _signOnDateController = [];
    _signOffDateController = [];
    _selectedvesseltype = [];
    _selectedEngine = [];
    _selectedRank = [];
    _vesselNameFocus.clear();
    _vesseltypedropdownBloc.clear();
    _enginedropdownBloc.clear();
    _rankdropdownBloc.clear();
    _errorVehicleTypeBloc.clear();
    _errorEngineBloc.clear();
    _errorRankBloc.clear();
  }

  void callPostSeaServiceRecord() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditSeaServiceRecord(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    List<Item> postList = [];

    for (int i = 0;
        i <
            Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                .length;
        i++) {
      postList.add(Item(
          signOff: _signOffDateController[i].text,
          signOn: _signOnDateController[i].text,
          vesselName: _vessenameController[i].text,
          vesselType: _vesselBloc[i].vesselid[
              _vesselBloc[i].vesselname.indexOf(_selectedvesseltype[i])],
          companyName: _companyNameController[i].text,
          imoNumber: _imoNumberController[i].text,
          grossTonnage: _grossTonnController[i].text,
          engineId: _showEngineBloc[i].showEngine
              ? _engineBloc[i].engineid[
                  _engineBloc[i].enginename.indexOf(_selectedEngine[i])]
              : "",
          rankId: _rankBloc[i]
              .rankid[_rankBloc[i].rankname.indexOf(_selectedRank[i])],
          id: Provider.of<ResumeSeaServiceProvider>(context, listen: false)
                  .vesselId
                  .isEmpty
              ? null
              : i <
                      Provider.of<ResumeSeaServiceProvider>(context,
                              listen: false)
                          .vesselId
                          .length
                  ? Provider.of<ResumeSeaServiceProvider>(context,
                          listen: false)
                      .vesselId[i]
                  : "",
          validTillType: ''));
    }

    for (int i = 0; i < postList.length; i++) {
      print(postList[i].engineId);
      print(postList[i].grossTonnage);
      print(postList[i].id);
      print(postList[i].imoNumber);
      print(postList[i].rankId);
      print(postList[i].signOff);
      print(postList[i].signOn);
    }
    ResumeEditSeaServiceUpdateProvider getResumeSeaServiceProvider =
        Provider.of<ResumeEditSeaServiceUpdateProvider>(context, listen: false);

    if (!await getResumeSeaServiceProvider.callpostResumeSeaServiceapi(
        postList, header)) {
      asyncProvider.changeAsynccall();
      displaysnackbar('Something went wrong');
    } else {
      asyncProvider.changeAsynccall();
      Provider.of<ResumeSeaServiceProvider>(context, listen: false).isComplete =
          true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('RecordAdded', 'Record has been added successfully');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SeaServiceRecord()));
    }
  }

  _displayImoNumberTF(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              ],
              cursorColor: kgreenPrimaryColor,
              controller: _imoNumberController[index],
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter the IMO number');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the IMO number';
                  //addError(error: kEmailNullError);

                }
                return null;
              },
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 34),
                  //floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter your IMO Number',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('IMO Number')
      ],
    );
  }

  showVesselDropdown(int index) {
    return StreamBuilder(
        stream: _showVesselBloc[index].stateRadioButtonStrean,
        builder: (context, textsnapshot) {
          return StreamBuilder(
              stream: _showdropdownShowBloc[index].stateIndosNoStrean,
              builder: (context, dropsnapshot) {
                return Column(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 10),
                                child: Text(
                                  _selectedvesseltype[index].isNotEmpty
                                      ? _selectedvesseltype[index]
                                      : 'Select Vessel Type',
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  if (_showdropdownShowBloc[index].isedited) {
                                    _showdropdownShowBloc[index]
                                        .eventIndosNoSink
                                        .add(IndosNoAction.False);
                                  } else {
                                    _showdropdownShowBloc[index]
                                        .eventIndosNoSink
                                        .add(IndosNoAction.True);
                                  }
                                },
                                child: Icon(isStrechedDropDown[index]
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward))
                          ],
                        )),
                    StreamBuilder(
                      stream: _showdropdownShowBloc[index].stateIndosNoStrean,
                      initialData: false,
                      builder: (context, snapshot) {
                        return ExpandedSection(
                          expand: _showdropdownShowBloc[index].isedited,
                          height: 100,
                          child: MyScrollbar(
                            builder: (context, scrollController2) =>
                                ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    controller: scrollController2,
                                    shrinkWrap: true,
                                    itemCount:
                                        _vesselBloc[index].itemVessel.length,
                                    itemBuilder: (context, innerindex) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _vesselBloc[index]
                                                        .itemVessel[innerindex]
                                                        .type ==
                                                    "ItemClass.FIRST_LEVEL"
                                                ? Text(
                                                    _vesselBloc[index]
                                                        .itemVessel[innerindex]
                                                        .name,
                                                    style: const TextStyle(
                                                        color: Colors.grey))
                                                : InkWell(
                                                    onTap: () {
                                                      _errorVehicleTypeBloc[
                                                              index]
                                                          .eventResumeIssuingAuthoritySink
                                                          .add(
                                                              ResumeErrorIssuingAuthorityAction
                                                                  .False);
                                                      _selectedvesseltype[
                                                              index] =
                                                          _vesselBloc[index]
                                                              .itemVessel[
                                                                  innerindex]
                                                              .name;
                                                      _showdropdownShowBloc[
                                                              index]
                                                          .eventIndosNoSink
                                                          .add(IndosNoAction
                                                              .False);
                                                      _showVesselBloc[index]
                                                          .eventRadioButtonSink
                                                          .add(RadioButtonAction
                                                              .True);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16),
                                                      child: Text(
                                                          _vesselBloc[index]
                                                              .itemVessel[
                                                                  innerindex]
                                                              .name),
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
              });
        });
  }
}
