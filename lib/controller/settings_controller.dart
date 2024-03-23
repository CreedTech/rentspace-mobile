// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:rentspace/repo/settings_repo.dart';

// import '../api/global_services.dart';
// import '../model/response/user_details_response.dart';
// import '../states/user_profile_details_state.dart';

// // expose the user setting provider to the ui, statenotifierProvider takes the object you want to expose and the state you want to change
// final userSettingsProvider =
//     StateNotifierProvider<UserSettings, UserProfileDetailsState>((ref) {
//   // get an instance of settings repository provider
//   final settingReponsitoryProvider = ref.read(settingsRepositoryProvider);

//   return UserSettings(settingReponsitoryProvider);
// });

// // expose the user profile details details to the ui.
// final userProfileDetailsProvider =
//     FutureProvider.autoDispose<UserProfileDetailsResponse>((ref) async {
//   final details = await GlobalService.sharedPreferencesManager.getUserDetails();
//   return details;
// });

// class UserSettings extends StateNotifier<UserProfileDetailsState> {
//   UserSettings(this.settingsRepository) : super(UserProfileDetailsState());
//   SettingsRepository settingsRepository;

// // pick image from gallery
//   Future<File?> pickImageFromGallery(BuildContext context) async {
//     File? image;
//     try {
//       final pickedImage =
//           await ImagePicker().pickImage(source: ImageSource.gallery);

//       if (pickedImage != null) {
//         image = File(pickedImage.path);
//         // save it in state
//         state.file = image;
//         // make a api call

//         print('saved${state.file!.path}');
//       }
//     } catch (e) {
//       print('Error$e');
//     }
//     return image;
//   }

// // pick image from camera
//   Future<File?> pickImageFromCamera() async {
//     File? image;
//     try {
//       final pickedImage =
//           await ImagePicker().pickImage(source: ImageSource.camera);

//       if (pickedImage != null) {
//         image = File(pickedImage.path);
//         // save it in state
//         state.file = image;
//         print('saved${state.file!.path}');
//       }
//     } catch (e) {
//       print('Error$e');
//     }
//     return image;
//   }

//   Future<void> getUserProfileDetails() async {
//     var response = await settingsRepository.getUserProfileDetails();

//     if (response.statusCode == 200) {
//       print('this is the response.body');
//       print(response.body);

//       // save user details in state
//       state.userProfileDetailsResponse =
//           UserProfileDetailsResponse.fromJson(json.decode(response.body));
//       print(jsonDecode(response.body));

//       await GlobalService.sharedPreferencesManager
//           .saveUserDetails(state.userProfileDetailsResponse!);
//     }

//     return;
//   }
// }
