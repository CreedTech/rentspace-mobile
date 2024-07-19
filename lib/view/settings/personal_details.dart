// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../constants/colors.dart';
import '../../widgets/copy_widget.dart';
import '../../widgets/custom_dialogs/index.dart';
import '../../widgets/custom_loader.dart';
import '../../controller/auth/user_controller.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  File? selectedImage;
  final UserController userController = Get.find();
  late AnimationController controller;
  bool isRefresh = false;

  @override
  initState() {
    super.initState();
  }

  Future<bool> fetchUserData({bool refresh = true}) async {
    if (refresh) {
      await userController.fetchData();
      // Move setState inside fetchData
      setState(() {});
    }
    return true;
  }

  uploadImage(BuildContext context, File imageFile) async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    var headers = {'Authorization': 'Bearer $authToken'};
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConstants.BASE_URL + AppConstants.UPDATE_PHOTO));
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print('Image uploaded successfully');
      }
      // context.pop();

      refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          isRefresh = true;
        });
      }

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: Colors.green,
          message: 'Your profile picture has been updated successfully. !!',
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
      await fetchUserData(refresh: true);
      // Get.to(FirstPage());
    } else {
      EasyLoading.dismiss();
      customErrorDialog(
          context, 'File too large', 'Please select image below 1.5mb');
      if (kDebugMode) {
        print(response.request);
      }
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
      if (kDebugMode) {
        print('Image upload failed with status ${response.statusCode}');
      }
    }
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 100, // Ensure only images are picked
    );

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      uploadImage(context, imageFile);
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                width: 4.h,
              ),
              Text(
                'Profile Details',
                style: GoogleFonts.lato(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 24.w,
          ),
          child: ListView(
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: (userController
                                .userModel!.userDetails![0].imageUpdated ==
                            false)
                        ? () {
                            _pickImage(context, ImageSource.gallery);
                          }
                        : null,
                    child: Stack(
                      children: [
                        Container(
                          width: 52.5,
                          height: 52.5,
                          // padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              colorFilter: const ColorFilter.mode(
                                brandThree,
                                BlendMode.darken,
                              ),
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                userController
                                    .userModel!.userDetails![0].avatar,
                              ),
                            ),
                          ),
                        ),
                        (userController
                                    .userModel!.userDetails![0].imageUpdated ==
                                false)
                            ? Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: brandTwo,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${userController.userModel!.userDetails![0].firstName.capitalizeFirst} ${userController.userModel!.userDetails![0].lastName.capitalizeFirst}",
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 17, top: 5, right: 17, bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).canvasColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        "${userController.userModel!.userDetails![0].userName.capitalizeFirst}",
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      subtitle: Text(
                        "Username",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      trailing: CopyWidget(
                        text:
                            userController.userModel!.userDetails![0].userName,
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        userController.userModel!.userDetails![0].dvaNumber,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      subtitle: Text(
                        "Account Number",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      trailing: CopyWidget(
                        text:
                            userController.userModel!.userDetails![0].dvaNumber,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 17, top: 5, right: 17, bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.1), // Shadow color
                  //     spreadRadius: 0.5, // Spread radius
                  //     blurRadius: 2, // Blur radius
                  //     offset: const Offset(0, 3), // Offset
                  //   ),
                  // ],
                  color: Theme.of(context).canvasColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        "${userController.userModel!.userDetails![0].firstName.capitalizeFirst} ${userController.userModel!.userDetails![0].lastName.capitalizeFirst}",
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff787878),
                        ),
                      ),
                      subtitle: Text(
                        "Account Name",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff787878),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Color(0xff787878),
                        size: 20,
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        userController.userModel!.userDetails![0].userName
                            .capitalizeFirst!,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff787878),
                        ),
                      ),
                      subtitle: Text(
                        "Username",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff787878),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Color(0xff787878),
                        size: 20,
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        userController.userModel!.userDetails![0]
                            .residentialAddress.capitalizeFirst!,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff787878),
                        ),
                      ),
                      subtitle: Text(
                        "Address",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff787878),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Color(0xff787878),
                        size: 20,
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        userController.userModel!.userDetails![0].phoneNumber,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff787878),
                        ),
                      ),
                      subtitle: Text(
                        "Phone Number",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff787878),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Color(0xff787878),
                        size: 20,
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        userController.userModel!.userDetails![0].email,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff787878),
                        ),
                      ),
                      subtitle: Text(
                        "Email",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff787878),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Color(0xff787878),
                        size: 20,
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,

                      title: Text(
                        userController.userModel!.userDetails![0].dateOfBirth,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff787878),
                        ),
                      ),
                      subtitle: Text(
                        "Date of Birth",
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff787878),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Color(0xff787878),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
