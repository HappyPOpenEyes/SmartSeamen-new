import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import 'DocumentScreenResponse.dart';

class ResumeDocumentProvider extends ChangeNotifier {
  bool success = false,
      isComplete = false,
      hasStcwDoc = false,
      hasCompetency = false,
      competencyMandatoryCheck = false;
  String error = "",
      cdcCongigId = "",
      passportConfigId = "",
      passportValidType = "";
  int cdcLength = 1,
      visaLength = 0,
      competencyMandatoryLength = 0,
      competencyOptionalLength = 0,
      stcwMandatoryLength = 0,
      stcwOptionalLength = 0;
  List<String> passportNo = [],
      passportId = [],
      passportPlaceofIssueId = [],
      passportPlaceofIssueName = [],
      passportIssueDate = [],
      passportExpiryDate = [],
      passportValidTypeName = [],
      //Passport Fields ends
      //CDC Fields begin
      cdcBookId = [],
      cdcBookNo = [],
      cdcPlaceofIssueID = [],
      cdcPlaceofIssueName = [],
      cdcIssueDate = [],
      cdcExpiryDate = [],
      cdcValidTillType = [],
      cdcValidTillTypeName = [],
      //CDC Fields ends
      //Visa Fields begin
      visaName = [],
      visaId = [],
      visaStaticNames = [],
      visaDisplayStaticNames = [],
      visaCountryName = [],
      visaIssueDate = [],
      visaExpiryDate = [],
      visaConfigId = [],
      visaValidType = [],
      visaStaticValidType = [],
      visaCountries = [],
      visaCountriesId = [],
      visaStaticConfigId = [],

      //MedicaDocument Begins
      medicalDocumentName = [],
      medicalStaticDocumentName = [],
      medicalDocumentId = [],
      medicaluserId = [],

      //Competency Fields Begin
      //Mandatory Fields
      competencyDocName = [],
      competencyCertificateNo = [],
      competencyPlaceofIssueName = [],
      competencyMandatoryValidTillTypeId = [],
      competencyIssueDate = [],
      competencyExpiryDate = [],
      competencyUserId = [],

      //Optional Fields
      competencyOptionalValidTillTypeId = [],
      competencyOptionalUserId = [],

      //Display Data
      displaycompetencyCertificateNo = [],
      displaycompetencyDocName = [],
      displaycompetencyPlaceofIssueName = [],
      displaycompetencyIssueDate = [],
      displaycompetencyExpiryDate = [],
      displaycompetencyValidTillType = [],

      //Display Optional Data
      displayOptionalcompetencyCertificateNo = [],
      displayOptionalcompetencyDocName = [],
      displayOptionalcompetencyPlaceofIssueName = [],
      displayOptionalcompetencyIssueDate = [],
      displayOptionalcompetencyExpiryDate = [],
      displayOptionalcompetencyValidTillType = [],

      //Competency Config
      competencyMandatoryDocName = [],
      competencyMandatoryDocId = [],
      competencyOptionalDocName = [],
      competencyOptionalDocId = [],

      //STCW Fields begin
      stcwDocumentName = [],
      stcwCertificateNo = [],
      stcwValidTillType = [],
      stcwValidTillTypeId = [],
      stcwExpiryDate = [],
      stcwIssueDate = [],
      stcwUserId = [],

      //STCW optional Fields
      stcwOptionalDocumentName = [],
      stcwOptionalDocumentId = [],
      stcwOptionalCertificateNo = [],
      stcwOptionalValidTillTypeId = [],
      stcwOptionalValidTillType = [],
      stcwOptionalExpiryDate = [],
      stcwOptionalIssueDate = [],
      stcwOptionalUserId = [],

      //STCW Config
      stcwMandatoryDocName = [],
      stcwMandatoryDocId = [],
      stcwOptionalDocName = [],
      stcwOptionalDocId = [];
  List<bool> hasMedicalDocument = [], hasVisaDocument = [];
  bool showMedicalDocuments = false;
  bool showtraveldocs = false, showCompetencydocs = false;
  static final DateFormat formatter = DateFormat('dd MMMM, yyyy');

  increaselength() {
    cdcLength++;
    notifyListeners();
  }

  decreaselength() {
    cdcLength--;
    notifyListeners();
  }

  increaseMandatoryCompetencylength() {
    competencyMandatoryLength++;
    notifyListeners();
  }

  decreaseMandatoryCompetencylength() {
    competencyMandatoryLength--;
    notifyListeners();
  }

  decreaseMandatoryIndexCompetencylength(int index) {
    competencyDocName.removeAt(index);
    competencyCertificateNo.removeAt(index);
    competencyPlaceofIssueName.removeAt(index);
    competencyMandatoryValidTillTypeId.removeAt(index);
    competencyIssueDate.removeAt(index);
    competencyExpiryDate.removeAt(index);
    competencyUserId.removeAt(index);
    displaycompetencyCertificateNo.removeAt(index);
    displaycompetencyDocName.removeAt(index);
    displaycompetencyPlaceofIssueName.removeAt(index);
    displaycompetencyIssueDate.removeAt(index);
    displaycompetencyExpiryDate.removeAt(index);
    displaycompetencyValidTillType.removeAt(index);
    competencyMandatoryLength--;
    notifyListeners();
  }

  increaseOptionalCompetencylength() {
    competencyOptionalLength++;
    notifyListeners();
  }

  decreaseOptionalCompetencylength() {
    competencyOptionalLength--;
    notifyListeners();
  }

  increaseMandatorySTCWlength() {
    stcwMandatoryLength++;
    notifyListeners();
  }

  decreaseMandatorySTCWlength() {
    stcwMandatoryLength--;
    notifyListeners();
  }

  decreaseMandatoryIndexSTCWlength(int index) {
    stcwDocumentName.removeAt(index);
    stcwCertificateNo.removeAt(index);
    stcwValidTillType.removeAt(index);
    stcwValidTillTypeId.removeAt(index);
    stcwExpiryDate.removeAt(index);
    stcwIssueDate.removeAt(index);
    stcwUserId.removeAt(index);
    stcwMandatoryLength--;
    notifyListeners();
  }

  increaseOptionalSTCWlength() {
    stcwOptionalLength++;
    notifyListeners();
  }

  decreaseOptionalSTCWlength() {
    stcwOptionalLength--;
    notifyListeners();
  }

  increaseVisalength() {
    visaLength++;
    notifyListeners();
  }

  decreaseVisalength() {
    visaLength--;
    notifyListeners();
  }

  Future<bool> callgetDocumentapi(header) async {
    isComplete = false;
    showCompetencydocs = false;
    showMedicalDocuments = false;
    hasStcwDoc = false;
    visaLength = 0;
    competencyMandatoryLength = 0;
    competencyOptionalLength = 0;
    stcwMandatoryLength = 0;
    stcwOptionalLength = 0;

    passportNo = [];
    passportId = [];
    passportPlaceofIssueId = [];
    passportPlaceofIssueName = [];
    passportIssueDate = [];
    passportExpiryDate = [];
    passportConfigId = "";
    passportValidType = "";
    passportValidTypeName = [];

    //CDC Doc begin
    cdcBookId = [];
    cdcBookNo = [];
    cdcPlaceofIssueID = [];
    cdcPlaceofIssueName = [];
    cdcIssueDate = [];
    cdcExpiryDate = [];
    cdcCongigId = "";
    cdcValidTillType = [];
    cdcValidTillTypeName = [];

    //Visa Doc bein
    visaId = [];
    visaName = [];
    visaStaticNames = [];
    visaCountryName = [];
    visaIssueDate = [];
    visaExpiryDate = [];
    hasVisaDocument = [];
    visaConfigId = [];
    visaValidType = [];
    visaStaticValidType = [];
    visaCountries = [];
    visaCountriesId = [];
    visaStaticConfigId = [];
    visaDisplayStaticNames = [];

    //Medical Document Begin
    medicalDocumentName = [];
    medicalStaticDocumentName = [];
    medicalDocumentId = [];
    hasMedicalDocument = [];
    medicaluserId = [];

    //Competency Fields Begin
    competencyDocName = [];
    displaycompetencyDocName = [];
    competencyCertificateNo = [];
    displaycompetencyCertificateNo = [];
    competencyPlaceofIssueName = [];
    displaycompetencyPlaceofIssueName = [];
    competencyIssueDate = [];
    competencyExpiryDate = [];
    displaycompetencyExpiryDate = [];
    displaycompetencyIssueDate = [];
    competencyUserId = [];
    competencyMandatoryDocName = [];
    competencyMandatoryDocId = [];
    competencyOptionalDocName = [];
    competencyOptionalDocId = [];
    displaycompetencyValidTillType = [];
    competencyMandatoryValidTillTypeId = [];

    displayOptionalcompetencyCertificateNo = [];
    displayOptionalcompetencyDocName = [];
    displayOptionalcompetencyPlaceofIssueName = [];
    displayOptionalcompetencyIssueDate = [];
    displayOptionalcompetencyExpiryDate = [];
    displayOptionalcompetencyValidTillType = [];

    competencyOptionalValidTillTypeId = [];
    competencyOptionalUserId = [];

    //STCW Doc begins
    stcwDocumentName = [];
    stcwCertificateNo = [];
    stcwExpiryDate = [];
    stcwIssueDate = [];
    stcwValidTillType = [];
    stcwValidTillTypeId = [];
    stcwUserId = [];

    //STCW optional
    stcwOptionalDocumentName = [];
    stcwOptionalDocumentId = [];
    stcwOptionalCertificateNo = [];
    stcwOptionalValidTillType = [];
    stcwOptionalValidTillTypeId = [];
    stcwOptionalExpiryDate = [];
    stcwOptionalIssueDate = [];
    stcwOptionalUserId = [];

    //STCW Config
    stcwMandatoryDocName = [];
    stcwMandatoryDocId = [];
    stcwOptionalDocName = [];
    stcwOptionalDocId = [];

    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/getbyalldoc'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header,
        },
      );

      print(response.statusCode);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        GetDocumentResponse getDocumentResponse =
            getDocumentResponseFromJson(response.body);
        for (int i = 0;
            i < getDocumentResponse.data.passportDetails.length;
            i++) {
          if (getDocumentResponse.data.passportDetails[i].validTillDate !=
              null) {
            passportExpiryDate.add(
                getDocumentResponse.data.passportDetails[i].validTillDate!);
          } else {
            passportExpiryDate.add("");
          }
          passportId.add(getDocumentResponse.data.passportDetails[i].id);
          passportIssueDate
              .add(getDocumentResponse.data.passportDetails[i].issueDate);
          passportNo
              .add(getDocumentResponse.data.passportDetails[i].documentNo);
          if (getDocumentResponse.data.passportDetails[i].issuingAuthorityId !=
              null) {
            passportPlaceofIssueId.add(getDocumentResponse
                .data.passportDetails[i].issuingAuthorityId!);
          } else {
            passportPlaceofIssueId.add("");
          }
          passportPlaceofIssueName.add(
              getDocumentResponse.data.passportDetails[i].issuingAuthorityName);
          passportValidType = getDocumentResponse
              .data.passportDetails[i].validTillType
              .toString();
          passportValidTypeName.add(
              getDocumentResponse.data.passportDetails[i].validTillTypeName);
        }
        for (int i = 0;
            i < getDocumentResponse.data.travelconfigid.length;
            i++) {
          if (getDocumentResponse.data.travelconfigid[i].value ==
              passportConfigValue) {
            passportConfigId =
                getDocumentResponse.data.travelconfigid[i].id.toString();
          } else if (getDocumentResponse.data.travelconfigid[i].value ==
              cdcConfigValue) {
            cdcCongigId =
                getDocumentResponse.data.travelconfigid[i].id.toString();
          }
        }
        for (int i = 0; i < getDocumentResponse.data.visaconfigid.length; i++) {
          visaName.add(getDocumentResponse.data.visaconfigid[i].displayText);
          visaConfigId
              .add(getDocumentResponse.data.visaconfigid[i].id.toString());
        }
        for (int i = 0; i < getDocumentResponse.data.visacountry.length; i++) {
          visaCountries
              .add(getDocumentResponse.data.visacountry[i].countryName);
          visaCountriesId
              .add(getDocumentResponse.data.visacountry[i].id.toString());
        }
        if (getDocumentResponse.data.cdcDetails.isNotEmpty) {
          cdcLength = getDocumentResponse.data.cdcDetails.length;
        }
        for (int i = 0; i < getDocumentResponse.data.cdcDetails.length; i++) {
          cdcValidTillType.add(
              getDocumentResponse.data.cdcDetails[i].validTillType.toString());
          cdcBookId.add(getDocumentResponse.data.cdcDetails[i].id);
          cdcBookNo.add(getDocumentResponse.data.cdcDetails[i].documentNo);
          if (getDocumentResponse.data.cdcDetails[i].validTillDate != null) {
            cdcExpiryDate
                .add(getDocumentResponse.data.cdcDetails[i].validTillDate!);
          } else {
            cdcExpiryDate.add("");
          }
          cdcIssueDate.add(getDocumentResponse.data.cdcDetails[i].issueDate);
          if (getDocumentResponse.data.cdcDetails[i].issuingAuthorityId !=
              null) {
            cdcPlaceofIssueID.add(
                getDocumentResponse.data.cdcDetails[i].issuingAuthorityId!);
          } else {
            cdcPlaceofIssueID.add("");
          }
          cdcPlaceofIssueName
              .add(getDocumentResponse.data.cdcDetails[i].issuingAuthorityName);
          cdcValidTillTypeName
              .add(getDocumentResponse.data.cdcDetails[i].validTillTypeName);
        }
        for (int i = 0; i < getDocumentResponse.data.visaDetails.length; i++) {
          visaLength++;
          visaId.add(getDocumentResponse.data.visaDetails[i].id);
          if (getDocumentResponse.data.visaDetails[i].configrationId
                  .toString() ==
              visaOtherId) {
            visaDisplayStaticNames.add(
                // ignore: prefer_interpolation_to_compose_strings
                "${getDocumentResponse.data.visaDetails[i].configrationName} - " +
                    getDocumentResponse.data.visaDetails[i].countryName);
          } else {
            visaDisplayStaticNames
                .add(getDocumentResponse.data.visaDetails[i].configrationName);
          }
          visaStaticNames
              .add(getDocumentResponse.data.visaDetails[i].configrationName);
          visaStaticConfigId.add(getDocumentResponse
              .data.visaDetails[i].configrationId
              .toString());
          visaValidType.add(
              getDocumentResponse.data.visaDetails[i].validTillType.toString());

          visaStaticValidType
              .add(getDocumentResponse.data.visaDetails[i].validTillTypeName);
          if (getDocumentResponse.data.visaDetails[i].validTillDate != null) {
            visaExpiryDate
                .add(getDocumentResponse.data.visaDetails[i].validTillDate);
          } else {
            visaExpiryDate.add("");
          }
          if (getDocumentResponse.data.visaDetails[i].issueDate != null) {
            visaIssueDate
                .add(getDocumentResponse.data.visaDetails[i].issueDate);
          } else {
            visaIssueDate.add("");
          }
          if (getDocumentResponse.data.visaDetails[i].countryName != null) {
            visaCountryName
                .add(getDocumentResponse.data.visaDetails[i].countryName);
          } else {
            visaCountryName.add("");
          }
        }

        if (passportNo.isEmpty && cdcBookNo.isEmpty) {
          if (visaId.isEmpty) {
            showtraveldocs = false;
          } else {
            showtraveldocs = true;
          }
        } else {
          showtraveldocs = true;
        }
        for (int i = 0; i < getDocumentResponse.data.medical.length; i++) {
          medicalDocumentId
              .add(getDocumentResponse.data.medical[i].medicalDocumentId);
          medicalDocumentName
              .add(getDocumentResponse.data.medical[i].medicalName);
          medicaluserId.add(getDocumentResponse.data.medical[i].id ?? "");
          if (getDocumentResponse.data.medical[i].hasDocument != null) {
            if (int.parse(getDocumentResponse.data.medical[i].hasDocument
                    .toString()) ==
                1) {
              hasMedicalDocument.add(true);
              showMedicalDocuments = true;
              medicalStaticDocumentName
                  .add(getDocumentResponse.data.medical[i].medicalName);
            } else if (int.parse(getDocumentResponse.data.medical[i].hasDocument
                    .toString()) ==
                0) {
              hasMedicalDocument.add(false);
              showMedicalDocuments = true;
            }
          } else {
            hasMedicalDocument.add(false);
          }
        }

        for (int i = 0;
            i < getDocumentResponse.data.mandateoptional.mandate.length;
            i++) {
          competencyMandatoryDocName.add(
              getDocumentResponse.data.mandateoptional.mandate[i].displayText);
          competencyMandatoryDocId
              .add(getDocumentResponse.data.mandateoptional.mandate[i].id);
        }
        for (int i = 0;
            i < getDocumentResponse.data.mandateoptional.optional.length;
            i++) {
          competencyOptionalDocName.add(
              getDocumentResponse.data.mandateoptional.optional[i].displayText);
          competencyOptionalDocId
              .add(getDocumentResponse.data.mandateoptional.optional[i].id);
        }
        for (int i = 0; i < getDocumentResponse.data.optionalDoc.length; i++) {
          competencyOptionalLength++;
          competencyOptionalUserId
              .add(getDocumentResponse.data.optionalDoc[i].id);
          displayOptionalcompetencyCertificateNo
              .add(getDocumentResponse.data.optionalDoc[i].certificateNo);
          displayOptionalcompetencyDocName
              .add(getDocumentResponse.data.optionalDoc[i].displayText);
          displayOptionalcompetencyPlaceofIssueName
              .add(getDocumentResponse.data.optionalDoc[i].issueName);
          displayOptionalcompetencyIssueDate.add(formatter.format(
              DateTime.parse(
                  getDocumentResponse.data.optionalDoc[i].issueDate)));
          if (getDocumentResponse.data.optionalDoc[i].validTillDate == null) {
            displayOptionalcompetencyExpiryDate.add("");
          } else {
            displayOptionalcompetencyExpiryDate
                .add(getDocumentResponse.data.optionalDoc[i].validTillDate);
          }
          if (getDocumentResponse.data.optionalDoc[i].validTillType
                  .toString() ==
              lifetimeValidType) {
            displayOptionalcompetencyValidTillType.add('LifeTime');
          } else if (getDocumentResponse.data.optionalDoc[i].validTillType
                  .toString() ==
              unlimitedValidType) {
            displayOptionalcompetencyValidTillType.add('Unlimited');
          } else {
            displayOptionalcompetencyValidTillType.add("");
          }
          competencyOptionalValidTillTypeId.add(
              getDocumentResponse.data.optionalDoc[i].validTillType.toString());
        }

        print('Competancy Length');
        print(getDocumentResponse.data.competancy.length);
        for (int i = 0; i < getDocumentResponse.data.competancy.length; i++) {
          competencyMandatoryLength++;
          competencyMandatoryValidTillTypeId.add(
              getDocumentResponse.data.competancy[i].validTillType.toString());
          if (getDocumentResponse.data.competancy[i].displayText != null) {
            competencyDocName
                .add(getDocumentResponse.data.competancy[i].displayText);
            showCompetencydocs = true;
            if (getDocumentResponse.data.competancy[i].validTillType
                    .toString() ==
                lifetimeValidType) {
              displaycompetencyValidTillType.add('LifeTime');
            } else if (getDocumentResponse.data.competancy[i].validTillType
                    .toString() ==
                unlimitedValidType) {
              displaycompetencyValidTillType.add('Unlimited');
            } else {
              displaycompetencyValidTillType.add("");
            }
            displaycompetencyDocName
                .add(getDocumentResponse.data.competancy[i].displayText);
            displaycompetencyCertificateNo
                .add(getDocumentResponse.data.competancy[i].certificateNo);
            displaycompetencyPlaceofIssueName
                .add(getDocumentResponse.data.competancy[i].issueName);
            displaycompetencyIssueDate.add(formatter.format(DateTime.parse(
                getDocumentResponse.data.competancy[i].issueDate)));
            if (getDocumentResponse.data.competancy[i].validTillDate != null) {
              displaycompetencyExpiryDate.add(formatter.format(DateTime.parse(
                  getDocumentResponse.data.competancy[i].validTillDate)));
            } else {
              displaycompetencyExpiryDate.add("");
            }
            competencyCertificateNo
                .add(getDocumentResponse.data.competancy[i].certificateNo);
            competencyPlaceofIssueName
                .add(getDocumentResponse.data.competancy[i].issueName);
            competencyUserId.add(getDocumentResponse.data.competancy[i].id);
            if (getDocumentResponse.data.competancy[i].issueDate != null) {
              hasCompetency = true;
              competencyIssueDate
                  .add(getDocumentResponse.data.competancy[i].issueDate);
            } else {
              competencyIssueDate.add("");
            }
            if (getDocumentResponse.data.competancy[i].validTillDate != null) {
              competencyExpiryDate.add(formatter.format(DateTime.parse(
                  getDocumentResponse.data.competancy[i].validTillDate)));
            } else {
              competencyExpiryDate.add("");
            }
          }
        }
        bool data = false;
        for (int i = 0; i < competencyMandatoryDocName.length; i++) {
          print(competencyMandatoryDocName);
          print(displaycompetencyDocName);
          if (!displaycompetencyDocName
              .contains(competencyMandatoryDocName[i])) {
            data = true;
          }
          print(data);
        }

        competencyMandatoryCheck = data;

        //STCW Mandatory
        for (int i = 0; i < getDocumentResponse.data.stcwmandate.length; i++) {
          hasStcwDoc = true;
          stcwMandatoryLength++;
          if (getDocumentResponse.data.stcwmandate[i].certificateNo != null) {
            stcwCertificateNo
                .add(getDocumentResponse.data.stcwmandate[i].certificateNo!);
          } else {
            stcwCertificateNo.add("");
          }
          stcwUserId.add(getDocumentResponse.data.stcwmandate[i].id);
          stcwDocumentName
              .add(getDocumentResponse.data.stcwmandate[i].stcwName);
          stcwIssueDate.add(getDocumentResponse.data.stcwmandate[i].issueDate);
          if (getDocumentResponse.data.stcwmandate[i].validDate != null) {
            stcwExpiryDate.add(formatter
                .format(getDocumentResponse.data.stcwmandate[i].validDate!));
          } else {
            stcwExpiryDate.add("");
          }
          stcwValidTillTypeId.add(
              getDocumentResponse.data.stcwmandate[i].validTillType.toString());
          if (getDocumentResponse.data.stcwmandate[i].validTillType
                  .toString() ==
              lifetimeValidType) {
            stcwValidTillType.add('LifeTime');
          } else if (getDocumentResponse.data.stcwmandate[i].validTillType
                  .toString() ==
              unlimitedValidType) {
            stcwValidTillType.add('Unlimited');
          } else {
            stcwValidTillType.add("");
          }
        }

        //STCW Optional
        for (int i = 0; i < getDocumentResponse.data.stcwoptional.length; i++) {
          stcwOptionalLength++;
          if (getDocumentResponse.data.stcwoptional[i].certificateNo != null) {
            stcwOptionalCertificateNo
                .add(getDocumentResponse.data.stcwoptional[i].certificateNo!);
          } else {
            stcwOptionalCertificateNo.add("");
          }
          stcwOptionalUserId.add(getDocumentResponse.data.stcwoptional[i].id);
          stcwOptionalDocumentName
              .add(getDocumentResponse.data.stcwoptional[i].stcwName);
          stcwOptionalIssueDate
              .add(getDocumentResponse.data.stcwoptional[i].issueDate);
          stcwOptionalValidTillTypeId.add(getDocumentResponse
              .data.stcwoptional[i].validTillType
              .toString());
          if (getDocumentResponse.data.stcwoptional[i].validDate != null) {
            stcwOptionalExpiryDate.add(formatter
                .format(getDocumentResponse.data.stcwoptional[i].validDate!));
          } else {
            stcwOptionalExpiryDate.add("");
          }
          if (getDocumentResponse.data.stcwoptional[i].validTillType
                  .toString() ==
              lifetimeValidType) {
            stcwOptionalValidTillType.add('LifeTime');
          } else if (getDocumentResponse.data.stcwoptional[i].validTillType
                  .toString() ==
              unlimitedValidType) {
            stcwOptionalValidTillType.add('Unlimited');
          } else {
            stcwOptionalValidTillType.add("");
          }
        }

        //STCW Mandatory Config
        for (int i = 0;
            i < getDocumentResponse.data.stcwmandateoptional.mandate.length;
            i++) {
          stcwMandatoryDocName.add(
              getDocumentResponse.data.stcwmandateoptional.mandate[i].stcwName);
          stcwMandatoryDocId
              .add(getDocumentResponse.data.stcwmandateoptional.mandate[i].id);
        }

        //STCW Optional Config
        for (int i = 0;
            i < getDocumentResponse.data.stcwmandateoptional.optional.length;
            i++) {
          stcwOptionalDocName.add(getDocumentResponse
              .data.stcwmandateoptional.optional[i].stcwName);
          stcwOptionalDocId
              .add(getDocumentResponse.data.stcwmandateoptional.optional[i].id);
        }
        if (passportNo.isNotEmpty &&
            cdcBookNo.isNotEmpty &&
            visaExpiryDate.isNotEmpty &&
            showMedicalDocuments &&
            hasStcwDoc &&
            !competencyMandatoryCheck) {
          prefs.setBool('DocumentTab', true);
        } else {
          prefs.setBool('DocumentTab', false);
        }
        return success = true;
      } else if (response.statusCode == 422) {
        //prefs.setString('profilestatus', 'Invalid Credentials.');
        return success = false;
      } else {
        //prefs.setString('profilestatus', 'Something went wrong.');
        return success = false;
      }
    } catch (err) {
      error = err.toString();
      return success = false;
    }
  }
}
