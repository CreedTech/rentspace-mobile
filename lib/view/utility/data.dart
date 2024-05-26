import 'dart:convert';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/view/utility/data_list.dart';
import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../constants/data_constants.dart';
import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/utility_response_controller.dart';
import '../../controller/wallet_controller.dart';
import 'package:http/http.dart' as http;

import 'airtime_confirmation.dart';

class DataBundleScreen extends StatefulWidget {
  const DataBundleScreen({super.key});

  @override
  State<DataBundleScreen> createState() => _DataBundleScreenState();
}

var ch8t = NumberFormat.simpleCurrency(name: 'NGN');

class _DataBundleScreenState extends State<DataBundleScreen> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final UtilityResponseController utilityResponseController = Get.find();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController selectuserdataplansController =
      TextEditingController();
  final TextEditingController selectnetworkController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController packageController = TextEditingController();
  final TextEditingController selectplanmodelsubController =
      TextEditingController();
  final TextEditingController selectnetworkproviderController =
      TextEditingController();
  final DataBundleFormKey = GlobalKey<FormState>();
  // String? _selectedData;

  List<String> _amount = [];
  List<String> _dataName = [];
  List<String> _dataValidity = [];
  String? selectedItem;
  String? selectedItemAmount;
  String? selectedItemValidity;
  bool isDataSelected = false;
  bool isNetworkSelected = false;
  bool isNunmberInputted = false;

  List<String> SelectSubscription = const <String>[
    'Data Bundle',
    'Internet Subscription',
  ];

  // List<String> networkCarrier = const <String>[
  //   'Select Network',
  //   'MTN',
  //   'Glo',
  //   'Airtel',
  //   '9mobile',
  // ];

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

  String? _selectedCarrier;
  String? _selectedImage;
  String billType = '';
  // bool showInvalidRecipientNumberAlert = false;
  String _userInput = '';
  String? billerId;
  String? divisionId;
  String? productId;
  String? description;

  void validateUsersInput() {
    if (DataBundleFormKey.currentState!.validate()) {
      Get.to(DataListScreen(
          number: recipientController.text.trim(),
          network: _selectedCarrier!.trim(),
          image: _selectedImage!));
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
      print('_selectedCarrier');
      print(_selectedCarrier);
      print('detectedCarrier');
      print(detectedCarrier);
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
      await walletController.fetchWallet();
      await utilityResponseController.fetchUtilitiesResponse('Data');
      // setState(() {}); // Move setState inside fetchData
    }
    EasyLoading.dismiss();
    return true;
  }

  // Future getDataBundles() async {
  //   EasyLoading.show(
  //     indicator: const CustomLoader(),
  //     maskType: EasyLoadingMaskType.black,
  //     dismissOnTap: false,
  //   );
  //   String authToken =
  //       await GlobalService.sharedPreferencesManager.getAuthToken();
  //   final response = await http.post(
  //     Uri.parse(AppConstants.BASE_URL + AppConstants.GET_DATA_VARIATION_CODES),
  //     headers: {
  //       'Authorization': 'Bearer $authToken',
  //       "Content-Type": "application/json"
  //     },
  //     body: jsonEncode(<String, String>{
  //       "selectedNetwork": _selectedCarrier!,
  //     }),
  //   );
  //   EasyLoading.dismiss();
  //   // print(response);

  //   if (response.statusCode == 200) {
  //     EasyLoading.dismiss();
  //     var jsonResponse = jsonDecode(response.body);
  //     print('jsonResponse');
  //     List<String> dataAmount = [];
  //     List<String> dataName = [];
  //     List<String> dataValidity = [];
  //     // tempName.add("Select bank");
  //     for (var item in jsonResponse['amount_options']) {
  //       String amount = item['amount'];
  //       String name = item['name'];
  //       String validity = item['validity'];
  //       // String name = item['name'];
  //       if (name != "") {
  //         dataAmount.add(amount);
  //         dataName.add(name);
  //         dataValidity.add(validity);
  //       }
  //     }
  //     if (!mounted) return;
  //     setState(() {
  //       _amount = dataAmount;
  //       _dataName = dataName;
  //       _dataValidity = dataValidity;
  //       // _bankCode = tempCode;

  //       // _canShowOptions = true;
  //     });
  //   } else {
  //     EasyLoading.dismiss();
  //     print('Failed to load data from the server');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    // recipientController.addListener(() {
    //   setState(() {
    //     // _selectedCarrier = getCarrier(recipientController.text);
    //     selectnetworkController.text = _selectedCarrier!;
    //   });
    // });
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
    final networkCarrierSelect = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: const Color(0xffF6F6F8),
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height / 2.8,
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
                                  var billerLists = Hive.box('Data');
                                  var storedData = billerLists.get('Data');
                                  //  storedData['data'];
                                  print(_selectedCarrier!);
                                  var outputList = storedData['data']
                                      .where(
                                          (o) => o['name'] == _selectedCarrier!)
                                      .toList();
                                  print('output list ${outputList}');
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
                                    billerId = outputList[0]['id'];
                                    divisionId = outputList[0]['division'];
                                    productId = outputList[0]['product'];
                                    isNetworkSelected = true;
                                  });
                                  print(billerId);
                                  print(divisionId);
                                  print(productId);

                                  Navigator.pop(
                                    context,
                                  );
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
                                : SizedBox(),
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

    final choosePackage = TextFormField(
      onTap: () async {
        (isNetworkSelected == true)
            ? await utilityResponseController
                .fetchBillerItem(billerId!, divisionId!, productId!)
                .then((value) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xffF6F6F8),
                  isDismissible: true,
                  enableDrag: true,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    var billerItems = Hive.box(billerId!);
                    print(billerItems);
                    var storedData = billerItems.get(billerId!);
                    print(billerId);
                    //  storedData['data'];
                    var outputList = storedData['data']
                        .where((o) => o['billerid'] == billerId!)
                        .toList();
                    print('output data list ${outputList}');
                    return FractionallySizedBox(
                      heightFactor: 0.88,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xffF6F6F8),
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: ListView(
                          children: [
                            Text(
                              'Choose Package',
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
                                    .billerItemResponseModel!
                                    .data
                                    .paymentItems
                                    .length,
                                itemBuilder: (context, idx) {
                                  return Column(
                                    children: [
                                      ListTileTheme(
                                        contentPadding: const EdgeInsets.only(
                                            left: 13.0,
                                            right: 13.0,
                                            top: 4,
                                            bottom: 4),
                                        selectedColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius:
                                                20, // Adjust the radius as needed
                                            backgroundColor: Colors
                                                .transparent, // Ensure the background is transparent
                                            child: ClipOval(
                                              child: Image.asset(
                                                'assets/utility/${_selectedCarrier!.toLowerCase()}.jpg',
                                                width: 29,
                                                height: 28,
                                                fit: BoxFit
                                                    .fitWidth, // Ensure the image fits inside the circle
                                              ),
                                            ),
                                          ),

                                          // title: Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.start,
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.center,
                                          //   children: [
                                          //     Padding(
                                          //       padding: const EdgeInsets.only(
                                          //         right: 8,
                                          //       ),
                                          //       child: CircleAvatar(
                                          //         radius:
                                          //             20, // Adjust the radius as needed
                                          //         backgroundColor: Colors
                                          //             .transparent, // Ensure the background is transparent
                                          //         child: ClipOval(
                                          //           child: Image.asset(
                                          //             _selectedImage!,
                                          //             width: 29,
                                          //             height: 28,
                                          //             fit: BoxFit
                                          //                 .fitWidth, // Ensure the image fits inside the circle
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     const SizedBox(
                                          //       width: 8,
                                          //     ),
                                          //     Text(
                                          //       utilityResponseController
                                          //           .billerItemResponseModel!
                                          //           .data
                                          //           .paymentItems[idx].paymentItemName,
                                          //       // overflow: TextOverflow.,
                                          //       maxLines: 2,
                                          //       style: GoogleFonts.lato(
                                          //           fontSize: 16,
                                          //           fontWeight: FontWeight.w500,
                                          //           color: colorDark),
                                          //     ),
                                          //   ],
                                          // ),

                                          title: Text(
                                            utilityResponseController
                                                .billerItemResponseModel!
                                                .data
                                                .paymentItems[idx]
                                                .paymentItemName
                                                .capitalize!,
                                            maxLines: 2,
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: colorDark),
                                          ),
                                          trailing: Text(
                                            ch8t.format(
                                              double.tryParse(
                                                utilityResponseController
                                                    .billerItemResponseModel!
                                                    .data
                                                    .paymentItems[idx]
                                                    .amount,
                                              ),
                                            ),
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: colorBlack),
                                          ),
                                          // selected: _selectedCarrier == name[idx],
                                          onTap: () {
                                            setState(() {
                                              // selectedItem = _dataName[idx];
                                              // selectedItemAmount = _amount[idx];
                                              // selectedItemValidity =
                                              //     _dataValidity[idx];
                                              isDataSelected = true;
                                              amountController.text =
                                                  utilityResponseController
                                                      .billerItemResponseModel!
                                                      .data
                                                      .paymentItems[idx]
                                                      .amount;
                                              description =
                                                  utilityResponseController
                                                      .billerItemResponseModel!
                                                      .data
                                                      .paymentItems[idx]
                                                      .paymentItemName
                                                      .capitalize!;
                                            });
                                            packageController.text =
                                                utilityResponseController
                                                    .billerItemResponseModel!
                                                    .data
                                                    .paymentItems[idx]
                                                    .paymentItemName
                                                    .capitalize!;

                                            Navigator.pop(
                                              context,
                                            );
                                          },
                                        ),
                                      ),
                                      (idx !=
                                              utilityResponseController
                                                  .billerItemResponseModel!
                                                  .data
                                                  .paymentItems[idx]
                                                  .paymentItemName
                                                  .length)
                                          ? const Divider(
                                              color: Color(0xffC9C9C9),
                                              height: 1,
                                              indent: 13,
                                              endIndent: 13,
                                            )
                                          : SizedBox(),
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
              })
            : null;
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
      controller: packageController,
      textAlignVertical: TextAlignVertical.center,
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
          borderSide: const BorderSide(color: Color(0xffE0E0E0), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
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
              'Data',
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
          padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 24.h),
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
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.lato(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Space Wallet: ',
                              style: GoogleFonts.lato(
                                color: colorBlack,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              )),
                          TextSpan(
                            text: ch8t.format(walletController
                                .walletModel!.wallet![0].mainBalance),
                            style: GoogleFonts.lato(
                              color: brandOne,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: DataBundleFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                        Visibility(
                          visible: isNetworkSelected,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Choose Package',
                                  style: GoogleFonts.lato(
                                    color: colorBlack,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              choosePackage,
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 13.h,
                        ),
                        Visibility(
                          visible: isDataSelected && isNetworkSelected,
                          child: Column(
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
                                controller: amountController,
                                readOnly: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // validator: validatePhone,
                                validator: (value) {
                                  if (double.tryParse(value!)! >
                                      walletController.walletModel!.wallet![0]
                                          .mainBalance) {
                                    return 'Your account balance is too low for this transaction';
                                  }

                                  return null;
                                },

                                keyboardType: TextInputType.number,

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
                                  prefixText: "₦ ",
                                  prefixStyle: GoogleFonts.lato(
                                    color: colorBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 13.h,
                        ),
                        Visibility(
                          visible: isDataSelected && isNetworkSelected,
                          child: Column(
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
                                    _userInput = text;
                                    // _selectedCarrier = getCarrier(text);
                                    // selectnetworkController.text =
                                    //     _selectedCarrier!;
                                    isTextFieldEmpty =
                                        text.isNotEmpty && text.length == 11;
                                  });
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
                                ),
                              ),
                            ],
                          ),
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
                      backgroundColor:
                          (DataBundleFormKey.currentState != null &&
                                  DataBundleFormKey.currentState!.validate())
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
                      if (DataBundleFormKey.currentState != null &&
                          DataBundleFormKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        var billerLists = Hive.box('Data');
                        var storedData = billerLists.get('Data');
                        //  storedData['data'];
                        print(_selectedCarrier!);
                        var outputList = storedData['data']
                            .where((o) => o['name'] == _selectedCarrier!)
                            .toList();
                        print('output list ${outputList}');

                        print(recipientController.text);
                        print(amountController.text);
                        // print(billType!);
                        print(_selectedCarrier!);
                        Get.to(
                          AirtimeConfirmation(
                            number: recipientController.text,
                            amount: int.parse(amountController.text),
                            image: _selectedImage!,
                            billerId: outputList[0]['id'],
                            name: outputList[0]['name'],
                            divisionId: outputList[0]['division'],
                            productId: outputList[0]['product'],
                            category: description!,
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
}
