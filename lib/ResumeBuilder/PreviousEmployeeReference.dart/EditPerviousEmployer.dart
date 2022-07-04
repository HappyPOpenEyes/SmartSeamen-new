// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartseaman/ResumeBuilder/PreviousEmployeeReference.dart/PreviousEmployee.dart';

import '../../DropdownBloc.dart';
import '../../DropdownContainer.dart';
import '../../IssuingAuthorityErrorBloc.dart';
import '../../Register/CountriesBloc.dart';
import '../../SearchTextProvider.dart';
import '../../TextBoxLabel.dart';
import '../../asynccallprovider.dart';
import '../../constants.dart';
import '../Header.dart';
import '../PersonalInformation/ExpandedAnimation.dart';
import '../PersonalInformation/IndosNoBloc.dart';
import '../PersonalInformation/Scrollbar.dart';
import 'EditEmployerProvider.dart';
import 'EmployerDeleteProvider.dart';
import 'PostEmployerResponse.dart';
import 'PreviousEmplyeeProvider.dart';

class EditPreviousEmployer extends StatefulWidget {
  const EditPreviousEmployer({Key? key}) : super(key: key);

  @override
  _EditPreviousEmployerState createState() => _EditPreviousEmployerState();
}

class _EditPreviousEmployerState extends State<EditPreviousEmployer> {
  static final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _companynameController = [],
      _contactnameController = [],
      _contactnumberController = [];
  List<FocusNode> _companyNameFocus = [];
  final List<PhoneCountriesBloc> _countriesBloc = [];
  final List<DropdownBloc> _dropdownBloc = [];
  final List<String> _countryValue = [];
  final List<ResumeErrorIssuingAuthorityBloc> _errorCountryCodeBloc = [];
  var header;
  List<IndosNoBloc> _showCountryDropDownBloc = [];

  List<String> errors = [];
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
    for (int i = 0;
        i < Provider.of<ResumeEmployerProvider>(context, listen: false).length;
        i++) {
      _countriesBloc[i].dispose();
      _showCountryDropDownBloc[i].dispose();
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
              ResumeHeader('Previous Employer Reference', 5, true, ""),
              InkWell(
                onTap: () {
                  ResumeEmployerProvider employerProvider =
                      Provider.of<ResumeEmployerProvider>(context,
                          listen: false);
                  setState(() {
                    employerProvider.increaselength();
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
                      Text('Add Employer',
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
                  : _displayEditEmployerCard(),
            ],
          ),
        ),
      ),
    );
  }

  _displayEditEmployerCard() {
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
                    itemCount: Provider.of<ResumeEmployerProvider>(context,
                            listen: false)
                        .length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          _displayEmployerData(index),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // ignore: unnecessary_statements
                          for (int i = 0;
                              i < _errorCountryCodeBloc.length;
                              i++) {
                            if (_countryValue[i].isEmpty) {
                              _errorCountryCodeBloc[i]
                                  .eventResumeIssuingAuthoritySink
                                  .add(ResumeErrorIssuingAuthorityAction.True);
                            } else {
                              _errorCountryCodeBloc[i]
                                  .eventResumeIssuingAuthoritySink
                                  .add(ResumeErrorIssuingAuthorityAction.False);
                            }
                          }
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            callPostEmployerRecord();
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

  _displayEmployerData(int index) {
    return Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _displaycarddata(index)));
  }

  _displayCompanyNameTF(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              focusNode: _companyNameFocus[index],
              cursorColor: kgreenPrimaryColor,
              controller: _companynameController[index],
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter the company name');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the company name';
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
                  hintText: 'Enter your Company Name',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Company Name')
      ],
    );
  }

  _displayContactNameTF(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
              ],
              cursorColor: kgreenPrimaryColor,
              controller: _contactnameController[index],
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter the contact name');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the contact name';
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
                  hintText: 'Enter your Contact Name',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Contact Name')
      ],
    );
  }

  _buildcountrydropdown(int index) {
    return StreamBuilder(
      stream: _countriesBloc[index].stateCountriesStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (_countriesBloc[index].countrycode.isNotEmpty) {
            if (index <
                Provider.of<ResumeEmployerProvider>(context, listen: false)
                    .companyName
                    .length) {
              _countryValue[index] = _countriesBloc[index].countrycode[
                  _countriesBloc[index].countryId.indexOf(
                      Provider.of<ResumeEmployerProvider>(context,
                              listen: false)
                          .countryid[index])];
              _dropdownBloc[index].setdropdownvalue(
                  _countriesBloc[index].countrycode[_countriesBloc[index]
                      .countryId
                      .indexOf(Provider.of<ResumeEmployerProvider>(context,
                              listen: false)
                          .countryid[index])]);
              _dropdownBloc[index].eventDropdownSink.add(DropdownAction.Update);
            } else {
              _countryValue[index] = _countriesBloc[index].countrycode[0];
              _dropdownBloc[index].setdropdownvalue(_countryValue[index]);
              _dropdownBloc[index].eventDropdownSink.add(DropdownAction.Update);
            }
          }
          return StreamBuilder(
            initialData: false,
            stream:
                _errorCountryCodeBloc[index].stateResumeIssuingAuthorityStrean,
            builder: (context, errorsnapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0,
                        color: errorsnapshot.hasData &&
                                _errorCountryCodeBloc[index].showtext
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
                        stream: _showCountryDropDownBloc[index].stateIndosNoStrean,
                        builder: (context, dropdownsnapshot) {
                          return Column(
                            children: [
                              DrodpownContainer(
                                title: _countryValue[index].isNotEmpty
                                    ? _countryValue[index]
                                    : 'Select Country',
                                searchHint: 'Search Country',
                                showDropDownBloc: _showCountryDropDownBloc[index],
                                originalList: _countriesBloc[index].countrycode,
                              ),
                              ExpandedSection(
                                expand: _showCountryDropDownBloc[index].isedited,
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
                                              ?1: Provider.of<
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
                                              : _countriesBloc[index]
                                                  .countrycode.length,
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
                                                      if(!Provider.of<
                                                                  SearchChangeProvider>(
                                                              context,
                                                              listen: false)
                                                          .noDataFound){
                                                      _showCountryDropDownBloc[
                                                              index]
                                                          .eventIndosNoSink
                                                          .add(IndosNoAction
                                                              .False);
                                                      _errorCountryCodeBloc[
                                                              index]
                                                          .eventResumeIssuingAuthoritySink
                                                          .add(
                                                              ResumeErrorIssuingAuthorityAction
                                                                  .False);
                                                      _countryValue[
                                                          index] = Provider
                                                                  .of<SearchChangeProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .searchList
                                                              .isNotEmpty
                                                          ? Provider.of<SearchChangeProvider>(
                                                                      context,
                                                                      listen: false)
                                                                  .searchList[
                                                              listindex]
                                                          : _countriesBloc[
                                                                      index]
                                                                  .countrycode[
                                                              listindex];

                                                      _dropdownBloc[index].setdropdownvalue(Provider.of<
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
                                                          : _countriesBloc[
                                                                      index]
                                                                  .countrycode[
                                                              listindex]);
                                                      _dropdownBloc[index]
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
                                                    }},
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16),
                                                      child: Text(Provider.of<SearchChangeProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .noDataFound
                                                          ? 'No Data Found'
                                                          : Provider.of<
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
                                                          : _countriesBloc[index]
                                                                  .countrycode[
                                                              listindex]),
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
          return const CircularProgressIndicator(
              backgroundColor: kbackgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor));
        }
      },
    );
  }

  _displayContactNumberTF(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        child: TextFormField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          ],
          cursorColor: kgreenPrimaryColor,
          maxLength: 15,
          controller: _contactnumberController[index],
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            color: kblackPrimaryColor,
            fontFamily: 'OpenSans',
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kPhoneNumberNullError);
            } else if (value.length > 4) {
              removeError(error: kPhoneNumberLengthError);
            }
          },
          validator: (value) {
            if (value!.isEmpty) {
              return kPhoneNumberNullError;
              //addError(error: kEmailNullError);
            } else if (value.length < 4) {
              return kPhoneNumberLengthError;
              //addError(error: kInvalidEmailError);

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
              hintText: 'Enter your Contact Number',
              hintStyle: hintstyle),
        ),
      ),
    );
  }

  void getdata() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditPreviousEmployer(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');

    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    var focuscount = 0;
    for (int i = 0;
        i < Provider.of<ResumeEmployerProvider>(context, listen: false).length;
        i++) {
      _countriesBloc.add(PhoneCountriesBloc());
      _countriesBloc[i].eventCountriesSink.add(PhoneCountriesAction.Post);
      _companyNameFocus.add(FocusNode());
      _companynameController.add(TextEditingController());
      _contactnameController.add(TextEditingController());
      _contactnumberController.add(TextEditingController());
      _dropdownBloc.add(DropdownBloc());
      _showCountryDropDownBloc.add(IndosNoBloc());
      _countryValue.add("");
      _errorCountryCodeBloc.add(ResumeErrorIssuingAuthorityBloc());
      if (i <
          Provider.of<ResumeEmployerProvider>(context, listen: false)
              .companyName
              .length) {
        _companynameController[i].text =
            Provider.of<ResumeEmployerProvider>(context, listen: false)
                .companyName[i];
        _contactnameController[i].text =
            Provider.of<ResumeEmployerProvider>(context, listen: false)
                .contactPersonName[i];
        _contactnumberController[i].text =
            Provider.of<ResumeEmployerProvider>(context, listen: false)
                .contactNumber[i];
      } else {
        focuscount = 1;
      }
    }
    if (focuscount == 1) {
      _companyNameFocus[
              Provider.of<ResumeEmployerProvider>(context, listen: false)
                      .length -
                  1]
          .requestFocus();
    }
    asyncProvider.changeAsynccall();
  }

  void callPostEmployerRecord() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditPreviousEmployer(), context);
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    ResumeEditEmployerUpdateProvider editEmployerProvider =
        Provider.of<ResumeEditEmployerUpdateProvider>(context, listen: false);
    List<Reference> postList = [];
    for (int i = 0;
        i < Provider.of<ResumeEmployerProvider>(context, listen: false).length;
        i++) {
      String id;
      if (i <
          Provider.of<ResumeEmployerProvider>(context, listen: false)
              .employerId
              .length) {
        id = Provider.of<ResumeEmployerProvider>(context, listen: false)
            .employerId[i];
      } else {
        id = "";
      }
      String contactname = _contactnameController[i].text.trim();
      postList.add(Reference(
          companyName: _companynameController[i].text,
          contactPerson: contactname,
          contactno: _contactnumberController[i].text,
          countryId: _countriesBloc[i].countryId[
              _countriesBloc[i].countrycode.indexOf(_countryValue[i])],
          id: id));
    }
    if (await editEmployerProvider.callpostResumeEmployerapi(
        postList, header)) {
      asyncProvider.changeAsynccall();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PreviousEmployeeReference()));
    } else {
      asyncProvider.changeAsynccall();
      displaysnackbar('Something went wrong');
    }
  }

  _displayerrortext(int index) {
    return StreamBuilder(
      initialData: false,
      stream: _errorCountryCodeBloc[index].stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && _errorCountryCodeBloc[index].showtext) {
          return Visibility(
            visible: _errorCountryCodeBloc[index].showtext,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please select the country code',
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

  void cleardata() {
    _companynameController = [];
    _contactnameController = [];
    _contactnumberController = [];
    _companyNameFocus = [];
    _dropdownBloc.clear();
    _countryValue.clear();
    _errorCountryCodeBloc.clear();
  }

  _displaycarddata(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Employer ${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                _showDeleteDialog(index);
              },
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
        _displayCompanyNameTF(index),
        const SizedBox(
          height: 24,
        ),
        _displayContactNameTF(index),
        const SizedBox(
          height: 24,
        ),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                //height: 80,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Column(
                      children: [
                        _buildcountrydropdown(index),
                        _displayerrortext(index),
                        _displayContactNumberTF(index),
                      ],
                    )),
              ),
            ),
            TextBoxLabel('Contact Number')
          ],
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }

  void _showDeleteDialog(int index) {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: const Text('Delete Previous Employer Record',
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

  deleterecord(int index) async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const EditPreviousEmployer(), context);
    if (index ==
        Provider.of<ResumeEmployerProvider>(context, listen: false)
            .companyName
            .length) {
      ResumeEmployerProvider employerProvider =
          Provider.of<ResumeEmployerProvider>(context, listen: false);
      setState(() {
        employerProvider.decreaselength();
        _companynameController.removeLast();
        _contactnameController.removeLast();
        _contactnumberController.removeLast();
        _countryValue.removeLast();
        cleardata();
        getdata();
      });
    } else {
      ResumeEmployerDeleteProvider employerDeleteProvider =
          Provider.of<ResumeEmployerDeleteProvider>(context, listen: false);
      employerDeleteProvider.callpostDeleteResumeEmployerapi(
          Provider.of<ResumeEmployerProvider>(context, listen: false)
              .employerId[index],
          header);
      ResumeEmployerProvider employerProvider =
          Provider.of<ResumeEmployerProvider>(context, listen: false);
      setState(() {
        employerProvider.decreaselength();
        _companynameController.removeAt(index);
        _contactnameController.removeAt(index);
        _contactnumberController.removeAt(index);
        _countryValue.removeAt(index);
      });
    }
  }
}
