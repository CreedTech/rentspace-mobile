// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rentspace/widgets/custom_loader.dart';
import 'package:rentspace/view/utility/airtime.dart';

import '../../constants/colors.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/utility/utility_response_controller.dart';
import '../../controller/wallet/wallet_controller.dart';
// import 'package:http/http.dart' as http;

import 'airtime_confirmation.dart';

class CableScreen extends StatefulWidget {
  const CableScreen({super.key});

  @override
  State<CableScreen> createState() => _CableScreenState();
}

class _CableScreenState extends State<CableScreen> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController providerController = TextEditingController();
  final TextEditingController packageController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController smartcardController = TextEditingController();
  final UtilityResponseController utilityResponseController = Get.find();
  final tvFormKey = GlobalKey<FormState>();
  bool isDataSelected = false;
  bool isNetworkSelected = false;
  bool isNunmberInputted = false;
  String? _selectedCarrier;
  String? _selectedImage;
  String? billerId;
  String? divisionId;
  String? productId;
  String? description;
  // String _selectedTVCode = 'bill-20';
  // String tvCable = 'DSTV - Subscription';
  // String tvImage = 'assets/utility/dstv.jpg';
  // String tvName = '';
  // String tvNumber = '';
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
      await utilityResponseController.fetchUtilitiesResponse('Cable TV');
      // setState(() {}); // Move setState inside fetchData
    }
    EasyLoading.dismiss();
    return true;
  }


  @override
  void dispose() {
    super.dispose();
    smartcardController.dispose();
    providerController.dispose();
    amountController.dispose();
    packageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    // canProceed = false;
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
                    // var billerItems = Hive.box(billerId!);
                    // print(billerItems);
                    // var storedData = billerItems.get(billerId!);
                    // print(billerId);
                    //  storedData['data'];
                    // var outputList = storedData['data']
                    //     .where((o) => o['billerid'] == billerId!)
                    //     .toList();
                    // print('output data list ${outputList}');
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
                                                'assets/utility/${_selectedCarrier!.replaceAll(' ', '').toLowerCase()}.jpg',
                                                width: 29,
                                                height: 28,
                                                fit: BoxFit
                                                    .fitWidth, // Ensure the image fits inside the circle
                                              ),
                                            ),
                                          ),

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
                                            style: GoogleFonts.roboto(
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
                context.pop();
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
              'Cable',
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
                    key: tvFormKey,
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
                            TextFormField(
                              onTap: () {
                                showModalBottomSheet(
                                  isDismissible: true,
                                  backgroundColor: const Color(0xffF6F6F8),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2.8,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 20),
                                      decoration: BoxDecoration(
                                          color: const Color(0xffF6F6F8),
                                          borderRadius:
                                              BorderRadius.circular(19)),
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
                                                                child: ClipOval(
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/utility/${utilityResponseController.utilityResponseModel!.utilities![idx].name.replaceAll(' ', '').toLowerCase()}.jpg',
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
                                                        onTap: () {
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
                                                                  'Cable TV');
                                                          var storedData =
                                                              billerLists.get(
                                                                  'Cable TV');
                                                          //  storedData['data'];
                                                          // print(
                                                          //     _selectedCarrier!);
                                                          var outputList =
                                                              storedData['data']
                                                                  .where((o) =>
                                                                      o['name'] ==
                                                                      _selectedCarrier!)
                                                                  .toList();
                                                          // print(
                                                          //     'output list ${outputList}');
                                                          // canProceed = true;
                                                          setState(() {
                                                            // billType = airtimeBill[idx];
                                                            _selectedCarrier =
                                                                utilityResponseController
                                                                    .utilityResponseModel!
                                                                    .utilities![
                                                                        idx]
                                                                    .name;
                                                            _selectedImage =
                                                                'assets/utility/${utilityResponseController.utilityResponseModel!.utilities![idx].name.replaceAll(' ', '').toLowerCase()}.jpg';
                                                            // canProceed = true;
                                                            providerController
                                                                    .text =
                                                                _selectedCarrier!;
                                                            billerId =
                                                                outputList[0]
                                                                    ['id'];
                                                            divisionId =
                                                                outputList[0][
                                                                    'division'];
                                                            productId =
                                                                outputList[0]
                                                                    ['product'];
                                                            isNetworkSelected =
                                                                true;
                                                          });
                                                          // print(billerId);
                                                          // print(divisionId);
                                                          // print(productId);

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
                                    );
                                  },
                                );
                              },

                              readOnly: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              enableSuggestions: true,
                              cursorColor:
                                  Theme.of(context).colorScheme.primary,
                              style: GoogleFonts.lato(
                                  color: Theme.of(context).colorScheme.primary,
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
                                      color: Colors.red, width: 1.0),
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
                                        color: Colors.red, width: 1.0),
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
                        Visibility(
                          visible: isDataSelected && isNetworkSelected,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 3.w),
                                child: Text(
                                  'Smart Card Number',
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
                                controller: smartcardController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // validator: validatePhone,
                                style: GoogleFonts.lato(
                                  color: colorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                                keyboardType: TextInputType.number,
                                // onTapOutside: (String) {
                                //   print(billerId);
                                //   utilityResponseController.validateCustomer(
                                //       smartcardController.text.trim(),
                                //       divisionId,
                                //       description,
                                //       productId,
                                //       billerId);
                                //   // (utilityResponseController.isValidationLoading.value == false)?
                                //   var billerLists =
                                //       Hive.box('customerValidation');
                                //   var storedData = billerLists.get(billerId);
                                //   //  storedData['data'];
                                //   print(_selectedCarrier!);
                                //   var outputList = storedData['data'];
                                //   print('output list ${ outputList['name']}');
                                //   // canProceed = true;
                                //   setState(() {
                                //     tvName = outputList['name'];
                                //     // billerId = outputList[0]['id'];
                                //     // divisionId = outputList[0]['division'];
                                //     // productId = outputList[0]['product'];
                                //     // isNetworkSelected = true;
                                //   });
                                // },
                                // onChanged: (text) {
                                //   setState(() {
                                //     // _selectedCarrier = getCarrier(text);
                                //     // selectnetworkController.text =
                                //     //     _selectedCarrier!;
                                //     isTextFieldEmpty =
                                //         text.isNotEmpty && text.length == 11;
                                //   });
                                // },

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
                                  if (value.length > 20) {
                                    return 'Smart Card Number must be less 15 Digits';
                                  }
                                  return null;
                                },
                                // onEditingComplete: () {
                                //   print(billerId);
                                //   utilityResponseController.validateCustomer(
                                //       smartcardController.text.trim(),
                                //       divisionId,
                                //       description,
                                //       productId,
                                //       billerId);
                                //   // _checkFieldsAndHitApi();
                                // },
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
                                        color: Colors.red, width: 1.0),
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
                      backgroundColor: (tvFormKey.currentState != null &&
                              tvFormKey.currentState!.validate())
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
                      if (tvFormKey.currentState != null &&
                          tvFormKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        var billerLists = Hive.box('Cable TV');
                        var storedData = billerLists.get('Cable TV');
                        storedData['data'];
                        // print(_selectedCarrier!);
                        var outputList = storedData['data']
                            .where((o) => o['name'] == _selectedCarrier!)
                            .toList();
                        // print('output list ${outputList}');

                        // print(smartcardController.text);
                        // print(amountController.text);
                        // print(description);
                        // print(_selectedCarrier!);
                        utilityResponseController
                            .validateCustomer(smartcardController.text,
                                divisionId, description!, productId, billerId)
                            .then((value) {
                          var customerVerification =
                              Hive.box('customerValidation');
                          var storedData = customerVerification.get(billerId);
                          //  storedData['data'];
                          // print(_selectedCarrier!);
                          var customerInfo = storedData['data'];
                          // print('customer info ${customerInfo['name']}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AirtimeConfirmation(
                                number: smartcardController.text,
                                amount: int.parse(amountController.text),
                                image: _selectedImage!.replaceAll(' ', ''),
                                billerId: billerId!,
                                name: outputList[0]['name'],
                                divisionId: divisionId!,
                                productId: productId!,
                                category: description!,
                                customerName: customerInfo['name'],
                              ),
                            ),
                          );
                        });
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
