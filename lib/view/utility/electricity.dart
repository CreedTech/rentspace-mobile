// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:rentspace/constants/electricity_constants.dart';

// import '../../api/global_services.dart';
// import '../../constants/app_constants.dart';
import '../../constants/colors.dart';
// import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/utility/utility_response_controller.dart';
import '../../controller/wallet/wallet_controller.dart';
import 'airtime_confirmation.dart';
import 'data.dart';
// import 'electricity_payment_page.dart';
// import 'package:http/http.dart' as http;

class Electricity extends StatefulWidget {
  const Electricity({super.key});

  @override
  State<Electricity> createState() => _ElectricityState();
}

class _ElectricityState extends State<Electricity> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController providerController = TextEditingController();
  final TextEditingController packageController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController meterController = TextEditingController();
  final UtilityResponseController utilityResponseController = Get.find();
  final electricityFormKey = GlobalKey<FormState>();
  bool isDataSelected = false;
  bool isNetworkSelected = false;
  bool isNunmberInputted = false;
  String? _selectedCarrier;
  String? _selectedImage;
  String? billerId;
  String? divisionId;
  String? productId;
  String? description;
  // String _selectedElectricCode = 'bill-11';
  // String electricity = 'Ikeja Electric';
  // String electricityImage = 'assets/utility/7.jpg';
  // String electricityDescription =
  //     'Areas in Lagos covered by Ikeja Electricity Distribution Company (IKEDC) inlcude Abule Egba, Akowonjo, Ikeja, Ikorodu, Oshodi & Shomolu.';
  // String electricityName = '';
  // String minmumPayment = '500';
  // String meterNumber = '';
  // bool hasError = false;
  // String verifyAccountError = "";
  // String _message = '';
  // bool isChecking = false;
  // bool canProceed = false;

  // bool isTextFieldEmpty = false;
  Future<bool> fetchUserData({bool refresh = true}) async {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    if (refresh) {
      await userController.fetchData();
      await walletController.fetchWallet();
      await utilityResponseController.fetchUtilitiesResponse('Utility');
      // setState(() {}); // Move setState inside fetchData
    }
    EasyLoading.dismiss();
    return true;
  }

  // void _updateMessage() {
  //   if (isChecking) {
  //     // If checking, display loader message
  //     _message = 'Verifying Meter Details';
  //     verifyAccountError = "";
  //     hasError = false;
  //     electricityName = "";
  //   }
  // }

  // verifyMeter(String currentCode) async {
  //   String authToken =
  //       await GlobalService.sharedPreferencesManager.getAuthToken();
  //   setState(() {
  //     isChecking = true;
  //     electricityName = "";
  //     verifyAccountError = "";
  //     hasError = false;
  //     canProceed = false;
  //   });
  //   final response = await http.post(
  //       Uri.parse(AppConstants.BASE_URL + AppConstants.VERIFY_METER),
  //       headers: {
  //         'Authorization': 'Bearer $authToken',
  //         "Content-Type": "application/json"
  //       },
  //       body: json.encode({
  //         "billingServiceID": _selectedElectricCode,
  //         "meterNumber": meterController.text.trim().toString()
  //       }));

  //   if (response.statusCode == 200) {
  //     // Request successful, handle the response data
  //     final Map<String, dynamic> jsonResponse = json.decode(response.body);
  //     final meterInfo = jsonResponse['customerName'];
  //     final amount = jsonResponse['minimum_amount'];
  //     if (meterInfo != null && meterInfo != 'NA') {
  //       setState(() {
  //         electricityName = meterInfo;
  //         isChecking = false;
  //         hasError = false;
  //         canProceed = true;
  //         minmumPayment = amount.toString();
  //       });
  //       _updateMessage();
  //     } else {
  //       // Error handling
  //       setState(() {
  //         electricityName = "";
  //         isChecking = false;
  //         hasError = true;
  //         verifyAccountError =
  //             'Meter Validation failed. Please check the digits and try again';
  //         canProceed = false;
  //       });
  //       _updateMessage();
  //       // if (context.mounted) {
  //       //   customErrorDialog(context, 'Error!', "Invalid account number");
  //       // }
  //     }

  //     //print(response.body);
  //   } else {
  //     // Error handling
  //     setState(() {
  //       electricityName = "";
  //       isChecking = false;
  //       hasError = true;
  //       verifyAccountError =
  //           'Meter Validation failed. Please check the digits and try again';
  //       canProceed = false;
  //     });
  //     _updateMessage();

  //     // if (context.mounted) {
  //     //   customErrorDialog(context, 'Error!', 'Something went wrong');
  //     // }

  //     print(
  //         'Request failed with status: ${response.statusCode}, ${response.body}');
  //   }
  // }

  // void _checkFieldsAndHitApi() {
  //   if (electricityFormKey.currentState!.validate()) {
  //     verifyMeter(_selectedElectricCode);
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    meterController.dispose();
    providerController.dispose();
  }

  @override
  void initState() {
    super.initState();
    // canProceed = false;
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    // final choosePackage = TextFormField(
    //   onTap: () async {
    //     (isNetworkSelected == true)
    //         ? await utilityResponseController
    //             .fetchBillerItem(billerId!, divisionId!, productId!)
    //             .then((value) {
    //             showModalBottomSheet(
    //               context: context,
    //               backgroundColor: const Color(0xffF6F6F8),
    //               isDismissible: true,
    //               enableDrag: true,
    //               isScrollControlled: true,
    //               builder: (BuildContext context) {
    //                 var billerItems = Hive.box(billerId!);
    //                 print(billerItems);
    //                 var storedData = billerItems.get(billerId!);
    //                 print(billerId);
    //                 //  storedData['data'];
    //                 var outputList = storedData['data']
    //                     .where((o) => o['billerid'] == billerId!)
    //                     .toList();
    //                 print('output data list $outputList');
    //                 return FractionallySizedBox(
    //                   heightFactor: 0.88,
    //                   child: Container(
    //                     padding: const EdgeInsets.symmetric(
    //                         horizontal: 24, vertical: 20),
    //                     decoration: BoxDecoration(
    //                       color: const Color(0xffF6F6F8),
    //                       borderRadius: BorderRadius.circular(19),
    //                     ),
    //                     child: ListView(
    //                       children: [
    //                         Text(
    //                           'Choose Package',
    //                           style: GoogleFonts.lato(
    //                               fontSize: 16,
    //                               color: colorBlack,
    //                               fontWeight: FontWeight.w500),
    //                         ),
    //                         const SizedBox(
    //                           height: 10,
    //                         ),
    //                         Container(
    //                           decoration: BoxDecoration(
    //                             color: Colors.white,
    //                             borderRadius: BorderRadius.circular(20.0),
    //                           ),
    //                           child: ListView.builder(
    //                             physics: const BouncingScrollPhysics(),
    //                             shrinkWrap: true,
    //                             itemCount: utilityResponseController
    //                                 .billerItemResponseModel!
    //                                 .data
    //                                 .paymentItems
    //                                 .length,
    //                             itemBuilder: (context, idx) {
    //                               return Column(
    //                                 children: [
    //                                   ListTileTheme(
    //                                     contentPadding: const EdgeInsets.only(
    //                                         left: 13.0,
    //                                         right: 13.0,
    //                                         top: 4,
    //                                         bottom: 4),
    //                                     selectedColor: Theme.of(context)
    //                                         .colorScheme
    //                                         .secondary,
    //                                     child: ListTile(
    //                                       leading: CircleAvatar(
    //                                         radius:
    //                                             20, // Adjust the radius as needed
    //                                         backgroundColor: Colors
    //                                             .transparent, // Ensure the background is transparent
    //                                         child: ClipOval(
    //                                           child: Image.asset(
    //                                             'assets/utility/${_selectedCarrier!.replaceAll(' ', '').toLowerCase()}.jpg',
    //                                             width: 29,
    //                                             height: 28,
    //                                             fit: BoxFit
    //                                                 .fitWidth, // Ensure the image fits inside the circle
    //                                           ),
    //                                         ),
    //                                       ),

    //                                       title: Text(
    //                                         utilityResponseController
    //                                             .billerItemResponseModel!
    //                                             .data
    //                                             .paymentItems[idx]
    //                                             .paymentItemName
    //                                             .capitalize!,
    //                                         maxLines: 2,
    //                                         style: GoogleFonts.lato(
    //                                             fontSize: 14,
    //                                             fontWeight: FontWeight.w500,
    //                                             color: colorDark),
    //                                       ),
    //                                       trailing: Text(
    //                                         ch8t.format(
    //                                           double.tryParse(
    //                                             utilityResponseController
    //                                                 .billerItemResponseModel!
    //                                                 .data
    //                                                 .paymentItems[idx]
    //                                                 .amount,
    //                                           ),
    //                                         ),
    //                                         style: GoogleFonts.lato(
    //                                             fontSize: 14,
    //                                             fontWeight: FontWeight.w500,
    //                                             color: colorBlack),
    //                                       ),
    //                                       // selected: _selectedCarrier == name[idx],
    //                                       onTap: () {
    //                                         setState(() {
    //                                           isDataSelected = true;
    //                                           amountController.text =
    //                                               utilityResponseController
    //                                                   .billerItemResponseModel!
    //                                                   .data
    //                                                   .paymentItems[idx]
    //                                                   .amount;
    //                                           description =
    //                                               utilityResponseController
    //                                                   .billerItemResponseModel!
    //                                                   .data
    //                                                   .paymentItems[idx]
    //                                                   .paymentItemName
    //                                                   .capitalize!;
    //                                         });
    //                                         packageController.text =
    //                                             utilityResponseController
    //                                                 .billerItemResponseModel!
    //                                                 .data
    //                                                 .paymentItems[idx]
    //                                                 .paymentItemName
    //                                                 .capitalize!;

    //                                         Navigator.pop(
    //                                           context,
    //                                         );
    //                                       },
    //                                     ),
    //                                   ),
    //                                   (idx !=
    //                                           utilityResponseController
    //                                               .billerItemResponseModel!
    //                                               .data
    //                                               .paymentItems[idx]
    //                                               .paymentItemName
    //                                               .length)
    //                                       ? const Divider(
    //                                           color: Color(0xffC9C9C9),
    //                                           height: 1,
    //                                           indent: 13,
    //                                           endIndent: 13,
    //                                         )
    //                                       : SizedBox(),
    //                                 ],
    //                               );
    //                             },
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 );
    //               },
    //             );
    //           })
    //         : null;
    //   },
    //   readOnly: true,
    //   autovalidateMode: AutovalidateMode.onUserInteraction,
    //   enableSuggestions: true,
    //   cursorColor: colorBlack,
    //   style: GoogleFonts.lato(
    //     color: colorBlack,
    //     fontSize: 14,
    //     fontWeight: FontWeight.w500,
    //   ),
    //   controller: packageController,
    //   textAlignVertical: TextAlignVertical.center,
    //   keyboardType: TextInputType.text,
    //   decoration: InputDecoration(
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: const BorderSide(
    //         color: Color(0xffE0E0E0),
    //       ),
    //     ),
    //     focusedBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: const BorderSide(color: Color(0xffE0E0E0), width: 1.0),
    //     ),
    //     enabledBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: const BorderSide(
    //         color: Color(0xffE0E0E0),
    //       ),
    //     ),
    //     errorBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: const BorderSide(color: Colors.red, width: 1.0),
    //     ),
    //     suffixIcon: const Icon(
    //       Icons.keyboard_arrow_down,
    //       size: 24,
    //       color: colorBlack,
    //     ),
    //     filled: false,
    //     fillColor: Colors.transparent,
    //     contentPadding:
    //         const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
    //     hintStyle: GoogleFonts.lato(
    //       color: brandOne,
    //       fontSize: 12,
    //       fontWeight: FontWeight.w700,
    //     ),
    //   ),
    //   maxLines: 1,
    // );

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
              'Electricity',
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
                            style: GoogleFonts.roboto(
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
                    key: electricityFormKey,
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
                                'Service Provider',
                                style: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextFormField(
                              onTap: () {
                                showModalBottomSheet(
                                  isDismissible: true,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  backgroundColor: const Color(0xffF6F6F8),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FractionallySizedBox(
                                      heightFactor: 0.7,
                                      child: Container(
                                        // height:
                                        //     MediaQuery.of(context).size.height /
                                        //         1.2,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 20),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffF6F6F8),
                                            borderRadius:
                                                BorderRadius.circular(19)),
                                        child: ListView(
                                          children: [
                                            Text(
                                              'Select Provider',
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
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  0,
                                                  10,
                                                  0,
                                                  10,
                                                ),
                                                itemCount:
                                                    utilityResponseController
                                                        .utilityResponseModel!
                                                        .utilities!
                                                        .length,
                                                itemBuilder: (context, idx) {
                                                  return Column(
                                                    children: [
                                                      ListTileTheme(
                                                        selectedColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                        child: ListTile(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 25.0,
                                                            right: 25.0,
                                                          ),
                                                          title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  right: 8,
                                                                ),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius:
                                                                      20, // Adjust the radius as needed
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent, // Ensure the background is transparent
                                                                  child:
                                                                      ClipOval(
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/utility/${utilityResponseController.utilityResponseModel!.utilities![idx].name.replaceAll(' ', '').toLowerCase()}.jpg',
                                                                      width: 29,
                                                                      height:
                                                                          28,
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
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.4,
                                                                child: Text(
                                                                  utilityResponseController
                                                                      .utilityResponseModel!
                                                                      .utilities![
                                                                          idx]
                                                                      .name,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: GoogleFonts.lato(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color:
                                                                          colorDark),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            // billType = airtimeBill[idx];
                                                            _selectedCarrier =
                                                                utilityResponseController
                                                                    .utilityResponseModel!
                                                                    .utilities![
                                                                        idx]
                                                                    .name;
                                                            _selectedImage =
                                                                'assets/utility/${utilityResponseController.utilityResponseModel!.utilities![idx].name.replaceAll(' ', '').toLowerCase()}.jpg';
                                                            var billerLists =
                                                                Hive.box(
                                                                    'Utility');
                                                            var storedData =
                                                                billerLists.get(
                                                                    'Utility');
                                                            //  storedData['data'];
                                                            // print(
                                                            //     _selectedCarrier!);
                                                            var outputList = storedData[
                                                                    'data']
                                                                .where((o) =>
                                                                    o['name'] ==
                                                                    _selectedCarrier!)
                                                                .toList();
                                                            // print(
                                                            //     'output list ${outputList}');
                                                            // canProceed = true;
                                                            await utilityResponseController
                                                                .fetchBillerItem(
                                                                    outputList[
                                                                            0]
                                                                        ['id'],
                                                                    outputList[
                                                                            0][
                                                                        'division'],
                                                                    outputList[
                                                                            0][
                                                                        'product'])
                                                                .then((value) {
                                                              var billerItems =
                                                                  Hive.box(
                                                                      outputList[
                                                                              0]
                                                                          [
                                                                          'id']);
                                                              // print(
                                                              //     billerItems);
                                                              var storedItem =
                                                                  billerItems.get(
                                                                      outputList[
                                                                              0]
                                                                          [
                                                                          'id']);
                                                              // print(billerId);
                                                              //  storedItem['data'];
                                                              var outputItem = storedItem[
                                                                      'data']
                                                                  .where((o) =>
                                                                      o['billerid'] ==
                                                                      outputList[
                                                                              0]
                                                                          [
                                                                          'id'])
                                                                  .toList();
                                                              // print(
                                                              //     'output data item ${outputItem}');
                                                              setState(() {
                                                                // billType = airtimeBill[idx];
                                                                _selectedCarrier =
                                                                    utilityResponseController
                                                                        .utilityResponseModel!
                                                                        .utilities![
                                                                            idx]
                                                                        .name;
                                                                description =
                                                                    outputItem[
                                                                            0][
                                                                        'paymentitemname'];
                                                                _selectedImage =
                                                                    'assets/utility/${utilityResponseController.utilityResponseModel!.utilities![idx].name.replaceAll(' ', '').toLowerCase()}.jpg';
                                                                // canProceed = true;
                                                                providerController
                                                                        .text =
                                                                    _selectedCarrier!;
                                                                billerId =
                                                                    outputList[
                                                                            0]
                                                                        ['id'];
                                                                divisionId =
                                                                    outputList[
                                                                            0][
                                                                        'division'];
                                                                productId =
                                                                    outputList[
                                                                            0][
                                                                        'product'];
                                                                isNetworkSelected =
                                                                    true;
                                                              });
                                                              // print(billerId);
                                                              // print(divisionId);
                                                              // print(productId);

                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      (idx !=
                                                              utilityResponseController
                                                                  .utilityResponseModel!
                                                                  .utilities![
                                                                      idx]
                                                                  .name
                                                                  .length)
                                                          ? const Divider(
                                                              color: Color(
                                                                  0xffC9C9C9),
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
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
                                prefixIcon: (_selectedImage != null)
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 15),
                                        child: CircleAvatar(
                                          radius:
                                              14, // Adjust the radius as needed
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
                                // hintText: tvCable,
                                filled: false,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.all(14),
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
                                  'Meter Number',
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
                                controller: meterController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // validator: validatePhone,
                                style: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                                keyboardType: TextInputType.number,

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Meter Number';
                                  }
                                  if (!value.isNum) {
                                    return 'Meter number must be entered in digits';
                                  }
                                  // if (value.length < 10) {
                                  //   return 'Smart Card Number must be at least 10 Digits';
                                  // }
                                  if (value.length > 20) {
                                    return 'Meter Number must be less 20 Digits';
                                  }
                                  return null;
                                },

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
                                  // hintText: 'Enter Smart Card Number',
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // validator: validatePhone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'amount cannot be empty';
                                  }
                                  if (double.tryParse(
                                          value.trim().replaceAll(',', '')) ==
                                      null) {
                                    return 'enter valid number';
                                  }
                                  if (double.tryParse(value)! >
                                      walletController.walletModel!.wallet![0]
                                          .mainBalance) {
                                    return 'Your account balance is too low for this transaction';
                                  }
                                  if (double.tryParse(value)!.isNegative) {
                                    return 'enter valid number';
                                  }
                                  if (double.tryParse(
                                          value.trim().replaceAll(',', '')) ==
                                      0) {
                                    return 'amount cannot be zero';
                                  }
                                  if (double.tryParse(value)! < 500) {
                                    return 'minimum amount is ₦500';
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
                                        color: brandOne, width: 1.0),
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
                                        width: 1.0), // Change color to yellow
                                  ),
                                  filled: false,
                                  contentPadding: const EdgeInsets.all(14),
                                  fillColor: brandThree,
                                  prefixText: "₦ ",
                                  prefixStyle: GoogleFonts.roboto(
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
                        // Visibility(
                        //   visible: electricityName == '',
                        //   child: Align(
                        //     alignment: Alignment.bottomCenter,
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           vertical: 20, horizontal: 20),
                        //       child: ElevatedButton(
                        //         style: ElevatedButton.styleFrom(
                        //           minimumSize: const Size(250, 50),
                        //           backgroundColor: brandOne,
                        //           elevation: 0,
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(
                        //               10,
                        //             ),
                        //           ),
                        //         ),
                        //         onPressed: () async {
                        //           if (electricityFormKey.currentState!
                        //               .validate()) {
                        //             // _doSomething();
                        //             // Get.to(ConfirmTransactionPinPage(
                        //             //     pin: _pinController.text.trim()));
                        //             FocusScope.of(context).unfocus();
                        //             _checkFieldsAndHitApi();
                        //             // validateUsersInput();
                        //           }
                        //         },
                        //         child: const Text(
                        //           'Check',
                        //           textAlign: TextAlign.center,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        // Visibility(
                        //   visible: electricityName != '',
                        //   child: Align(
                        //     alignment: Alignment.bottomCenter,
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           vertical: 20, horizontal: 20),
                        //       child: ElevatedButton(
                        //         style: ElevatedButton.styleFrom(
                        //           minimumSize: const Size(250, 50),
                        //           backgroundColor: brandOne,
                        //           elevation: 0,
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(
                        //               10,
                        //             ),
                        //           ),
                        //         ),
                        //         onPressed: () async {
                        //           if (electricityFormKey.currentState!
                        //                   .validate() &&
                        //               electricityName != '') {
                        //             // _doSomething();
                        //             // Get.to(ConfirmTransactionPinPage(
                        //             //     pin: _pinController.text.trim()));
                        //             FocusScope.of(context).unfocus();
                        //             await fetchUserData()
                        //                 .then(
                        //                   (value) => Navigator.push(
                        //                     context,
                        //                     MaterialPageRoute(
                        //                       builder: (context) =>
                        //                           ElectricityPaymentPage(
                        //                         electricity: electricity,
                        //                         electricityCode:
                        //                             _selectedElectricCode,
                        //                         electricityImage:
                        //                             electricityImage,
                        //                         electricityName:
                        //                             electricityName,
                        //                         electricityDescription:
                        //                             electricityDescription,
                        //                         minmumAmount:
                        //                             minmumPayment.trim(),
                        //                         meterNumber:
                        //                             meterController.text.trim(),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 )
                        //                 .catchError(
                        //                   (error) => {
                        //                     customErrorDialog(context, 'Oops',
                        //                         'Something went wrong. Try again later'),
                        //                   },
                        //                 );
                        //             // validateUsersInput();
                        //           }
                        //         },
                        //         child: const Text(
                        //           'Proceed',
                        //           textAlign: TextAlign.center,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
                          (electricityFormKey.currentState != null &&
                                  electricityFormKey.currentState!.validate())
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
                      if (electricityFormKey.currentState != null &&
                          electricityFormKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        var billerLists = Hive.box('Utility');
                        var storedData = billerLists.get('Utility');
                        //  storedData['data'];
                        // print(_selectedCarrier!);
                        var outputList = storedData['data']
                            .where((o) => o['name'] == _selectedCarrier!)
                            .toList();
                        // print('output list ${outputList}');

                        // print('validating info');
                        // print(meterController.text);
                        // print(divisionId);
                        // print(description);
                        // print(productId);
                        // print(billerId);
                        // print(_selectedCarrier!);
                        utilityResponseController
                            .validateElectricityCustomer(
                                meterController.text.trim().toString(),
                                divisionId,
                                description!,
                                productId,
                                billerId)
                            .then((value) {
                          var customerVerification =
                              Hive.box('customerElectricValidation_$billerId');
                          var storedData = customerVerification.get(billerId);
                          //  storedData['data'];
                          // print(_selectedCarrier!);
                          var customerInfo = storedData['data'];
                          // print('customer info ${customerInfo['name']}');
                          Get.to(
                            AirtimeConfirmation(
                              number: meterController.text.trim(),
                              amount: int.parse(amountController.text),
                              image: _selectedImage!.replaceAll(' ', ''),
                              billerId: billerId!,
                              name: outputList[0]['name'],
                              divisionId: divisionId!,
                              productId: productId!,
                              category: description!,
                              customerName: customerInfo['name'],
                            ),
                          );
                        });
                        // Get.to(
                        //   AirtimeConfirmation(
                        //     number: smartcardController.text,
                        //     amount: int.parse(amountController.text),
                        //     image: _selectedImage!,
                        //     billerId: billerId!,
                        //     name: outputList[0]['name'],
                        //     divisionId: divisionId!,
                        //     productId: productId!,
                        //     category: description!,
                        //   ),
                        // );
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
