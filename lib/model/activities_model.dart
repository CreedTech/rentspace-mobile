import 'dart:convert';

List<Activities> modelUserFromJson(String str) =>
    List<Activities>.from(json.decode(str).map((x) => Activities.fromJson(x)));

String modelUserToJson(List<Activities> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Activities {
  final String id;
  final String activityType;
  final String description;

  // final String status;
  final String activityDate;

  Activities({
    required this.id,
    required this.activityType,
    required this.description,
    // required this.status,
    required this.activityDate,
  });

  factory Activities.fromJson(Map<String, dynamic> json) => Activities(
        id: json["_id"],
        activityType: json["activityType"],
        description: json["description"],
        // status: json["status"],
        activityDate: json["activityDate"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "activityType": activityType,
        "description": description,
        // "status": status,
        "activityDate": activityDate,
      };
}
