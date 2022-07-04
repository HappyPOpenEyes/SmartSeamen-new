import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ApplyJobProvider extends ChangeNotifier {
  bool success = false;
  Future<bool> callApplyJobapi(jobId, rankId, companyId, header) async {
    var body = {
      "job_requirement_id": jobId,
      "company_id": companyId,
      "rank_id": rankId
    };
    print(body);
    try {
      var response = await http.post(Uri.parse(apiurl + '/resume/applyjob'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": header
          },
          encoding: Encoding.getByName("utf-8"));

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return success = true;
      } else if (response.statusCode == 422) {
        return success = false;
      } else {
        return success = false;
      }
    } catch (err) {
      print(err.toString());
      return success = false;
    }
  }
}
