// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, library_private_types_in_public_api, use_build_context_synchronously, no_logic_in_create_state

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
import '../Header.dart';
import 'EditPermanentAdressProvider.dart';
import 'ExpandedAnimation.dart';
import 'GetResumeProvider.dart';
import 'IndosNoBloc.dart';
import 'ResumeBuilder.dart';
import 'ResumeCountryBloc.dart';
import 'Scrollbar.dart';

class EditAdress extends StatefulWidget {
  var index;
  EditAdress(this.index, {Key? key}) : super(key: key);
  @override
  _EditAdressState createState() => _EditAdressState(index);
}

class _EditAdressState extends State<EditAdress> {
  var index;
  static final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  TextEditingController address1Controller = TextEditingController(),
      address2Controller = TextEditingController(),
      landmarkController = TextEditingController(),
      countryController = TextEditingController(),
      stateController = TextEditingController(),
      cityController = TextEditingController(),
      pincodeController = TextEditingController(),
      comaddress1Controller = TextEditingController(),
      comaddress2Controller = TextEditingController(),
      comlandmarkController = TextEditingController(),
      comcountryController = TextEditingController(),
      comstateController = TextEditingController(),
      comcityController = TextEditingController(),
      compincodeController = TextEditingController();
  final _countryBloc = ResumeCountriesBloc();
  final _dropdownBloc = DropdownBloc();
  final _radioBloc = IndosNoBloc();
  final _errorCountryBloc = ResumeErrorIssuingAuthorityBloc();
  final _showAddressDropDownBloc = IndosNoBloc();
  String countryvalue = "", comcountryvalue = "";
  int radiovalue = 0;
  TextEditingController searchController = TextEditingController();
  bool radioInitialValue = true;
  _EditAdressState(this.index);
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

  void callback(Widget nextPage) {
    setState(() {});
  }

  @override
  void dispose() {
    _countryBloc.dispose();
    _dropdownBloc.dispose();
    _radioBloc.dispose();
    _errorCountryBloc.dispose();
    _showAddressDropDownBloc.dispose();
    super.dispose();
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
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          index == 1
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        'Same as permanent address?',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    StreamBuilder(
                                      initialData:
                                          Provider.of<GetResumeProvider>(
                                                          context,
                                                          listen: false)
                                                      .isCommunication ==
                                                  "0"
                                              ? false
                                              : true,
                                      stream: _radioBloc.stateIndosNoStrean,
                                      builder: (context, snapshot) {
                                        //If 0 means false, means not same as permanent address
                                        //If 1 means true, means same as permanent address
                                        if (_radioBloc.isedited) {
                                          radiovalue = 1;
                                        } else {
                                          radiovalue = 0;
                                        }
                                        if (snapshot.hasData &&
                                            _radioBloc.isedited) {
                                          return _displayradiobuttons(snapshot);
                                        } else {
                                          return Column(
                                            children: [
                                              _displayradiobuttons(snapshot),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              _displayaddressforms(1)
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          index == 0
                              ? _displayaddressforms(0)
                              : const SizedBox(),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {},
                                  child: ElevatedButton(
                                    style: buttonStyle(),
                                    onPressed: () {
                                      if (index == 0) {
                                        if (countryvalue.isEmpty) {
                                          _errorCountryBloc
                                              .eventResumeIssuingAuthoritySink
                                              .add(
                                                  ResumeErrorIssuingAuthorityAction
                                                      .True);
                                          if (!_formKey.currentState!
                                              .validate()) {}
                                        } else {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            callpostaddressfunction();
                                          }
                                        }
                                      } else {
                                        if (radiovalue == 1) {
                                          callpostcommaddressfunction();
                                        } else {
                                          if (comcountryvalue.isEmpty) {
                                            _errorCountryBloc
                                                .eventResumeIssuingAuthoritySink
                                                .add(
                                                    ResumeErrorIssuingAuthorityAction
                                                        .True);
                                            if (!_formKey.currentState!
                                                .validate()) {}
                                          } else {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              callpostcommaddressfunction();
                                            }
                                          }
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
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

  _buildAddress1TF(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller:
                  index == 0 ? address1Controller : comaddress1Controller,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter your address');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your address';
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
                  hintText: 'Enter your Address',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Address 1')
      ],
    );
  }

  _buildAddress2TF(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller:
                  index == 0 ? address2Controller : comaddress2Controller,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Enter your Address',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Adress 2')
      ],
    );
  }

  _buildLandmarkTF(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller:
                  index == 0 ? landmarkController : comlandmarkController,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter your landmark');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your landmark';
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
                  hintText: 'Enter your landmark',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Landmark')
      ],
    );
  }

  _buildCountryTF(int index) {
    return StreamBuilder(
      stream: _countryBloc.stateResumeCountriesStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (index == 0) {
            if (Provider.of<GetResumeProvider>(context, listen: false)
                    .adressCountry
                    .isNotEmpty &&
                countryvalue.isEmpty) {
              countryvalue =
                  Provider.of<GetResumeProvider>(context, listen: false)
                      .adressCountry;
              _dropdownBloc.setdropdownvalue(countryvalue);
              _dropdownBloc.eventDropdownSink.add(DropdownAction.Update);
            } else if (Provider.of<GetResumeProvider>(context, listen: false)
                    .adressCountry
                    .isEmpty &&
                countryvalue.isEmpty) {
              countryvalue = _countryBloc.countryname[0];
              _dropdownBloc.setdropdownvalue(countryvalue);
              _dropdownBloc.eventDropdownSink.add(DropdownAction.Update);
            }
          } else {
            if (Provider.of<GetResumeProvider>(context, listen: false)
                    .comadressCountry
                    .isNotEmpty &&
                comcountryvalue.isEmpty) {
              comcountryvalue =
                  Provider.of<GetResumeProvider>(context, listen: false)
                      .comadressCountry;

              _dropdownBloc.setdropdownvalue(comcountryvalue);
              _dropdownBloc.eventDropdownSink.add(DropdownAction.Update);
            } else if (Provider.of<GetResumeProvider>(context, listen: false)
                    .comadressCountry
                    .isEmpty &&
                comcountryvalue.isEmpty) {
              comcountryvalue = _countryBloc.countryname[0];
              _dropdownBloc.setdropdownvalue(comcountryvalue);
              _dropdownBloc.eventDropdownSink.add(DropdownAction.Update);
            }
          }
          return Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: StreamBuilder(
                    initialData: false,
                    stream: _errorCountryBloc.stateResumeIssuingAuthorityStrean,
                    builder: (context, errorsnapshot) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: _errorCountryBloc.showtext
                                  ? Colors.red
                                  : Colors.grey),
                          borderRadius: const BorderRadius.all(Radius.circular(
                                  20.0) //                 <--- border radius here
                              ),
                        ),
                        child: StreamBuilder(
                          stream: _dropdownBloc.stateDropdownStrean,
                          builder: (context, dropdownsnapshot) {
                            return StreamBuilder(
                              stream:
                                  _showAddressDropDownBloc.stateIndosNoStrean,
                              initialData: false,
                              builder: (context, snapshot) {
                                return Column(
                                  children: [
                                    DrodpownContainer(
                                      title: index == 0
                                          ? countryvalue.isNotEmpty
                                              ? countryvalue
                                              : 'Select Country'
                                          : comcountryvalue.isNotEmpty
                                              ? comcountryvalue
                                              : 'Select Country',
                                      searchHint: 'Search Country',
                                      showDropDownBloc:
                                          _showAddressDropDownBloc,
                                      originalList: _countryBloc.countryname,
                                    ),
                                    ExpandedSection(
                                      expand: _showAddressDropDownBloc.isedited,
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
                                                            : _countryBloc
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
                                                              onTap: () {
                                                                if (!Provider.of<
                                                                            SearchChangeProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .noDataFound) {
                                                                  _showAddressDropDownBloc
                                                                      .eventIndosNoSink
                                                                      .add(IndosNoAction
                                                                          .False);
                                                                  _errorCountryBloc
                                                                      .eventResumeIssuingAuthoritySink
                                                                      .add(ResumeErrorIssuingAuthorityAction
                                                                          .False);
                                                                  if (index ==
                                                                      0) {
                                                                    countryvalue = Provider.of<SearchChangeProvider>(context, listen: false)
                                                                            .searchList
                                                                            .isNotEmpty
                                                                        ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                            listindex]
                                                                        : _countryBloc
                                                                            .countryname[listindex];
                                                                  } else {
                                                                    comcountryvalue = Provider.of<SearchChangeProvider>(context, listen: false)
                                                                            .searchList
                                                                            .isNotEmpty
                                                                        ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                            listindex]
                                                                        : _countryBloc
                                                                            .countryname[listindex];
                                                                  }
                                                                  _dropdownBloc.setdropdownvalue(Provider.of<SearchChangeProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .searchList
                                                                          .isNotEmpty
                                                                      ? Provider.of<SearchChangeProvider>(context, listen: false).searchList[
                                                                          listindex]
                                                                      : _countryBloc
                                                                              .countryname[
                                                                          listindex]);
                                                                  _dropdownBloc
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
                                                                        : _countryBloc
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
                  )),
              TextBoxLabel('Select Country')
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

  _buildStateTF(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller: index == 0 ? stateController : comstateController,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter your state');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your state';
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
                  hintText: 'Enter your state',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('State')
      ],
    );
  }

  _buildCityTF(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller: index == 0 ? cityController : comcityController,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter your city');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your city';
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
                  hintText: 'Enter your city',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('City')
      ],
    );
  }

  _buildPincodeTF(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller: index == 0 ? pincodeController : compincodeController,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter your pinocde');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your pincode';
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
                  hintText: 'Enter your pincode',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Pincode')
      ],
    );
  }

  _displayradiobuttons(AsyncSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _radioBloc.eventIndosNoSink.add(IndosNoAction.True);
              _radioBloc.isedited = true;
              ;
            },
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
            onTap: () {
              _countryBloc.eventResumeCountriesSink
                  .add(ResumeCountriesAction.Post);
              _radioBloc.eventIndosNoSink.add(IndosNoAction.False);
              _radioBloc.isedited = false;
            },
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

  void getdata() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(EditAdress(index), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    if (index == 0) {
      address1Controller.text =
          Provider.of<GetResumeProvider>(context, listen: false).address1;
      address2Controller.text =
          Provider.of<GetResumeProvider>(context, listen: false).address2;
      cityController.text =
          Provider.of<GetResumeProvider>(context, listen: false).city;
      stateController.text =
          Provider.of<GetResumeProvider>(context, listen: false).state;
      landmarkController.text =
          Provider.of<GetResumeProvider>(context, listen: false).landmark;
      pincodeController.text =
          Provider.of<GetResumeProvider>(context, listen: false).pincode;
    }
    if (index == 1 &&
        Provider.of<GetResumeProvider>(context, listen: false)
                .isCommunication ==
            "0") {
      comaddress1Controller.text =
          Provider.of<GetResumeProvider>(context, listen: false).comaddress1;
      comaddress2Controller.text =
          Provider.of<GetResumeProvider>(context, listen: false).comaddress2;
      comcityController.text =
          Provider.of<GetResumeProvider>(context, listen: false).comcity;
      comstateController.text =
          Provider.of<GetResumeProvider>(context, listen: false).comstate;
      comlandmarkController.text =
          Provider.of<GetResumeProvider>(context, listen: false).comlandmark;
      compincodeController.text =
          Provider.of<GetResumeProvider>(context, listen: false).compincode;
    }
    getcountry();

    _countryBloc.header = header;
    _countryBloc.eventResumeCountriesSink.add(ResumeCountriesAction.Post);
    asyncProvider.changeAsynccall();
  }

  _displayaddressforms(int index) {
    return Column(
      children: [
        _buildAddress1TF(index),
        const SizedBox(
          height: 14,
        ),
        _buildAddress2TF(index),
        const SizedBox(
          height: 14,
        ),
        _buildLandmarkTF(index),
        const SizedBox(
          height: 14,
        ),
        _buildCountryTF(index),
        _displayErrorText(),
        const SizedBox(
          height: 14,
        ),
        _buildStateTF(index),
        const SizedBox(
          height: 14,
        ),
        _buildCityTF(index),
        const SizedBox(
          height: 14,
        ),
        _buildPincodeTF(index),
      ],
    );
  }

  void callpostaddressfunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    ResumeAddressUpdateProvider resumeAddressUpdateProvider =
        Provider.of<ResumeAddressUpdateProvider>(context, listen: false);

    if (await resumeAddressUpdateProvider.callpostResumeAddressapi(
        address1Controller.text,
        landmarkController.text,
        _countryBloc
            .countrycode[_countryBloc.countryname.indexOf(countryvalue)],
        pincodeController.text,
        cityController.text,
        stateController.text,
        radiovalue,
        header,
        address2: address2Controller.text)) {
      asyncProvider.changeAsynccall();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('AddressUpdateSuccess', 'Address updated successfully');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ResumeBuilder()));
    } else {
      asyncProvider.changeAsynccall();
      displaysnackbar(Provider.of<ResumeAddressUpdateProvider>(context).error);
    }
  }

  callpostcommaddressfunction() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(EditAdress(index), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    ResumeAddressUpdateProvider resumeAddressUpdateProvider =
        Provider.of<ResumeAddressUpdateProvider>(context, listen: false);
    if (radiovalue == 1) clearcomdata();

    if (await resumeAddressUpdateProvider.callpostResumeAddressapi(
        address1Controller.text,
        landmarkController.text,
        Provider.of<GetResumeProvider>(context, listen: false).adressCountryId,
        pincodeController.text,
        cityController.text,
        stateController.text,
        radiovalue,
        header,
        address2: address2Controller.text,
        comAdress1: comaddress1Controller.text,
        comAdress2: comaddress2Controller.text,
        comCity: comcityController.text,
        comCountryid: comcountryvalue.isEmpty
            ? ""
            : _countryBloc
                .countrycode[_countryBloc.countryname.indexOf(comcountryvalue)],
        comLandmark: comlandmarkController.text,
        comPincode: compincodeController.text,
        comState: comstateController.text)) {
      asyncProvider.changeAsynccall();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('AddressUpdateSuccess', 'Address updated successfully');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ResumeBuilder()));
    } else {
      asyncProvider.changeAsynccall();
      displaysnackbar(Provider.of<ResumeAddressUpdateProvider>(context).error);
    }
  }

  _displayErrorText() {
    return StreamBuilder(
      initialData: false,
      stream: _errorCountryBloc.stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && _errorCountryBloc.showtext) {
          return Visibility(
            visible: _errorCountryBloc.showtext,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please select the country',
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

  void clearcomdata() {
    comaddress1Controller.clear();
    comaddress2Controller.clear();
    comlandmarkController.clear();
    comcountryController.clear();
    comstateController.clear();
    comcityController.clear();
    compincodeController.clear();
  }

  void getcountry() {}
}
