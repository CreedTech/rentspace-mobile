import 'package:rentspace/model/user_details_model.dart';

class UserProfileDetailsResponse {
  String? msg;
  List<UserDetailsModel> userDetails;

  UserProfileDetailsResponse({required this.msg, required this.userDetails});

  factory UserProfileDetailsResponse.fromJson(Map<String, dynamic> json) {
    // Check if 'userDetails' exists and is a list
    if (json.containsKey('userDetails') && json['userDetails'] is List) {
      var userDetailsList = json['userDetails'] as List<dynamic>;
      List<UserDetailsModel> details = userDetailsList
          .map((userDetailsJson) => UserDetailsModel.fromJson(userDetailsJson))
          .toList();
      return UserProfileDetailsResponse(
        msg: json['msg'] as String,
        userDetails: details,
      );
    } else {
      // If 'userDetails' is not a list, handle it accordingly
      // For example, you can create a single UserDetailsModel object
      UserDetailsModel userDetail =
          UserDetailsModel.fromJson(json['userDetails']);
      return UserProfileDetailsResponse(
        msg: json['msg'] as String,
        userDetails: [userDetail],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'userDetails':
          userDetails.map((userDetails) => userDetails.toJson()).toList(),
    };
  }
}
