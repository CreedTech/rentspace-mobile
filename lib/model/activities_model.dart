import 'dart:convert';

class ActivitiesModel {
  ActivitiesModel({
    required this.activities,
  });
  List<Activities>? activities;

  ActivitiesModel.fromJson(Map<String, dynamic> json) {
    final dynamic activitiesData = json['userActivities'];
    if (activitiesData is List<dynamic>) {
      // If activitiesData is a List, map each element to Activities object.
      activities = activitiesData.map((e) => Activities.fromJson(e)).toList();
      print(activities!.length);
      print(activitiesData[0]);
    } else if (activitiesData is Map<String, dynamic>) {
      // If activitiesData is a Map, create a single Activities object.
      activities = [Activities.fromJson(activitiesData)];
    } else {
      // Handle other cases if necessary.
      print('Invalid activities data: $activitiesData');
      activities = [];
    }
  }
  //   ActivitiesModel.fromJson(Map<String, dynamic> json) {
  //     //  assets = List.from(json['assets']).map((e) => Assets.fromJson(e)).toList();
  //     // List<Activities>.from(json.decode('userActivities').map((x) => Activities.fromJson(x)));
  //   final dynamic activitiesData = json['userActivities'];
  //   if (activitiesData is Map<String, dynamic>) {
  //     // If activitiesData is a Map, create a single activitiesModel object.
  //     activities = [Activities.fromJson(activitiesData)];
  //     print(activities);
  //   } else {
  //     // Handle the case where activitiesData is not a Map (e.g., it's a List).
  //     // You might want to log an error or handle this case differently based on your requirements.
  //     activities = activitiesData.map((e) => ActivitiesModel.fromJson(e)).toList();
  //     print('activitiesData is not a Map: $activitiesData');
  //     // Set activities to an empty list or null, depending on your needs.
  //     // wallet = [];
  //   }
  // }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userActivities'] = activities!.map((e) => e.toJson()).toList();
    return _data;
  }
}

// List<Activities> modelUserFromJson(String str) =>
//     List<Activities>.from(json.decode(str).map((x) => Activities.fromJson(x)));

// String modelUserToJson(List<Activities> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
