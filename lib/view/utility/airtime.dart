import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/controller/app_controller.dart';

import '../../controller/auth/user_controller.dart';

class AirtimePage extends ConsumerStatefulWidget {
  const AirtimePage({super.key});

  @override
  ConsumerState<AirtimePage> createState() => _AirtimePageState();
}

var ch8t = NumberFormat.simpleCurrency(name: 'NGN');

class _AirtimePageState extends ConsumerState<AirtimePage> {
  final UserController userController = Get.find();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController selectnetworkController = TextEditingController();
  final TextEditingController _aPinController = TextEditingController();
  final AirtimeformKey = GlobalKey<FormState>();
  List<String> networkCarrier = const <String>[
    'Select Network',
    'MTN',
    'Glo',
    'Airtel',
    '9mobile',
  ];
  List<String> networkImages = const <String>[
    'assets/utility/mtn.jpg',
    "assets/utility/airtel.jpg",
    "assets/utility/glo.jpg",
    "assets/utility/9mobile.jpg",
  ];

  String _selectedCarrier = 'Select Network';
  String _selectedImage = 'assets/utility/mtn.jpg';
  String billType = '';
  String _userInput = '';

  bool showInvalidAmountAlert = false;
  bool showInvalidRecipientNumberAlert = false;

  void validateUsersInput() {
    if (AirtimeformKey.currentState!.validate()) {
      int amount = int.parse(amountController.text);
      String number = recipientController.text;
      String bill = billType;
      String biller = _selectedCarrier;

      confirmPayment(context, amount, number, bill, biller);
    }
  }

  String getCurrency() {
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return format.currencySymbol;
  }

  void detectCarrier() {
    String phoneNumber = recipientController.text;

    if (isValidPhoneNumber(phoneNumber)) {
      String detectedCarrier = getCarrier(phoneNumber);
      setState(() {
        _selectedCarrier = detectedCarrier;
      });
      print(_selectedCarrier);
      print(detectedCarrier);
      if (detectedCarrier == 'MTN') {
        setState(() {
          _selectedImage = 'assets/utility/mtn.jpg';
        });
      } else if ((detectedCarrier == 'Glo')) {
        setState(() {
          _selectedImage = "assets/utility/glo.jpg";
        });
      } else if ((detectedCarrier == '9mobile')) {
        setState(() {
          _selectedImage = "assets/utility/9mobile.jpg";
        });
      } else if ((detectedCarrier == 'Airtel')) {
        setState(() {
          _selectedImage = "assets/utility/airtel.jpg";
        });
      } else {
        _selectedImage = '';
      }
    } else {
      customErrorDialog(context, "Invalid", 'Invalid Recipient Number');
    }
  }

  String getCarrier(String phoneNumber) {
    if (phoneNumber.length < 4) {
      return "Select Network";
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
      return 'Glo';
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
      return 'Airtel';
    } else if (prefix == '0809' ||
        prefix == '0909' ||
        prefix == '0908' ||
        prefix == '0817' ||
        prefix == '0818') {
      return '9mobile';
    }

    return "Select Network";
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
    recipientController.addListener(() {
      setState(() {
        _selectedCarrier = getCarrier(recipientController.text);
        selectnetworkController.text = _selectedCarrier;
      });
    });
  }

  bool isTextFieldEmpty = false;

  String displayedAmount = '';
  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appControllerProvider.notifier);
    final selectNetworkCarrier = CustomDropdown(
      selectedStyle: GoogleFonts.nunito(
          color: Theme.of(context).primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500),
      items: networkCarrier,
      excludeSelected: true,
      hintText: 'Select Network',
      fillColor: Colors.transparent,
      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      fieldSuffixIcon: Icon(
        Iconsax.arrow_down5,
        size: 25.h,
        color: Theme.of(context).primaryColor,
      ),
      // fieldSuffixIcon: getNetworkImage(_selectedCarrier),
      onChanged: (value) {
        setState(() {
          _selectedCarrier = value;
          selectnetworkController.text = _selectedCarrier;
        });
        if (_selectedCarrier == 'MTN') {
          setState(() {
            billType = 'bill-25';
            _selectedImage = 'assets/utility/mtn.jpg';
          });
        } else if ((_selectedCarrier == 'Glo')) {
          setState(() {
            billType = 'bill-27';
            _selectedImage = "assets/utility/glo.jpg";
          });
        } else if ((_selectedCarrier == '9mobile')) {
          setState(() {
            billType = 'bill-26';
            _selectedImage = "assets/utility/9mobile.jpg";
          });
        } else if ((_selectedCarrier == 'Airtel')) {
          setState(() {
            billType = 'bill-28';
            _selectedImage = "assets/utility/airtel.jpg";
          });
        } else {
          billType = '';
          _selectedImage = 'assets/utility/mtn.jpg';
        }
      },
      controller: selectnetworkController,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_sharp,
              size: 30, color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
        title: Text(
          'Airtime',
          style: GoogleFonts.nunito(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              'History',
              style: GoogleFonts.nunito(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.h),
          child: Stack(
            children: [
              Form(
                key: AirtimeformKey,
                child: Column(
                  children: [
                    selectNetworkCarrier,
                    SizedBox(
                      height: 13.h,
                    ),
                    TextFormField(
                      enableSuggestions: true,
                      cursorColor: Theme.of(context).primaryColor,
                      controller: recipientController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // validator: validatePhone,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        setState(() {
                          _userInput = text;
                          _selectedCarrier = getCarrier(text);
                          selectnetworkController.text = _selectedCarrier;
                          print("Selected network: $_selectedCarrier");
                        });
                        if (_selectedCarrier == 'MTN') {
                          setState(() {
                            billType = 'bill-25';
                            _selectedImage = 'assets/utility/mtn.jpg';
                          });
                        } else if ((_selectedCarrier == 'Glo')) {
                          setState(() {
                            billType = 'bill-27';
                            _selectedImage = "assets/utility/glo.jpg";
                          });
                        } else if ((_selectedCarrier == '9mobile')) {
                          setState(() {
                            billType = 'bill-26';
                            _selectedImage = "assets/utility/9mobile.jpg";
                          });
                        } else if ((_selectedCarrier == 'Airtel')) {
                          setState(() {
                            billType = 'bill-28';
                            _selectedImage = "assets/utility/airtel.jpg";
                          });
                        } else {
                          billType = '';
                          _selectedImage = 'assets/utility/mtn.jpg';
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
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color(0xffE0E0E0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: brandOne, width: 2.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xffE0E0E0),
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.0), // Change color to yellow
                        ),
                        filled: false,
                        contentPadding: const EdgeInsets.all(14),
                        fillColor: brandThree,
                        hintText: '0XX XXX XXXX',
                        hintStyle: GoogleFonts.nunito(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.asset(
                              _selectedImage,
                              height: 10.0,
                              width: 10.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // CustomTextField(
                    //   hintText: '0XX XXX XXXX',
                    //   labelText: 'Recipient Number',
                    //   keyboardType: TextInputType.number,
                    //   controller: recipientController,
                    //   onChanged: (text) {
                    //     setState(() {
                    //       _userInput = text;
                    //       _selectedCarrier = getCarrier(text);
                    //       selectnetworkController.text = _selectedCarrier;
                    //       print("Selected network: $_selectedCarrier");
                    //     });
                    //   },
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Enter Recipient Number';
                    //     }
                    //     if (value.length != 11) {
                    //       return 'Recipient Number must be 11 Digit';
                    //     }
                    //     return null;
                    //   },
                    //   // icon: GestureDetector(
                    //   //   onTap: () {
                    //   //     // Navigator.pushNamed(
                    //   //     //     context, RouteList.users_contact);
                    //   //   },
                    //   //   child: Icon(
                    //   //     Icons.contacts,
                    //   //     color: backgroundColor,
                    //   //   ),
                    //   // ),
                    // ),

                    SizedBox(
                      height: 13.h,
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: brandTwo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(11.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 8.h,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Top up',
                                style: GoogleFonts.nunito(
                                  color: brandOne,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.baseline,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildAmountButton(50),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    buildAmountButton(500),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildAmountButton(100),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    buildAmountButton(1000),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildAmountButton(200),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    buildAmountButton(2000),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            TextFormField(
                              enableSuggestions: true,
                              cursorColor: Theme.of(context).primaryColor,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: amountController,
                              onChanged: (value) {
                                // Enter_Transaction_Pin.of(context)
                                //     .updateDisplayedcurrentAmount(value);
                                setState(() {
                                  print("Entered Amount: $value");
                                  // Check if the text field is empty
                                  displayedAmount = value;
                                  isTextFieldEmpty = value.isNotEmpty &&
                                      int.tryParse(value) != null &&
                                      int.parse(value) >= 50;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter Amount',
                                filled: false,
                                fillColor: brandThree,
                                errorStyle: GoogleFonts.nunito(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                                // hintStyle: GoogleFonts.nunito(
                                //   color: Colors.grey,
                                //   fontSize: 12,
                                //   fontWeight: FontWeight.w400,
                                // ),
                                contentPadding: EdgeInsets.all(14.sp),
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                    color: brandOne,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: brandOne, width: 2.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: brandOne,
                                  ),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 2.0), // Change color to yellow
                                ),
                                prefixText: "₦  ",
                                prefixStyle: GoogleFonts.nunito(
                                  color: brandOne,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Amount';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                if (int.tryParse(value)! < 50) {
                                  return 'Amount cannot be less than 50 naira';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isTextFieldEmpty,
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
                      onPressed: () {
                        if (AirtimeformKey.currentState!.validate()) {
                          // _doSomething();
                          // Get.to(ConfirmTransactionPinPage(
                          //     pin: _pinController.text.trim()));
                          validateUsersInput();
                        } else {
                          customErrorDialog(context, "Invalid!",
                              "Please Input your pin to proceed");
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
        height: 70.h,
        decoration: BoxDecoration(
          color: brandTwo.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              '₦$amount',
              style: GoogleFonts.nunito(
                color: brandOne,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> confirmPayment(BuildContext context, int amount, String number,
      String bill, String biller) async {
    final appState = ref.watch(appControllerProvider.notifier);
    validatePinOne(pinOneValue) {
      if (pinOneValue.isEmpty) {
        return 'pin cannot be empty';
      }
      if (pinOneValue.length < 4) {
        return 'pin is incomplete';
      }
      if (int.tryParse(pinOneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    print(bill);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          alignment: Alignment.bottomCenter,
          insetPadding: const EdgeInsets.all(0),
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              ch8t.format(amount),
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                color: brandOne,
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(20.0.r),
              borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          )),
          content: SizedBox(
            height: 300.h,
            // width: 390.h,
            child: Container(
              width: 400.w,
              child: Column(
                children: [
                  Stack(children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     //  resendVerification(context, '', subText)
                    //     Navigator.pop(context);
                    //   },
                    //   child: Align(
                    //     alignment: Alignment.topRight,
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(30),
                    //         color: Colors.white,
                    //       ),
                    //       child: const Padding(
                    //         padding: EdgeInsets.all(10),
                    //         child: Icon(
                    //           Iconsax.close_circle,
                    //           color: brandOne,
                    //           size: 30,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        // decoration: BoxDecoration(
                        //   color: brandTwo,
                        //   borderRadius: BorderRadius.circular(16.r),
                        // ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: 15.h),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Provider Network',
                                    style: GoogleFonts.nunito(
                                      color: brandOne,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        _selectedCarrier,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.nunito(
                                          color: brandOne,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 9.w,
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        child: Image.asset(
                                          _selectedImage,
                                          height: 39.0,
                                          width: 39.0,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 11.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Amount',
                                    style: GoogleFonts.nunito(
                                      color: brandOne,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    ch8t.format(amount),
                                    style: GoogleFonts.nunito(
                                      color: brandOne,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 11.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Reicpient Number',
                                    style: GoogleFonts.nunito(
                                      color: brandOne,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$number',
                                    style: GoogleFonts.nunito(
                                      color: brandOne,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payment Method',
                                    style: GoogleFonts.nunito(
                                      color: brandOne,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Space Wallet',
                                        style: GoogleFonts.nunito(
                                          color: brandOne,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        ch8t.format(userController
                                            .userModel!
                                            .userDetails![0]
                                            .wallet
                                            .mainBalance),
                                        style: GoogleFonts.nunito(
                                          color: brandOne,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 35.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                 
                                  Get.bottomSheet(
                                    isDismissible: true,
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 350,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0),
                                        ),
                                        child: Container(
                                          color: Theme.of(context).canvasColor,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              Text(
                                                'Enter PIN to Proceed',
                                                style: GoogleFonts.nunito(
                                                    fontSize: 18,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.w800),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Pinput(
                                                obscureText: true,
                                                defaultPinTheme: PinTheme(
                                                  width: 50,
                                                  height: 50,
                                                  textStyle: const TextStyle(
                                                    fontSize: 20,
                                                    color: brandOne,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: brandTwo,
                                                        width: 1.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                onCompleted: (String val) {
                                                  if (BCrypt.checkpw(
                                                    _aPinController.text
                                                        .trim()
                                                        .toString(),
                                                    userController
                                                        .userModel!
                                                        .userDetails![0]
                                                        .wallet
                                                        .pin,
                                                  )) {
                                                    _aPinController.clear();
                                                    Get.back();
                                                    // _doWallet();
                                                    appState.buyAirtime(
                                                        context,
                                                        amount,
                                                        number.toString(),
                                                        bill,
                                                        biller);
                                                  } else {
                                                    _aPinController.clear();
                                                    if (context.mounted) {
                                                      customErrorDialog(
                                                          context,
                                                          "Invalid PIN",
                                                          'Enter correct PIN to proceed');
                                                    }
                                                  }
                                                },
                                                validator: validatePinOne,
                                                onChanged: validatePinOne,
                                                controller: _aPinController,
                                                length: 4,
                                                closeKeyboardWhenCompleted:
                                                    true,
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize:
                                                      const Size(300, 50),
                                                  backgroundColor: brandOne,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (BCrypt.checkpw(
                                                    _aPinController.text
                                                        .trim()
                                                        .toString(),
                                                    userController
                                                        .userModel!
                                                        .userDetails![0]
                                                        .wallet
                                                        .pin,
                                                  )) {
                                                    _aPinController.clear();
                                                    Get.back();
                                                    // _doWallet();
                                                    appState.buyAirtime(
                                                        context,
                                                        amount,
                                                        number.toString(),
                                                        bill,
                                                        biller);
                                                  } else {
                                                    _aPinController.clear();
                                                    if (context.mounted) {
                                                      customErrorDialog(
                                                          context,
                                                          "Invalid PIN",
                                                          'Enter correct PIN to proceed');
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  'Proceed to Payment',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.nunito(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: brandOne,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(13),
                                    child: Align(
                                      child: Text(
                                        'Pay',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.nunito(
                                          color: Colors.white,
                                          fontSize: 19.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
