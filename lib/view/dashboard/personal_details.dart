// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'package:iconsax/iconsax.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../constants/colors.dart';
// import '../../constants/utils/obscureEmail.dart';
// import '../../controller/user_controller.dart';
import '../../constants/widgets/copy_widget.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../controller/auth/user_controller.dart';
// import '../actions/onboarding_page.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

// final _auth = FirebaseAuth.instance;
bool _isEmailVerified = false;
// User? _user;

class _PersonalDetailsState extends State<PersonalDetails> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  File? selectedImage;
  final UserController userController = Get.find();
  // final WalletController walletController = Get.find();
  late AnimationController controller;
  bool isRefresh = false;

  @override
  initState() {
    super.initState();

    // _user = _auth.currentUser;
    _isEmailVerified =
        userController.userModel!.userDetails![0].hasVerifiedEmail;

    // checkingForBioMetrics();
    // print(_isEmailVerified);
  }

  Future<bool> fetchUserData({bool refresh = true}) async {
    if (refresh) {
      await userController.fetchData();
      setState(() {}); // Move setState inside fetchData
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
      print('Image uploaded successfully');
      // Get.back();

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
      print(response.request);
      print(response.reasonPhrase);
      print('Image upload failed with status ${response.statusCode}');
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
      print('No image selected.');
    }
  }

  Future updateVerification() async {
    // var userUpdate = FirebaseFirestore.instance.collection('accounts');

    // await userUpdate.doc(userId).update({
    //   'has_verified_email': 'true',
    // }).catchError((error) {
    //   print(error);
    // });
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
            Get.back();
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
                            : SizedBox(),
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
              // Column(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Iconsax.user,
              //             color: brandOne,
              //             // size: 20,
              //           ),
              //         ),
              //         title: Text(
              //           'Full Name',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //           "${userController.userModel!.userDetails![0].lastName.capitalize} ${userController.userModel!.userDetails![0].firstName.capitalize}"
              //               .toUpperCase(),
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 13,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Iconsax.smileys,
              //             color: brandOne,
              //             // size: 20,
              //           ),
              //         ),
              //         title: Text(
              //           'User Name',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //           userController.userModel!.userDetails![0].userName!
              //               .toUpperCase(),
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 13,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Icons.mail_outline,
              //             color: brandOne,
              //           ),
              //         ),
              //         title: Text(
              //           'Email',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //             obscureEmail(
              //                 userController.userModel!.userDetails![0].email!),
              //             style: GoogleFonts.lato(
              //               color: Theme.of(context).primaryColor,
              //               fontSize: 13,
              //               fontWeight: FontWeight.w600,
              //             )),
              //         onTap: () async {},
              //         trailing: Icon(
              //           Iconsax.verify5,
              //           color: Theme.of(context).colorScheme.secondary,
              //         ),
              //         //  const Icon(
              //         //   Iconsax.edit,
              //         //   color: brandOne,
              //         // ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Iconsax.call,
              //             color: brandOne,
              //           ),
              //         ),
              //         title: Text(
              //           'Phone',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //             userController
              //                 .userModel!.userDetails![0].phoneNumber!,
              //             style: GoogleFonts.lato(
              //               color: Theme.of(context).primaryColor,
              //               fontSize: 13,
              //               fontWeight: FontWeight.w600,
              //             )),
              //         // onTap: () {
              //         //   (userController.userModel!.userDetails![0]
              //         //               .hasVerifiedPhone ==
              //         //           false)
              //         //       ? Get.to(PhoneVerificationScreen())
              //         //       : null;
              //         // },
              //         trailing: (userController.userModel!.userDetails![0]
              //                     .hasVerifiedPhone ==
              //                 true)
              //             ? Container(
              //                 padding: const EdgeInsets.symmetric(
              //                     horizontal: 20, vertical: 5),
              //                 decoration: BoxDecoration(
              //                   color: Colors.green,
              //                   borderRadius: BorderRadius.circular(100),
              //                 ),
              //                 child: Text(
              //                   'verify',
              //                   style: GoogleFonts.lato(color: Colors.white),
              //                 ),
              //               )
              //             : Icon(
              //                 Iconsax.verify5,
              //                 color: Theme.of(context).colorScheme.secondary,
              //               ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Iconsax.security,
              //             color: brandOne,
              //           ),
              //         ),
              //         title: Text(
              //           'BVN',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //             (userController.userModel!.userDetails![0].bvn != "")
              //                 ? obscureBVN(
              //                     userController.userModel!.userDetails![0].bvn)
              //                 : '',
              //             style: GoogleFonts.lato(
              //               color: Theme.of(context).primaryColor,
              //               fontSize: 13,
              //               fontWeight: FontWeight.w600,
              //             )),
              //         onTap: () {
              //           if (userController.userModel!.userDetails![0].bvn ==
              //               "") {
              //             Get.to(BvnPage(
              //                 email: userController
              //                     .userModel!.userDetails![0].email));
              //           }
              //         },
              //         trailing: (userController
              //                     .userModel!.userDetails![0].hasVerifiedBvn ==
              //                 false)
              //             ? Container(
              //                 padding: const EdgeInsets.symmetric(
              //                     horizontal: 20, vertical: 5),
              //                 decoration: BoxDecoration(
              //                   color: brandOne,
              //                   borderRadius: BorderRadius.circular(100),
              //                 ),
              //                 child: Text(
              //                   'Add BVN',
              //                   style: GoogleFonts.lato(color: Colors.white),
              //                 ),
              //               )
              //             : Icon(
              //                 Iconsax.verify5,
              //                 color: Theme.of(context).colorScheme.secondary,
              //               ),
              //         //  const Icon(
              //         //   Iconsax.edit,
              //         //   color: brandOne,
              //         // ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Icons.location_on_outlined,
              //             color: brandOne,
              //           ),
              //         ),
              //         title: Text(
              //           'Address',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //           // (userController.userModel!.userDetails![0].residentialAddress != "")
              //           //     ?
              //           userController.userModel!.userDetails![0]
              //               .residentialAddress.capitalize!
              //           // : 'Add Your Address for KYC Verification'
              //           ,
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 13,
              //             fontWeight: FontWeight.w600,
              //             // decoration: TextDecoration.
              //           ),
              //         ),
              //         // onTap: () {
              //         //   if (userController.user[0].bvn == "") {
              //         //     Get.to(const BvnPage());
              //         //   }
              //         // },
              //         trailing: Icon(
              //           Iconsax.verify5,
              //           color: Theme.of(context).colorScheme.secondary,
              //         ),
              //         //  const Icon(
              //         //   Iconsax.edit,
              //         //   color: brandOne,
              //         // ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 2),
              //       child: ListTile(
              //         leading: Container(
              //           padding: const EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Theme.of(context).cardColor,
              //           ),
              //           child: const Icon(
              //             Icons.date_range_outlined,
              //             color: brandOne,
              //           ),
              //         ),
              //         title: Text(
              //           'Date Of Birth',
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         subtitle: Text(
              //           userController.userModel!.userDetails![0].dateOfBirth
              //               .toString(),
              //           style: GoogleFonts.lato(
              //             color: Theme.of(context).primaryColor,
              //             fontSize: 13,
              //             fontWeight: FontWeight.w600,
              //             // decoration: TextDecoration.
              //           ),
              //         ),
              //         // onTap: () {
              //         //   if (userController.user[0].bvn == "") {
              //         //     Get.to(const BvnPage());
              //         //   }
              //         // },
              //         trailing: Icon(
              //           Iconsax.verify5,
              //           color: Theme.of(context).colorScheme.secondary,
              //         ),
              //         //  const Icon(
              //         //   Iconsax.edit,
              //         //   color: brandOne,
              //         // ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
