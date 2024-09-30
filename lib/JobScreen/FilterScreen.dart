// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:smartseaman/JobScreen/GetAdvancedSearchProvider.dart';
import 'package:smartseaman/JobScreen/SelectFiltersProvider.dart';
import 'package:smartseaman/RadioButtonBloc.dart';
import 'package:smartseaman/ResumeBuilder/PersonalInformation/ExpandedAnimation.dart';

import '../ResumeBuilder/PersonalInformation/IndosNoBloc.dart';
import '../ResumeBuilder/PersonalInformation/Scrollbar.dart';
import '../constants.dart';
import 'JobList.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final List<IndosNoBloc> _dropdownShowBloc = [
    IndosNoBloc(),
    IndosNoBloc(),
    IndosNoBloc(),
    IndosNoBloc()
  ];
  final List<RadioButtonBloc> _showStatusBloc = [
    RadioButtonBloc(),
    RadioButtonBloc(),
    RadioButtonBloc(),
    RadioButtonBloc(),
    RadioButtonBloc(),
    RadioButtonBloc(),
  ];
  List<bool> isStrechedDropDown = [false, false, false, false];
  final List<RadioButtonBloc> _companiesListBloc = [],
      _ranksListBloc = [],
      _vesselsListBloc = [],
      _nationalityListBloc = [];
  final List<RadioButtonBloc> _displaySelectedItemBloc = [
    RadioButtonBloc(),
    RadioButtonBloc(),
    RadioButtonBloc(),
    RadioButtonBloc()
  ];
  DateTime selectedDate = DateTime.now();
  List<String> selectedcompanies = [],
      selectedranks = [],
      selectedvessels = [],
      selectednationality = [];
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  TextEditingController joiningStartController = TextEditingController(),
      endStartController = TextEditingController(),
      joiningExpirationController = TextEditingController(),
      endExpirationController = TextEditingController();

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < 4; i++) {
      _dropdownShowBloc[i].dispose();
      _displaySelectedItemBloc[i].dispose();
    }
    for (int i = 0; i < 5; i++) {
      _showStatusBloc[i].dispose();
    }
    for (int i = 0;
        i <
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .companyName
                .length;
        i++) {
      _companiesListBloc[i].dispose();
    }
    for (int i = 0;
        i <
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .rankId
                .length;
        i++) {
      _ranksListBloc[i].dispose();
    }
    for (int i = 0;
        i <
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .vesselName
                .length;
        i++) {
      _vesselsListBloc[i].dispose();
    }
    for (int i = 0;
        i <
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .nationalityId
                .length;
        i++) {
      _nationalityListBloc[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.height * 0.11),
              child: DrawerHeader(
                child: Row(
                  children: [
                    const Text(
                      'Advanced Search:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close)),
                  ],
                ),
              ),
            ),
            const Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            Row(
              children: [
                _displayLabelText('Company Name'),
                const Spacer(),
                _buildStatusContainer(0),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            _displayDropdown(0),
            _displaySelectedList(0),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                _displayLabelText('Rank'),
                const Spacer(),
                _buildStatusContainer(1),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            _displayDropdown(1),
            _displaySelectedList(1),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                _displayLabelText('Vessel Type'),
                const Spacer(),
                _buildStatusContainer(2),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            _displayDropdown(2),
            _displaySelectedList(2),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                _displayLabelText('Nationality'),
                const Spacer(),
                _buildStatusContainer(3),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            _displayDropdown(3),
            _displaySelectedList(3),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                _displayLabelText('Tentative Joining'),
                const Spacer(),
                _buildStatusContainer(4),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            _buildTentaiveJoiningContainer(),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                _displayLabelText('Expiration'),
                const Spacer(),
                _buildStatusContainer(5),
              ],
            ),
            _buildExpirationContainer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => callfiltersApi(),
                  style: buttonStyle(),
                  child: const Text(
                    'Search',
                    style: TextStyle(color: kbackgroundColor),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    cleardata();
                  },
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                        color: kgreenPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _displayDropdown(int dropdownIndex) {
    clearDuplicateData();
    return StreamBuilder(
      stream: _dropdownShowBloc[dropdownIndex].stateIndosNoStrean,
      builder: (context, snapshot) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.62,
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.grey),
          ),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            dropdownIndex == 0
                                ? 'Select Company'
                                : dropdownIndex == 1
                                    ? 'Select Rank'
                                    : dropdownIndex == 2
                                        ? 'Select Vessel'
                                        : 'Select Nationality',
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            if (_dropdownShowBloc[dropdownIndex].isedited) {
                              _dropdownShowBloc[dropdownIndex]
                                  .eventIndosNoSink
                                  .add(IndosNoAction.False);
                            } else {
                              _dropdownShowBloc[dropdownIndex]
                                  .eventIndosNoSink
                                  .add(IndosNoAction.True);
                            }
                            _displaySelectedItemBloc[dropdownIndex]
                                .eventRadioButtonSink
                                .add(RadioButtonAction.True);
                          },
                          child: Icon(isStrechedDropDown[dropdownIndex]
                              ? Icons.arrow_upward
                              : Icons.arrow_downward))
                    ],
                  )),
              StreamBuilder(
                stream: _dropdownShowBloc[dropdownIndex].stateIndosNoStrean,
                initialData: false,
                builder: (context, snapshot) {
                  return ExpandedSection(
                    expand: _dropdownShowBloc[dropdownIndex].isedited,
                    height: 100,
                    child: MyScrollbar(
                      builder: (context, scrollController2) => ListView.builder(
                          padding: const EdgeInsets.all(0),
                          controller: scrollController2,
                          shrinkWrap: true,
                          itemCount: dropdownIndex == 0
                              ? Provider.of<GetAdvancedSearchProvider>(context,
                                      listen: false)
                                  .companyName
                                  .length
                              : dropdownIndex == 1
                                  ? Provider.of<GetAdvancedSearchProvider>(
                                          context,
                                          listen: false)
                                      .rankName
                                      .length
                                  : dropdownIndex == 2
                                      ? Provider.of<GetAdvancedSearchProvider>(
                                              context,
                                              listen: false)
                                          .vesselName
                                          .length
                                      : Provider.of<GetAdvancedSearchProvider>(
                                              context,
                                              listen: false)
                                          .nationalityName
                                          .length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      children: [
                                        StreamBuilder(
                                          initialData: false,
                                          stream: dropdownIndex == 0
                                              ? _companiesListBloc[index]
                                                  .stateRadioButtonStrean
                                              : dropdownIndex == 1
                                                  ? _ranksListBloc[index]
                                                      .stateRadioButtonStrean
                                                  : dropdownIndex == 2
                                                      ? _vesselsListBloc[index]
                                                          .stateRadioButtonStrean
                                                      : _nationalityListBloc[
                                                              index]
                                                          .stateRadioButtonStrean,
                                          builder: (context, snapshot) {
                                            return Checkbox(
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                value: dropdownIndex == 0
                                                    ? _companiesListBloc[index]
                                                        .radioValue
                                                    : dropdownIndex == 1
                                                        ? _ranksListBloc[index]
                                                            .radioValue
                                                        : dropdownIndex == 2
                                                            ? _vesselsListBloc[
                                                                    index]
                                                                .radioValue
                                                            : _nationalityListBloc[
                                                                    index]
                                                                .radioValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    changeValues(
                                                        dropdownIndex, index);
                                                    print(selectedcompanies);
                                                  });
                                                });
                                          },
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              changeValues(
                                                  dropdownIndex, index);
                                              print(selectedcompanies);
                                            });
                                          },
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: Text(dropdownIndex == 0
                                                ? Provider.of<
                                                            GetAdvancedSearchProvider>(
                                                        context,
                                                        listen: false)
                                                    .companyName[index]
                                                : dropdownIndex == 1
                                                    ? Provider.of<
                                                                GetAdvancedSearchProvider>(
                                                            context,
                                                            listen: false)
                                                        .rankName[index]
                                                    : dropdownIndex == 2
                                                        ? Provider.of<
                                                                    GetAdvancedSearchProvider>(
                                                                context,
                                                                listen: false)
                                                            .vesselName[index]
                                                        : Provider.of<
                                                                    GetAdvancedSearchProvider>(
                                                                context,
                                                                listen: false)
                                                            .nationalityName[index]),
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
        );
      },
    );
  }

  _displayLabelText(String label) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          label,
          style: const TextStyle(
              color: kblackPrimaryColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _buildTentaiveJoiningContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.62,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            children: [
              _buildTentaiveDate(true),
              const SizedBox(
                height: 10,
              ),
              _buildTentaiveDate(false),
            ],
          ),
        ),
      ),
    );
  }

  _buildTentaiveDate(bool isStartDate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        child: TextFormField(
          cursorColor: kgreenPrimaryColor,
          controller: isStartDate ? joiningStartController : endStartController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            color: kblackPrimaryColor,
            fontFamily: 'OpenSans',
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              _showStatusBloc[4]
                  .eventRadioButtonSink
                  .add(RadioButtonAction.True);
            } else {
              _showStatusBloc[4]
                  .eventRadioButtonSink
                  .add(RadioButtonAction.False);
            }
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
              //floatingLabelBehavior: FloatingLabelBehavior.always,
              border: const OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              suffixIcon: InkWell(
                onTap: () => _selectTentativeDate(context, isStartDate),
                child: const Icon(
                  Icons.date_range,
                  color: kBluePrimaryColor,
                ),
              ),
              hintText: isStartDate ? 'Start Date' : 'End Date',
              hintStyle: hintstyle),
        ),
      ),
    );
  }

  Future<void> _selectTentativeDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2023, 10));
    if (isStart) {
      if (picked != null && picked != selectedDate) {
        joiningStartController.text = formatter.format(picked);
        _showStatusBloc[4].eventRadioButtonSink.add(RadioButtonAction.True);
      }
    } else {
      if (picked != null && picked != selectedDate) {
        endStartController.text = formatter.format(picked);
        _showStatusBloc[4].eventRadioButtonSink.add(RadioButtonAction.True);
      }
    }
  }

  _buildExpirationContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.62,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            children: [
              _buildExpirationDate(true),
              const SizedBox(
                height: 10,
              ),
              _buildExpirationDate(false),
            ],
          ),
        ),
      ),
    );
  }

  _buildExpirationDate(bool isStart) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        child: TextFormField(
          cursorColor: kgreenPrimaryColor,
          controller:
              isStart ? joiningExpirationController : endExpirationController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            color: kblackPrimaryColor,
            fontFamily: 'OpenSans',
          ),
          onChanged: (value) {
            print(value);
            if (value.isNotEmpty) {
              _showStatusBloc[5]
                  .eventRadioButtonSink
                  .add(RadioButtonAction.True);
            } else {
              _showStatusBloc[5]
                  .eventRadioButtonSink
                  .add(RadioButtonAction.False);
            }
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
              //floatingLabelBehavior: FloatingLabelBehavior.always,
              border: const OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              suffixIcon: InkWell(
                onTap: () => _selectExpirationDate(context, isStart),
                child: const Icon(
                  Icons.date_range,
                  color: kBluePrimaryColor,
                ),
              ),
              hintText: isStart ? 'Start Date' : 'End Date',
              hintStyle: hintstyle),
        ),
      ),
    );
  }

  Future<void> _selectExpirationDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2023, 10));
    if (isStart) {
      if (picked != null && picked != selectedDate) {
        joiningExpirationController.text = formatter.format(picked);
        _showStatusBloc[5].eventRadioButtonSink.add(RadioButtonAction.True);
      }
    } else {
      if (picked != null && picked != selectedDate) {
        _showStatusBloc[5].eventRadioButtonSink.add(RadioButtonAction.True);
        endExpirationController.text = formatter.format(picked);
      }
    }
  }

  void getdata() {
    for (int i = 0; i < 4; i++) {
      _dropdownShowBloc[i].isedited = false;
    }
    for (int i = 0; i < 6; i++) {
      _showStatusBloc[i].radioValue = false;
    }
    joiningStartController.text =
        Provider.of<GetSelectedFiltersProvider>(context, listen: false)
            .tentativeJoiningDate;
    endStartController.text =
        Provider.of<GetSelectedFiltersProvider>(context, listen: false)
            .tentativeEndDate;
    joiningExpirationController.text =
        Provider.of<GetSelectedFiltersProvider>(context, listen: false)
            .expirationStartDate;
    endExpirationController.text =
        Provider.of<GetSelectedFiltersProvider>(context, listen: false)
            .expirationEndDate;
    for (int i = 0;
        i <
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .companyName
                .length;
        i++) {
      _companiesListBloc.add(RadioButtonBloc());
      _companiesListBloc[i].radioValue = false;
    }
    for (int i = 0;
        i <
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .rankName
                .length;
        i++) {
      _ranksListBloc.add(RadioButtonBloc());
      _ranksListBloc[i].radioValue = false;
    }
    for (int i = 0;
        i <
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .vesselName
                .length;
        i++) {
      _vesselsListBloc.add(RadioButtonBloc());
      _vesselsListBloc[i].radioValue = false;
    }

    for (int i = 0;
        i <
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .nationalityName
                .length;
        i++) {
      _nationalityListBloc.add(RadioButtonBloc());
      _nationalityListBloc[i].radioValue = false;
    }

    if (Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .companyId
        .isNotEmpty) {
      for (int i = 0;
          i <
              Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                  .companyId
                  .length;
          i++) {
        selectedcompanies.add(
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                    .companyName[
                Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                    .companyId
                    .indexOf(Provider.of<GetSelectedFiltersProvider>(context,
                            listen: false)
                        .companyId[i])]);
        _companiesListBloc[
                Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                    .companyId
                    .indexOf(Provider.of<GetSelectedFiltersProvider>(context,
                            listen: false)
                        .companyId[i])]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      }
      _showStatusBloc[0].eventRadioButtonSink.add(RadioButtonAction.True);
      _displaySelectedItemBloc[0]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
      _displaySelectedItemBloc[0]
          .eventRadioButtonSink
          .add(RadioButtonAction.True);
    }

    if (Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .rankList
        .isNotEmpty) {
      for (int i = 0;
          i <
              Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                  .rankList
                  .length;
          i++) {
        selectedranks.add(
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                    .rankName[
                Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                    .rankId
                    .indexOf(Provider.of<GetSelectedFiltersProvider>(context,
                            listen: false)
                        .rankList[i])]);
        _ranksListBloc[
                Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                    .rankId
                    .indexOf(Provider.of<GetSelectedFiltersProvider>(context,
                            listen: false)
                        .rankList[i])]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      }
      _showStatusBloc[1].eventRadioButtonSink.add(RadioButtonAction.True);
      _displaySelectedItemBloc[1]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
      _displaySelectedItemBloc[1]
          .eventRadioButtonSink
          .add(RadioButtonAction.True);
    }

    if (Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .vesselType
        .isNotEmpty) {
      for (int i = 0;
          i <
              Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                  .vesselType
                  .length;
          i++) {
        selectedvessels.add(
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                    .vesselName[
                Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                    .vesselId
                    .indexOf(Provider.of<GetSelectedFiltersProvider>(context,
                            listen: false)
                        .vesselType[i])]);
        _vesselsListBloc[
                Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                    .vesselId
                    .indexOf(Provider.of<GetSelectedFiltersProvider>(context,
                            listen: false)
                        .vesselType[i])]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      }
      _showStatusBloc[2].eventRadioButtonSink.add(RadioButtonAction.True);
      _displaySelectedItemBloc[2]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
      _displaySelectedItemBloc[2]
          .eventRadioButtonSink
          .add(RadioButtonAction.True);
    }

    if (Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .nationalityId
        .isNotEmpty) {
      for (int i = 0;
          i <
              Provider.of<GetSelectedFiltersProvider>(context, listen: false)
                  .nationalityId
                  .length;
          i++) {
        selectednationality.add(
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                    .nationalityName[
                Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                    .nationalityId
                    .indexOf(Provider.of<GetSelectedFiltersProvider>(context,
                            listen: false)
                        .nationalityId[i])]);
        _nationalityListBloc[
                Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                    .nationalityId
                    .indexOf(Provider.of<GetSelectedFiltersProvider>(context,
                            listen: false)
                        .nationalityId[i])]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      }
      _showStatusBloc[3].eventRadioButtonSink.add(RadioButtonAction.True);
      _displaySelectedItemBloc[3]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
      _displaySelectedItemBloc[3]
          .eventRadioButtonSink
          .add(RadioButtonAction.True);
    }
  }

  _displaySelectedList(int dropdownIndex) {
    List<Widget> showSelectedCompanies = [];
    return StreamBuilder(
      initialData: true,
      stream: _displaySelectedItemBloc[dropdownIndex].stateRadioButtonStrean,
      builder: (context, snapshot) {
        clearDuplicateData();
        showSelectedCompanies.clear();
        int length = 0;
        if (dropdownIndex == 0) {
          if (selectedcompanies.length > 5) {
            length = 5;
          } else {
            length = selectedcompanies.length;
          }
        } else if (dropdownIndex == 1) {
          if (selectedranks.length > 5) {
            length = 5;
          } else {
            length = selectedranks.length;
          }
        } else if (dropdownIndex == 2) {
          if (selectedvessels.length > 5) {
            length = 5;
          } else {
            length = selectedvessels.length;
          }
        } else {
          if (selectednationality.length > 5) {
            length = 5;
          } else {
            length = selectednationality.length;
          }
        }
        for (int i = 0; i < length; i++) {
          showSelectedCompanies.add(Chip(
            elevation: 8,
            padding: const EdgeInsets.all(8),
            backgroundColor: kBluePrimaryColor,
            shadowColor: Colors.black,
            deleteIcon: const Icon(
              Icons.close,
              size: 12,
              color: kbackgroundColor,
            ),
            onDeleted: () {
              setState(() {
                deleteChips(dropdownIndex, i);
              });
            },
            label: Text(
              dropdownIndex == 0
                  ? selectedcompanies[i]
                  : dropdownIndex == 1
                      ? selectedranks[i]
                      : dropdownIndex == 2
                          ? selectedvessels[i]
                          : selectednationality[i],
              style: const TextStyle(fontSize: 14, color: kbackgroundColor),
            ), //Text
          ));
        }

        if (dropdownIndex == 0) {
          _displayExtraCount(selectedcompanies, length, showSelectedCompanies);
        } else if (dropdownIndex == 1) {
          _displayExtraCount(selectedranks, length, showSelectedCompanies);
        } else if (dropdownIndex == 2) {
          _displayExtraCount(selectedvessels, length, showSelectedCompanies);
        } else if (dropdownIndex == 3) {
          _displayExtraCount(
              selectednationality, length, showSelectedCompanies);
        }

        if (showSelectedCompanies.isEmpty) {
          return const SizedBox();
        } else {
          return Wrap(
            children: showSelectedCompanies,
          );
        }
      },
    );
  }

  void clearDuplicateData() {
    print('In here');
    final ids = <dynamic>{};
    selectedcompanies.retainWhere((x) => ids.add(x));
    final rankids = <dynamic>{};
    selectedranks.retainWhere((x) => rankids.add(x));
    final vesselids = <dynamic>{};
    selectedvessels.retainWhere((x) => vesselids.add(x));
    final nationalityids = <dynamic>{};
    selectednationality.retainWhere((x) => nationalityids.add(x));
  }

  void changeValues(int dropdownIndex, int index) {
    if (dropdownIndex == 0) {
      print(_companiesListBloc[index].radioValue);
      if (_companiesListBloc[index].radioValue) {
        _companiesListBloc[index]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _companiesListBloc[index].radioValue = false;
        selectedcompanies.removeAt(selectedcompanies.indexOf(
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .companyName[index]));
        clearDuplicateData();
        print(selectedcompanies);
        _displaySelectedItemBloc[dropdownIndex]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _displaySelectedItemBloc[dropdownIndex]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      } else {
        if (!selectedcompanies.contains(
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .companyName[index])) {
          _companiesListBloc[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _companiesListBloc[index].radioValue = true;
          clearDuplicateData();
          selectedcompanies.add(
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .companyName[index]);
          clearDuplicateData();
          _displaySelectedItemBloc[dropdownIndex]
              .eventRadioButtonSink
              .add(RadioButtonAction.False);
          _displaySelectedItemBloc[dropdownIndex]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
        }
      }
    } else if (dropdownIndex == 1) {
      if (_ranksListBloc[index].radioValue) {
        _ranksListBloc[index].eventRadioButtonSink.add(RadioButtonAction.False);
        _ranksListBloc[index].radioValue = false;
        selectedranks.removeAt(selectedranks.indexOf(
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .rankName[index]));
        clearDuplicateData();
        _displaySelectedItemBloc[dropdownIndex]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _displaySelectedItemBloc[dropdownIndex]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      } else {
        if (!selectedranks.contains(
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .rankName[index])) {
          _ranksListBloc[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _ranksListBloc[index].radioValue = true;
          clearDuplicateData();
          selectedranks.add(
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .rankName[index]);
          clearDuplicateData();
          _displaySelectedItemBloc[dropdownIndex]
              .eventRadioButtonSink
              .add(RadioButtonAction.False);
          _displaySelectedItemBloc[dropdownIndex]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
        }
      }
    } else if (dropdownIndex == 2) {
      if (_vesselsListBloc[index].radioValue) {
        _vesselsListBloc[index]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _vesselsListBloc[index].radioValue = false;
        selectedvessels.removeAt(selectedvessels.indexOf(
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .vesselName[index]));
        clearDuplicateData();
        _displaySelectedItemBloc[dropdownIndex]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _displaySelectedItemBloc[dropdownIndex]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      } else {
        if (!selectedvessels.contains(
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .vesselName[index])) {
          _vesselsListBloc[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _vesselsListBloc[index].radioValue = true;
          clearDuplicateData();
          selectedvessels.add(
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .vesselName[index]);
          clearDuplicateData();
          _displaySelectedItemBloc[dropdownIndex]
              .eventRadioButtonSink
              .add(RadioButtonAction.False);
          _displaySelectedItemBloc[dropdownIndex]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
        }
      }
    } else {
      if (_nationalityListBloc[index].radioValue) {
        _nationalityListBloc[index]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _nationalityListBloc[index].radioValue = false;
        selectednationality.removeAt(selectednationality.indexOf(
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .nationalityName[index]));
        clearDuplicateData();
        _displaySelectedItemBloc[dropdownIndex]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _displaySelectedItemBloc[dropdownIndex]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      } else {
        if (!selectednationality.contains(
            Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                .nationalityName[index])) {
          _nationalityListBloc[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          _nationalityListBloc[index].radioValue = true;
          clearDuplicateData();
          selectednationality.add(
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .nationalityName[index]);
          clearDuplicateData();
          _displaySelectedItemBloc[dropdownIndex]
              .eventRadioButtonSink
              .add(RadioButtonAction.False);
          _displaySelectedItemBloc[dropdownIndex]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
        }
      }
    }
  }

  void deleteChips(int dropdownIndex, int i) {
    if (dropdownIndex == 0) {
      _companiesListBloc[
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .companyName
                  .indexOf(selectedcompanies[i])]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
      _companiesListBloc[
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .companyName
                  .indexOf(selectedcompanies[i])]
          .radioValue = false;
      selectedcompanies.removeAt(i);
      _displaySelectedItemBloc[dropdownIndex]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
      _displaySelectedItemBloc[dropdownIndex]
          .eventRadioButtonSink
          .add(RadioButtonAction.True);
    } else if (dropdownIndex == 1) {
      _ranksListBloc[
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .rankName
                  .indexOf(selectedranks[i])]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
      _ranksListBloc[
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .rankName
                  .indexOf(selectedranks[i])]
          .radioValue = false;
      selectedranks.removeAt(i);
      _displaySelectedItemBloc[dropdownIndex]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
      _displaySelectedItemBloc[dropdownIndex]
          .eventRadioButtonSink
          .add(RadioButtonAction.True);
    } else if (dropdownIndex == 2) {
      _vesselsListBloc[
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .vesselName
                  .indexOf(selectedvessels[i])]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
      _vesselsListBloc[
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .vesselName
                  .indexOf(selectedvessels[i])]
          .radioValue = false;
      selectedvessels.removeAt(i);
      _displaySelectedItemBloc[dropdownIndex]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
      _displaySelectedItemBloc[dropdownIndex]
          .eventRadioButtonSink
          .add(RadioButtonAction.True);
    } else {
      print(selectednationality[i]);
      print(Provider.of<GetAdvancedSearchProvider>(context, listen: false)
          .nationalityName);
      _nationalityListBloc[
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .nationalityName
                  .indexOf(selectednationality[i])]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
      _nationalityListBloc[
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .nationalityName
                  .indexOf(selectednationality[i])]
          .radioValue = false;
      selectednationality.removeAt(i);
      _displaySelectedItemBloc[dropdownIndex]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
      _displaySelectedItemBloc[dropdownIndex]
          .eventRadioButtonSink
          .add(RadioButtonAction.True);
    }
  }

  callfiltersApi() {
    List<String> selectedcompanyid = [],
        selectedrankid = [],
        selectedvesselid = [],
        selectednationalityid = [];
    for (int i = 0; i < selectedcompanies.length; i++) {
      selectedcompanyid.add(
          Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .companyId[
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .companyName
                  .indexOf(selectedcompanies[i])]);
    }
    for (int i = 0; i < selectedranks.length; i++) {
      selectedrankid.add(
          Provider.of<GetAdvancedSearchProvider>(context, listen: false).rankId[
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .rankName
                  .indexOf(selectedranks[i])]);
    }
    for (int i = 0; i < selectedvessels.length; i++) {
      selectedvesselid.add(
          Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .vesselId[
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .vesselName
                  .indexOf(selectedvessels[i])]);
    }
    for (int i = 0; i < selectednationality.length; i++) {
      selectednationalityid.add(
          Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .nationalityId[
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .nationalityName
                  .indexOf(selectednationality[i])]);
    }
    Provider.of<GetSelectedFiltersProvider>(context, listen: false).companyId =
        selectedcompanyid;
    Provider.of<GetSelectedFiltersProvider>(context, listen: false).rankList =
        selectedrankid;
    Provider.of<GetSelectedFiltersProvider>(context, listen: false).vesselType =
        selectedvesselid;
    Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .nationalityId = selectednationalityid;
    Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .tentativeJoiningDate = joiningStartController.text;
    Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .tentativeEndDate = endStartController.text;
    Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .expirationStartDate = joiningExpirationController.text;
    Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .expirationEndDate = endExpirationController.text;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const JobList()));
  }

  _displayClearAllText(int index) {
    return StreamBuilder(
      initialData: false,
      stream: _showStatusBloc[index].stateRadioButtonStrean,
      builder: (context, snapshot) {
        return Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: InkWell(
                onTap: () => checkStatus(index),
                child: !_showStatusBloc[index].radioValue
                    ? index != 4 && index != 5
                        ? Text(
                            _showStatusBloc[index].radioValue
                                ? 'Clear All'
                                : 'Select All',
                            style: TextStyle(
                              color: kgreenPrimaryColor,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                            ))
                        : const SizedBox()
                    : Text('Clear All',
                        style: TextStyle(
                          color: kgreenPrimaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                        ))),
          ),
        );
      },
    );
  }

  checkStatus(int index) {
    if (_showStatusBloc[index].radioValue) {
      _showStatusBloc[index].eventRadioButtonSink.add(RadioButtonAction.False);
      if (index == 0) {
        for (int i = 0; i < _companiesListBloc.length; i++) {
          _companiesListBloc[i]
              .eventRadioButtonSink
              .add(RadioButtonAction.False);
        }
        selectedcompanies.clear();
        _displaySelectedItemBloc[index]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _displaySelectedItemBloc[index]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      } else if (index == 1) {
        for (int i = 0; i < _ranksListBloc.length; i++) {
          _ranksListBloc[i].eventRadioButtonSink.add(RadioButtonAction.False);
        }
        selectedranks.clear();
        _displaySelectedItemBloc[index]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _displaySelectedItemBloc[index]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      } else if (index == 2) {
        for (int i = 0; i < _vesselsListBloc.length; i++) {
          _vesselsListBloc[i].eventRadioButtonSink.add(RadioButtonAction.False);
        }
        selectedvessels.clear();
        _displaySelectedItemBloc[index]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _displaySelectedItemBloc[index]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      } else if (index == 3) {
        for (int i = 0; i < _nationalityListBloc.length; i++) {
          _nationalityListBloc[i]
              .eventRadioButtonSink
              .add(RadioButtonAction.False);
        }
        selectednationality.clear();
        _displaySelectedItemBloc[index]
            .eventRadioButtonSink
            .add(RadioButtonAction.False);
        _displaySelectedItemBloc[index]
            .eventRadioButtonSink
            .add(RadioButtonAction.True);
      } else if (index == 4) {
        joiningStartController.clear();
        endStartController.clear();
      } else {
        joiningExpirationController.clear();
        endExpirationController.clear();
      }
    } else {
      _showStatusBloc[index].eventRadioButtonSink.add(RadioButtonAction.True);
      if (index == 0) {
        for (int i = 0; i < _companiesListBloc.length; i++) {
          _companiesListBloc[i]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          selectedcompanies.add(
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .companyName[i]);
          _displaySelectedItemBloc[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.False);
          _displaySelectedItemBloc[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
        }
      } else if (index == 1) {
        for (int i = 0; i < _ranksListBloc.length; i++) {
          _ranksListBloc[i].eventRadioButtonSink.add(RadioButtonAction.True);
          selectedranks.add(
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .rankName[i]);
          _displaySelectedItemBloc[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.False);
          _displaySelectedItemBloc[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
        }
      } else if (index == 2) {
        for (int i = 0; i < _vesselsListBloc.length; i++) {
          _vesselsListBloc[i].eventRadioButtonSink.add(RadioButtonAction.True);
          selectedvessels.add(
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .vesselName[i]);
          _displaySelectedItemBloc[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.False);
          _displaySelectedItemBloc[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
        }
      } else if (index == 3) {
        for (int i = 0; i < _nationalityListBloc.length; i++) {
          _nationalityListBloc[i]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
          selectednationality.add(
              Provider.of<GetAdvancedSearchProvider>(context, listen: false)
                  .nationalityName[i]);
          _displaySelectedItemBloc[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.False);
          _displaySelectedItemBloc[index]
              .eventRadioButtonSink
              .add(RadioButtonAction.True);
        }
      }
    }
  }

  _buildStatusContainer(int i) {
    return Row(
      children: [
        _displayClearAllText(i),
        SizedBox(width: MediaQuery.of(context).size.width * 0.08)
      ],
    );
  }

  void cleardata() {
    for (int i = 0; i < _companiesListBloc.length; i++) {
      _companiesListBloc[i].eventRadioButtonSink.add(RadioButtonAction.False);
    }
    for (int i = 0; i < _ranksListBloc.length; i++) {
      _ranksListBloc[i].eventRadioButtonSink.add(RadioButtonAction.False);
    }
    for (int i = 0; i < _vesselsListBloc.length; i++) {
      _vesselsListBloc[i].eventRadioButtonSink.add(RadioButtonAction.False);
    }
    for (int i = 0; i < _nationalityListBloc.length; i++) {
      _nationalityListBloc[i].eventRadioButtonSink.add(RadioButtonAction.False);
    }
    joiningExpirationController.clear();
    joiningStartController.clear();
    endExpirationController.clear();
    endStartController.clear();
    selectedcompanies.clear();
    selectedranks.clear();
    selectedvessels.clear();
    selectednationality.clear();
    Provider.of<GetSelectedFiltersProvider>(context, listen: false).companyId =
        [];
    Provider.of<GetSelectedFiltersProvider>(context, listen: false).rankList =
        [];
    Provider.of<GetSelectedFiltersProvider>(context, listen: false).vesselType =
        [];
    Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .nationalityId = [];
    Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .tentativeJoiningDate = joiningStartController.text;
    Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .tentativeEndDate = endStartController.text;
    Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .expirationStartDate = joiningExpirationController.text;
    Provider.of<GetSelectedFiltersProvider>(context, listen: false)
        .expirationEndDate = endExpirationController.text;
    for (int i = 0; i < 4; i++) {
      _displaySelectedItemBloc[i]
          .eventRadioButtonSink
          .add(RadioButtonAction.False);
    }
    callfiltersApi();
  }

  void _displayExtraCount(List<String> selectedlist, int length, var list) {
    if (selectedlist.length > 5) {
      list.add(Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
            decoration: BoxDecoration(
                color: kBluePrimaryColor,
                border: Border.all(
                  color: kBluePrimaryColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                '+${selectedlist.length - length}',
                style: const TextStyle(color: kbackgroundColor),
              ),
            )),
      ));
    }
  }
}
