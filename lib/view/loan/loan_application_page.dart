// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:pinput/pinput.dart';
import 'package:rentspace/model/loan_form_model.dart';
import 'package:rentspace/view/loan/loan_application_page_continuation.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../constants/bank_constants.dart';
import '../../constants/colors.dart';
import '../../constants/utils/clean_image.dart';
import '../../constants/utils/formatPhoneNumber.dart';
import '../../widgets/custom_loader.dart';
import '../../controller/rent/rent_controller.dart';
import 'package:http/http.dart' as http;

class LoanApplicationPage extends StatefulWidget {
  const LoanApplicationPage({super.key, required this.current});
  final int current;

  @override
  State<LoanApplicationPage> createState() => _LoanApplicationPageState();
}

class _LoanApplicationPageState extends State<LoanApplicationPage> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _idSelectController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _bvnController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _houseAddressController = TextEditingController();
  final TextEditingController _utilityBillController = TextEditingController();
  final TextEditingController _landLordOrAgentController =
      TextEditingController();
  final TextEditingController _landlordNameController = TextEditingController();
  final TextEditingController _samePropertyController = TextEditingController();
  final TextEditingController _landlordAddressController =
      TextEditingController();
  final TextEditingController _landlordPhoneNumberController =
      TextEditingController();
  final TextEditingController _landlordAccountNumberController =
      TextEditingController();
  final TextEditingController _landlordBankController = TextEditingController();
  // final TextEditingController _currentAddressDurationController =
  //     TextEditingController();
  final TextEditingController _propertyTypesController =
      TextEditingController();
  var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 0);
  final RentController rentController = Get.find();
  final loanFormKey = GlobalKey<FormState>();
  List<String> idTypes = ['Passport', 'Voter ID', 'Driver License ', 'NIN'];
  List<String> landordOrAgentTypes = ['Landlord', 'Agent'];
  List<String> samePropertyResponse = ['Yes', 'No'];
  List<String> propertyTypes = ['Residential', 'Commercial'];
  String? selectedId;
  bool isLandlordOrAgentSelected = false;
  bool idSelected = false;

  bool isDeviceConnected = false;
  bool isAlertSet = false;
  late StreamSubscription subscription;
  bool hasError = false;
  String _bankAccountName = "";
  bool isChecking = false;
  String verifyAccountError = "";
  String? selectedBankName;
  String? selectedBankCode;
  List<String> filteredBanks = [];
  List<MapEntry<String, String>> bankEntries = [];
  List<MapEntry<String, String>> filteredBankEntries = [];
  // late int genderValue;

  void _loadFormData() async {
    var box = await Hive.openBox<LoanFormData>('formDataBox');
    var formData = box.get('loanFormData');
    if (formData != null) {
      setState(() {
        _reasonController.text = formData.reason ?? '';
        _idSelectController.text = formData.id ?? '';
        _idNumberController.text = formData.idNumber ?? '';
        _bvnController.text = formData.bvn ?? '';
        _utilityBillController.text = formData.bill ?? '';
        _phoneNumberController.text = formData.phoneNumber ?? '';
        _houseAddressController.text = formData.houseAddress ?? '';
        _landLordOrAgentController.text = formData.landlordOrAgent ?? '';
        _landlordNameController.text = formData.landlordOrAgentName ?? '';
        // _landlordAddressController.text = formData.landlordOrAgentAddress ?? '';
        _landlordPhoneNumberController.text =
            formData.landlordOrAgentNumber ?? '';
        _landlordAccountNumberController.text =
            formData.landlordAccountNumber ?? '';
        _landlordBankController.text = formData.landlordBankName ?? '';
        _propertyTypesController.text = formData.propertyType ?? '';
        // _currentAddressDurationController.text = formData.howLong ?? '';
        _samePropertyController.text = formData.sameProperty ?? '';
      });
      if (_landLordOrAgentController.text != '') {
        setState(() {
          isLandlordOrAgentSelected = true;
        });
      }
      if (_idSelectController.text != '') {
        setState(() {
          idSelected = true;
        });
      }
    }
  }

  Future<void> _saveFormData() async {
    if (loanFormKey.currentState!.validate()) {
      EasyLoading.show(
        indicator: const CustomLoader(),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      var box = await Hive.openBox<LoanFormData>('formDataBox');
      var formData = LoanFormData()
        ..reason = _reasonController.text
        ..id = _idSelectController.text
        ..idNumber = _idNumberController.text
        ..bvn = _bvnController.text
        ..bill = _utilityBillController.text
        ..phoneNumber = _phoneNumberController.text
        ..houseAddress = _houseAddressController.text
        ..landlordOrAgent = _landLordOrAgentController.text
        ..landlordOrAgentName = _landlordNameController.text
        // ..landlordOrAgentAddress = _landlordAddressController.text
        ..landlordOrAgentNumber = _landlordPhoneNumberController.text
        ..landlordAccountNumber = _landlordAccountNumberController.text
        ..landlordBankName = _landlordBankController.text
        ..propertyType = _propertyTypesController.text
        // ..howLong = _currentAddressDurationController.text
        ..sameProperty = _samePropertyController.text;
      box.put('loanFormData', formData);

      EasyLoading.dismiss();
    }
  }

  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void _updateMessage() {
    if (isChecking) {
      // If checking, display loader message
      verifyAccountError = "";
      hasError = false;
      _bankAccountName = "";
    }
  }

  getAccountDetails(String currentCode) async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();

    setState(() {
      isChecking = true;
      _bankAccountName = "";
      verifyAccountError = "";
      hasError = false;
    });
    final response = await http.post(
        Uri.parse(
            AppConstants.BASE_URL + AppConstants.PROVIDUS_GET_NIP_ACCOUNT_INFO),
        headers: {
          'Authorization': 'Bearer $authToken',
          "Content-Type": "application/json"
        },
        body: json.encode({
          "beneficiaryBank": currentCode,
          "accountNumber":
              _landlordAccountNumberController.text.trim().toString()
        }));

    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final userBankName = jsonResponse['accountName'];

      if (userBankName != null && userBankName != 'NA') {
        setState(() {
          _bankAccountName = userBankName;
          isChecking = false;
          hasError = false;
        });
        _updateMessage();
      } else {
        // Error handling
        setState(() {
          _bankAccountName = "";
          isChecking = false;
          hasError = true;
          verifyAccountError =
              'Account verification failed. Please check the details and try again';
        });
      }
    } else {
      // Error handling
      setState(() {
        _bankAccountName = "";
        isChecking = false;
        hasError = false;
        verifyAccountError =
            "Account verification failed. Please check the details and try again";
      });
      _updateMessage();

      if (kDebugMode) {
        print(
            'Request failed with status: ${response.statusCode}, ${response.body}');
      }
    }
  }

  void _checkFieldsAndHitApi() {
    // print(_landlordAccountNumberController.text.length == 11);
    if (_landlordAccountNumberController.text.isNotEmpty &&
        _landlordAccountNumberController.text.length == 10 &&
        selectedBankName != null) {
      getAccountDetails(selectedBankCode!);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFormData();
    // _searchController.addListener(_onSearchChanged);
    bankEntries = BankConstants.bankData.entries.toList();

    filteredBankEntries = bankEntries;
  }

  void getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && !isAlertSet) {
          if (mounted) {
            noInternetConnectionScreen(context);
          }
          setState(() => isAlertSet = true);
        }
      },
    );
  }

  noInternetConnectionScreen(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
            elevation: 0.0,
            alignment: Alignment.bottomCenter,
            insetPadding: const EdgeInsets.all(0),
            title: null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            content: SizedBox(
              height: 170.h,
              child: Container(
                width: 400.w,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Text(
                      'No internet Connection',
                      style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "Uh-oh! It looks like you're not connected. Please check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(MediaQuery.of(context).size.width - 50, 50),
                          backgroundColor: brandTwo,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          // EasyLoading.dismiss();
                          setState(() => isAlertSet = false);
                          isDeviceConnected =
                              await InternetConnectionChecker().hasConnection;
                          if (!isDeviceConnected && isAlertSet == false) {
                            // showDialogBox();
                            noInternetConnectionScreen(context);
                            setState(() => isAlertSet = true);
                          }
                        },
                        child: Text(
                          "Try Again",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    validateReason(lastValue) {
      if (lastValue.isEmpty) {
        return 'Reason cannot be blank';
      }

      return null;
    }

    validateId(lastValue) {
      if (lastValue.isEmpty) {
        return 'ID cannot be empty';
      }
      if (int.tryParse(lastValue) == null) {
        return 'enter valid ID';
      }
    }

    validateIdSelect(lastValue) {
      if (lastValue.isEmpty) {
        return 'You have to select an ID';
      }

      return null;
    }

    validateBvn(bvnValue) {
      if (bvnValue.isEmpty) {
        return 'BVN cannot be empty';
      }
      if (bvnValue.length < 11) {
        return 'BVN is invalid';
      }
      if (bvnValue.length > 11) {
        return 'BVN can not be more than 11 digits';
      }
      if (int.tryParse(bvnValue) == null) {
        return 'enter valid BVN';
      }
      return null;
    }

    validatePhone(phoneValue) {
      if (phoneValue.isEmpty) {
        return 'phone number cannot be empty';
      }
      if (phoneValue.length < 11) {
        return 'phone number is invalid';
      }
      if (int.tryParse(phoneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    validateAddress(lastValue) {
      if (lastValue.isEmpty) {
        return 'Address cannot be empty';
      }
      return null;
    }

    validateBill(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please select an image';
      }
      return null;
    }

    validateLandlordOrAgent(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please select one';
      }
      return null;
    }

    validateLandlordName(lastValue) {
      if (lastValue.isEmpty) {
        return 'Enter full name';
      }
      return null;
    }

    validateSameProperty(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please select one';
      }
      return null;
    }

    validateLandlordAddress(lastValue) {
      if (lastValue.isEmpty) {
        return 'Address can not be empty';
      }
      return null;
    }

    // validateHowLong(lastValue) {
    //   if (lastValue.isEmpty) {
    //     return 'Please enter how long';
    //   }
    //   return null;
    // }

    validateAccountNumber(accountValue) {
      if (accountValue.isEmpty) {
        return '';
      }
      if (accountValue.length < 10) {
        return 'account number is invalid';
      }
      if (accountValue.length > 10) {
        return 'Invalid account Number';
      }
      if (int.tryParse(accountValue) == null) {
        return 'enter valid account number';
      }
      return null;
    }

    validatePropertyType(lastValue) {
      if (lastValue.isEmpty) {
        return 'Please select one';
      }
      return null;
    }

    validateLandLordPhone(phoneValue) {
      if (phoneValue.isEmpty) {
        return 'phone number cannot be empty';
      }
      if (phoneValue.length < 11) {
        return 'phone number is invalid';
      }
      if (int.tryParse(phoneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    // final pickedFile = await ImagePicker().pickImage(
    //   source: source,
    //   imageQuality: 100, // Ensure only images are picked
    // );

    // if (pickedFile != null) {
    //   File imageFile = File(pickedFile.path);
    //   // uploadImage(context, imageFile);
    //   String imageName = path.basename(imageFile.path);
    //   setState(() {
    //     _utilityBillController.text = cleanImageName(imageName);
    //   });
    // } else {
    //   if (kDebugMode) {
    //     print('No image selected.');
    //   }
    // }
    Future<void> pickImage(BuildContext context, ImageSource source) async {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 100, // Ensure only images are picked
      );

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        setState(() {
          _utilityBillController.text = imageFile.path;
        });
        // uploadImage(context, imageFile);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    }

    final reason = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _reasonController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Tell us why you need a loan...',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateReason,
    );

    final selectId = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.7,
              child: Container(
                // height: 350,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(19)),
                child: ListView(
                  children: [
                    Text(
                      'Select ID',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: idTypes.length,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          idTypes[idx],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // selected: _selectedCarrier == name[idx],
                                  onTap: () {
                                    setState(() {
                                      selectedId = idTypes[idx];
                                      idSelected = true;
                                    });

                                    _idSelectController.text = idTypes[idx];

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != idTypes.length - 1)
                                  ? Divider(
                                      color: Theme.of(context).dividerColor,
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
              ),
            );
          },
        );
      },
      readOnly: true,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      controller: _idSelectController,

      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Select ',
        hintStyle: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateIdSelect,
    );

    final idNumber = TextFormField(
      enableSuggestions: true,
      readOnly: !idSelected,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _idNumberController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Passport, Voter ID, Driver License, NIN',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateId,
    );
    final bvn = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _bvnController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: '343526475645',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateBvn,
    );
    final phoneNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _phoneNumberController,
      onChanged: (text) {
        // Format the phone number whenever the user types
        String formattedNumber = formatPhoneNumber(text);
        _phoneNumberController.value = _phoneNumberController.value.copyWith(
          text: formattedNumber,
          selection: TextSelection.fromPosition(
            TextPosition(offset: formattedNumber.length),
          ),
        );
      },
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: '+234 8033 865 3475',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validatePhone,
    );
    final address = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _houseAddressController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Include landmarks & closest busstop',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateAddress,
    );

    final utilityBill = TextFormField(
      onTap: () {
        pickImage(context, ImageSource.gallery);
      },
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _utilityBillController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: true,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'PHCN bill, waste management bill, water bill, bank state...',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Image.asset(
          'assets/icons/camera_icon.png',
          // width: 14,
          // height: 14,
          scale: 3,
          color: Theme.of(context).colorScheme.primary,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateBill,
    );

    final selectLandlordOrAgent = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.45,
              child: Container(
                // height: 350,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(19)),
                child: ListView(
                  children: [
                    Text(
                      'Landlord Or Agent',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: landordOrAgentTypes.length,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          landordOrAgentTypes[idx],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedId = landordOrAgentTypes[idx];
                                      isLandlordOrAgentSelected = true;
                                    });

                                    _landLordOrAgentController.text =
                                        landordOrAgentTypes[idx];
                                    // });

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != landordOrAgentTypes.length - 1)
                                  ? Divider(
                                      color: Theme.of(context).dividerColor,
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
              ),
            );
          },
        );
      },
      readOnly: true,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      controller: _landLordOrAgentController,

      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Select one',
        hintStyle: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_outlined,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateLandlordOrAgent,
    );

    final landlordName = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _landlordNameController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Full name',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateLandlordName,
    );

    // final landlordAddress = TextFormField(
    //   enableSuggestions: true,
    //   readOnly: _samePropertyController.text == samePropertyResponse[0]
    //       ? true
    //       : false,
    //   cursorColor: Theme.of(context).colorScheme.primary,
    //   controller: _samePropertyController.text == samePropertyResponse[0]
    //       ? _houseAddressController
    //       : _landlordAddressController,
    //   style: GoogleFonts.lato(
    //       color: Theme.of(context).colorScheme.primary, fontSize: 14),
    //   keyboardType: TextInputType.streetAddress,
    //   decoration: InputDecoration(
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: BorderSide(
    //         color: Theme.of(context).brightness == Brightness.dark
    //             ? const Color.fromRGBO(189, 189, 189, 30)
    //             : const Color.fromRGBO(189, 189, 189, 100),
    //       ),
    //     ),
    //     focusedBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: const BorderSide(color: brandOne, width: 1),
    //     ),
    //     enabledBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: BorderSide(
    //         color: Theme.of(context).brightness == Brightness.dark
    //             ? const Color.fromRGBO(189, 189, 189, 30)
    //             : const Color.fromRGBO(189, 189, 189, 100),
    //       ),
    //     ),
    //     errorBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: const BorderSide(color: Colors.red, width: 1),
    //     ),
    //     filled: false,
    //     contentPadding: const EdgeInsets.all(14),
    //     hintText: 'Include landmarks & closest busstop',
    //     hintStyle: GoogleFonts.lato(
    //       color: const Color(0xffBDBDBD),
    //       fontSize: 12,
    //       fontWeight: FontWeight.w400,
    //     ),
    //     errorStyle: GoogleFonts.lato(
    //       color: Colors.red,
    //       fontSize: 12,
    //       fontWeight: FontWeight.w400,
    //     ),
    //   ),
    //   maxLines: 1,
    //   validator: validateLandlordAddress,
    // );

    final selectSameProperty = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.45,
              child: Container(
                // height: 350,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(19)),
                child: ListView(
                  children: [
                    Text(
                      'Does your ${_landLordOrAgentController.text} live on the same property as you?',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: samePropertyResponse.length,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          samePropertyResponse[idx],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedId = samePropertyResponse[idx];
                                    });

                                    _samePropertyController.text =
                                        samePropertyResponse[idx];
                                    // });

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != samePropertyResponse.length - 1)
                                  ? Divider(
                                      color: Theme.of(context).dividerColor,
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
              ),
            );
          },
        );
      },
      readOnly: true,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      controller: _samePropertyController,

      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Select one',
        hintStyle: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_outlined,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateSameProperty,
    );
    final landlordPhoneNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _landlordPhoneNumberController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (text) {
        // Format the phone number whenever the user types
        String formattedNumber = formatPhoneNumber(text);
        _landlordPhoneNumberController.value =
            _landlordPhoneNumberController.value.copyWith(
          text: formattedNumber,
          selection: TextSelection.fromPosition(
            TextPosition(offset: formattedNumber.length),
          ),
        );
      },
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: '+234 000-0000-000',
        hintStyle: GoogleFonts.lato(
          color: const Color(0xffBDBDBD),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateLandLordPhone,
    );
    // final currentAddressDuration = TextFormField(
    //   enableSuggestions: true,
    //   cursorColor: Theme.of(context).colorScheme.primary,
    //   controller: _currentAddressDurationController,
    //   // autovalidateMode: AutovalidateMode.onUserInteraction,
    //   style: GoogleFonts.lato(
    //       color: Theme.of(context).colorScheme.primary, fontSize: 14),
    //   keyboardType: TextInputType.text,
    //   decoration: InputDecoration(
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: BorderSide(
    //         color: Theme.of(context).brightness == Brightness.dark
    //             ? const Color.fromRGBO(189, 189, 189, 30)
    //             : const Color.fromRGBO(189, 189, 189, 100),
    //       ),
    //     ),
    //     focusedBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: const BorderSide(color: brandOne, width: 1),
    //     ),
    //     enabledBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: BorderSide(
    //         color: Theme.of(context).brightness == Brightness.dark
    //             ? const Color.fromRGBO(189, 189, 189, 30)
    //             : const Color.fromRGBO(189, 189, 189, 100),
    //       ),
    //     ),
    //     errorBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: const BorderSide(color: Colors.red, width: 1),
    //     ),
    //     filled: false,
    //     contentPadding: const EdgeInsets.all(14),
    //     hintText: 'Input how long',
    //     hintStyle: GoogleFonts.lato(
    //       color: const Color(0xffBDBDBD),
    //       fontSize: 12,
    //       fontWeight: FontWeight.w400,
    //     ),
    //     errorStyle: GoogleFonts.lato(
    //       color: Colors.red,
    //       fontSize: 12,
    //       fontWeight: FontWeight.w400,
    //     ),
    //   ),
    //   maxLines: 1,
    //   validator: validateHowLong,
    // );
    final accountNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAccountNumber,
      controller: _landlordAccountNumberController,
      keyboardType: TextInputType.number,
      onChanged: (e) {
        // print(_landlordAccountNumberController.text.length);
        if (_landlordAccountNumberController.text.length == 10) {
          FocusScope.of(context).unfocus();
        }
        _checkFieldsAndHitApi();
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        contentPadding: const EdgeInsets.all(14),
        filled: false,
      ),
    );

    final selectpropertyType = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.45,
              child: Container(
                // height: 350,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(19)),
                child: ListView(
                  children: [
                    Text(
                      'Type of Property',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: propertyTypes.length,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          propertyTypes[idx],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedId = propertyTypes[idx];
                                    });

                                    _propertyTypesController.text =
                                        propertyTypes[idx];
                                    // });

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != propertyTypes.length - 1)
                                  ? Divider(
                                      color: Theme.of(context).dividerColor,
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
              ),
            );
          },
        );
      },
      readOnly: true,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      controller: _propertyTypesController,

      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Select one',
        hintStyle: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_outlined,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validatePropertyType,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
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
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  'Loan Application',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 24.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Wrap(
                        children: [
                          Text(
                            '${rentController.rentModel!.rents![widget.current].rentName}:',
                            style: GoogleFonts.lato(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            nairaFormaet.format(rentController
                                .rentModel!.rents![widget.current].paidAmount),
                            style: GoogleFonts.lato(
                              color: brandOne,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Form(
                      key: loanFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Reason',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              reason,
                            ],
                          ),
                          SizedBox(
                            height: 23.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Personal Verification',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'ID',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: selectId,
                                  ),
                                  SizedBox(
                                    width: 11.w,
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Opacity(
                                      opacity: (idSelected == true) ? 1 : 0.5,
                                      child: idNumber,
                                    ),
                                  ),
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
                                  'BVN',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              bvn,
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
                                  'Phone Number',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              phoneNumber,
                            ],
                          ),
                          SizedBox(
                            height: 23.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Proof of Residence',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'House Address',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              address,
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
                                  'Utility Bill',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              utilityBill,
                            ],
                          ),
                          SizedBox(
                            height: 23.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Landlord/Agent Verification',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Landlord or Agent',
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              selectLandlordOrAgent,
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          // (isLandlordOrAgentSelected)
                          Visibility(
                            visible: isLandlordOrAgentSelected,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: Text(
                                        '${_landLordOrAgentController.text} Name',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    landlordName,
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
                                        'Does your ${_landLordOrAgentController.text} live on the same property as you?',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    selectSameProperty,
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Padding(
                                //       padding: EdgeInsets.symmetric(
                                //           vertical: 3.h, horizontal: 3.w),
                                //       child: Text(
                                //         '${_landLordOrAgentController.text} Address',
                                //         style: GoogleFonts.lato(
                                //           color: Theme.of(context)
                                //               .colorScheme
                                //               .primary,
                                //           fontWeight: FontWeight.w500,
                                //           fontSize: 12,
                                //         ),
                                //       ),
                                //     ),
                                //     landlordAddress,
                                //   ],
                                // ),
                                // SizedBox(
                                //   height: 20.h,
                                // ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: Text(
                                        '${_landLordOrAgentController.text} Phone Number',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    landlordPhoneNumber,
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
                                        '${_landLordOrAgentController.text}\'s Account Number',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    accountNumber,
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
                                        '${_landLordOrAgentController.text}\'s Bank',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      onTap: () async {
                                        // _landlordAccountNumberController.clear();
                                        setState(() {
                                          _bankAccountName = '';
                                        });
                                        showModalBottomSheet(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          isDismissible: false,
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) => BankSelection(
                                            onBankSelected:
                                                (selectedBank, selectedCode) {
                                              _landlordBankController.text =
                                                  selectedBank;
                                              selectedBankCode = selectedCode;
                                              selectedBankName = selectedBank;

                                              _handleBankSelection(
                                                  selectedBank, selectedCode);
                                              if (_landlordAccountNumberController
                                                      .text.length ==
                                                  10) {
                                                _checkFieldsAndHitApi();
                                              }
                                            },
                                          ),
                                          // },
                                        );
                                      },
                                      onChanged: (e) {
                                        if (_landlordAccountNumberController
                                                .text.length ==
                                            10) {
                                          _checkFieldsAndHitApi();
                                        }
                                        // setState(() {
                                        //   canProceed = false;
                                        // });
                                        // tvName = "";
                                      },
                                      readOnly: true,
                                      // autovalidateMode:
                                      //     AutovalidateMode.onUserInteraction,
                                      enableSuggestions: true,
                                      cursorColor:
                                          Theme.of(context).colorScheme.primary,
                                      style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 14),

                                      controller: _landlordBankController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      // textCapitalization: TextCapitalization.sentences,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Color(0xffE0E0E0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: brandOne, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Color(0xffE0E0E0),
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.red, width: 1.0),
                                        ),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 12),
                                          child: Image.asset(
                                            'assets/icons/bank_icon.png',
                                            width: 26,
                                            // Ensure the image fits inside the circle
                                          ),
                                        ),
                                        suffixIcon: Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 24,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        filled: false,
                                        fillColor: Colors.transparent,
                                        contentPadding:
                                            const EdgeInsets.all(14),
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                (isChecking)
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: const Color(0xffEEF8FF),
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                                    child:
                                                        const SpinKitSpinningLines(
                                                      color: brandTwo,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20.w,
                                                ),
                                                Text(
                                                  'Verifying Account Details',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.lato(
                                                    color: brandOne,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
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
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            verifyAccountError,
                                            style: GoogleFonts.lato(
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                (_bankAccountName != '')
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffEEF8FF),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            _bankAccountName.capitalize!,
                                            style: GoogleFonts.lato(
                                              color: brandOne,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.h, horizontal: 3.w),
                                      child: Text(
                                        'Type of Property',
                                        style: GoogleFonts.lato(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    selectpropertyType,
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width - 50, 50),
                    backgroundColor: brandTwo,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (loanFormKey.currentState!.validate()) {
                      await _saveFormData().then(
                        (value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoanApplicationPageContinuation(
                              current: widget.current,
                              reason: _reasonController.text,
                              id: _idSelectController.text,
                              idNumber: _idNumberController.text,
                              bvn: _bvnController.text,
                              phoneNumber: _phoneNumberController.text,
                              address: _houseAddressController.text,
                              bill: _utilityBillController.text,
                              landlordOrAgent: _landLordOrAgentController.text,
                              landlordOrAgentName: _landlordNameController.text,
                              livesInSameProperty: _samePropertyController.text,
                              // landlordOrAgentAddress:
                              //     _landlordAddressController.text,
                              landlordOrAgentNumber:
                                  _landlordPhoneNumberController.text,
                              landlordAccountNumber:
                                  _landlordAccountNumberController.text,
                              landlordBankName: _landlordBankController.text,
                              // duration: _currentAddressDurationController.text,
                              propertyType: _propertyTypesController.text,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBankSelection(String selectedBank, String selectedCode) {
    // Perform additional actions based on the selected bank
    selectedBankCode = selectedCode;
    selectedBankName = selectedBank;
    // print('Bank selected in MyApp: $selectedBank');
    // You can add more actions here
  }
}

class BankSelection extends StatefulWidget {
  final Function(String, String) onBankSelected;
  const BankSelection({super.key, required this.onBankSelected});

  @override
  State<BankSelection> createState() => _BankSelectionState();
}

class _BankSelectionState extends State<BankSelection> {
  List<MapEntry<String, String>> bankEntries = [];
  List<MapEntry<String, String>> filteredBankEntries = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bankEntries = BankConstants.bankData.entries.toList();
    filteredBankEntries = bankEntries; // Display all banks initially
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterBanks(_searchController.text);
  }

  void _filterBanks(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredBankEntries = bankEntries; // Show all banks if query is empty
      } else {
        filteredBankEntries = bankEntries.where((entry) {
          final bankName = entry.value.toLowerCase();
          final queryLower = query.toLowerCase();
          return bankName.contains(queryLower);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      filteredBankEntries = bankEntries; // Reset to show all banks
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Bank',
                        style: GoogleFonts.lato(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 24),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    color: Theme.of(context).canvasColor,
                    child: TextFormField(
                      style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14),
                      cursorColor: Theme.of(context).colorScheme.primary,
                      controller: _searchController,
                      onChanged: (query) => _filterBanks(query),
                      decoration: InputDecoration(
                        filled: false,
                        contentPadding: const EdgeInsets.all(3),
                        prefixIcon: Icon(
                          Icons.search_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        suffixIcon: _searchController.text
                                .isNotEmpty // Show clear button only when typing
                            ? IconButton(
                                icon: Icon(
                                  Iconsax.close_circle5,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  _clearSearch(); // Clear the text field
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          // borderSide: BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: brandOne,
                          ),
                          // borderSide: BorderSide.none
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: brandOne,
                          ),
                          // borderSide: BorderSide.none
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.0),
                        ),
                        hintStyle: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        hintText: "Search Bank",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredBankEntries.length,
                  itemBuilder: (context, idx) {
                    final bankEntry = filteredBankEntries[idx];
                    String bankCode = filteredBankEntries[idx].key;
                    String bankName = filteredBankEntries[idx].value;

                    return Column(
                      children: [
                        StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return ListTileTheme(
                            selectedColor:
                                Theme.of(context).colorScheme.secondary,
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(
                                left: 0.0,
                                right: 0.0,
                              ),
                              minLeadingWidth: 0,
                              leading: Image.asset(
                                'assets/icons/bank_icon.png',
                                width: 44,
                                height: 44,
                                fit: BoxFit
                                    .fitWidth, // Ensure the image fits inside the circle
                              ),
                              title: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  bankName,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ),
                              onTap: () {
                                final selectedBank = bankEntry.value;
                                final selectedCode = bankCode;
                                // Handle bank selection
                                widget.onBankSelected(
                                    selectedBank, selectedCode);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Divider(
                            thickness: 1,
                            color: Theme.of(context).dividerColor,
                            height: 1,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
