// To parse this JSON data, do
//
//     final postSeaServiceRecord = postSeaServiceRecordFromJson(jsonString);

import 'dart:convert';

PostSeaServiceRecord postSeaServiceRecordFromJson(String str) =>
    PostSeaServiceRecord.fromJson(json.decode(str));

String postSeaServiceRecordToJson(PostSeaServiceRecord data) =>
    json.encode(data.toJson());

class PostSeaServiceRecord {
  PostSeaServiceRecord({
    required this.userid,
    required this.items,
  });

  String userid;
  List<Item> items;

  factory PostSeaServiceRecord.fromJson(Map<String, dynamic> json) =>
      PostSeaServiceRecord(
        userid: json["userid"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.signOn,
    required this.signOff,
    required this.validTillType,
    required this.vesselName,
    required this.vesselType,
    required this.companyName,
    required this.grossTonnage,
    required this.imoNumber,
    required this.rankId,
    required this.engineId,
    required this.id,
  });

  String signOn;
  String signOff;
  String validTillType;
  String vesselName;
  String vesselType;
  String companyName;
  String grossTonnage;
  String imoNumber;
  String rankId;
  String engineId;
  String? id;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      signOn: json["sign_on"],
      signOff: json["sign_off"],
      validTillType: json["valid_till_type"],
      vesselName: json["vessel_name"],
      vesselType: json["vessel_type"],
      companyName: json["company_name"],
      grossTonnage: json["gross_tonnage"],
      rankId: json["rank_id"],
      engineId: json["engine_id"],
      imoNumber: json["imo_number"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "sign_on": signOn,
        "sign_off": signOff,
        "valid_till_type": validTillType,
        "vessel_name": vesselName,
        "vessel_type": vesselType,
        "company_name": companyName,
        "gross_tonnage": grossTonnage,
        "rank_id": rankId,
        "engine_id": engineId,
        "id": id,
        "imo_number": imoNumber
      };
}
