import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../constants/app_constants.dart';
import '../constants/constants.dart';
import '../model/response_model.dart';
import 'package:http/http.dart';

// we use providers to return objects with states that don't change
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return SettingsRepository(apiClient);
});

class SettingsRepository {
  SettingsRepository(this._apiClient);
  ApiClient _apiClient;

// not able to effectively check for errors yet because couldn't test the api
  Future<ResponseModel> updatePhoto(imagePath) async {
    ResponseModel responseModel;
    Response response = await _apiClient.postPhoto(UPDATE_PHOTO, imagePath);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return responseModel = ResponseModel('Profile Updated', true);
    }
    return responseModel = ResponseModel('Not updated', false);
  }

  Future<Response> getUserProfileDetails() async {
    Response response = await _apiClient.getData(AppConstants.GET_USER);

    return response;
  }
}
