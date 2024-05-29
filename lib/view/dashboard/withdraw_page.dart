import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rentspace/controller/auth/user_controller.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../constants/bank_constants.dart';
import '../../constants/colors.dart';
import 'package:http/http.dart' as http;

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  final UserController userController = Get.find();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _narrationController = TextEditingController();
  late TextEditingController _searchController;
  String searchQuery = '';
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  late StreamSubscription subscription;
  final withdrawalFormKey = GlobalKey<FormState>();
  bool _isTyping = false;
  bool hasError = false;
  String _message = '';
  String _bankAccountName = "";
  bool isChecking = false;
  String verifyAccountError = "";
  String? selectedBankName;
  String? selectedBankCode;

  void _onSearchChanged() {
    setState(() {
      // _searchQuery = _searchController.text.toLowerCase();
      _isTyping = searchQuery.isNotEmpty;
    });
  }

  void _updateMessage() {
    if (isChecking) {
      // If checking, display loader message
      _message = 'Verifying Account Details';
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
          "accountNumber": _accountNumberController.text.trim().toString()
        }));
    print(currentCode);
    print(currentCode);

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
        _updateMessage();
        // if (context.mounted) {
        //   customErrorDialog(context, 'Error!', "Invalid account number");
        // }
      }

      //print(response.body);
    } else {
      // Error handling
      setState(() {
        _bankAccountName = "";
        isChecking = false;
        hasError = false;
        verifyAccountError = "";
      });
      _updateMessage();

      if (context.mounted) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: null,
                elevation: 0,
                content: SizedBox(
                  height: 250,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              // color: brandOne,
                            ),
                            child: const Icon(
                              Iconsax.close_circle,
                              color: brandOne,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Iconsax.warning_24,
                          color: Colors.red,
                          size: 75,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Error!',
                        style: GoogleFonts.lato(
                          color: Colors.red,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Something went wrong",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(color: brandOne, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            });
      }

      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }

  void _checkFieldsAndHitApi() {
    if (withdrawalFormKey.currentState!.validate() &&
        selectedBankName != null) {
      getAccountDetails(selectedBankCode!);
    }
  }

  @override
  void initState() {
    super.initState();
    getConnectivity();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    _message = '';
    // fetchUserData();
  }

  void getConnectivity() {
    print('checking internet...');
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
                          color: brandOne,
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
                          color: brandOne,
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
                          minimumSize: const Size(300, 50),
                          maximumSize: const Size(400, 50),
                          backgroundColor: Theme.of(context).primaryColor,
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
                          // fetchUserData();
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
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, String>> sortedBanks = BankConstants.bankData.entries
        .toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    validateNumber(accountValue) {
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

    final accountNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: colorBlack,
      style: GoogleFonts.lato(
        color: colorBlack,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateNumber,
      // maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: _accountNumberController,
      keyboardType: TextInputType.number,
      onChanged: (e) {
        _checkFieldsAndHitApi();
      },
      // onEditingComplete: handleEditingComplete(editedValue),

      // maxLength: 10,
      decoration: InputDecoration(
        //prefix: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        contentPadding: const EdgeInsets.all(14),
        filled: false,
        // hintText: 'Enter 10 digits Account Number',
        // hintStyle: GoogleFonts.lato(
        //   color: Colors.grey,
        //   fontSize: 12,
        //   fontWeight: FontWeight.w400,
        // ),
      ),
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
              'Withdraw',
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
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 24.h,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You only get one withdrawal per month. Please add your withdrawal account below to proceed.',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: colorBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Add a Withdrawal Account',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 24,
                        color: colorBlack,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.lato(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    'Please add an account that is linked to your BVN',
                                style: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: withdrawalFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                'Select Bank',
                                style: GoogleFonts.lato(
                                    color: colorBlack,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                            TextFormField(
                              onTap: () async {
                                showModalBottomSheet(
                                  backgroundColor: const Color(0xffF6F6F8),
                                  isDismissible: false,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (
                                    BuildContext context,
                                  ) {
                                    return StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      // String searchQuery = '';
                                      // List<String> filteredBanks(
                                      //     String query) {
                                      //   if (query.isEmpty) {
                                      //     return selectedBankName;
                                      //   } else {
                                      //     setState(() {});

                                      //     return selectedBankName
                                      //         .where((bankName) => bankName
                                      //             .toLowerCase()
                                      //             .contains(
                                      //                 query.toLowerCase()))
                                      //         .toList();
                                      //   }
                                      // }

                                      return FractionallySizedBox(
                                        heightFactor: 0.8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 26, horizontal: 24),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Select Bank',
                                                          style:
                                                              GoogleFonts.lato(
                                                                  color:
                                                                      colorBlack,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 24),
                                                        ),
                                                        GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Icon(
                                                              Icons.close,
                                                              size: 24,
                                                              color: colorBlack,
                                                            )),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 18,
                                                    ),
                                                    Container(
                                                      color: const Color(
                                                          0xffEBEBEB),
                                                      child: TextFormField(
                                                        style: GoogleFonts.lato(
                                                            color: colorBlack,
                                                            fontSize: 14),
                                                        cursorColor: colorBlack,
                                                        controller:
                                                            _searchController,
                                                        onChanged:
                                                            (String value) {
                                                          _onSearchChanged();
                                                          print(
                                                              "searchQuery here");
                                                          print(searchQuery);
                                                        },
                                                        // onChanged: (value) {
                                                        //   setState(() {
                                                        //     searchQuery = value;
                                                        //   });

                                                        // },
                                                        decoration:
                                                            InputDecoration(
                                                          filled: false,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          prefixIcon:
                                                              const Icon(
                                                            Icons
                                                                .search_outlined,
                                                            color: colorBlack,
                                                            size: 24,
                                                          ),
                                                          suffixIcon:
                                                              _isTyping // Show clear button only when typing
                                                                  ? IconButton(
                                                                      icon:
                                                                          const Icon(
                                                                        Iconsax
                                                                            .close_circle5,
                                                                        size:
                                                                            18,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                        _searchController
                                                                            .clear(); // Clear the text field
                                                                      },
                                                                    )
                                                                  : null,
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                            // borderSide: BorderSide.none
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                const BorderSide(
                                                              color: brandOne,
                                                            ),
                                                            // borderSide: BorderSide.none
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                const BorderSide(
                                                              color: brandOne,
                                                            ),
                                                            // borderSide: BorderSide.none
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 2.0),
                                                          ),
                                                          hintStyle:
                                                              const TextStyle(
                                                            color: colorBlack,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          hintText:
                                                              "Search Bank",
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
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        sortedBanks.length,
                                                    itemBuilder:
                                                        (context, idx) {
                                                      String bankCode =
                                                          sortedBanks[idx].key;
                                                      String bankName =
                                                          sortedBanks[idx]
                                                              .value;
                                                      // final bankName =
                                                      //     filteredBanks(
                                                      //             searchQuery)[
                                                      //         idx];
                                                      return Column(
                                                        children: [
                                                          StatefulBuilder(builder:
                                                              (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                            return ListTileTheme(
                                                              selectedColor: Theme
                                                                      .of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                              child: ListTile(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 0.0,
                                                                  right: 0.0,
                                                                ),
                                                                minLeadingWidth:
                                                                    0,
                                                                leading:
                                                                    Image.asset(
                                                                  'assets/icons/bank_icon.png',
                                                                  width: 44,
                                                                  height: 44,
                                                                  fit: BoxFit
                                                                      .fitWidth, // Ensure the image fits inside the circle
                                                                ),
                                                                title: SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      1.5,
                                                                  child: Text(
                                                                    bankName,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.lato(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color:
                                                                            colorBlack),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  setState(() {
                                                                    selectedBankName =
                                                                        bankName;
                                                                    selectedBankCode =
                                                                        bankCode;
                                                                    // saveSelectedBankCode(bankCode);
                                                                    // ScaffoldMessenger.of(
                                                                    //         context)
                                                                    //     .showSnackBar(
                                                                    //         SnackBar(
                                                                    //   content:
                                                                    //       Text('Bank code saved: $selectedBankCode'),
                                                                    // ));
                                                                  });
                                                                  // setState(
                                                                  //     () {
                                                                  //   selectedBankName =
                                                                  //       bankName;
                                                                  //   selectedBankCode = BankConstants
                                                                  //       .bankData
                                                                  //       .keys
                                                                  //       .firstWhere(
                                                                  //           (key) => BankConstants.bankData[key] == bankName,
                                                                  //           orElse: () => null);
                                                                  // });

                                                                  _bankController
                                                                          .text =
                                                                      selectedBankName!;
                                                                  _checkFieldsAndHitApi();
                                                                  // _selectedTVCode = tvBill[idx];
                                                                  // tvCable = name[idx];
                                                                  // tvImage = image[idx];
                                                                  // canProceed = true;

                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                  print(
                                                                      selectedBankName);

                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                            );
                                                          }),
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        20),
                                                            child: Divider(
                                                              thickness: 1,
                                                              color: Color(
                                                                  0xffC9C9C9),
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
                                    });
                                  },
                                );
                              },
                              onChanged: (e) {
                                _checkFieldsAndHitApi();
                                // setState(() {
                                //   canProceed = false;
                                // });
                                // tvName = "";
                              },
                              readOnly: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              enableSuggestions: true,
                              cursorColor: colorBlack,
                              style: GoogleFonts.lato(
                                  color: colorBlack, fontSize: 14),

                              controller: _bankController,
                              textAlignVertical: TextAlignVertical.center,
                              // textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.emailAddress,
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
                                      color: brandOne, width: 2.0),
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
                                      width: 2.0), // Change color to yellow
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
                                suffixIcon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 24,
                                  color: colorBlack,
                                ),
                                filled: false,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.all(14),
                              ),
                              maxLines: 1,
                            ),

                            // GestureDetector(
                            //   onTap: _openBankSelectorOverlay,
                            //   child: AbsorbPointer(
                            //     child: bank,
                            //   ),
                            // ),
                          ],
                        ),
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
                                'Account Number',
                                style: GoogleFonts.lato(
                                    color: colorBlack,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                            accountNumber
                          ],
                        ),
                        (isChecking)
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffEEF8FF),
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

                            // :(hasError == true)?Text(verifyAccountError):Text(_bankAccountName)
                            : const SizedBox(),
                        (hasError == true || verifyAccountError != '')
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
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
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffEEF8FF),
                                    borderRadius: BorderRadius.circular(15),
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
                      backgroundColor: brandTwo,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onPressed: withdrawalFormKey.currentState != null &&
                            withdrawalFormKey.currentState!.validate() &&
                            _bankAccountName != ''
                        ? () async {
                            FocusScope.of(context).unfocus();
                            userController.createWithdrawalAccount(
                              context,
                              selectedBankCode!,
                              _accountNumberController.text.trim(),
                              selectedBankName,
                              _bankAccountName,
                            );
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         TransferConfirmationPage(
                            //       bankName: _bankController.text,
                            //       accountNumber:
                            //           _accountNumberController.text,
                            //       bankCode: _currentBankCode,
                            //       accountName: _bankAccountName,
                            //       amount: _amountController.text,
                            //       narration: _narrationController.text,
                            //     ),
                            //   ),
                            // );
                            // Proceed with the action
                          }
                        : null,
                    child: Text(
                      'Proceed',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: colorWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
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
}
