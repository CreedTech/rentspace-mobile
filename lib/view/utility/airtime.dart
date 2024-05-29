import 'dart:io';

// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
// import 'package:pinput/pinput.dart';
// import 'package:rentspace/constants/airtime_constants.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:intl/intl.dart';
// import 'package:rentspace/controller/app_controller.dart';
import 'package:rentspace/controller/wallet_controller.dart';
import 'package:rentspace/view/utility/airtime_confirmation.dart';

import '../../constants/widgets/custom_loader.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/utility_response_controller.dart';

class AirtimePage extends ConsumerStatefulWidget {
  const AirtimePage({super.key});

  @override
  ConsumerState<AirtimePage> createState() => _AirtimePageState();
}

var ch8t = NumberFormat.simpleCurrency(name: 'NGN');

class _AirtimePageState extends ConsumerState<AirtimePage> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final UtilityResponseController utilityResponseController = Get.find();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController selectnetworkController = TextEditingController();
  final airtimeformKey = GlobalKey<FormState>();
  // List<String> networkCarrier = const <String>[
  //   'Select Network',
  //   'MTN',
  //   'Glo',
  //   'Airtel',
  //   '9mobile',
  // ];
  // List<String> networkImages = const <String>[
  //   'assets/utility/mtn.jpg',
  //   "assets/utility/airtel.jpg",
  //   "assets/utility/glo.jpg",
  //   "assets/utility/9mobile.jpg",
  // ];

  String? _selectedCarrier;
  String? _selectedImage;
  // String? billType;
  // String _userInput = '';

  bool showInvalidAmountAlert = false;
  bool showInvalidRecipientNumberAlert = false;

  // void validateUsersInput() {
  //   if (airtimeformKey.currentState!.validate()) {
  //     int amount = int.parse(amountController.text);
  //     String number = recipientController.text;
  //     // String bill = billType!;
  //     // String biller = _selectedCarrier!;

  //     // confirmPayment(context, amount, number, bill, biller);
  //   }
  // }

  String getCurrency() {
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'N');
    return format.currencySymbol;
  }

  void detectCarrier() {
    String phoneNumber = recipientController.text;

    if (isValidPhoneNumber(phoneNumber)) {
      String detectedCarrier = getCarrier(phoneNumber);
      setState(() {
        _selectedCarrier = detectedCarrier;
      });
      // print('_selectedCarrier');
      // print(_selectedCarrier);
      // print('detectedCarrier');
      // print(detectedCarrier);
      if (detectedCarrier == 'MTN'.toUpperCase()) {
        setState(() {
          _selectedImage = 'assets/utility/mtn.jpg';
        });
      } else if ((detectedCarrier == 'GLO'.toUpperCase())) {
        setState(() {
          _selectedImage = "assets/utility/glo.jpg";
        });
      } else if ((detectedCarrier == '9MOBILE'.toUpperCase())) {
        setState(() {
          _selectedImage = "assets/utility/9mobile.jpg";
        });
      } else if ((detectedCarrier == 'Airtel'.toUpperCase())) {
        setState(() {
          _selectedImage = "assets/utility/airtel.jpg";
        });
      }
    } else {
      customErrorDialog(context, "Invalid", 'Invalid Recipient Number');
    }
  }

  String getCarrier(String phoneNumber) {
    if (phoneNumber.length < 4) {
      return "";
    }
    String prefix = phoneNumber.substring(0, 4);

    if (prefix == "0703" ||
        prefix == '0706' ||
        prefix == '0702' ||
        prefix == '0803' ||
        prefix == '0806' ||
        prefix == '0810' ||
        prefix == '0813' ||
        prefix == '0814' ||
        prefix == '0903' ||
        prefix == '0906' ||
        prefix == '0913' ||
        prefix == '0916' ||
        prefix == '0816') {
      return 'MTN';
    } else if (prefix == '0805' ||
        prefix == '0705' ||
        prefix == '0905' ||
        prefix == '0811' ||
        prefix == '0815' ||
        prefix == '0915' ||
        prefix == '0807') {
      return 'GLO';
    } else if (prefix == '0808' ||
        prefix == '0708' ||
        prefix == '0701' ||
        prefix == '0812' ||
        prefix == '0901' ||
        prefix == '0902' ||
        prefix == '0904' ||
        prefix == '0907' ||
        prefix == '0912' ||
        prefix == '0802') {
      return 'AIRTEL';
    } else if (prefix == '0809' ||
        prefix == '0909' ||
        prefix == '0908' ||
        prefix == '0817' ||
        prefix == '0818') {
      return '9MOBILE';
    }

    return "";
  }

  bool isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.startsWith("0703") ||
        phoneNumber.startsWith("0706") ||
        phoneNumber.startsWith("0702") ||
        phoneNumber.startsWith("0803") ||
        phoneNumber.startsWith("0806") ||
        phoneNumber.startsWith("0810") ||
        phoneNumber.startsWith("0813") ||
        phoneNumber.startsWith("0814") ||
        phoneNumber.startsWith("0903") ||
        phoneNumber.startsWith("0906") ||
        phoneNumber.startsWith("0913") ||
        phoneNumber.startsWith("0916") ||
        phoneNumber.startsWith("0816") ||
        phoneNumber.startsWith("0805") ||
        phoneNumber.startsWith("0705") ||
        phoneNumber.startsWith("0905") ||
        phoneNumber.startsWith("0811") ||
        phoneNumber.startsWith("0815") ||
        phoneNumber.startsWith("0915") ||
        phoneNumber.startsWith("0807") ||
        phoneNumber.startsWith("0808") ||
        phoneNumber.startsWith("0708") ||
        phoneNumber.startsWith("0701") ||
        phoneNumber.startsWith("0812") ||
        phoneNumber.startsWith("0901") ||
        phoneNumber.startsWith("0902") ||
        phoneNumber.startsWith("0904") ||
        phoneNumber.startsWith("0907") ||
        phoneNumber.startsWith("0912") ||
        phoneNumber.startsWith("0802") ||
        phoneNumber.startsWith("0809") ||
        phoneNumber.startsWith("0908") ||
        phoneNumber.startsWith("0817") ||
        phoneNumber.startsWith("0810");
  }

  Future<bool> fetchUserData({bool refresh = true}) async {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    if (refresh) {
      await userController.fetchData();
      // await walletController.fetchWallet();
      await utilityResponseController.fetchUtilitiesResponse('Airtime');
      // setState(() {}); // Move setState inside fetchData
    }
    EasyLoading.dismiss();
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    recipientController.dispose();
    selectnetworkController.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    // recipientController.addListener(() {
    //   setState(() {
    //     _selectedCarrier = getCarrier(recipientController.text);
    //     selectnetworkController.text = _selectedCarrier!;
    //   });
    // });
  }

  bool isTextFieldEmpty = false;

  String displayedAmount = '';
  @override
  Widget build(BuildContext context) {
    // final appState = ref.watch(appControllerProvider.notifier);
    final networkCarrierSelect = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: const Color(0xffF6F6F8),
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 350,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                  color: const Color(0xffF6F6F8),
                  borderRadius: BorderRadius.circular(19)),
              child: ListView(
                children: [
                  Text(
                    'Select Network',
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        color: colorBlack,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: utilityResponseController
                          .utilityResponseModel!.utilities!.length,
                      itemBuilder: (context, idx) {
                        return Column(
                          children: [
                            ListTileTheme(
                              contentPadding: const EdgeInsets.only(
                                  left: 13.0, right: 13.0, top: 4, bottom: 4),
                              selectedColor:
                                  Theme.of(context).colorScheme.secondary,
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8,
                                      ),
                                      child: CircleAvatar(
                                        radius:
                                            20, // Adjust the radius as needed
                                        backgroundColor: Colors
                                            .transparent, // Ensure the background is transparent
                                        child: ClipOval(
                                          child: Image.asset(
                                            'assets/utility/${utilityResponseController.utilityResponseModel!.utilities![idx].name.toLowerCase()}.jpg',
                                            width: 29,
                                            height: 28,
                                            fit: BoxFit
                                                .fitWidth, // Ensure the image fits inside the circle
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        utilityResponseController
                                            .utilityResponseModel!
                                            .utilities![idx]
                                            .name,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: colorDark),
                                      ),
                                    ),
                                  ],
                                ),

                                // selected: _selectedCarrier == name[idx],
                                onTap: () {
                                  // billType = airtimeBill[idx];
                                  _selectedCarrier = utilityResponseController
                                      .utilityResponseModel!
                                      .utilities![idx]
                                      .name;
                                  _selectedImage =
                                      'assets/utility/${utilityResponseController.utilityResponseModel!.utilities![idx].name.toLowerCase()}.jpg';
                                  // canProceed = true;
                                  setState(() {
                                    // billType = airtimeBill[idx];
                                    _selectedCarrier = utilityResponseController
                                        .utilityResponseModel!
                                        .utilities![idx]
                                        .name;
                                    _selectedImage =
                                        'assets/utility/${utilityResponseController.utilityResponseModel!.utilities![idx].name.toLowerCase()}.jpg';
                                    // canProceed = true;
                                    selectnetworkController.text =
                                        _selectedCarrier!;
                                  });

                                  Navigator.pop(
                                    context,
                                  );

                                  setState(() {});
                                },
                              ),
                            ),
                            (idx !=
                                    utilityResponseController
                                        .utilityResponseModel!
                                        .utilities![idx]
                                        .name
                                        .length)
                                ? const Divider(
                                    color: Color(0xffC9C9C9),
                                    height: 1,
                                    indent: 13,
                                    endIndent: 13,
                                  )
                                : const SizedBox(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: colorBlack,
      style: GoogleFonts.lato(
        color: colorBlack,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),

      controller: selectnetworkController,
      textAlignVertical: TextAlignVertical.center,
      // textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Colors.red, width: 1.0), // Change color to yellow
        ),
        prefixIcon: (_selectedImage != null)
            ? Padding(
                padding: const EdgeInsets.only(right: 10, left: 15),
                child: CircleAvatar(
                  radius: 14, // Adjust the radius as needed
                  backgroundColor: Colors
                      .transparent, // Ensure the background is transparent
                  child: ClipOval(
                    child: Image.asset(
                      _selectedImage!,
                      width: 28,
                      height: 28,
                      fit: BoxFit
                          .cover, // Ensure the image fits inside the circle
                    ),
                  ),
                ),
              )
            : null,
        suffixIcon: const Icon(
          Icons.keyboard_arrow_down,
          size: 24,
          color: colorBlack,
        ),
        filled: false,
        fillColor: Colors.transparent,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        hintStyle: GoogleFonts.lato(
          color: brandOne,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      maxLines: 1,
    );

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffF6F6F8),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: colorBlack,
              ),
            ),
            SizedBox(
              width: 4.h,
            ),
            Text(
              'Airtime',
              style: GoogleFonts.lato(
                color: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 24.h),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Space Points:',
                          style: GoogleFonts.lato(
                            color: colorBlack,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/spacepoint.png',
                          width: 9.75,
                          height: 13,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          userController
                              .userModel!.userDetails![0].utilityPoints
                              .toString(),
                          style: GoogleFonts.lato(
                            color: brandOne,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    //  RichText(
                    //   text: TextSpan(
                    //     style: GoogleFonts.lato(
                    //       color: Colors.black54,
                    //       fontSize: 14,
                    //     ),
                    //     children: <TextSpan>[
                    //       TextSpan(
                    //         text: 'Space Points: ',
                    //         style: GoogleFonts.lato(
                    //           color: colorBlack,
                    //           fontWeight: FontWeight.w400,
                    //           fontSize: 14,
                    //         ),
                    //       ),
                    //       TextSpan(
                    //         text: userController
                    //             .userModel!.userDetails![0].utilityPoints
                    //             .toString(),
                    //         style: GoogleFonts.lato(
                    //           color: brandOne,
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: 14,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: airtimeformKey,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Select an amount',
                            style: GoogleFonts.lato(
                              color: colorBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildAmountButton(200),
                                const SizedBox(
                                  height: 16,
                                ),
                                buildAmountButton(2000),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildAmountButton(500),
                                const SizedBox(
                                  height: 16,
                                ),
                                buildAmountButton(3000),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildAmountButton(1000),
                                const SizedBox(
                                  height: 16,
                                ),
                                buildAmountButton(5000),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.h, horizontal: 3.w),
                              child: Text(
                                'Amount',
                                style: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            TextFormField(
                              enableSuggestions: true,
                              cursorColor: colorBlack,
                              style: GoogleFonts.lato(
                                  color: colorBlack, fontSize: 14),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: amountController,
                              onChanged: (value) {
                                // Enter_Transaction_Pin.of(context)
                                //     .updateDisplayedcurrentAmount(value);
                                setState(() {
                                  // print("Entered Amount: $value");
                                  // Check if the text field is empty
                                  displayedAmount = value;
                                  isTextFieldEmpty = value.isNotEmpty &&
                                      int.tryParse(value) != null &&
                                      int.parse(value) >= 50 &&
                                      !(int.tryParse(value)!.isNegative) &&
                                      int.tryParse(value
                                              .trim()
                                              .replaceAll(',', '')) !=
                                          0 &&
                                      recipientController.text.isNotEmpty &&
                                      recipientController.text.length == 11;
                                  // isTextFieldEmpty = value.isNotEmpty &&
                                  //     int.tryParse(value) != null &&
                                  //     int.parse(value) >= 50;
                                });
                              },
                              decoration: InputDecoration(
                                // hintText: 'Amount',
                                errorStyle: GoogleFonts.lato(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                                // hintStyle: GoogleFonts.lato(
                                //   color: Colors.grey,
                                //   fontSize: 12,
                                //   fontWeight: FontWeight.w400,
                                // ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: brandOne,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xffBDBDBD),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xffBDBDBD),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 2.0), // Change color to yellow
                                ),
                                prefixText: "₦ ",
                                prefixStyle: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                filled: false,
                                contentPadding: const EdgeInsets.all(14),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Amount';
                                }
                                if (int.tryParse(value)! >
                                    userController.userModel!.userDetails![0]
                                        .utilityPoints) {
                                  return 'Your Space Point is too low for this transaction';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                if (int.tryParse(value)! < 10) {
                                  return 'Amount cannot be less than 10 naira';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.h, horizontal: 3.w),
                              child: Text(
                                'Select Network',
                                style: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            networkCarrierSelect,
                          ],
                        ),
                        SizedBox(
                          height: 13.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.h, horizontal: 3.w),
                              child: Text(
                                'Number',
                                style: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextFormField(
                              enableSuggestions: true,
                              cursorColor: colorBlack,
                              style: GoogleFonts.lato(
                                color: colorBlack,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              controller: recipientController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // validator: validatePhone,

                              keyboardType: TextInputType.number,
                              onChanged: (text) {
                                setState(() {
                                  // _userInput = text;
                                  _selectedCarrier = getCarrier(text);
                                  selectnetworkController.text =
                                      _selectedCarrier!;
                                  // print("Selected network: $_selectedCarrier");
                                  isTextFieldEmpty = amountController
                                          .text.isNotEmpty &&
                                      int.tryParse(amountController.text) !=
                                          null &&
                                      int.parse(amountController.text) >= 10 &&
                                      !(int.tryParse(amountController.text)!
                                          .isNegative) &&
                                      int.tryParse(amountController.text
                                              .trim()
                                              .replaceAll(',', '')) !=
                                          0 &&
                                      text.isNotEmpty &&
                                      text.length == 11;
                                });

                                if (_selectedCarrier == 'MTN'.toUpperCase()) {
                                  setState(() {
                                    _selectedImage = 'assets/utility/mtn.jpg';
                                  });
                                } else if ((_selectedCarrier ==
                                    'Glo'.toUpperCase())) {
                                  setState(() {
                                    _selectedImage = "assets/utility/glo.jpg";
                                  });
                                } else if ((_selectedCarrier ==
                                    '9mobile'.toUpperCase())) {
                                  setState(() {
                                    _selectedImage =
                                        "assets/utility/9mobile.jpg";
                                  });
                                } else if ((_selectedCarrier ==
                                    'Airtel'.toUpperCase())) {
                                  setState(() {
                                    _selectedImage =
                                        "assets/utility/airtel.jpg";
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Recipient Number';
                                }
                                if (value.length != 11) {
                                  return 'Recipient Number must be 11 Digit';
                                }
                                return null;
                              },
                              // maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              // maxLength: 11,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE0E0E0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: brandOne, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE0E0E0),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1.0), // Change color to yellow
                                ),
                                filled: false,
                                contentPadding: const EdgeInsets.all(14),
                                fillColor: brandThree,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 140.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 50, 50),
                      backgroundColor: (airtimeformKey.currentState != null &&
                              airtimeformKey.currentState!.validate())
                          ? brandTwo
                          : Colors.grey,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (airtimeformKey.currentState != null &&
                          airtimeformKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        var billerLists = Hive.box('Airtime');
                        var storedData = billerLists.get('Airtime');
                        //  storedData['data'];
                        // print(_selectedCarrier!);
                        var outputList = storedData['data']
                            .where((o) => o['name'] == _selectedCarrier!)
                            .toList();
                        print('output list ${outputList}');

                        print(outputList[0]['name']);
                        // print(amountController.text);
                        // print(billType!);
                        // print(_selectedCarrier!);

                        Get.to(
                          AirtimeConfirmation(
                            number: recipientController.text,
                            amount: int.parse(amountController.text),
                            image: _selectedImage!,
                            billerId: outputList[0]['id'],
                            name: outputList[0]['name'],
                            divisionId: outputList[0]['division'],
                            productId: outputList[0]['product'],
                            category: outputList[0]['category'],
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Proceed',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAmountButton(int amount) {
    return GestureDetector(
      onTap: () {
        // Update the displayedAmount when a button is clicked
        setState(() {
          displayedAmount = amount.toString();
          amountController.text = displayedAmount;
          isTextFieldEmpty = true;
        });
      },
      child: Container(
        width: 100.w,
        height: 55.h,
        decoration: BoxDecoration(
          color: const Color(0xffEEF8FF),
          borderRadius: BorderRadius.circular(7.r),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Text(
              '₦$amount',
              style: GoogleFonts.lato(
                color: brandOne,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> confirmPayment(BuildContext context, int amount, String number,
  //     String bill, String biller) async {
  //   final appState = ref.watch(appControllerProvider.notifier);
  //   validatePinOne(pinOneValue) {
  //     if (pinOneValue.isEmpty) {
  //       return 'pin cannot be empty';
  //     }
  //     if (pinOneValue.length < 4) {
  //       return 'pin is incomplete';
  //     }
  //     if (int.tryParse(pinOneValue) == null) {
  //       return 'enter valid number';
  //     }
  //     return null;
  //   }

  //   print(bill);

  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         elevation: 0,
  //         contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
  //         alignment: Alignment.bottomCenter,
  //         insetPadding: const EdgeInsets.all(0),
  //         title: Padding(
  //           padding: const EdgeInsets.only(top: 0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const SizedBox(),
  //               Text(
  //                 ch8t.format(amount),
  //                 textAlign: TextAlign.center,
  //                 style: GoogleFonts.roboto(
  //                   fontWeight: FontWeight.w700,
  //                   fontSize: 30,
  //                   color: brandOne,
  //                 ),
  //               ),
  //               alert(context),
  //             ],
  //           ),
  //         ),
  //         shape: const RoundedRectangleBorder(
  //             // borderRadius: BorderRadius.circular(20.0.r),
  //             borderRadius: BorderRadius.only(
  //           topRight: Radius.circular(16),
  //           topLeft: Radius.circular(16),
  //         )),
  //         content: SizedBox(
  //           height: 400.h,
  //           // width: 390.h,
  //           child: Container(
  //             width: 400.w,
  //             child: Column(
  //               children: [
  //                 Stack(children: [
  //                   SizedBox(
  //                     height: 18.h,
  //                   ),
  //                   Align(
  //                     alignment: Alignment.topLeft,
  //                     child: Padding(
  //                       padding: EdgeInsets.symmetric(
  //                           vertical: 15.h, horizontal: 15.h),
  //                       child: Column(
  //                         children: [
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 'Provider Network',
  //                                 style: GoogleFonts.lato(
  //                                   color: brandTwo,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                               Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 crossAxisAlignment: CrossAxisAlignment.center,
  //                                 children: [
  //                                   ClipRRect(
  //                                     borderRadius:
  //                                         BorderRadius.circular(100.0),
  //                                     child: Image.asset(
  //                                       _selectedImage!,
  //                                       height: 20.h,
  //                                       width: 20.h,
  //                                     ),
  //                                   ),
  //                                   SizedBox(
  //                                     width: 9.w,
  //                                   ),
  //                                   Text(
  //                                     _selectedCarrier!,
  //                                     textAlign: TextAlign.center,
  //                                     style: GoogleFonts.lato(
  //                                       color: brandOne,
  //                                       fontSize: 12,
  //                                       fontWeight: FontWeight.w600,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               )
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             height: 11.h,
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 'Recipient Number',
  //                                 style: GoogleFonts.lato(
  //                                   color: brandTwo,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 number,
  //                                 style: GoogleFonts.lato(
  //                                   color: brandOne,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w600,
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             height: 16.h,
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 'Amount',
  //                                 style: GoogleFonts.lato(
  //                                   color: brandTwo,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 ch8t.format(amount),
  //                                 style: GoogleFonts.roboto(
  //                                   color: brandOne,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w600,
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             height: 11.h,
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 'Transaction Fee',
  //                                 style: GoogleFonts.lato(
  //                                   color: brandTwo,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 ch8t.format(0),
  //                                 style: GoogleFonts.roboto(
  //                                   color: brandOne,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w600,
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             height: 15.h,
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 'Payment Method',
  //                                 style: GoogleFonts.lato(
  //                                   color: brandOne,
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                               // Column(
  //                               //   crossAxisAlignment: CrossAxisAlignment.end,
  //                               //   children: [
  //                               //     Text(
  //                               //       'Space Wallet',
  //                               //       style: GoogleFonts.lato(
  //                               //         color: brandOne,
  //                               //         fontSize: 15,
  //                               //         fontWeight: FontWeight.w600,
  //                               //       ),
  //                               //     ),
  //                               //     Text(
  //                               //       ch8t.format(userController.userModel!
  //                               //           .userDetails![0].wallet.mainBalance),
  //                               //       style: GoogleFonts.lato(
  //                               //         color: brandOne,
  //                               //         fontSize: 15,
  //                               //         fontWeight: FontWeight.w600,
  //                               //       ),
  //                               //     ),
  //                               //   ],
  //                               // )
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             height: 11.h,
  //                           ),
  //                           Container(
  //                             width: double.infinity,
  //                             padding: EdgeInsets.symmetric(vertical: 5.h),
  //                             decoration: BoxDecoration(
  //                               color: brandTwo.withOpacity(0.05),
  //                               borderRadius: BorderRadius.circular(15),
  //                             ),
  //                             child: ListTile(
  //                               leading: Icon(
  //                                 Icons.wallet,
  //                                 color: ((amount) >
  //                                         walletController.walletModel!
  //                                             .wallet![0].mainBalance)
  //                                     ? Colors.grey
  //                                     : brandOne,
  //                                 size: 25,
  //                               ),
  //                               title: RichText(
  //                                 // textAlign: TextAlign.center,
  //                                 text: TextSpan(
  //                                   style: GoogleFonts.lato(
  //                                     fontWeight: FontWeight.w700,
  //                                     fontSize: 14,
  //                                   ),
  //                                   children: <TextSpan>[
  //                                     TextSpan(
  //                                       text: "Balance",
  //                                       style: GoogleFonts.lato(
  //                                         color: ((amount) >
  //                                                 walletController.walletModel!
  //                                                     .wallet![0].mainBalance)
  //                                             ? Colors.grey
  //                                             : brandOne,
  //                                         fontWeight: FontWeight.w700,
  //                                         fontSize: 14,
  //                                       ),
  //                                     ),
  //                                     TextSpan(
  //                                       text:
  //                                           '(${ch8t.format(walletController.walletModel!.wallet![0].mainBalance)})',
  //                                       style: GoogleFonts.roboto(
  //                                         color: ((amount) >
  //                                                 walletController.walletModel!
  //                                                     .wallet![0].mainBalance)
  //                                             ? Colors.grey
  //                                             : brandOne,
  //                                         fontWeight: FontWeight.w500,
  //                                         fontSize: 14,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               subtitle: ((amount) >
  //                                       walletController.walletModel!.wallet![0]
  //                                           .mainBalance)
  //                                   ? Text(
  //                                       'Insufficient Balance',
  //                                       style: GoogleFonts.lato(
  //                                         color: Colors.grey,
  //                                         fontWeight: FontWeight.w500,
  //                                         fontSize: 12,
  //                                       ),
  //                                     )
  //                                   : null,
  //                               trailing: ((amount) >
  //                                       walletController.walletModel!.wallet![0]
  //                                           .mainBalance)
  //                                   ? GestureDetector(
  //                                       onTap: () {
  //                                         Get.to(const FundWallet());
  //                                       },
  //                                       child: Wrap(
  //                                         alignment: WrapAlignment.end,
  //                                         crossAxisAlignment:
  //                                             WrapCrossAlignment.end,
  //                                         children: [
  //                                           Text(
  //                                             'Top up',
  //                                             textAlign: TextAlign.center,
  //                                             style: GoogleFonts.lato(
  //                                               color: brandOne,
  //                                               fontWeight: FontWeight.w500,
  //                                               fontSize: 12,
  //                                             ),
  //                                           ),
  //                                           const Icon(
  //                                             Icons.arrow_forward_ios,
  //                                             color: brandOne,
  //                                             size: 20,
  //                                           )
  //                                         ],
  //                                       ),
  //                                     )
  //                                   : const Icon(
  //                                       Icons.check,
  //                                       color: brandOne,
  //                                       size: 20,
  //                                     ),
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             height: 35.h,
  //                           ),
  //                           ElevatedButton(
  //                             style: ElevatedButton.styleFrom(
  //                               minimumSize: const Size(250, 50),
  //                               backgroundColor: (((amount) >
  //                                       walletController.walletModel!.wallet![0]
  //                                           .mainBalance))
  //                                   ? Colors.grey
  //                                   : brandOne,
  //                               elevation: 0,
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(
  //                                   50,
  //                                 ),
  //                               ),
  //                             ),
  //                             onPressed: ((amount) >
  //                                     walletController
  //                                         .walletModel!.wallet![0].mainBalance)
  //                                 ? null
  //                                 : () async {
  //                                     FocusScope.of(context).unfocus();
  //                                     Get.bottomSheet(
  //                                       isDismissible: true,
  //                                       SizedBox(
  //                                         width:
  //                                             MediaQuery.of(context).size.width,
  //                                         height: 400.h,
  //                                         child: ClipRRect(
  //                                           borderRadius:
  //                                               const BorderRadius.only(
  //                                             topLeft: Radius.circular(30.0),
  //                                             topRight: Radius.circular(30.0),
  //                                           ),
  //                                           child: Container(
  //                                             color:
  //                                                 Theme.of(context).canvasColor,
  //                                             padding:
  //                                                 const EdgeInsets.fromLTRB(
  //                                                     10, 5, 10, 5),
  //                                             child: Column(
  //                                               crossAxisAlignment:
  //                                                   CrossAxisAlignment.center,
  //                                               mainAxisAlignment:
  //                                                   MainAxisAlignment.center,
  //                                               children: [
  //                                                 // const SizedBox(
  //                                                 //   height: 50,
  //                                                 // ),

  //                                                 SizedBox(
  //                                                   height: 20.h,
  //                                                 ),
  //                                                 Pinput(
  //                                                   useNativeKeyboard: false,
  //                                                   obscureText: true,
  //                                                   defaultPinTheme: PinTheme(
  //                                                     width: 50,
  //                                                     height: 50,
  //                                                     textStyle:
  //                                                         GoogleFonts.lato(
  //                                                       color: brandOne,
  //                                                       fontSize: 28,
  //                                                     ),
  //                                                     decoration: BoxDecoration(
  //                                                       border: Border.all(
  //                                                           color: Colors.grey,
  //                                                           width: 1.0),
  //                                                       borderRadius:
  //                                                           BorderRadius
  //                                                               .circular(5),
  //                                                     ),
  //                                                   ),
  //                                                   focusedPinTheme: PinTheme(
  //                                                     width: 50,
  //                                                     height: 50,
  //                                                     textStyle:
  //                                                         const TextStyle(
  //                                                       fontSize: 25,
  //                                                       color: brandOne,
  //                                                     ),
  //                                                     decoration: BoxDecoration(
  //                                                       border: Border.all(
  //                                                           color: brandOne,
  //                                                           width: 2.0),
  //                                                       borderRadius:
  //                                                           BorderRadius
  //                                                               .circular(5),
  //                                                     ),
  //                                                   ),
  //                                                   submittedPinTheme: PinTheme(
  //                                                     width: 50,
  //                                                     height: 50,
  //                                                     textStyle:
  //                                                         const TextStyle(
  //                                                       fontSize: 25,
  //                                                       color: brandOne,
  //                                                     ),
  //                                                     decoration: BoxDecoration(
  //                                                       border: Border.all(
  //                                                           color: brandOne,
  //                                                           width: 2.0),
  //                                                       borderRadius:
  //                                                           BorderRadius
  //                                                               .circular(5),
  //                                                     ),
  //                                                   ),
  //                                                   followingPinTheme: PinTheme(
  //                                                     width: 50,
  //                                                     height: 50,
  //                                                     textStyle:
  //                                                         const TextStyle(
  //                                                       fontSize: 25,
  //                                                       color: brandOne,
  //                                                     ),
  //                                                     decoration: BoxDecoration(
  //                                                       border: Border.all(
  //                                                           color: brandTwo,
  //                                                           width: 2.0),
  //                                                       borderRadius:
  //                                                           BorderRadius
  //                                                               .circular(5),
  //                                                     ),
  //                                                   ),

  //                                                   onCompleted: (String val) {
  //                                                     if (BCrypt.checkpw(
  //                                                       _aPinController.text
  //                                                           .trim()
  //                                                           .toString(),
  //                                                       userController
  //                                                           .userModel!
  //                                                           .userDetails![0]
  //                                                           .wallet
  //                                                           .pin,
  //                                                     )) {
  //                                                       // _aPinController.clear();
  //                                                       Get.back();
  //                                                       print(_aPinController
  //                                                           .text
  //                                                           .trim()
  //                                                           .toString());
  //                                                       // _doWallet();
  //                                                       appState.buyAirtime(
  //                                                           context,
  //                                                           amount,
  //                                                           number.toString(),
  //                                                           bill,
  //                                                           biller);
  //                                                     } else {
  //                                                       _aPinController.clear();
  //                                                       if (context.mounted) {
  //                                                         customErrorDialog(
  //                                                             context,
  //                                                             "Invalid PIN",
  //                                                             'Enter correct PIN to proceed');
  //                                                       }
  //                                                     }
  //                                                   },
  //                                                   // validator: validatePinOne,
  //                                                   // onChanged: validatePinOne,
  //                                                   controller: _aPinController,
  //                                                   length: 4,
  //                                                   closeKeyboardWhenCompleted:
  //                                                       true,
  //                                                   keyboardType:
  //                                                       TextInputType.number,
  //                                                 ),
  //                                                 NumericKeyboard(
  //                                                   onKeyboardTap:
  //                                                       (String value) {
  //                                                     setState(() {
  //                                                       _aPinController.text =
  //                                                           _aPinController
  //                                                                   .text +
  //                                                               value;
  //                                                     });
  //                                                     print(value);
  //                                                     print(
  //                                                         _aPinController.text);
  //                                                   },
  //                                                   textStyle: GoogleFonts.lato(
  //                                                     color: brandOne,
  //                                                     fontSize: 24,
  //                                                   ),
  //                                                   rightButtonFn: () {
  //                                                     if (_aPinController
  //                                                         .text.isEmpty) return;
  //                                                     setState(() {
  //                                                       _aPinController.text =
  //                                                           _aPinController.text
  //                                                               .substring(
  //                                                                   0,
  //                                                                   _aPinController
  //                                                                           .text
  //                                                                           .length -
  //                                                                       1);
  //                                                     });
  //                                                   },
  //                                                   rightButtonLongPressFn: () {
  //                                                     if (_aPinController
  //                                                         .text.isEmpty) return;
  //                                                     setState(() {
  //                                                       _aPinController.text =
  //                                                           '';
  //                                                     });
  //                                                   },
  //                                                   rightIcon: const Icon(
  //                                                     Icons.backspace_outlined,
  //                                                     color: Colors.red,
  //                                                   ),
  //                                                   mainAxisAlignment:
  //                                                       MainAxisAlignment
  //                                                           .spaceBetween,
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     );
  //                                   },
  //                             child: Text(
  //                               'Pay',
  //                               textAlign: TextAlign.center,
  //                               style: GoogleFonts.lato(
  //                                 color: Colors.white,
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.w700,
  //                               ),
  //                             ),
  //                           ),
  //                           // GestureDetector(
  //                           //   onTap: () {
  //                           //     Get.bottomSheet(
  //                           //       isDismissible: true,
  //                           //       SizedBox(
  //                           //         width: MediaQuery.of(context).size.width,
  //                           //         height: 350,
  //                           //         child: ClipRRect(
  //                           //           borderRadius: const BorderRadius.only(
  //                           //             topLeft: Radius.circular(30.0),
  //                           //             topRight: Radius.circular(30.0),
  //                           //           ),
  //                           //           child: Container(
  //                           //             color: Theme.of(context).canvasColor,
  //                           //             padding: const EdgeInsets.fromLTRB(
  //                           //                 10, 5, 10, 5),
  //                           //             child: Column(
  //                           //               crossAxisAlignment:
  //                           //                   CrossAxisAlignment.center,
  //                           //               children: [
  //                           //                 const SizedBox(
  //                           //                   height: 50,
  //                           //                 ),
  //                           //                 Text(
  //                           //                   'Enter PIN to Proceed',
  //                           //                   style: GoogleFonts.lato(
  //                           //                       fontSize: 18,
  //                           //                       color: Theme.of(context)
  //                           //                           .primaryColor,
  //                           //                       fontWeight: FontWeight.w700),
  //                           //                   textAlign: TextAlign.center,
  //                           //                 ),
  //                           //                 const SizedBox(
  //                           //                   height: 20,
  //                           //                 ),
  //                           //                 Pinput(
  //                           //                   obscureText: true,
  //                           //                   defaultPinTheme: PinTheme(
  //                           //                     width: 50,
  //                           //                     height: 50,
  //                           //                     textStyle: const TextStyle(
  //                           //                       fontSize: 20,
  //                           //                       color: brandOne,
  //                           //                     ),
  //                           //                     decoration: BoxDecoration(
  //                           //                       border: Border.all(
  //                           //                           color: brandTwo,
  //                           //                           width: 1.0),
  //                           //                       borderRadius:
  //                           //                           BorderRadius.circular(5),
  //                           //                     ),
  //                           //                   ),
  //                           //                   onCompleted: (String val) {
  //                           //                     if (BCrypt.checkpw(
  //                           //                       _aPinController.text
  //                           //                           .trim()
  //                           //                           .toString(),
  //                           //                       userController
  //                           //                           .userModel!
  //                           //                           .userDetails![0]
  //                           //                           .wallet
  //                           //                           .pin,
  //                           //                     )) {
  //                           //                       _aPinController.clear();
  //                           //                       Get.back();
  //                           //                       // _doWallet();
  //                           //                       appState.buyAirtime(
  //                           //                           context,
  //                           //                           amount,
  //                           //                           number.toString(),
  //                           //                           bill,
  //                           //                           biller);
  //                           //                     } else {
  //                           //                       _aPinController.clear();
  //                           //                       if (context.mounted) {
  //                           //                         customErrorDialog(
  //                           //                             context,
  //                           //                             "Invalid PIN",
  //                           //                             'Enter correct PIN to proceed');
  //                           //                       }
  //                           //                     }
  //                           //                   },
  //                           //                   validator: validatePinOne,
  //                           //                   onChanged: validatePinOne,
  //                           //                   controller: _aPinController,
  //                           //                   length: 4,
  //                           //                   closeKeyboardWhenCompleted: true,
  //                           //                   keyboardType:
  //                           //                       TextInputType.number,
  //                           //                 ),
  //                           //                 const SizedBox(
  //                           //                   height: 20,
  //                           //                 ),
  //                           //                 const SizedBox(
  //                           //                   height: 40,
  //                           //                 ),
  //                           //                 ElevatedButton(
  //                           //                   style: ElevatedButton.styleFrom(
  //                           //                     minimumSize:
  //                           //                         const Size(300, 50),
  //                           //                     backgroundColor: brandOne,
  //                           //                     elevation: 0,
  //                           //                     shape: RoundedRectangleBorder(
  //                           //                       borderRadius:
  //                           //                           BorderRadius.circular(
  //                           //                         10,
  //                           //                       ),
  //                           //                     ),
  //                           //                   ),
  //                           //                   onPressed: () {
  //                           //                     if (BCrypt.checkpw(
  //                           //                       _aPinController.text
  //                           //                           .trim()
  //                           //                           .toString(),
  //                           //                       userController
  //                           //                           .userModel!
  //                           //                           .userDetails![0]
  //                           //                           .wallet
  //                           //                           .pin,
  //                           //                     )) {
  //                           //                       _aPinController.clear();
  //                           //                       Get.back();
  //                           //                       // _doWallet();
  //                           //                       appState.buyAirtime(
  //                           //                           context,
  //                           //                           amount,
  //                           //                           number.toString(),
  //                           //                           bill,
  //                           //                           biller);
  //                           //                     } else {
  //                           //                       _aPinController.clear();
  //                           //                       if (context.mounted) {
  //                           //                         customErrorDialog(
  //                           //                             context,
  //                           //                             "Invalid PIN",
  //                           //                             'Enter correct PIN to proceed');
  //                           //                       }
  //                           //                     }
  //                           //                   },
  //                           //                   child: Text(
  //                           //                     'Proceed to Payment',
  //                           //                     textAlign: TextAlign.center,
  //                           //                     style: GoogleFonts.lato(
  //                           //                       color: Colors.white,
  //                           //                       fontSize: 16,
  //                           //                       fontWeight: FontWeight.w700,
  //                           //                     ),
  //                           //                   ),
  //                           //                 ),
  //                           //               ],
  //                           //             ),
  //                           //           ),
  //                           //         ),
  //                           //       ),
  //                           //     );
  //                           //   },
  //                           //   child: Container(
  //                           //     decoration: BoxDecoration(
  //                           //         color: brandOne,
  //                           //         borderRadius: BorderRadius.circular(15)),
  //                           //     child: Padding(
  //                           //       padding: const EdgeInsets.all(13),
  //                           //       child: Align(
  //                           //         child: Text(
  //                           //           'Pay',
  //                           //           textAlign: TextAlign.center,
  //                           //           style: GoogleFonts.lato(
  //                           //             color: Colors.white,
  //                           //             fontSize: 19,
  //                           //             fontWeight: FontWeight.w600,
  //                           //           ),
  //                           //         ),
  //                           //       ),
  //                           //     ),
  //                           //   ),
  //                           // ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ]),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // GestureDetector alert(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  //       showDialog(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: null,
  //               elevation: 0,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(16.h),
  //               ),
  //               content: SizedBox(
  //                 height: 200.h,
  //                 width: 400.h,
  //                 child: SingleChildScrollView(
  //                     child: Column(
  //                   children: [
  //                     // GestureDetector(
  //                     //   onTap: () {
  //                     //     Navigator.of(context).pop();
  //                     //   },
  //                     //   child: Align(
  //                     //     alignment: Alignment.topRight,
  //                     //     child: Container(
  //                     //       decoration: BoxDecoration(
  //                     //         borderRadius: BorderRadius.circular(30.h),
  //                     //         color: Colors.red,
  //                     //       ),
  //                     //       child: Padding(
  //                     //         padding: EdgeInsets.all(10.h),
  //                     //         child: Icon(
  //                     //           Iconsax.close_circle,
  //                     //           color: Colors.red,
  //                     //           size: 20,
  //                     //         ),
  //                     //       ),
  //                     //     ),
  //                     //   ),
  //                     // ),
  //                     SizedBox(
  //                       height: 10.h,
  //                     ),
  //                     Text(
  //                       'Payment Not completed',
  //                       style: GoogleFonts.lato(
  //                         color: brandOne,
  //                         fontWeight: FontWeight.w700,
  //                         fontSize: 18,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 3.h,
  //                     ),
  //                     Text(
  //                       'Do you want to cancel this payment?',
  //                       textAlign: TextAlign.center,
  //                       style: GoogleFonts.lato(
  //                           color: brandOne,
  //                           fontSize: 12,
  //                           fontWeight: FontWeight.w500),
  //                     ),
  //                     SizedBox(
  //                       height: 20.h,
  //                     ),
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                             minimumSize: const Size(300, 50),
  //                             backgroundColor: brandOne,
  //                             elevation: 0,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(
  //                                 50,
  //                               ),
  //                             ),
  //                           ),
  //                           onPressed: () {
  //                             FocusScope.of(context).unfocus();
  //                             Navigator.of(context).pop();
  //                           },
  //                           child: Text(
  //                             'Proceed to Pay',
  //                             textAlign: TextAlign.center,
  //                             style: GoogleFonts.lato(
  //                               color: Colors.white,
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w700,
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           height: 15.h,
  //                         ),
  //                         ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                             minimumSize: const Size(300, 50),
  //                             backgroundColor: Colors.white,
  //                             elevation: 0,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(
  //                                 50,
  //                               ),
  //                               side:
  //                                   const BorderSide(color: brandOne, width: 1),
  //                             ),
  //                           ),
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                             Navigator.of(context).pop();
  //                           },
  //                           child: Text(
  //                             'Cancel',
  //                             textAlign: TextAlign.center,
  //                             style: GoogleFonts.lato(
  //                               color: brandOne,
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w700,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 )),
  //               ),
  //             );
  //           });
  //     },
  //     child: const Icon(
  //       Icons.close,
  //       color: brandOne,
  //       size: 20,
  //     ),
  //   );
  // }
}
