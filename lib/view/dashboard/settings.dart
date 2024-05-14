// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path/path.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/constants/app_constants.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/view/FirstPage.dart';
// import 'package:rentspace/controller/wallet_controller.dart';
import 'package:rentspace/view/actions/add_card.dart';
import 'package:rentspace/view/actions/contact_us.dart';
import 'package:rentspace/view/dashboard/personal_details.dart';
import 'package:rentspace/view/dashboard/security.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../api/global_services.dart';
import '../../constants/colors.dart';
import 'package:get_storage/get_storage.dart';
// import '../../constants/firebase_auth_constants.dart';
import '../../constants/theme_services.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';
// import '../../controller/user_controller.dart';
import '../../controller/auth/auth_controller.dart';
import '../actions/bank_and_card.dart';
import '../actions/share_and_earn.dart';
import '../faqs.dart';
import '../savings/spaceRent/spacerent_list.dart';
import 'dashboard.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

// final _auth = FirebaseAuth.instance;
// User? _user;
bool _isEmailVerified = false;
final LocalAuthentication _localAuthentication = LocalAuthentication();
String _message = "Not Authorized";
bool _hasBiometric = false;
bool _themeMode = themeChange.isSavedDarkMode();
final hasBiometricStorage = GetStorage();
bool _hasFeeds = true;
final hasFeedsStorage = GetStorage();

class _SettingsPageState extends ConsumerState<SettingsPage>
    with TickerProviderStateMixin {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  File? selectedImage;
  final UserController userController = Get.find();
  // final WalletController walletController = Get.find();
  late AnimationController controller;
  bool isRefresh = false;

  Future getImage(BuildContext context) async {
    print('getting...');
    var _image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(_image!.path); // won't have any error now
    });
    if (!context.mounted) return;
    uploadImg(context);
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
          textStyle: GoogleFonts.lato(
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

  Future uploadImg(BuildContext context) async {
    // EasyLoading.show(
    //   indicator: const CustomLoader(),
    //   maskType: EasyLoadingMaskType.black,
    //   dismissOnTap: false,
    // );
    // var userPinUpdate = FirebaseFirestore.instance.collection('accounts');

    // FirebaseStorage storage = FirebaseStorage.instance;
    // String fileName = basename(selectedImage!.path);
    // Reference ref = storage.ref().child(fileName);
    // UploadTask uploadTask = ref.putFile(selectedImage!);
    // var downloadURL =
    //     await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    // var url = downloadURL.toString();
    // await userPinUpdate.doc(userId).update({
    //   'image': url,
    // }).then((value) {
    //   // Get.back();
    //   EasyLoading.dismiss();
    //   showTopSnackBar(
    //     Overlay.of(context),
    //     CustomSnackBar.success(
    //       backgroundColor: brandOne,
    //       message: 'Your profile picture has been updated successfully. !!',
    //       textStyle: GoogleFonts.lato(
    //         fontSize: 14,
    //         color: Colors.white,
    //         fontWeight: FontWeight.w600,
    //       ),
    //     ),
    //   );
    // }).catchError((error) {
    //   EasyLoading.dismiss();
    //   customErrorDialog(context, 'Error', error.toString());
    // });
  }

  late double valueNotifier;
  @override
  initState() {
    super.initState();
    userController.users.isEmpty
        ? valueNotifier = 0.0
        : valueNotifier = double.tryParse(userController
            .userModel!.userDetails![0].financeHealth
            .toString())!;

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {});
    // controller.repeat(reverse: false);

    // _user = _auth.currentUser;
    // _isEmailVerified =
    //     userController.userModel!.userDetails![0].hasVerifiedEmail;

    checkingForBioMetrics();
    print(_isEmailVerified);
  }

  enableBiometrics(BuildContext context) {
    if (hasBiometricStorage.read('hasBiometric') == null ||
        hasBiometricStorage.read('hasBiometric') == false) {
      hasBiometricStorage.write('hasBiometric', true);
      Get.back();
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: brandOne,
          message: 'Biometrics enabled',
          textStyle: GoogleFonts.lato(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

      if (hasBiometricStorage.read('hasBiometric') == false) {
        setState(
          () {
            _hasBiometric = true;
            hasBiometricStorage.write('hasBiometric', _hasBiometric);
          },
        );
        Get.back();
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            backgroundColor: brandOne,
            message: 'Biometrics enabled',
            textStyle: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      } else {
        return;
      }
    } else {
      print(hasBiometricStorage.read('hasBiometric').toString());
    }
    //print()
  }

  disableBiometrics(BuildContext context) {
    if (hasBiometricStorage.read('hasBiometric') == null ||
        hasBiometricStorage.read('hasBiometric') == true) {
      hasBiometricStorage.write('hasBiometric', false);
      Get.back();
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: brandOne,
          message: 'Biometrics disabled',
          textStyle: GoogleFonts.lato(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

      if (hasBiometricStorage.read('hasBiometric') == true) {
        setState(
          () {
            _hasBiometric = false;
            hasBiometricStorage.write('hasBiometric', _hasBiometric);
          },
        );
        Get.back();
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            backgroundColor: brandOne,
            message: 'Biometrics disabled',
            textStyle: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      } else {
        return;
      }
    } else {
      print(hasBiometricStorage.read('hasBiometric').toString());
    }
    //print()
  }

  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print(canCheckBiometrics);
    return canCheckBiometrics;
  }

  Future<void> _authenticateMe(BuildContext context) async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Touch fingerprint scanner to enable Biometrics",
      );
      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });
      if (authenticated) {
        enableBiometrics(context);
      } else {
        customErrorDialog(context, 'Error', "Could not authenticate");
      }

      print("Authenticated");
    } catch (e) {
      print("Not authenticated");
    }
    if (!mounted) return;
  }

  Future<void> _NotAuthenticateMe(BuildContext context) async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Touch fingerprint scanner to disable Biometrics",
      );
      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });

      if (authenticated) {
        disableBiometrics(context);
      } else {
        customErrorDialog(context, 'Error', "Could not authenticate");
      }

      print("Authenticated");
    } catch (e) {
      print("Not authenticated");
    }
    if (!mounted) return;
  }

  Future<void> onRefresh() async {
    refreshController.refreshCompleted();
    // if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline) {
    if (mounted) {
      setState(() {
        isRefresh = true;
      });
    }
    userController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider.notifier);
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: LiquidPullToRefresh(
        height: 100,
        animSpeedFactor: 2,
        color: brandOne,
        backgroundColor: Colors.white,
        showChildOpacityTransition: false,
        onRefresh: onRefresh,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  // height: 80,
                  width: MediaQuery.of(context).size.width - 20,
                  // decoration: BoxDecoration(
                  //   color: brandOne,
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Container(
                              width: 60,
                              height: 60,
                              // padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                // border: Border.all(color: brandOne,width: 2),
                                // color: brandOne,
                                // shape: BoxShape.circle,
                                borderRadius: BorderRadius.circular(100),
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
                                  // NetworkImage(
                                  //   userController.user[0].image,
                                  // ),
                                ),
                              ),
                              // child: Image.network(
                              //   userController.user[0].image,
                              //   fit: BoxFit.cover,
                              //   // height: 60,
                              //   // width: 60,
                              // ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                _pickImage(context, ImageSource.gallery);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${userController.userModel!.userDetails![0].firstName.capitalizeFirst} ${userController.userModel!.userDetails![0].lastName.capitalizeFirst}",
                              style: GoogleFonts.lato(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            (userController.userModel!.userDetails![0].status ==
                                    'verified')
                                ? Icon(
                                    Iconsax.verify5,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  )
                                : const SizedBox(),

                            //  ? const Icon(
                            //   Iconsax.verify5,
                            //   color: brandOne,
                            // ):,
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (userController
                                          .userModel!.userDetails![0].hasDva ==
                                      true)
                                  ? "Account Number: ${userController.userModel!.userDetails![0].dvaNumber}"
                                  : "Wallet ID: ${userController.userModel!.userDetails![0].wallet.walletId}",
                              style: GoogleFonts.lato(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            // const Icon(
                            //   Iconsax.copy,
                            //   color: brandTwo,
                            //   size: 15,
                            // ),
                          ],
                        ),
                      ),
                      // CupertinoProgressBar(
                      //   value: ,
                      // ),
                      Container(
                        width: 320,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: brandThree,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceAround,
                              //   children: [
                              //     Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text(
                              //           ch8t.format(
                              //             userController.userModel!
                              //                 .userDetails![0].referralPoints,
                              //           ),
                              //           style: GoogleFonts.lato(
                              //             color: brandOne,
                              //             fontSize: 20,
                              //             fontWeight: FontWeight.w600,
                              //           ),
                              //         ),
                              //         // SizedBox(
                              //         //   height: 10.h,
                              //         // ),
                              //         Text(
                              //           'SpacePoints',
                              //           style: GoogleFonts.lato(
                              //             color: brandOne,
                              //             fontSize: 14,
                              //             fontWeight: FontWeight.w500,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text(
                              //           ch8t.format(
                              //             userController.userModel!
                              //                 .userDetails![0].referralPoints,
                              //           ),
                              //           style: GoogleFonts.lato(
                              //             color: brandOne,
                              //             fontSize: 20,
                              //             fontWeight: FontWeight.w600,
                              //           ),
                              //         ),
                              //         // SizedBox(
                              //         //   height: 10.h,
                              //         // ),
                              //         Text(
                              //           'Referral Bonus',
                              //           style: GoogleFonts.lato(
                              //             color: brandOne,
                              //             fontSize: 14,
                              //             fontWeight: FontWeight.w500,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     ],
                              // ),

                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       'Referral Points',
                              //       style: GoogleFonts.lato(
                              //         color: brandOne,
                              //       ),
                              //     ),
                              //     Text(
                              //       "${valueNotifier.toInt()}%",
                              //       style: GoogleFonts.lato(
                              //         color: brandOne,
                              //         fontWeight: FontWeight.w600,
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Text(
                                      'SpacePoints',
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Text(
                                      userController.userModel!.userDetails![0]
                                          .utilityPoints
                                          .floor()
                                          .toString(),
                                      style: GoogleFonts.lato(
                                        color: brandOne,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // LinearProgressIndicator(
                      //   color: (valueNotifier < 70)
                      //       ? (valueNotifier < 30
                      //           ? Colors.red
                      //           : Colors.cyan)
                      //       : Colors.greenAccent,
                      // ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                    ),
                    child: const Icon(
                      Iconsax.user,
                      color: brandOne,
                    ),
                  ),
                  title: Text(
                    'Profile',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.to(const PersonalDetails());
                    // Navigator.pushNamed(context, RouteList.profile);
                  },
                  trailing: Icon(
                    Iconsax.arrow_right_3,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              // Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                    ),
                    child: const Icon(
                      Iconsax.security_safe,
                      color: brandOne,
                    ),
                  ),
                  title: Text(
                    'Security',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.to(const Security());
                    // Navigator.pushNamed(context, RouteList.profile);
                  },
                  trailing: Icon(
                    Iconsax.arrow_right_3,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                    ),
                    child: const Icon(
                      Iconsax.share,
                      color: brandOne,
                    ),
                  ),
                  title: Text(
                    'Referral',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.to(const ShareAndEarn());
                    // Navigator.pushNamed(context, RouteList.profile);
                  },
                  trailing: Icon(
                    Iconsax.arrow_right_3,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                    ),
                    child: const Icon(
                      Iconsax.call,
                      color: brandOne,
                    ),
                  ),
                  title: Text(
                    'Contact Us',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.to(const ContactUsPage());
                    // Navigator.pushNamed(context, RouteList.profile);
                  },
                  trailing: Icon(
                    Iconsax.arrow_right_3,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                    ),
                    child: const Icon(
                      Iconsax.information,
                      color: brandOne,
                    ),
                  ),
                  title: Text(
                    'FAQs',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.to(const FaqsPage());
                    // Navigator.pushNamed(context, RouteList.profile);
                  },
                  trailing: Icon(
                    Iconsax.arrow_right_3,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: const Icon(
                      Iconsax.logout,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Logout',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Get.bottomSheet(
                      SizedBox(
                        height: 250,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          child: Container(
                            color: Theme.of(context).canvasColor,
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                Text(
                                  'Are you sure you want to logout?',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    // fontFamily: "DefaultFontFamily",
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                //card
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await authState.logout(context).then(
                                                (value) => GetStorage().erase(),
                                              );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 15),
                                          textStyle: const TextStyle(
                                              color: brandFour, fontSize: 13),
                                        ),
                                        child: Text(
                                          "Yes",
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: brandTwo,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 15),
                                          textStyle: GoogleFonts.lato(
                                              color: brandFour, fontSize: 13),
                                        ),
                                        child: Text(
                                          "No",
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                //card
                              ],
                            ),
                          ),
                        ),
                      ),
                    );

                    // .then((value) => {Get.to(LoginPage())});
                  },
                  trailing: Icon(
                    Iconsax.arrow_right_3,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
