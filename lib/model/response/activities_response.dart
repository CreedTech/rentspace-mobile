
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
