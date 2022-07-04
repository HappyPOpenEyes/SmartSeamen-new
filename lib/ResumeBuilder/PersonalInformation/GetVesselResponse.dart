// To parse this JSON data, do
//
//     final getVesselResponse = getVesselResponseFromJson(jsonString);

import 'dart:convert';

GetVesselResponse getVesselResponseFromJson(String str) => GetVesselResponse.fromJson(json.decode(str));

String getVesselResponseToJson(GetVesselResponse data) => json.encode(data.toJson());

class GetVesselResponse {
    GetVesselResponse({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    List<Datum> data;

    factory GetVesselResponse.fromJson(Map<String, dynamic> json) => GetVesselResponse(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.vesselName,
        required this.itemClass,
        required this.id,
    });

    String vesselName;
    ItemClass? itemClass;
    String? id;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        vesselName: json["vessel_name"],
        itemClass: itemClassValues.map[json["itemClass"]],
        id: json["id"] == null ? null : json["id"],
    );

    Map<String, dynamic> toJson() => {
        "vessel_name": vesselName,
        "itemClass": itemClassValues.reverse[itemClass],
        "id": id == null ? null : id,
    };
}

enum ItemClass { FIRST_LEVEL, SECOND_LEVEL }

final itemClassValues = EnumValues({
    "first-level": ItemClass.FIRST_LEVEL,
    "second-level": ItemClass.SECOND_LEVEL
});

class EnumValues<T> {
    late Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap;
        return reverseMap;
    }
}
