import 'dart:io';

import '../model/response/user_details_response.dart';


class UserProfileDetailsState {
  File? file;
  // UserProfileDetailsResponse? _userProfileDetailsResponse;
  UserProfileDetailsResponse? userProfileDetailsResponse;

  UserProfileDetailsState({this.userProfileDetailsResponse, this.file});

  UserProfileDetailsState copyWith({userProfileDetailsResponse, File? file}) {
    return UserProfileDetailsState(
        userProfileDetailsResponse:
            userProfileDetailsResponse ?? this.userProfileDetailsResponse,
        file: file ?? this.file);
  }
}
