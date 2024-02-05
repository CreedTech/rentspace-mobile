import 'package:rentspace/model/user_model.dart';

class UserProfileDetailsResponse {
  String? msg;
  List<UserModel>? userDetails;

  UserProfileDetailsResponse({required this.msg, required this.userDetails});

  factory UserProfileDetailsResponse.fromJson(Map<String, dynamic> json) {
    var userDetailsList = json['userDetails'] as List<dynamic>;
    List<UserModel> details = userDetailsList
        .map((userDetailsJson) => UserModel.fromJson(userDetailsJson))
        .toList();

    return UserProfileDetailsResponse(
      msg: json['msg'] as String,
      userDetails: details,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'userDetails':
          userDetails?.map((userDetails) => userDetails.toJson()).toList(),
    };
  }
}
