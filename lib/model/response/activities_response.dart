// import '../activities_model.dart';

// class ActivitiesResponse {
//   String? msg;
//   List<Activities> activities;

//   ActivitiesResponse({required this.msg, required this.activities});

//   factory ActivitiesResponse.fromJson(Map<String, dynamic> json) {
//     // Check if 'userActivities' exists and is a list
//     if (json.containsKey('userActivities') && json['userActivities'] is List) {
//       List<dynamic> activitiesJsonList = json['userActivities'];
//       List<Activities> activitiesList =
//           activitiesJsonList.map((json) => Activities.fromJson(json)).toList();
//       return ActivitiesResponse(
//         msg: json['msg'] as String?,
//         activities: activitiesList,
//       );
//     } else {
//       // If 'userActivities' is not a list, handle it accordingly
//       // For example, you can create a single Activities object
//       Activities activity = Activities.fromJson(json['userActivities']);
//       return ActivitiesResponse(
//         msg: json['msg'] as String?,
//         activities: [activity],
//       );
//     }
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'msg': msg,
//       'userActivities':
//           activities.map((activities) => activities.toJson()).toList(),
//     };
//   }
// }

import 'package:rentspace/model/activities_model.dart';

class ActivitiesResultModel {
  late final List<Activities> activities;

  ActivitiesResultModel({required this.activities});

  factory ActivitiesResultModel.fromJson(Map<String, dynamic> json) {
    List<Activities> activities = [];
    if (json.containsKey('userActivities') && json['userActivities'] is List) {
      List<dynamic> userActivitiesList = json['userActivities'];
      activities = userActivitiesList
          .map((activityJson) => Activities.fromJson(activityJson))
          .toList();
    }
    return ActivitiesResultModel(activities: activities);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'userActivities': activities.map((activity) => activity.toJson()).toList()
    };
    return data;
  }
}
