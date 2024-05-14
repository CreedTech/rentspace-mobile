import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/constants.dart';
import 'package:rentspace/view/utility/data_list.dart';
// import 'package:swift/utils/image_asset/assets.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/wallet_controller.dart';

class DataBundleScreen extends StatefulWidget {
  const DataBundleScreen({super.key});

  @override
  State<DataBundleScreen> createState() => _DataBundleScreenState();
}

var ch8t = NumberFormat.simpleCurrency(name: 'N');

class _DataBundleScreenState extends State<DataBundleScreen> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController selectuserdataplansController =
      TextEditingController();
  final TextEditingController selectnetworkController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController selectplanmodelsubController =
      TextEditingController();
  final TextEditingController selectnetworkproviderController =
      TextEditingController();
  final DataBundleFormKey = GlobalKey<FormState>();
  String? _selectedData;

  List<String> SelectSubscription = const <String>[
    'Data Bundle',
    'Internet Subscription',
  ];

  List<String> networkCarrier = const <String>[
    'Select Network',
    'MTN',
    'Glo',
    'Airtel',
    '9mobile',
  ];

  List<String> UserSelectDataPlans = const <String>[
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
  // bool showInvalidRecipientNumberAlert = false;
  String _userInput = '';

  void validateUsersInput() {
    if (DataBundleFormKey.currentState!.validate()) {
      Get.to(DataListScreen(
          number: recipientController.text.trim(),
          network: _selectedCarrier.trim(),
          image: _selectedImage));
      // int amount = int.parse(amountController.text);
      // String number = recipientController.text;
      // String bill = billType;
      // String biller = _selectedCarrier;

      // confirmPayment(context, amount, number, bill, biller);
    }
  }

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
        _selectedImage = 'assets/utility/mtn.jpg';
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

  @override
  void initState() {
    super.initState();
    fetchUserData();
    recipientController.addListener(() {
      setState(() {
        _selectedCarrier = getCarrier(recipientController.text);
        selectnetworkController.text = _selectedCarrier;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    selectuserdataplansController.dispose();
    selectnetworkController.dispose();
    selectnetworkproviderController.dispose();
    recipientController.dispose();
    selectplanmodelsubController.dispose();
  }

  bool isTextFieldEmpty = false;

  String displayedAmount = '';

  bool showSelectModelDropdown = false;

  bool showInvalidAmountAlert = false;

  @override
  Widget build(BuildContext context) {
    final selectNetworkCarrier = CustomDropdown(
      selectedStyle: GoogleFonts.lato(
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
          // recipientController.clear();
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
          billType = 'MTN';
          _selectedImage = 'assets/utility/mtn.jpg';
        }
      },
      controller: selectnetworkController,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
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
          'Buy Data',
          style: GoogleFonts.lato(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.h),
          child: ListView(
            children: [
              Stack(
                children: [
                  Form(
                    key: DataBundleFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 13.h,
                        ),
                        Text(
                          'Enter receiver\'s phone number to buy data instantly.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 13.h,
                        ),
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
                              isTextFieldEmpty =
                                  text.isNotEmpty && text.length == 11;
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
                            hintStyle: GoogleFonts.lato(
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
                        SizedBox(
                          height: 13.h,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        SizedBox(
                          height: 50.h,
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
                                onPressed: () async {
                                  if (DataBundleFormKey.currentState!
                                      .validate()) {
                                    // _doSomething();
                                    // Get.to(ConfirmTransactionPinPage(
                                    //     pin: _pinController.text.trim()));
                                    FocusScope.of(context).unfocus();
                                    // await fetchUserData()
                                    //     .then((value) => validateUsersInput())
                                    //     .catchError(
                                    //       (error) => {
                                    //         EasyLoading.dismiss(),
                                    //         customErrorDialog(context, 'Oops',
                                    //             'Something went wrong. Try again later'),
                                    //       },
                                    //     );
                                    validateUsersInput();
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
            ],
          ),
        ),
      ),
    );
  }
}
