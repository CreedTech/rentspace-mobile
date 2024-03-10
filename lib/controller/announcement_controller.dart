import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../constants/widgets/custom_loader.dart';
import '../repo/announcement_repository.dart';

class AnnouncementController extends GetxController {
  AnouncementRepository anouncementRepository;
  var isLoading = false.obs;
  AnnouncementController(this.anouncementRepository);
  Future getAnouncement() async {
    isLoading(true);
    String message;
    try {
      isLoading(true);
      // state = const AsyncLoading();
      EasyLoading.show(
        indicator: CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true,
      );
      var response = await anouncementRepository.fetchAnnouncementData('url');
      if (response.success) {
        EasyLoading.dismiss();
        isLoading(false);
        // notifyListeners();
        // state = AsyncValue.data(true);
        return;
      } else {
        print(response.message.toString());
      }

      // check for different reasons to enhance users experience
      if (response.success == false &&
          response.message.contains("invalid signature")) {
        message = "User info could not be retrieved , Try again later.";
        // customErrorDialog(context, message, subText)
        showTopSnackBar(
          Overlay.of(Get.context!),
          CustomSnackBar.error(
            message: message,
          ),
        );
        return;
      } else {
        // to capture other errors later
        message = "Something went wrong";
        showTopSnackBar(
          Overlay.of(Get.context!),
          CustomSnackBar.error(
            message: message,
          ),
        );

        return;
      }
    } catch (e) {
      EasyLoading.dismiss();
      // state = AsyncError(e, StackTrace.current);
      message = "Ooops something went wrong";
      showTopSnackBar(
        Overlay.of(Get.context!),
        CustomSnackBar.error(
          message: message,
        ),
      );

      return;
    } finally {
      isLoading(false);
      EasyLoading.dismiss();
      return;
    }
  }

  @override
  void onInit() {
    getAnouncement();
    super.onInit();
  }
}
