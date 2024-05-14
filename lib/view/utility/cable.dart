import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/tv_constants.dart';
import 'package:rentspace/constants/widgets/custom_loader.dart';
import 'package:rentspace/view/utility/cable_list.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../constants/colors.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/wallet_controller.dart';
import 'package:http/http.dart' as http;

class CableScreen extends StatefulWidget {
  const CableScreen({super.key});

  @override
  State<CableScreen> createState() => _CableScreenState();
}

class _CableScreenState extends State<CableScreen> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController providerController = TextEditingController();
  final TextEditingController smartcardController = TextEditingController();
  final tvFormKey = GlobalKey<FormState>();
  String _selectedTVCode = 'bill-20';
  String tvCable = 'DSTV - Subscription';
  String tvImage = 'assets/utility/dstv.jpg';
  String tvName = '';
  String tvNumber = '';
  // String tvName = '';
  bool hasError = false;
  String verifyAccountError = "";
  String _message = '';
  bool isChecking = false;
  bool canProceed = false;

  bool isTextFieldEmpty = false;
  Future<bool> fetchUserData({bool refresh = true}) async {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    if (refresh) {
      await userController.fetchData();
      await walletController.fetchWallet();
      // setState(() {}); // Move setState inside fetchData
    }
    EasyLoading.dismiss();
    return true;
  }

  void _updateMessage() {
    if (isChecking) {
      // If checking, display loader message
      _message = 'Verifying TV Details';
      verifyAccountError = "";
      hasError = false;
      tvName = "";
    }
  }

  verifyTV(String currentCode) async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    setState(() {
      isChecking = true;
      tvName = "";
      verifyAccountError = "";
      hasError = false;
      canProceed = false;
    });
    final response = await http.post(
        Uri.parse(AppConstants.BASE_URL + AppConstants.VERIFY_TV),
        headers: {
          'Authorization': 'Bearer $authToken',
          "Content-Type": "application/json"
        },
        body: json.encode({
          "billingServiceID": _selectedTVCode,
          "smartCardNumber": smartcardController.text.trim().toString()
        }));

    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final smartCardFirstName = jsonResponse['firstName'];
      final smartCardLastName = jsonResponse['lastName'];
      final smartCardStatus = jsonResponse['accountStatus'];
      tvName = '$smartCardFirstName $smartCardLastName';
      if (tvName != '' && tvName != 'N/A') {
        setState(() {
          tvName = tvName;
          isChecking = false;
          hasError = false;
          canProceed = true;
        });
        _updateMessage();
      } else {
        // Error handling
        setState(() {
          tvName = "";
          isChecking = false;
          hasError = true;
          verifyAccountError =
              'SmartCard Validation failed. Please check the digits and try again';
          canProceed = false;
        });
        _updateMessage();
        // if (context.mounted) {
        //   customErrorDialog(context, 'Error!', "Invalid account number");
        // }
      }

      //print(response.body);
    } else {
      // Error handling
      setState(() {
        tvName = "";
        isChecking = false;
        hasError = true;
        verifyAccountError =
            'SmartCard Validation failed. Please check the digits and try again';
        canProceed = false;
      });
      _updateMessage();

      // if (context.mounted) {
      //   customErrorDialog(context, 'Error!', 'Something went wrong');
      // }

      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }

  void _checkFieldsAndHitApi() {
    if (tvFormKey.currentState!.validate()) {
      verifyTV(_selectedTVCode);
    }
  }

  void validateUsersInput() {
    if (tvFormKey.currentState!.validate()) {
      Get.to(CableListScreen(
        image: tvImage,
        name: tvName,
        tvName: tvCable,
        cardNumber: smartcardController.text.trim(),
        code: _selectedTVCode,
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    smartcardController.dispose();
    providerController.dispose();
  }

  @override
  void initState() {
    super.initState();
    canProceed = false;
    fetchUserData();
    // recipientController.addListener(() {
    //   setState(() {
    //     _selectedCarrier = getCarrier(recipientController.text);
    //     selectnetworkController.text = _selectedCarrier;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_sharp,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'TV',
          style: GoogleFonts.lato(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 20.h,
          ),
          child: ListView(
            children: [
              Form(
                key: tvFormKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 3.w),
                            child: Text(
                              'Service Provider',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          TextFormField(
                            onTap: () {
                              showModalBottomSheet(
                                showDragHandle: true,
                                isDismissible: true,
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (BuildContext context) {
                                  List<String> tvBill = TVConstants.tvCodes
                                      .map((country) => country['code']!)
                                      .toList();
                                  List<String> name = TVConstants.tvCodes
                                      .map((country) => country['name']!)
                                      .toList();
                                  List<String> image = TVConstants.tvCodes
                                      .map((country) => country['image']!)
                                      .toList();

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.fromLTRB(
                                        0,
                                        10,
                                        0,
                                        10,
                                      ),
                                      itemCount: name.length,
                                      itemBuilder: (context, idx) {
                                        return ListTileTheme(
                                          selectedColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.only(
                                              left: 25.0,
                                              right: 25.0,
                                            ),
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 8,
                                                  ),
                                                  child: CircleAvatar(
                                                    radius:
                                                        20, // Adjust the radius as needed
                                                    backgroundColor: Colors
                                                        .transparent, // Ensure the background is transparent
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                        image[idx],
                                                        width: 35,
                                                        height: 35,
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Text(
                                                    name[idx],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            leading: Radio<String>(
                                              fillColor: MaterialStateColor
                                                  .resolveWith(
                                                (states) => brandOne,
                                              ),
                                              value: name[idx],
                                              groupValue: tvCable,
                                              onChanged: (String? value) {
                                                tvCable = value!;
                                                // Hive.box('settings')
                                                //     .put('region', region);
                                                Navigator.pop(context);
                                                setState(() {
                                                  _selectedTVCode = tvBill[idx];
                                                  tvCable = name[idx];
                                                  tvImage = image[idx];
                                                  canProceed = true;
                                                });
                                              },
                                            ),
                                            selected: tvCable == name[idx],
                                            onTap: () {
                                              _selectedTVCode = tvBill[idx];
                                              tvCable = name[idx];
                                              tvImage = image[idx];
                                              canProceed = true;

                                              Navigator.pop(
                                                context,
                                              );

                                              setState(() {});
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            onChanged: (e) {
                              // _checkFieldsAndHitApi();
                              setState(() {
                                canProceed = false;
                              });
                              tvName = "";
                            },
                            readOnly: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            enableSuggestions: true,
                            cursorColor: Theme.of(context).primaryColor,
                            style: GoogleFonts.lato(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14),

                            controller: providerController,
                            textAlignVertical: TextAlignVertical.center,
                            // textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: const UnderlineInputBorder(
                                // borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Color(0xffE0E0E0),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                // borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: brandOne, width: 2.0),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                // borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Color(0xffE0E0E0),
                                ),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                // borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0), // Change color to yellow
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  right: 8,
                                ),
                                child: CircleAvatar(
                                  radius: 14, // Adjust the radius as needed
                                  backgroundColor: Colors
                                      .transparent, // Ensure the background is transparent
                                  child: ClipOval(
                                    child: Image.asset(
                                      tvImage,
                                      width: 28,
                                      height: 28,
                                      fit: BoxFit
                                          .cover, // Ensure the image fits inside the circle
                                    ),
                                  ),
                                ),
                              ),
                              suffixIcon: Icon(
                                Iconsax.arrow_down5,
                                size: 25.h,
                                color: Theme.of(context).primaryColor,
                              ),
                              hintText: tvCable,
                              filled: false,
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.all(14),
                              hintStyle: GoogleFonts.lato(
                                color: brandOne,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 3.w),
                            child: Text(
                              'Smart Card Number',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          TextFormField(
                            enableSuggestions: true,
                            cursorColor: Theme.of(context).primaryColor,
                            controller: smartcardController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // validator: validatePhone,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (text) {
                              setState(() {
                                tvName = "";
                                // _userInput = text;
                                // _selectedCarrier = getCarrier(text);
                                // selectnetworkController.text = _selectedCarrier;
                                // print("Selected network: $_selectedCarrier");
                                isTextFieldEmpty = int.tryParse(text) != null &&
                                    !(int.tryParse(text)!.isNegative) &&
                                    int.tryParse(text.trim()) != 0 &&
                                    text.isNotEmpty;
                                // canProceed = int.tryParse(text) != null &&
                                //     !(int.tryParse(text)!.isNegative) &&
                                //     int.tryParse(text.trim()) != 0 &&
                                //     text.isNotEmpty;
                                // _checkFieldsAndHitApi();
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Smart Card Number';
                              }
                              if (!value.isNum) {
                                return 'Smart Card number must be entered in digits';
                              }
                              // if (value.length < 10) {
                              //   return 'Smart Card Number must be at least 10 Digits';
                              // }
                              if (value.length > 15) {
                                return 'Smart Card Number must be less 15 Digits';
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              _checkFieldsAndHitApi();
                            },
                            // maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            // maxLength: 11,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Color(0xffE0E0E0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: brandOne, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Color(0xffE0E0E0),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2.0), // Change color to yellow
                              ),
                              filled: false,
                              contentPadding: const EdgeInsets.all(14),
                              fillColor: brandThree,
                              hintText: 'Enter Smart Card Number',
                              hintStyle: GoogleFonts.lato(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (isChecking)
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 10.w),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  color: brandTwo.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Center(
                                      widthFactor: 0.2,
                                      child: SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: const SpinKitSpinningLines(
                                          color: brandTwo,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Text(
                                      'Verifying Smart Card Details',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        color: brandOne,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    (hasError == true || verifyAccountError != '')
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 10.w),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Flexible(
                                    // flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 10.w, left: 10.w),
                                      child: const Icon(
                                        Iconsax.close_circle5,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: Text(
                                      verifyAccountError,
                                      style: GoogleFonts.lato(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    (tvName != '')
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 10.w),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: brandTwo.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Flexible(
                                    // flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 10.w, left: 10.w),
                                      child: const Icon(
                                        Icons.verified,
                                        color: brandOne,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: Text(
                                      tvName,
                                      style: GoogleFonts.lato(
                                        color: brandOne,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: 40.h,
                    ),
                    //  Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 20, vertical: 30),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Padding(
                    //         padding: EdgeInsets.symmetric(
                    //             vertical: 3.h, horizontal: 3.w),
                    //         child: Text(
                    //           'Choose Package',
                    //           style: GoogleFonts.lato(
                    //             color: Theme.of(context).primaryColor,
                    //             fontWeight: FontWeight.w700,
                    //             fontSize: 14,
                    //           ),
                    //         ),
                    //       ),
                    //       TextFormField(
                    //         onTap: () {
                    //           showModalBottomSheet(
                    //             showDragHandle: true,
                    //             isDismissible: true,
                    //             backgroundColor: Colors.white,
                    //             context: context,
                    //             builder: (BuildContext context) {
                    //               List<String> tvBill = TVConstants.tvCodes
                    //                   .map((country) => country['code']!)
                    //                   .toList();
                    //               List<String> name = TVConstants.tvCodes
                    //                   .map((country) => country['name']!)
                    //                   .toList();
                    //               List<String> image = TVConstants.tvCodes
                    //                   .map((country) => country['image']!)
                    //                   .toList();

                    //               return Container(
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.white,
                    //                   borderRadius: BorderRadius.circular(20.0),
                    //                 ),
                    //                 child: ListView.builder(
                    //                   physics: const BouncingScrollPhysics(),
                    //                   shrinkWrap: true,
                    //                   padding: const EdgeInsets.fromLTRB(
                    //                     0,
                    //                     10,
                    //                     0,
                    //                     10,
                    //                   ),
                    //                   itemCount: name.length,
                    //                   itemBuilder: (context, idx) {
                    //                     return ListTileTheme(
                    //                       selectedColor: Theme.of(context)
                    //                           .colorScheme
                    //                           .secondary,
                    //                       child: ListTile(
                    //                         contentPadding:
                    //                             const EdgeInsets.only(
                    //                           left: 25.0,
                    //                           right: 25.0,
                    //                         ),
                    //                         title: Row(
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment.start,
                    //                           crossAxisAlignment:
                    //                               CrossAxisAlignment.start,
                    //                           children: [
                    //                             // Padding(
                    //                             //   padding:
                    //                             //       const EdgeInsets.only(
                    //                             //     right: 8,
                    //                             //   ),
                    //                             //   child: CircleAvatar(
                    //                             //     radius:
                    //                             //         20, // Adjust the radius as needed
                    //                             //     backgroundColor: Colors
                    //                             //         .transparent, // Ensure the background is transparent
                    //                             //     child: ClipOval(
                    //                             //       child: Image.asset(
                    //                             //         image[idx],
                    //                             //         width: 35,
                    //                             //         height: 35,
                    //                             //         fit: BoxFit
                    //                             //             .fitWidth, // Ensure the image fits inside the circle
                    //                             //       ),
                    //                             //     ),
                    //                             //   ),
                    //                             // ),
                    //                             const SizedBox(
                    //                               width: 8,
                    //                             ),
                    //                             SizedBox(
                    //                               width: MediaQuery.of(context)
                    //                                       .size
                    //                                       .width *
                    //                                   0.4,
                    //                               child: Text(
                    //                                 name[idx],
                    //                                 overflow:
                    //                                     TextOverflow.ellipsis,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         leading: Radio<String>(
                    //                           fillColor: MaterialStateColor
                    //                               .resolveWith(
                    //                             (states) => brandOne,
                    //                           ),
                    //                           value: name[idx],
                    //                           groupValue: tvCable,
                    //                           onChanged: (String? value) {
                    //                             tvCable = value!;
                    //                             // Hive.box('settings')
                    //                             //     .put('region', region);
                    //                             Navigator.pop(context);
                    //                             setState(() {
                    //                               _selectedTVCode = tvBill[idx];
                    //                               tvCable = name[idx];
                    //                               tvImage = image[idx];
                    //                               canProceed = true;
                    //                               print(tvName);
                    //                             });
                    //                             print(_selectedTVCode);
                    //                             print(tvName);
                    //                           },
                    //                         ),
                    //                         selected: tvCable == name[idx],
                    //                         onTap: () {
                    //                           _selectedTVCode = tvBill[idx];
                    //                           tvCable = name[idx];
                    //                           tvImage = image[idx];
                    //                           canProceed = true;

                    //                           Navigator.pop(
                    //                             context,
                    //                           );

                    //                           setState(() {});
                    //                         },
                    //                       ),
                    //                     );
                    //                   },
                    //                 ),
                    //               );
                    //             },
                    //           );
                    //         },
                    //         onChanged: (e) {
                    //           // _checkFieldsAndHitApi();
                    //           setState(() {
                    //             canProceed = false;
                    //           });
                    //           tvName = "";
                    //         },
                    //         readOnly: true,
                    //         autovalidateMode:
                    //             AutovalidateMode.onUserInteraction,
                    //         enableSuggestions: true,
                    //         cursorColor: Theme.of(context).primaryColor,
                    //         style: GoogleFonts.lato(
                    //             color: Theme.of(context).primaryColor,
                    //             fontSize: 14),

                    //         controller: providerController,
                    //         textAlignVertical: TextAlignVertical.center,
                    //         // textCapitalization: TextCapitalization.sentences,
                    //         keyboardType: TextInputType.emailAddress,
                    //         decoration: InputDecoration(
                    //           border: const UnderlineInputBorder(
                    //             // borderRadius: BorderRadius.circular(15.0),
                    //             borderSide: BorderSide(
                    //               color: Color(0xffE0E0E0),
                    //             ),
                    //           ),
                    //           focusedBorder: const UnderlineInputBorder(
                    //             // borderRadius: BorderRadius.circular(15),
                    //             borderSide:
                    //                 BorderSide(color: brandOne, width: 2.0),
                    //           ),
                    //           enabledBorder: const UnderlineInputBorder(
                    //             // borderRadius: BorderRadius.circular(15),
                    //             borderSide: BorderSide(
                    //               color: Color(0xffE0E0E0),
                    //             ),
                    //           ),
                    //           errorBorder: const UnderlineInputBorder(
                    //             // borderRadius: BorderRadius.circular(15),
                    //             borderSide: BorderSide(
                    //                 color: Colors.red,
                    //                 width: 2.0), // Change color to yellow
                    //           ),
                    //           // prefixIcon: Padding(
                    //           //   padding: const EdgeInsets.only(
                    //           //     right: 8,
                    //           //   ),
                    //           //   child: CircleAvatar(
                    //           //     radius: 14, // Adjust the radius as needed
                    //           //     backgroundColor: Colors
                    //           //         .transparent, // Ensure the background is transparent
                    //           //     child: ClipOval(
                    //           //       child: Image.asset(
                    //           //         tvImage,
                    //           //         width: 28,
                    //           //         height: 28,
                    //           //         fit: BoxFit
                    //           //             .cover, // Ensure the image fits inside the circle
                    //           //       ),
                    //           //     ),
                    //           //   ),
                    //           // ),
                    //           suffixIcon: Icon(
                    //             Iconsax.arrow_right,
                    //             size: 25.h,
                    //             color: Theme.of(context).primaryColor,
                    //           ),
                    //           hintText: tvCable,
                    //           filled: false,
                    //           fillColor: Colors.transparent,
                    //           contentPadding: EdgeInsets.all(14),
                    //           hintStyle: GoogleFonts.lato(
                    //             color: brandOne,
                    //             fontSize: 12,
                    //             fontWeight: FontWeight.w700,
                    //           ),
                    //         ),
                    //         maxLines: 1,
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    SizedBox(
                      height: 20.h,
                    ),

                    Visibility(
                      visible: tvName == '',
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(250, 50),
                              backgroundColor: brandOne,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (tvFormKey.currentState!.validate()) {
                                // _doSomething();
                                // Get.to(ConfirmTransactionPinPage(
                                //     pin: _pinController.text.trim()));
                                FocusScope.of(context).unfocus();
                                _checkFieldsAndHitApi();
                                // validateUsersInput();
                              }
                            },
                            child: const Text(
                              'Check',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: tvName != '',
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(250, 50),
                              backgroundColor: brandOne,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (tvFormKey.currentState!.validate() &&
                                  tvName != '') {
                                // _doSomething();
                                // Get.to(ConfirmTransactionPinPage(
                                //     pin: _pinController.text.trim()));
                                FocusScope.of(context).unfocus();
                                validateUsersInput();
                                // validateUsersInput();
                              }
                            },
                            child: const Text(
                              'Proceed',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
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
