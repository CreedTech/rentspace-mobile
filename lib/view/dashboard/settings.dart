// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      backgroundColor: const Color(0xffF6F6F8),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffF6F6F8),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          children: [
            Text(
              'Profile',
              style: GoogleFonts.lato(
                color: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: LiquidPullToRefresh(
        height: 100,
        animSpeedFactor: 2,
        color: brandOne,
        backgroundColor: Colors.white,
        showChildOpacityTransition: false,
        onRefresh: onRefresh,
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 24.w,
          ),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 17, top: 17, right: 17, bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1), // Shadow color
                      spreadRadius: 0.5, // Spread radius
                      blurRadius: 2, // Blur radius
                      offset: const Offset(0, 3), // Offset
                    ),
                  ],
                  color: colorWhite,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      horizontalTitleGap: 0,
                      minLeadingWidth: 0,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 13, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xffF2F2F2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Space Point: ',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: colorBlack,
                                  ),
                                ),
                                const SizedBox(
                                  width: 13,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/spacepoint.png',
                                      width: 8.25,
                                      height: 11,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      userController.userModel!.userDetails![0]
                                          .utilityPoints
                                          .toString(),
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: brandTwo,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 13,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Account Number: ',
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: colorBlack,
                                    ),
                                  ),
                                  Text(
                                    userController
                                        .userModel!.userDetails![0].dvaNumber,
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: colorBlack,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: userController.userModel!
                                              .userDetails![0].dvaNumber,
                                        ),
                                      );
                                      Fluttertoast.showToast(
                                        msg: "Copied to clipboard!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.SNACKBAR,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: brandOne,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    },
                                    child: Image.asset(
                                      'assets/icons/copy_icon.png',
                                      width: 24,
                                      height: 24,
                                      color: colorBlack,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    'Copy',
                                    style: GoogleFonts.lato(
                                      color: brandTwo,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xffC9C9C9),
                    ),
                    GestureDetector(
                       onTap: () {
                          Get.to(const PersonalDetails());
                        },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        // horizontalTitleGap: 0,
                        minLeadingWidth: 0,
                        leading: Container(
                          width: 42.5,
                          height: 42.5,
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
                                userController.userModel!.userDetails![0].avatar,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          "${userController.userModel!.userDetails![0].firstName.capitalizeFirst} ${userController.userModel!.userDetails![0].lastName.capitalizeFirst}",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorBlack,
                          ),
                        ),
                        subtitle: Text(
                          "Account Details",
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: colorBlack,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_right,
                          color: colorBlack,
                          size: 20,
                        ),
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
                    left: 17, top: 17, right: 17, bottom: 17),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1), // Shadow color
                      spreadRadius: 0.5, // Spread radius
                      blurRadius: 2, // Blur radius
                      offset: const Offset(0, 3), // Offset
                    ),
                  ],
                  color: colorWhite,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(const Security());
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        // horizontalTitleGap: 0,
                        minLeadingWidth: 0,
                        leading: Image.asset('assets/security.png'),
                        title: Text(
                          "Security",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorBlack,
                          ),
                        ),
                        subtitle: Text(
                          "Manage your account security",
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: colorBlack,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_right,
                          color: colorBlack,
                          size: 20,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color(0xffC9C9C9),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Get.to(const Security());
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        // horizontalTitleGap: 0,
                        minLeadingWidth: 0,
                        leading: Image.asset('assets/theme_mode.png'),
                        title: Text(
                          "Dark Mode",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorBlack,
                          ),
                        ),
                        subtitle: Text(
                          "Switch to dark mode",
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: colorBlack,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_right,
                          color: colorBlack,
                          size: 20,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color(0xffC9C9C9),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const ShareAndEarn());
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        // horizontalTitleGap: 0,
                        minLeadingWidth: 0,
                        leading: Image.asset('assets/referrals.png'),
                        title: Text(
                          "Referral",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorBlack,
                          ),
                        ),
                        subtitle: Text(
                          "Refer and earn",
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: colorBlack,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_right,
                          color: colorBlack,
                          size: 20,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color(0xffC9C9C9),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const ContactUsPage());
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        // horizontalTitleGap: 0,
                        minLeadingWidth: 0,
                        leading: Image.asset('assets/contact.png'),
                        title: Text(
                          "Contact us",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorBlack,
                          ),
                        ),
                        subtitle: Text(
                          "Get support or send feedback",
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: colorBlack,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_right,
                          color: colorBlack,
                          size: 20,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color(0xffC9C9C9),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const FaqsPage());
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        // horizontalTitleGap: 0,
                        minLeadingWidth: 0,
                        leading: Image.asset('assets/faq.png'),
                        title: Text(
                          "FAQ",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorBlack,
                          ),
                        ),
                        subtitle: Text(
                          "See frequently asked questions",
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: colorBlack,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_right,
                          color: colorBlack,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 39,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
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
                  },
                  child: Text(
                    'Sign out',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffB51D1D),
                    ),
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
