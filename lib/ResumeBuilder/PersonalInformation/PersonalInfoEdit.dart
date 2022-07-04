// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../DropdownBloc.dart';
import '../../DropdownContainer.dart';
import '../../EditableVerifiedContainer.dart';
import '../../IssuingAuthorityErrorBloc.dart';
import '../../NotVerifiedContainer.dart';
import '../../Profile/UserDetailsProvider.dart';
import '../../RadioButtonBloc.dart';
import '../../Register/CountriesBloc.dart';
import '../../SearchTextProvider.dart';
import '../../TextBoxLabel.dart';
import '../../asynccallprovider.dart';
import '../../constants.dart';
import '../Header.dart';
import 'EditPersonalProvider.dart';
import 'ExpandedAnimation.dart';
import 'GetResumeProvider.dart';
import 'IndosNoBloc.dart';
import 'ResumeBuilder.dart';
import 'Scrollbar.dart';

class PersonalInfoEdit extends StatefulWidget {
  const PersonalInfoEdit({Key? key}) : super(key: key);

  @override
  _PersonalInfoEditState createState() => _PersonalInfoEditState();
}

class _PersonalInfoEditState extends State<PersonalInfoEdit> {
  static final _formKey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController(),
      lastnameController = TextEditingController(),
      emailController = TextEditingController(),
      phonenumberController = TextEditingController(),
      alternatephonenumberController = TextEditingController(),
      passwordController = TextEditingController(),
      dobController = TextEditingController();
  final _countriesBloc = PhoneCountriesBloc();
  final _dropdownBloc = DropdownBloc();
  final _alternatecountriesBloc = PhoneCountriesBloc();
  final _alternatedropdownBloc = DropdownBloc();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');

  DateTime selectedDate = DateTime.now();
  bool showcountryerror = false;
  String countryvalue = "", alternatecountryvalue = "";
  var header;
  final _errorCountryCodeBloc = ResumeErrorIssuingAuthorityBloc();
  final _alternateerrorCountryCodeBloc = ResumeErrorIssuingAuthorityBloc();
  final RadioButtonBloc _phoneNumberStatusBloc = RadioButtonBloc(),
      _emailStatusBloc = RadioButtonBloc();
  final _showCountryDropDownBloc = IndosNoBloc(),
      _showAlternativeCountryDropDownBloc = IndosNoBloc();
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
    _countriesBloc.dispose();
    _alternatecountriesBloc.dispose();
    _dropdownBloc.dispose();
    _alternatedropdownBloc.dispose();
    _errorCountryCodeBloc.dispose();
    _alternateerrorCountryCodeBloc.dispose();
    _phoneNumberStatusBloc.dispose();
    _emailStatusBloc.dispose();
    _showCountryDropDownBloc.dispose();
    _showAlternativeCountryDropDownBloc.dispose();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ResumeHeader('Personal Information', 1, true, ""),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Card(
                        color: Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFnameTF(),
                              const SizedBox(height: 14.0),
                              _buildLnameTF(),
                              const SizedBox(height: 14.0),
                              _displayContactNumberBloc(true),
                              //_buildcountryandphoneTF(),
                              const SizedBox(height: 14.0),
                              _displayContactNumberBloc(false),
                              const SizedBox(height: 14.0),
                              _buildEmailTF(),
                              _buildStatusContainer(1, true),
                              const SizedBox(height: 14.0),
                              _buildDOBTF(),
                              const SizedBox(height: 14.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: buttonStyle(),
                                    onPressed: () {
                                      bool checkData = false;

                                      if (countryvalue.isEmpty) {
                                        checkData = true;
                                        _errorCountryCodeBloc
                                            .eventResumeIssuingAuthoritySink
                                            .add(
                                                ResumeErrorIssuingAuthorityAction
                                                    .True);
                                      } else {
                                        _errorCountryCodeBloc
                                            .eventResumeIssuingAuthoritySink
                                            .add(
                                                ResumeErrorIssuingAuthorityAction
                                                    .False);
                                      }

                                      if (alternatecountryvalue.isEmpty &&
                                          alternatephonenumberController
                                              .text.isNotEmpty) {
                                        checkData = true;
                                        _alternateerrorCountryCodeBloc
                                            .eventResumeIssuingAuthoritySink
                                            .add(
                                                ResumeErrorIssuingAuthorityAction
                                                    .True);
                                      } else {
                                        _alternateerrorCountryCodeBloc
                                            .eventResumeIssuingAuthoritySink
                                            .add(
                                                ResumeErrorIssuingAuthorityAction
                                                    .False);
                                      }
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        if (!checkData) {
                                          calleditprofilefunction();
                                        }
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
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFnameTF() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: kbackgroundColor,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
              ],
              cursorColor: kgreenPrimaryColor,
              controller: firstnameController,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter your first name');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your first name';
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
                  hintText: 'Enter your First Name',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('First Name')
      ],
    );
  }

  Widget _buildLnameTF() {
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
              cursorColor: kgreenPrimaryColor,
              controller: lastnameController,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: 'Please enter your last name');
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your last name';
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
                  hintText: 'Enter your Last Name',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Last Name')
      ],
    );
  }

  _buildcountrydropdown(bool isPrimary) {
    return StreamBuilder(
      stream: isPrimary
          ? _countriesBloc.stateCountriesStrean
          : _alternatecountriesBloc.stateCountriesStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (isPrimary) {
            if (Provider.of<GetResumeProvider>(context, listen: false)
                .countryid
                .isNotEmpty) {
              countryvalue = _countriesBloc.countrycode[_countriesBloc.countryId
                  .indexOf(
                      Provider.of<GetResumeProvider>(context, listen: false)
                          .countryid)];
              _dropdownBloc.setdropdownvalue(countryvalue);
              _dropdownBloc.eventDropdownSink.add(DropdownAction.Update);
            } else {
              countryvalue = _countriesBloc.countrycode[0];
              _dropdownBloc.setdropdownvalue(countryvalue);
              _dropdownBloc.eventDropdownSink.add(DropdownAction.Update);
            }
          } else {
            if (Provider.of<GetResumeProvider>(context, listen: false)
                .alternatecountryid
                .isNotEmpty) {
              alternatecountryvalue = _alternatecountriesBloc.countrycode[
                  _alternatecountriesBloc.countryId.indexOf(
                      Provider.of<GetResumeProvider>(context, listen: false)
                          .alternatecountryid)];
              _alternatedropdownBloc.setdropdownvalue(countryvalue);
              _alternatedropdownBloc.eventDropdownSink
                  .add(DropdownAction.Update);
            } else {
              alternatecountryvalue = _alternatecountriesBloc.countrycode[0];
              _alternatedropdownBloc.setdropdownvalue(alternatecountryvalue);
              _alternatedropdownBloc.eventDropdownSink
                  .add(DropdownAction.Update);
            }
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(
                        20.0) //                 <--- border radius here
                    ),
              ),
              child: StreamBuilder(
                stream: isPrimary
                    ? _dropdownBloc.stateDropdownStrean
                    : _alternatedropdownBloc.stateDropdownStrean,
                builder: (context, dropdownsnapshot) {
                  return StreamBuilder(
                    stream: isPrimary
                        ? _showCountryDropDownBloc.stateIndosNoStrean
                        : _showAlternativeCountryDropDownBloc
                            .stateIndosNoStrean,
                    initialData: false,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          DrodpownContainer(
                            title: isPrimary
                                ? countryvalue.isNotEmpty
                                    ? countryvalue
                                    : 'Select Country'
                                : alternatecountryvalue.isNotEmpty
                                    ? alternatecountryvalue
                                    : 'Select Country',
                            searchHint: 'Search Country',
                            showDropDownBloc: isPrimary
                                ? _showCountryDropDownBloc
                                : _showAlternativeCountryDropDownBloc,
                            originalList: isPrimary
                                ? _countriesBloc.countrycode
                                : _alternatecountriesBloc.countrycode,
                          ),
                          ExpandedSection(
                            expand: isPrimary
                                ? _showCountryDropDownBloc.isedited
                                : _showAlternativeCountryDropDownBloc.isedited,
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
                                              : isPrimary
                                                  ? _countriesBloc
                                                      .countrycode.length
                                                  : _alternatecountriesBloc
                                                      .countrycode.length,
                                      itemBuilder: (context, listindex) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (!Provider.of<
                                                              SearchChangeProvider>(
                                                          context,
                                                          listen: false)
                                                      .noDataFound) {
                                                    if (isPrimary) {
                                                      _showCountryDropDownBloc
                                                          .eventIndosNoSink
                                                          .add(IndosNoAction
                                                              .False);
                                                      _errorCountryCodeBloc
                                                          .eventResumeIssuingAuthoritySink
                                                          .add(
                                                              ResumeErrorIssuingAuthorityAction
                                                                  .False);
                                                      countryvalue = Provider
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
                                                          : isPrimary
                                                              ? _countriesBloc
                                                                      .countrycode[
                                                                  listindex]
                                                              : _alternatecountriesBloc
                                                                      .countrycode[
                                                                  listindex];
                                                    } else {
                                                      _showAlternativeCountryDropDownBloc
                                                          .eventIndosNoSink
                                                          .add(IndosNoAction
                                                              .False);
                                                      _alternateerrorCountryCodeBloc
                                                          .eventResumeIssuingAuthoritySink
                                                          .add(
                                                              ResumeErrorIssuingAuthorityAction
                                                                  .False);
                                                      alternatecountryvalue = Provider.of<
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
                                                          : isPrimary
                                                              ? _countriesBloc
                                                                      .countrycode[
                                                                  listindex]
                                                              : _alternatecountriesBloc
                                                                      .countrycode[
                                                                  listindex];
                                                    }
                                                    _dropdownBloc.setdropdownvalue(Provider
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
                                                        : isPrimary
                                                            ? _countriesBloc
                                                                    .countrycode[
                                                                listindex]
                                                            : _alternatecountriesBloc
                                                                    .countrycode[
                                                                listindex]);
                                                    _dropdownBloc
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
                                                                  listen: false)
                                                              .searchList
                                                              .isNotEmpty
                                                          ? Provider.of<SearchChangeProvider>(
                                                                      context,
                                                                      listen: false)
                                                                  .searchList[
                                                              listindex]
                                                          : isPrimary
                                                              ? _countriesBloc
                                                                      .countrycode[
                                                                  listindex]
                                                              : _alternatecountriesBloc
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
        } else {
          return const CircularProgressIndicator(
              backgroundColor: kbackgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(kgreenPrimaryColor));
        }
      },
    );
  }

  _displayerrortext(bool isPrimary) {
    return StreamBuilder(
      initialData: false,
      stream: isPrimary
          ? _errorCountryCodeBloc.stateResumeIssuingAuthorityStrean
          : _alternateerrorCountryCodeBloc.stateResumeIssuingAuthorityStrean,
      builder: (context, snapshot) {
        if (snapshot.hasData && isPrimary
            ? _errorCountryCodeBloc.showtext
            : _alternateerrorCountryCodeBloc.showtext) {
          return Visibility(
            visible: isPrimary
                ? _errorCountryCodeBloc.showtext
                : _alternateerrorCountryCodeBloc.showtext,
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

  _buildProfilePhoneNumberTF(bool isPrimary) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        color: Colors.white,
        child: TextFormField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          ],
          maxLength: 15,
          cursorColor: kgreenPrimaryColor,
          controller: isPrimary
              ? phonenumberController
              : alternatephonenumberController,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: kblackPrimaryColor,
            fontFamily: 'OpenSans',
          ),
          onChanged: (value) {
            if (isPrimary) {
              if (phonenumberController.text !=
                  Provider.of<GetResumeProvider>(context, listen: false)
                      .phonenumber) {
                _phoneNumberStatusBloc.eventRadioButtonSink
                    .add(RadioButtonAction.False);
              } else {
                _phoneNumberStatusBloc.eventRadioButtonSink
                    .add(RadioButtonAction.True);
              }
            }
            if (value.isNotEmpty && isPrimary) {
              removeError(error: kPhoneNumberNullError);
            } else if (value.length > 4) {
              removeError(error: kPhoneNumberLengthError);
            }
          },
          validator: (value) {
            if (value!.isEmpty && isPrimary) {
              return kPhoneNumberNullError;
              //addError(error: kEmailNullError);
            } else if (value.isNotEmpty && value.length < 4) {
              return kPhoneNumberLengthError;
              //addError(error: kInvalidEmailError);

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
              hintText: 'Enter your Phone Number',
              hintStyle: hintstyle),
        ),
      ),
    );
  }

  Widget _buildEmailTF() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: kblackPrimaryColor,
                fontFamily: 'OpenSans',
              ),
              onChanged: (value) {
                if (value !=
                    Provider.of<GetResumeProvider>(context, listen: false)
                        .email) {
                  _emailStatusBloc.eventRadioButtonSink
                      .add(RadioButtonAction.False);
                } else {
                  _emailStatusBloc.eventRadioButtonSink
                      .add(RadioButtonAction.True);
                }
                if (value.isNotEmpty) {
                  removeError(error: kEmailNullError);
                } else if (value.contains('@') &&
                    emailValidatorRegExp.hasMatch(value)) {
                  removeError(error: kInvalidEmailError);
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return kEmailNullError;
                  //addError(error: kEmailNullError);

                } else if (value.contains('@') &&
                    !emailValidatorRegExp.hasMatch(value)) {
                  return kInvalidEmailError;
                  //addError(error: kInvalidEmailError);

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
                  hintText: 'Enter your Email',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('Email')
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    var initialDate =
        DateTime(selectedDate.year - 16, selectedDate.month, selectedDate.day);
    var firstDate =
        DateTime(selectedDate.year - 60, selectedDate.month, selectedDate.day);
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: initialDate);
    if (picked != null && picked != selectedDate) {
      setState(() {
        dobController.text = formatter.format(picked);
      });
    }
  }

  _buildDOBTF() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              cursorColor: kgreenPrimaryColor,
              controller: dobController,
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
                    onTap: () => _selectDate(context),
                    child: const Icon(
                      Icons.date_range,
                      color: kBluePrimaryColor,
                    ),
                  ),
                  hintText: 'Enter your Dob',
                  hintStyle: hintstyle),
            ),
          ),
        ),
        TextBoxLabel('DOB')
      ],
    );
  }

  void calleditprofilefunction() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const PersonalInfoEdit(), context);
    AsyncCallProvider asyncProvider =
        Provider.of<AsyncCallProvider>(context, listen: false);
    if (!Provider.of<AsyncCallProvider>(context, listen: false).isinasynccall) {
      asyncProvider.changeAsynccall();
    }
    ResumePersonalInfoUpdateProvider resumePersonalInfoUpdateProvider =
        Provider.of<ResumePersonalInfoUpdateProvider>(context, listen: false);
    String alternativecountryId = "";
    if (alternatecountryvalue.isNotEmpty) {
      alternativecountryId = _alternatecountriesBloc.countryId[
          _alternatecountriesBloc.countrycode.indexOf(alternatecountryvalue)];
    }
    if (await resumePersonalInfoUpdateProvider.callpostResumeprofileapi(
        firstnameController.text,
        lastnameController.text,
        phonenumberController.text,
        emailController.text,
        _countriesBloc
            .countryId[_countriesBloc.countrycode.indexOf(countryvalue)],
        alternativecountryId,
        alternatephonenumberController.text,
        dobController.text,
        Provider.of<UserDetailsProvider>(context, listen: false).userid,
        header)) {
      asyncProvider.changeAsynccall();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'ProfileUpdateSuccess', 'Personal Information updated successfully');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ResumeBuilder()));
    } else {
      asyncProvider.changeAsynccall();
      displaysnackbar(
          Provider.of<ResumePersonalInfoUpdateProvider>(context).error);
    }
  }

  void getdata() async {
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const PersonalInfoEdit(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    header = prefs.getString('header');
    _phoneNumberStatusBloc.eventRadioButtonSink.add(RadioButtonAction.True);
    _emailStatusBloc.eventRadioButtonSink.add(RadioButtonAction.True);
    _countriesBloc.eventCountriesSink.add(PhoneCountriesAction.Post);
    _alternatecountriesBloc.eventCountriesSink.add(PhoneCountriesAction.Post);
    firstnameController.text =
        Provider.of<GetResumeProvider>(context, listen: false).fname;
    lastnameController.text =
        Provider.of<GetResumeProvider>(context, listen: false).lname;
    emailController.text =
        Provider.of<GetResumeProvider>(context, listen: false).email;
    phonenumberController.text =
        Provider.of<GetResumeProvider>(context, listen: false).phonenumber;

    if (Provider.of<GetResumeProvider>(context, listen: false)
            .alternatephonenumber !=
        "null") {
      alternatephonenumberController.text =
          Provider.of<GetResumeProvider>(context, listen: false)
              .alternatephonenumber;
    }
    dobController.text =
        Provider.of<GetResumeProvider>(context, listen: false).dob;
  }

  _displayContactNumberBloc(bool isprimary) {
    return Stack(
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
                    _buildcountrydropdown(isprimary),
                    _displayerrortext(isprimary),
                    _buildProfilePhoneNumberTF(isprimary),
                    isprimary
                        ? Provider.of<GetResumeProvider>(context, listen: false)
                                .phonenumber
                                .isEmpty
                            ? Container()
                            : _buildStatusContainer(0, true)
                        : const SizedBox()
                  ],
                )),
          ),
        ),
        TextBoxLabel(isprimary ? 'Phone Number' : 'Alternative Phone Number')
      ],
    );
  }

  _buildStatusContainer(int index, bool isPrimary) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: StreamBuilder(
          stream: index == 1
              ? _emailStatusBloc.stateRadioButtonStrean
              : _phoneNumberStatusBloc.stateRadioButtonStrean,
          builder: (context, snapshot) {
            if (snapshot.hasData && index == 1
                ? _emailStatusBloc.radioValue
                : _phoneNumberStatusBloc.radioValue) {
              return EditableVerifiedContainer();
            } else {
              return NotVerifiedContaier(
                value: index == 1 ? 0 : 1,
                email: emailController.text,
                phone: isPrimary
                    ? phonenumberController.text
                    : alternatephonenumberController.text,
              );
            }
          },
        ),
      ),
    );
  }
}
