import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartseaman/constants.dart';

import 'DangerousCargoResponse.dart';

class ResumeDangerousCargoProvider extends ChangeNotifier {
  bool success = false, isComplete = false;
  String error = "";
  List<int> docIndex = [];
  List<String> document_name = [],
      docStaticName = [],
      document_id = [],
      docUserId = [],
      issuingAuthorityName = [],
      editissuingAuthorityName = [],
      expiryDate = [],
      editexpiryDate = [],
      issueDate = [],
      editissueDate = [],
      validTillTypeId = [],
      validTillType = [];
  List<bool> has_document = [];
  static final DateFormat formatter = DateFormat('dd MMMM, yyyy');
  Future<bool> callgetDangerousCargoapi(header) async {
    isComplete = false;
    docIndex = [];
    docStaticName = [];
    docUserId = [];
    document_name = [];
    document_id = [];
    issuingAuthorityName = [];
    editissuingAuthorityName = [];
    expiryDate = [];
    editexpiryDate = [];
    issueDate = [];
    editissueDate = [];
    has_document = [];
    validTillTypeId = [];
    validTillType = [];
    try {
      var response = await http.get(
        Uri.parse('$apiurl/resume/getbydangerousdoc'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": header,
        },
      );

      print(response.statusCode);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        GetDangerousCargoResponse getDangerousCargoResponse =
            getDangerousCargoResponseFromJson(response.body);
        for (int i = 0; i < getDangerousCargoResponse.data.length; i++) {
          document_id.add(getDangerousCargoResponse.data[i].documentId);
          document_name
              .add(getDangerousCargoResponse.data[i].dangerousCargoName);
          docUserId.add(getDangerousCargoResponse.data[i].id ?? "");
          validTillTypeId
              .add(getDangerousCargoResponse.data[i].validTillType.toString());

          if (getDangerousCargoResponse.data[i].validTillType.toString() ==
              lifetimeValidType) {
            validTillType.add('LifeTime');
          } else if (getDangerousCargoResponse.data[i].validTillType
                  .toString() ==
              unlimitedValidType) {
            validTillType.add('Unlimited');
          } else {
            validTillType.add("");
          }
          if (getDangerousCargoResponse.data[i].hasDocument == null) {
            has_document.add(false);
          } else if (int.parse(
                  getDangerousCargoResponse.data[i].hasDocument.toString()) ==
              1) {
            docStaticName
                .add(getDangerousCargoResponse.data[i].dangerousCargoName);
            has_document.add(true);
            docIndex.add(i);
          } else if (int.parse(
                  getDangerousCargoResponse.data[i].hasDocument.toString()) ==
              0) {
            has_document.add(false);
          }
          if (getDangerousCargoResponse.data[i].issueName != null) {
            issuingAuthorityName
                .add(getDangerousCargoResponse.data[i].issueName ?? '');
          }

          editissuingAuthorityName
              .add(getDangerousCargoResponse.data[i].issueName ?? '');
          if (getDangerousCargoResponse.data[i].validTillDate != null) {
            expiryDate.add(formatter.format(DateTime.parse(
                getDangerousCargoResponse.data[i].validTillDate)));
            editexpiryDate.add(getDangerousCargoResponse.data[i].validTillDate);
          } else {
            editexpiryDate.add("");
            expiryDate.add("");
          }

          if (getDangerousCargoResponse.data[i].issueDate != null) {
            issueDate.add(formatter.format(
                DateTime.parse(getDangerousCargoResponse.data[i].issueDate)));
            editissueDate.add(getDangerousCargoResponse.data[i].issueDate);
          } else {
            editissueDate.add("");
          }
        }

        if (has_document.contains(true)) {
          prefs.setBool('DangerousTab', true);
        } else {
          prefs.setBool('DangerousTab', false);
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
      print(err.toString());
      error = err.toString();
      return success = false;
    }
  }
}
