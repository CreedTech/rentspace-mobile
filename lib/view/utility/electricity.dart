import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/electricity_constants.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../constants/colors.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/wallet_controller.dart';
import 'electricity_payment_page.dart';
import 'package:http/http.dart' as http;

class Electricity extends StatefulWidget {
  const Electricity({super.key});

  @override
  State<Electricity> createState() => _ElectricityState();
}

class _ElectricityState extends State<Electricity> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController providerController = TextEditingController();
  final TextEditingController meterController = TextEditingController();
  final electricityFormKey = GlobalKey<FormState>();
  String _selectedElectricCode = 'bill-11';
  String electricity = 'Ikeja Electric';
  String electricityImage = 'assets/utility/7.jpg';
  String electricityDescription =
      'Areas in Lagos covered by Ikeja Electricity Distribution Company (IKEDC) inlcude Abule Egba, Akowonjo, Ikeja, Ikorodu, Oshodi & Shomolu.';
  String electricityName = '';
  String minmumPayment = '500';
  String meterNumber = '';
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
      _message = 'Verifying Meter Details';
      verifyAccountError = "";
      hasError = false;
      electricityName = "";
    }
  }

  verifyMeter(String currentCode) async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    setState(() {
      isChecking = true;
      electricityName = "";
      verifyAccountError = "";
      hasError = false;
      canProceed = false;
    });
    final response = await http.post(
        Uri.parse(AppConstants.BASE_URL + AppConstants.VERIFY_METER),
        headers: {
          'Authorization': 'Bearer $authToken',
          "Content-Type": "application/json"
        },
        body: json.encode({
          "billingServiceID": _selectedElectricCode,
          "meterNumber": meterController.text.trim().toString()
        }));

    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final meterInfo = jsonResponse['customerName'];
      final amount = jsonResponse['minimum_amount'];
      if (meterInfo != null && meterInfo != 'NA') {
        setState(() {
          electricityName = meterInfo;
          isChecking = false;
          hasError = false;
          canProceed = true;
          minmumPayment = amount.toString();
        });
        _updateMessage();
      } else {
        // Error handling
        setState(() {
          electricityName = "";
          isChecking = false;
          hasError = true;
          verifyAccountError =
              'Meter Validation failed. Please check the digits and try again';
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
        electricityName = "";
        isChecking = false;
        hasError = true;
        verifyAccountError =
            'Meter Validation failed. Please check the digits and try again';
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
    if (electricityFormKey.currentState!.validate()) {
      verifyMeter(_selectedElectricCode);
    }
  }

  @override
  void dispose() {
    super.dispose();
    meterController.dispose();
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
          'Electricity - Prepaid',
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
                key: electricityFormKey,
                child: Column(
                  children: [
                    // CustomDropdown(
                    //   selectedStyle: GoogleFonts.lato(
                    //       color: Theme.of(context).primaryColor,
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w500),
                    //   items: ElectriciryConstants,
                    //   excludeSelected: true,
                    //   hintText: 'Select Network',
                    //   fillColor: Colors.transparent,
                    //   borderSide: BorderSide(
                    //       color: Theme.of(context).primaryColor, width: 2),
                    //   fieldSuffixIcon: Icon(
                    //     Iconsax.arrow_down5,
                    //     size: 25.h,
                    //     color: Theme.of(context).primaryColor,
                    //   ),
                    //   // fieldSuffixIcon: getNetworkImage(_selectedCarrier),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _selectedElectricCode = electricBill[idx];
                    //       electricityName = name[idx];
                    //       electricityImage = image[idx];
                    //       electricityDescription = description[idx];
                    //       print(electricityName);
                    //     });
                    //   },
                    //   controller: providerController,
                    // ),

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
                                isDismissible: true,
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (BuildContext context) {
                                  List<String> electricBill =
                                      ElectriciryConstants.electirictyCodes
                                          .map((country) => country['code']!)
                                          .toList();
                                  List<String> name = ElectriciryConstants
                                      .electirictyCodes
                                      .map((country) => country['name']!)
                                      .toList();
                                  List<String> image = ElectriciryConstants
                                      .electirictyCodes
                                      .map((country) => country['image']!)
                                      .toList();
                                  List<String> description =
                                      ElectriciryConstants.electirictyCodes
                                          .map((country) =>
                                              country['description']!)
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
                                              groupValue: electricity,
                                              onChanged: (String? value) {
                                                electricity = value!;
                                                // Hive.box('settings')
                                                //     .put('region', region);
                                                Navigator.pop(context);
                                                setState(() {
                                                  _selectedElectricCode =
                                                      electricBill[idx];
                                                  electricity = name[idx];
                                                  electricityImage = image[idx];
                                                  electricityDescription =
                                                      description[idx];
                                                  canProceed = true;
                                                });
                                              },
                                            ),
                                            selected: electricity == name[idx],
                                            onTap: () {
                                              _selectedElectricCode =
                                                  electricBill[idx];
                                              electricity = name[idx];
                                              electricityImage = image[idx];
                                              electricityDescription =
                                                  description[idx];
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
                              electricityName = "";
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
                                      electricityImage,
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
                              hintText: electricity,
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
                              'Meter Number',
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
                            controller: meterController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // validator: validatePhone,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (text) {
                              setState(() {
                                electricityName = "";
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
                                return 'Enter Meter Number';
                              }
                              if (!value.isNum) {
                                return 'Meter number must be entered in digits';
                              }
                              // if (value.length < 10) {
                              //   return 'Meter Number must be at least 10 Digits';
                              // }
                              if (value.length > 15) {
                                return 'Meter Number must be less 15 Digits';
                              }
                              return null;
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
                              hintText: 'Enter Meter Number',
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
                                      'Verifying Meter Details',
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
                    (electricityName != '')
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
                                      electricityName,
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
                    SizedBox(
                      height: 20.h,
                    ),
                    Visibility(
                      visible: electricityName == '',
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
                              if (electricityFormKey.currentState!.validate()) {
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
                      visible: electricityName != '',
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
                              if (electricityFormKey.currentState!.validate() &&
                                  electricityName != '') {
                                // _doSomething();
                                // Get.to(ConfirmTransactionPinPage(
                                //     pin: _pinController.text.trim()));
                                FocusScope.of(context).unfocus();
                                await fetchUserData()
                                    .then(
                                      (value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ElectricityPaymentPage(
                                            electricity: electricity,
                                            electricityCode:
                                                _selectedElectricCode,
                                            electricityImage: electricityImage,
                                            electricityName: electricityName,
                                            electricityDescription:
                                                electricityDescription,
                                            minmumAmount: minmumPayment.trim(),
                                            meterNumber:
                                                meterController.text.trim(),
                                          ),
                                        ),
                                      ),
                                    )
                                    .catchError(
                                      (error) => {
                                        customErrorDialog(context, 'Oops',
                                            'Something went wrong. Try again later'),
                                      },
                                    );
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
