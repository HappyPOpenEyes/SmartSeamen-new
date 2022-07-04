// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../SideBar/SideBar.dart';
import '../../asynccallprovider.dart';
import '../../bottomnavigation.dart';
import '../../constants.dart';
import '../DangerousCargoEndorsment/DangerourCargo.dart';
import '../DangerousCargoEndorsment/DangerousCargoProvider.dart';
import '../Header.dart';
import 'DocumentScreenProvider.dart';
import 'EditCompetencyDocuments.dart';
import 'EditMedicalDocuments.dart';
import 'EditSTCWDocumentScreen.dart';
import 'EditTravelDocumentScreen.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({Key? key}) : super(key: key);

  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: const Color(0xFFF4F5FD),
      bottomNavigationBar: BottomNavigationClass(3),
      drawer: Drawer(
          child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.57,
              child: Sidebar())),
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
              ResumeHeader('Documents', 2, false, _scaffoldkey),
              _displayTravelDocuments(),
              _displayMedicalDocuments(),
              _displayCompetencyDocuments(),
              _displaySTCWAdditionalDocuments(),
            ],
          ),
        ),
      ),
    );
  }

  _displayTravelDocuments() {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: _displaycardheader('Travel', 0),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _displaySubHeading('Passport Details'),
                      const SizedBox(
                        height: 10,
                      ),
                      Provider.of<ResumeDocumentProvider>(context)
                              .passportNo
                              .isEmpty
                          ? _displayNoRecordText(
                              'No Passport details added. Click ',
                              ' to add Passport details.',
                              0)
                          : _displayPassportData(),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Divider(
                          thickness: 0.3,
                          color: kBluePrimaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _displaySubHeading('CDC / Seamen Book'),
                      const SizedBox(
                        height: 10,
                      ),
                      Provider.of<ResumeDocumentProvider>(context)
                              .cdcBookNo
                              .isEmpty
                          ? _displayNoRecordText('No CDC records added. Click ',
                              ' to add CDC records.', 0)
                          : _displayCDCCard(),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Divider(
                          thickness: 0.3,
                          color: kBluePrimaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _displaySubHeading('Visa'),
                      const SizedBox(
                        height: 10,
                      ),
                      Provider.of<ResumeDocumentProvider>(context,
                                  listen: false)
                              .visaId
                              .isEmpty
                          ? _displayNoRecordText(
                              'No Visa records added. Click ',
                              ' to add Visa records.',
                              0)
                          : _displayVisaCard(),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _displaycardheader(String s, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.48,
            child: Text(s,
                style: TextStyle(
                    color: kBluePrimaryColor,
                    fontSize: checkDeviceSize(context)
                        ? MediaQuery.of(context).size.width * 0.05
                        : MediaQuery.of(context).size.width * 0.045,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            width: 10,
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              if (index == 0) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EditTravelDocument()));
              } else if (index == 1) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EditMedicalDocuments()));
              } else if (index == 2) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EditCompetencyDocuments()));
              } else if (index == 3) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EditSTCWDocumentScreen()));
              }
            },
            child: Text(
                index == 0
                    ? Provider.of<ResumeDocumentProvider>(context)
                            .showtraveldocs
                        ? 'Edit'
                        : 'Add'
                    : index == 1
                        ? !Provider.of<ResumeDocumentProvider>(context)
                                .showMedicalDocuments
                            ? 'Add'
                            : 'Edit'
                        : index == 2
                            ? Provider.of<ResumeDocumentProvider>(context)
                                    .showCompetencydocs
                                ? 'Edit'
                                : 'Add'
                            : Provider.of<ResumeDocumentProvider>(context)
                                    .stcwCertificateNo
                                    .isEmpty
                                ? 'Add'
                                : 'Edit',
                style: TextStyle(
                    color: kgreenPrimaryColor,
                    fontSize: checkDeviceSize(context)
                        ? MediaQuery.of(context).size.width * 0.045
                        : MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  _displaySubHeading(String s) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(s,
          style: TextStyle(
              color: kgreenPrimaryColor,
              fontSize: checkDeviceSize(context)
                  ? MediaQuery.of(context).size.width * 0.045
                  : MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.bold)),
    );
  }

  _displaystatictext(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: checkDeviceSize(context)
                ? MediaQuery.of(context).size.width * 0.04
                : MediaQuery.of(context).size.width * 0.035,
          ),
        ),
        const SizedBox(
          height: 1,
        ),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: checkDeviceSize(context)
                ? MediaQuery.of(context).size.width * 0.038
                : MediaQuery.of(context).size.width * 0.032,
          ),
        ),
      ],
    );
  }

  _displayMedicalDocuments() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  title: _displaycardheader('Medical', 1),
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    !Provider.of<ResumeDocumentProvider>(context)
                            .showMedicalDocuments
                        ? _displayNoRecordText(
                            'No medical documents added. Click ',
                            ' to add medical documents.',
                            1)
                        : _displayMedicalDataCard(),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _displayCompetencyDocuments() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: _displaycardheader('Competency', 2),
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Provider.of<ResumeDocumentProvider>(context, listen: false)
                            .showCompetencydocs
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _displayTravelsSubHeading('Mandatory'),
                              const SizedBox(
                                height: 5,
                              ),
                              _displayCompetencyDetails(true),
                              _displayTravelsSubHeading('Optional'),
                              const SizedBox(
                                height: 5,
                              ),
                              _displayCompetencyDetails(false),
                            ],
                          )
                        : _displayNoRecordText(
                            'No Competency details added. Click ',
                            ' to add Passport details.',
                            2)
                  ],
                ))
          ]),
        ),
      ),
    );
  }

  _displaySTCWAdditionalDocuments() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: _displaycardheader('STCW & Additional', 3),
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Provider.of<ResumeDocumentProvider>(context).hasStcwDoc
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _displayTravelsSubHeading('Mandatory'),
                              const SizedBox(
                                height: 5,
                              ),
                              _displaySTCWCard(true),
                              _displayTravelsSubHeading('Optional'),
                              const SizedBox(
                                height: 5,
                              ),
                              _displaySTCWCard(false),
                            ],
                          )
                        : _displayNoRecordText('No STCW details added. Click ',
                            ' to add Passport details.', 3)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _displaySTCWCard(bool isMandatory) {
    return !isMandatory
        ? Provider.of<ResumeDocumentProvider>(context, listen: false)
                .stcwOptionalDocumentName
                .isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Please enter optional documents',
                    style: TextStyle(
                        color: kblackPrimaryColor,
                        fontSize: MediaQuery.of(context).size.width * 0.038)),
              )
            : _showSTCWDetails(isMandatory)
        : _showSTCWDetails(isMandatory);
  }

  _showSTCWDetails(bool isMandatory) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: isMandatory
            ? Provider.of<ResumeDocumentProvider>(context)
                .stcwDocumentName
                .length
            : Provider.of<ResumeDocumentProvider>(context)
                .stcwOptionalDocumentName
                .length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _displaySTCWDetailsCard(
                  index,
                  isMandatory
                      ? Provider.of<ResumeDocumentProvider>(context)
                          .stcwDocumentName[index]
                      : Provider.of<ResumeDocumentProvider>(context)
                          .stcwOptionalDocumentName[index],
                  isMandatory),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        },
      ),
    );
  }

  _displayCDCCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                Provider.of<ResumeDocumentProvider>(context, listen: false)
                    .cdcBookNo
                    .length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: _displaystatictext(
                            'Certificate No',
                            Provider.of<ResumeDocumentProvider>(context,
                                    listen: false)
                                .cdcBookNo[index]),
                      ),
                      _displaystatictext(
                          'Issuing Auhtority',
                          Provider.of<ResumeDocumentProvider>(context,
                                      listen: false)
                                  .cdcPlaceofIssueName[index] ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  _displayCDCData(index),
                  const SizedBox(
                    height: 5,
                  ),
                  index + 1 ==
                          Provider.of<ResumeDocumentProvider>(context,
                                  listen: false)
                              .cdcBookId
                              .length
                      ? const SizedBox()
                      : const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Divider(
                            thickness: 0.25,
                            color: Colors.grey,
                          ),
                        ),
                ],
              );
            },
          )),
    );
  }

  _displayTravelsSubHeading(String category) {
    return Wrap(
      children: [
        Text(
          category,
          style: TextStyle(
            color: kgreenPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: checkDeviceSize(context)
                ? MediaQuery.of(context).size.width * 0.045
                : MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      ],
    );
  }

  _displayCDCData(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: _displaystatictext(
                  'Issue Date',
                  Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .cdcIssueDate[index]),
            ),
            _displaystatictext(
                'Valid Till',
                Provider.of<ResumeDocumentProvider>(context, listen: false)
                        .cdcExpiryDate[index]
                        .isEmpty
                    ? Provider.of<ResumeDocumentProvider>(context,
                            listen: false)
                        .cdcValidTillTypeName[index]
                    : Provider.of<ResumeDocumentProvider>(context,
                            listen: false)
                        .cdcExpiryDate[index]),
          ],
        )
      ],
    );
  }

  _displayVisaCard() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount:
          Provider.of<ResumeDocumentProvider>(context).visaStaticNames.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  Provider.of<ResumeDocumentProvider>(context)
                      .visaDisplayStaticNames[index],
                  style: TextStyle(
                      color: kBluePrimaryColor,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 5,
              ),
              _displayVisaData(index),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        );
      },
    );
  }

  _displayVisaData(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: _displaystatictext(
                  'Issue Date',
                  Provider.of<ResumeDocumentProvider>(context)
                      .visaIssueDate[index]),
            ),
            _displaystatictext(
                'Valid Till',
                Provider.of<ResumeDocumentProvider>(context)
                        .visaExpiryDate[index]
                        .isEmpty
                    ? Provider.of<ResumeDocumentProvider>(context)
                        .visaStaticValidType[index]
                    : Provider.of<ResumeDocumentProvider>(context)
                        .visaExpiryDate[index]),
          ],
        )
      ],
    );
  }

  _displayCompetencyCard(int index, String categoryname, bool isMandatory) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(categoryname,
              style: TextStyle(
                  color: kBluePrimaryColor,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          _displayCompetencyData(index, isMandatory),
          const SizedBox(
            height: 10,
          ),
          isMandatory
              ? Provider.of<ResumeDocumentProvider>(context, listen: false)
                      .competencyMandatoryCheck
                  ? Text('Please select all the mandatory documents',
                      style: TextStyle(
                          color: Colors.red[500],
                          fontSize: MediaQuery.of(context).size.width * 0.038))
                  : Container()
              : Container()
        ],
      ),
    );
  }

  _displayCompetencyData(int index, bool isMandatory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.44,
              child: _displaystatictext(
                'Certificate No.',
                isMandatory
                    ? Provider.of<ResumeDocumentProvider>(context,
                            listen: false)
                        .displaycompetencyCertificateNo[index]
                    : Provider.of<ResumeDocumentProvider>(context,
                                listen: false)
                            .displayOptionalcompetencyCertificateNo[index],
              ),
            ),
            _displaystatictext(
                'Issuing Authority',
                isMandatory
                    ? Provider.of<ResumeDocumentProvider>(context,
                            listen: false)
                        .displaycompetencyPlaceofIssueName[index]
                    : Provider.of<ResumeDocumentProvider>(context,
                            listen: false)
                        .displayOptionalcompetencyPlaceofIssueName[index]),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.44,
                child: _displaystatictext(
                    'Issue Date',
                    isMandatory
                        ? Provider.of<ResumeDocumentProvider>(context)
                            .displaycompetencyIssueDate[index]
                        : Provider.of<ResumeDocumentProvider>(context)
                            .displayOptionalcompetencyIssueDate[index]),
              ),
              _displaystatictext(
                  'Valid Till',
                  isMandatory
                      ? Provider.of<ResumeDocumentProvider>(context)
                              .displaycompetencyExpiryDate[index]
                              .isEmpty
                          ? Provider.of<ResumeDocumentProvider>(context)
                              .displaycompetencyValidTillType[index]
                          : Provider.of<ResumeDocumentProvider>(context)
                              .displaycompetencyExpiryDate[index]
                      : Provider.of<ResumeDocumentProvider>(context)
                              .displayOptionalcompetencyExpiryDate[index]
                              .isEmpty
                          ? Provider.of<ResumeDocumentProvider>(context)
                              .displayOptionalcompetencyValidTillType[index]
                          : Provider.of<ResumeDocumentProvider>(context)
                              .displayOptionalcompetencyExpiryDate[index]),
            ],
          ),
        ),
      ],
    );
  }

  _displaySTCWDetailsCard(int index, String documentname, bool isMandatory) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _displayTravelsSubHeading(documentname),
          const SizedBox(
            height: 10,
          ),
          _displaySTCWData(index, isMandatory),
        ],
      ),
    );
  }

  _displaySTCWData(int index, bool isMandatory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isMandatory
            ? Provider.of<ResumeDocumentProvider>(context, listen: false)
                    .stcwCertificateNo[index]
                    .isEmpty
                ? Container()
                : _displaystatictext(
                    'Certificate No.',
                    Provider.of<ResumeDocumentProvider>(context, listen: false)
                        .stcwCertificateNo[index])
            : Provider.of<ResumeDocumentProvider>(context, listen: false)
                    .stcwOptionalCertificateNo[index]
                    .isEmpty
                ? Container()
                : _displaystatictext(
                    'Certificate No.',
                    Provider.of<ResumeDocumentProvider>(context, listen: false)
                        .stcwOptionalCertificateNo[index]),
        Row(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.44,
                child: _displaystatictext(
                    'Issue Date',
                    isMandatory
                        ? Provider.of<ResumeDocumentProvider>(context)
                            .stcwIssueDate[index]
                        : Provider.of<ResumeDocumentProvider>(context)
                            .stcwOptionalIssueDate[index])),
            _displaystatictext(
                'Expiry Date',
                isMandatory
                    ? Provider.of<ResumeDocumentProvider>(context)
                            .stcwValidTillType[index]
                            .isEmpty
                        ? Provider.of<ResumeDocumentProvider>(context)
                            .stcwExpiryDate[index]
                        : Provider.of<ResumeDocumentProvider>(context)
                            .stcwValidTillType[index]
                    : Provider.of<ResumeDocumentProvider>(context)
                            .stcwOptionalValidTillType[index]
                            .isEmpty
                        ? Provider.of<ResumeDocumentProvider>(context)
                            .stcwOptionalExpiryDate[index]
                        : Provider.of<ResumeDocumentProvider>(context)
                            .stcwOptionalValidTillType[index])
          ],
        ),
      ],
    );
  }

  void getdata() async {
    bool isRedirect = false;
    bool result = await checkConnectivity();
    if (result) callNoInternetScreen(const DocumentScreen(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.getString('header');
    if (prefs.getString('DeleteSuccesful') != null) {
      displaysnackbar(prefs.getString('DeleteSuccesful') ?? '');
      prefs.remove('DeleteSuccesful');
      if (checkNavigation()) {
        isRedirect = true;
        Future.delayed(const Duration(seconds: 1)).then((value) =>
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DangerousCargo())));
      }
    }
    if (prefs.getString('RecordAdded') != null) {
      displaysnackbar(prefs.getString('RecordAdded') ?? '');

      prefs.remove('RecordAdded');
      if (checkNavigation()) {
        isRedirect = true;
        Future.delayed(const Duration(seconds: 1)).then((value) =>
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DangerousCargo())));
      }
    }

    if (!isRedirect) {
      AsyncCallProvider asyncProvider =
          Provider.of<AsyncCallProvider>(context, listen: false);
      if (!Provider.of<AsyncCallProvider>(context, listen: false)
          .isinasynccall) {
        asyncProvider.changeAsynccall();
      }
      ResumeDocumentProvider getResumeDocumentProvider =
          Provider.of<ResumeDocumentProvider>(context, listen: false);
      if (!await getResumeDocumentProvider.callgetDocumentapi(header)) {
        displaysnackbar('Something went wrong');
      }
      asyncProvider.changeAsynccall();
    }
  }

  _displayPassportData() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount:
            Provider.of<ResumeDocumentProvider>(context).passportNo.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: _displaystatictext(
                          'Passport No',
                          // ignore: prefer_interpolation_to_compose_strings
                          ' # ' +
                              Provider.of<ResumeDocumentProvider>(context)
                                  .passportNo[index]),
                    ),
                    _displaystatictext(
                        'Issuing Authority',
                        Provider.of<ResumeDocumentProvider>(context)
                                .passportPlaceofIssueName[index]
                                .isEmpty
                            ? '-'
                            : Provider.of<ResumeDocumentProvider>(context)
                                .passportPlaceofIssueName[index]),
                  ],
                ),
              ),
              displayHeightSizedBox(5.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: _displaystatictext(
                          'Issue Date',
                          Provider.of<ResumeDocumentProvider>(context)
                              .passportIssueDate[index]),
                    ),
                    _displaystatictext(
                        'Expiry Date',
                        Provider.of<ResumeDocumentProvider>(context)
                                .passportExpiryDate[index]
                                .isEmpty
                            ? Provider.of<ResumeDocumentProvider>(context)
                                .passportValidTypeName[index]
                            : Provider.of<ResumeDocumentProvider>(context)
                                .passportExpiryDate[index]),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _displayNoRecordText(String label, String label2, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: label,
            style: TextStyle(
                color: kblackPrimaryColor,
                fontSize: MediaQuery.of(context).size.width * 0.038)),
        TextSpan(
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (index == 0) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditTravelDocument()));
              } else if (index == 1) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditMedicalDocuments()));
              } else if (index == 2) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditCompetencyDocuments()));
              } else if (index == 3) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditSTCWDocumentScreen()));
              }
            },
          text: 'here',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kBluePrimaryColor,
              decoration: TextDecoration.underline,
              fontSize: MediaQuery.of(context).size.width * 0.038),
        ),
        TextSpan(
            text: label2,
            style: TextStyle(
                color: kblackPrimaryColor,
                fontSize: MediaQuery.of(context).size.width * 0.038)),
      ])),
    );
  }

  _displayMedicalDataCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Provider.of<ResumeDocumentProvider>(context)
              .medicalStaticDocumentName
              .isEmpty
          ? Text(
              'No medical documents chosen',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: MediaQuery.of(context).size.width * 0.038,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Document Name',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Provider.of<ResumeDocumentProvider>(context)
                      .medicalStaticDocumentName
                      .length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Provider.of<ResumeDocumentProvider>(context)
                              .medicalStaticDocumentName[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.width * 0.038,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }

  bool checkNavigation() {
    if (Provider.of<ResumeDocumentProvider>(context, listen: false)
            .isComplete &&
        !Provider.of<ResumeDangerousCargoProvider>(context, listen: false)
            .isComplete) {
      return true;
    } else {
      return false;
    }
  }

  _displayCompetencyDetails(bool isMandatory) {
    return !isMandatory
        ? Provider.of<ResumeDocumentProvider>(context, listen: false)
                .displayOptionalcompetencyCertificateNo
                .isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Please enter optional documents',
                    style: TextStyle(
                        color: kblackPrimaryColor,
                        fontSize: MediaQuery.of(context).size.width * 0.038)),
              )
            : _showCompetencyDetails(isMandatory)
        : _showCompetencyDetails(isMandatory);
  }

  _showCompetencyDetails(bool isMandatory) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: isMandatory
            ? Provider.of<ResumeDocumentProvider>(context, listen: false)
                .displaycompetencyCertificateNo
                .length
            : Provider.of<ResumeDocumentProvider>(context, listen: false)
                .displayOptionalcompetencyCertificateNo
                .length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _displayCompetencyCard(
                  index,
                  isMandatory
                      ? Provider.of<ResumeDocumentProvider>(context,
                              listen: false)
                          .displaycompetencyDocName[index]
                      : Provider.of<ResumeDocumentProvider>(context,
                              listen: false)
                          .displayOptionalcompetencyDocName[index],
                  isMandatory),
              const SizedBox(
                height: 3,
              ),
              index + 1 ==
                      Provider.of<ResumeDocumentProvider>(context,
                              listen: false)
                          .displaycompetencyCertificateNo
                          .length
                  ? const SizedBox()
                  : const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Divider(
                        thickness: 0.25,
                        color: Colors.grey,
                      ),
                    ),
              const SizedBox(
                height: 3,
              ),
            ],
          );
        },
      ),
    );
  }
}
