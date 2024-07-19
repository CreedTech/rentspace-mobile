// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../constants/colors.dart';
import '../../widgets/custom_loader.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/utility/utility_response_controller.dart';
import '../../controller/wallet/wallet_controller.dart';
import 'airtime_confirmation.dart';
import 'data.dart';

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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AirtimeConfirmation(
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
