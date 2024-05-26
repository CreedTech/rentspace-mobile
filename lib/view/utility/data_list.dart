import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/constants/widgets/separator.dart';

import '../../api/global_services.dart';
import '../../constants/app_constants.dart';
import '../../constants/colors.dart';
import 'package:http/http.dart' as http;

import '../../constants/widgets/custom_dialog.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../controller/app_controller.dart';
import '../../controller/auth/user_controller.dart';
import '../../controller/wallet_controller.dart';
import '../actions/fund_wallet.dart';

class DataListScreen extends ConsumerStatefulWidget {
  const DataListScreen(
      {super.key,
      required this.number,
      required this.network,
      required this.image});
  final String number, network, image;

  @override
  ConsumerState<DataListScreen> createState() => _DataListScreenState();
}

class _DataListScreenState extends ConsumerState<DataListScreen> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController _aPinController = TextEditingController();
  String? selectedItem;
  String? selectedItemAmount;
  String? selectedItemValidity;
  bool isSelected = false;
  List<String> _amount = [];
  List<String> _dataName = [];
  List<String> _dataValidity = [];
  bool _canShowOptions = false;

  void validateUsersInput() {
    // if (airtimeformKey.currentState!.validate()) {
    int amount = int.parse(selectedItemAmount!);
    String number = widget.number;
    String selectedDataPlan = selectedItem!;
    String network = widget.network;
    String validity = selectedItemValidity!;

    confirmPayment(
        context, amount, number, selectedDataPlan, network, validity);
    // }
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

  getDataBundles() async {
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    final response = await http.post(
      Uri.parse(AppConstants.BASE_URL + AppConstants.GET_DATA_VARIATION_CODES),
      headers: {
        'Authorization': 'Bearer $authToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "selectedNetwork": widget.network,
      }),
    );
    EasyLoading.dismiss();
    // print(response);

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var jsonResponse = jsonDecode(response.body);
      print('jsonResponse');
      List<String> dataAmount = [];
      List<String> dataName = [];
      List<String> dataValidity = [];
      // tempName.add("Select bank");
      for (var item in jsonResponse['amount_options']) {
        String amount = item['amount'];
        String name = item['name'];
        String validity = item['validity'];
        // String name = item['name'];
        if (name != "") {
          dataAmount.add(amount);
          dataName.add(name);
          dataValidity.add(validity);
        }
      }
      if (!mounted) return;
      setState(() {
        _amount = dataAmount;
        _dataName = dataName;
        _dataValidity = dataValidity;
        // _bankCode = tempCode;

        _canShowOptions = true;
      });
    } else {
      EasyLoading.dismiss();
      print('Failed to load data from the server');
    }
  }

  @override
  initState() {
    super.initState();
    getDataBundles();
    fetchUserData();
    // _searchController = TextEditingController();
    // _searchController.addListener(_onSearchChanged);
    isSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Choose Data Bundle',
          style: GoogleFonts.lato(
            color: brandOne,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        // bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 30.h, bottom: 20.h
                                  // horizontal: 20.w,
                                  ),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 0.1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  // padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(widget.image),
                                    ),
                                  ),
                                  // ),
                                ),
                              ),
                            ),
                            Text(
                              widget.network,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              widget.number,
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Choose Bundle',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                            color: brandOne,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      (_canShowOptions)
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: brandOne,
                                border: Border.all(width: 2, color: brandOne),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _dataName.length,
                                  itemBuilder: (context, index) {
                                    final amountInfo = _amount[index];
                                    final nameInfo = _dataName[index];
                                    final validityInfo = _dataValidity[index];
                                    return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedItem = nameInfo;
                                            selectedItemAmount = amountInfo;
                                            selectedItemValidity = validityInfo;
                                            isSelected = true;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: selectedItem == nameInfo
                                                ? Colors.white
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: ListTile(
                                            minLeadingWidth: 0,
                                            leading: (selectedItem == nameInfo)
                                                ? const Icon(Icons.check)
                                                : null,
                                            title: Text(
                                              nameInfo,
                                              style: GoogleFonts.lato(
                                                color: selectedItem == nameInfo
                                                    ? brandOne
                                                    : Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            trailing: Text(
                                              NumberFormat.simpleCurrency(
                                                      name: 'N',
                                                      decimalDigits: 0)
                                                  .format(
                                                      double.parse(amountInfo)),
                                              style: GoogleFonts.roboto(
                                                color: selectedItem == nameInfo
                                                    ? brandOne
                                                    : Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            selected: selectedItem == nameInfo,
                                            selectedColor: brandOne,
                                          ),
                                        ));
                                  }),
                            )
                          : Column(
                              children: [
                                SizedBox(height: 30.h),
                                Text(
                                  'Loading Data...',
                                  style: GoogleFonts.lato(
                                    color: brandOne,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const CustomLoader(),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
            (isSelected)
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // height: 160,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: brandOne,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Selected',
                              style: GoogleFonts.lato(
                                color: brandTwo,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                selectedItem!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              trailing: Text(
                                NumberFormat.simpleCurrency(
                                        name: 'N', decimalDigits: 0)
                                    .format(double.parse(selectedItemAmount!)),
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const MySeparator(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(200, 50),
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      50,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (isSelected) {
                                    FocusScope.of(context).unfocus();
                                    await fetchUserData()
                                        .then((value) => validateUsersInput())
                                        .catchError(
                                          (error) => {
                                            customErrorDialog(context, 'Oops',
                                                'Something went wrong. Try again later'),
                                          },
                                        );
                                    // validateUsersInput();
                                  }
                                },
                                child: Text(
                                  'Submit',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    // fontFamily: 'Milliard',
                                    color: brandOne,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> confirmPayment(BuildContext context, int amount, String number,
      String selectDataPlan, String network, String validity) async {
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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          alignment: Alignment.bottomCenter,
          insetPadding: const EdgeInsets.all(0),
          title: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Text(
                  NumberFormat.simpleCurrency(name: 'NGN').format(amount),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    color: brandOne,
                  ),
                ),
                alert(context),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(20.0.r),
              borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          )),
          content: SizedBox(
            height: 400.h,
            // width: 390.h,
            child: SizedBox(
              width: 400.w,
              child: Column(
                children: [
                  Stack(children: [
                    SizedBox(
                      height: 18.h,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.h, horizontal: 15.h),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Provider Network',
                                  style: GoogleFonts.lato(
                                    color: brandTwo,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Image.asset(
                                        widget.image,
                                        height: 20.h,
                                        width: 20.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 9.w,
                                    ),
                                    Text(
                                      widget.network,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        color: brandOne,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recipient Number',
                                  style: GoogleFonts.lato(
                                    color: brandTwo,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  number,
                                  style: GoogleFonts.lato(
                                    color: brandOne,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Amount',
                                  style: GoogleFonts.lato(
                                    color: brandTwo,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  NumberFormat.simpleCurrency(name: 'NGN')
                                      .format(amount),
                                  style: GoogleFonts.roboto(
                                    color: brandOne,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 11.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Transaction Fee',
                                  style: GoogleFonts.lato(
                                    color: brandTwo,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  NumberFormat.simpleCurrency(name: 'NGN')
                                      .format(0),
                                  style: GoogleFonts.roboto(
                                    color: brandOne,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payment Method',
                                  style: GoogleFonts.lato(
                                    color: brandOne,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.end,
                                //   children: [
                                //     Text(
                                //       'Space Wallet',
                                //       style: GoogleFonts.lato(
                                //         color: brandOne,
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ),
                                //     Text(
                                //       NumberFormat.simpleCurrency(name: 'NGN').format(userController.userModel!
                                //           .userDetails![0].wallet.mainBalance),
                                //       style: GoogleFonts.lato(
                                //         color: brandOne,
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ),
                                //   ],
                                // )
                              ],
                            ),
                            SizedBox(
                              height: 11.h,
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              decoration: BoxDecoration(
                                color: brandTwo.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  Icons.wallet,
                                  color: ((amount) >
                                          walletController.walletModel!
                                              .wallet![0].mainBalance)
                                      ? Colors.grey
                                      : brandOne,
                                  size: 25,
                                ),
                                title: RichText(
                                  // textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Balance",
                                        style: GoogleFonts.lato(
                                          color: ((amount) >
                                                  walletController.walletModel!
                                                      .wallet![0].mainBalance)
                                              ? Colors.grey
                                              : brandOne,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '(${NumberFormat.simpleCurrency(name: 'NGN').format(walletController.walletModel!.wallet![0].mainBalance)})',
                                        style: GoogleFonts.lato(
                                          color: ((amount) >
                                                  walletController.walletModel!
                                                      .wallet![0].mainBalance)
                                              ? Colors.grey
                                              : brandOne,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: ((amount) >
                                        walletController.walletModel!.wallet![0]
                                            .mainBalance)
                                    ? Text(
                                        'Insufficient Balance',
                                        style: GoogleFonts.lato(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      )
                                    : null,
                                trailing: ((amount) >
                                        walletController.walletModel!.wallet![0]
                                            .mainBalance)
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.to(const FundWallet());
                                        },
                                        child: Wrap(
                                          alignment: WrapAlignment.end,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.end,
                                          children: [
                                            Text(
                                              'Top up',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.lato(
                                                color: brandOne,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: brandOne,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      )
                                    : Icon(
                                        Icons.check,
                                        color: brandOne,
                                        size: 20,
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: 35.h,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(250, 50),
                                backgroundColor: (((amount) >
                                        walletController.walletModel!.wallet![0]
                                            .mainBalance))
                                    ? Colors.grey
                                    : brandOne,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    50,
                                  ),
                                ),
                              ),
                              onPressed: ((amount) >
                                      walletController
                                          .walletModel!.wallet![0].mainBalance)
                                  ? null
                                  : () async {
                                      FocusScope.of(context).unfocus();
                                      Get.bottomSheet(
                                        isDismissible: true,
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 400.h,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(30.0),
                                              topRight: Radius.circular(30.0),
                                            ),
                                            child: Container(
                                              color:
                                                  Theme.of(context).canvasColor,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // const SizedBox(
                                                  //   height: 50,
                                                  // ),

                                                  SizedBox(
                                                    height: 20.h,
                                                  ),
                                                  Pinput(
                                                    useNativeKeyboard: false,
                                                    obscureText: true,
                                                    defaultPinTheme: PinTheme(
                                                      width: 50,
                                                      height: 50,
                                                      textStyle:
                                                          GoogleFonts.lato(
                                                        color: brandOne,
                                                        fontSize: 28,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    focusedPinTheme: PinTheme(
                                                      width: 50,
                                                      height: 50,
                                                      textStyle: TextStyle(
                                                        fontSize: 25,
                                                        color: brandOne,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: brandOne,
                                                            width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    submittedPinTheme: PinTheme(
                                                      width: 50,
                                                      height: 50,
                                                      textStyle: TextStyle(
                                                        fontSize: 25,
                                                        color: brandOne,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: brandOne,
                                                            width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    followingPinTheme: PinTheme(
                                                      width: 50,
                                                      height: 50,
                                                      textStyle: TextStyle(
                                                        fontSize: 25,
                                                        color: brandOne,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: brandTwo,
                                                            width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
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
                                                        // _aPinController.clear();
                                                        Get.back();
                                                        appState.buyData(
                                                            context,
                                                            amount,
                                                            number.toString(),
                                                            selectDataPlan,
                                                            network,
                                                            validity);
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
                                                    // validator: validatePinOne,
                                                    // onChanged: validatePinOne,
                                                    controller: _aPinController,
                                                    length: 4,
                                                    closeKeyboardWhenCompleted:
                                                        true,
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                  NumericKeyboard(
                                                    onKeyboardTap:
                                                        (String value) {
                                                      setState(() {
                                                        _aPinController.text =
                                                            _aPinController
                                                                    .text +
                                                                value;
                                                      });
                                                    },
                                                    textStyle: GoogleFonts.lato(
                                                      color: brandOne,
                                                      fontSize: 24,
                                                    ),
                                                    rightButtonFn: () {
                                                      if (_aPinController
                                                          .text.isEmpty) return;
                                                      setState(() {
                                                        _aPinController.text =
                                                            _aPinController.text
                                                                .substring(
                                                                    0,
                                                                    _aPinController
                                                                            .text
                                                                            .length -
                                                                        1);
                                                      });
                                                    },
                                                    rightButtonLongPressFn: () {
                                                      if (_aPinController
                                                          .text.isEmpty) return;
                                                      setState(() {
                                                        _aPinController.text =
                                                            '';
                                                      });
                                                    },
                                                    rightIcon: const Icon(
                                                      Icons.backspace_outlined,
                                                      color: Colors.red,
                                                    ),
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                              child: Text(
                                'Pay',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Get.bottomSheet(
                            //       isDismissible: true,
                            //       SizedBox(
                            //         width: MediaQuery.of(context).size.width,
                            //         height: 350,
                            //         child: ClipRRect(
                            //           borderRadius: const BorderRadius.only(
                            //             topLeft: Radius.circular(30.0),
                            //             topRight: Radius.circular(30.0),
                            //           ),
                            //           child: Container(
                            //             color: Theme.of(context).canvasColor,
                            //             padding: const EdgeInsets.fromLTRB(
                            //                 10, 5, 10, 5),
                            //             child: Column(
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.center,
                            //               children: [
                            //                 const SizedBox(
                            //                   height: 50,
                            //                 ),
                            //                 Text(
                            //                   'Enter PIN to Proceed',
                            //                   style: GoogleFonts.lato(
                            //                       fontSize: 18,
                            //                       color: Theme.of(context)
                            //                           .primaryColor,
                            //                       fontWeight: FontWeight.w700),
                            //                   textAlign: TextAlign.center,
                            //                 ),
                            //                 const SizedBox(
                            //                   height: 20,
                            //                 ),
                            //                 Pinput(
                            //                   obscureText: true,
                            //                   defaultPinTheme: PinTheme(
                            //                     width: 50,
                            //                     height: 50,
                            //                     textStyle: const TextStyle(
                            //                       fontSize: 20,
                            //                       color: brandOne,
                            //                     ),
                            //                     decoration: BoxDecoration(
                            //                       border: Border.all(
                            //                           color: brandTwo,
                            //                           width: 1.0),
                            //                       borderRadius:
                            //                           BorderRadius.circular(5),
                            //                     ),
                            //                   ),
                            //                   onCompleted: (String val) {
                            //                     if (BCrypt.checkpw(
                            //                       _aPinController.text
                            //                           .trim()
                            //                           .toString(),
                            //                       userController
                            //                           .userModel!
                            //                           .userDetails![0]
                            //                           .wallet
                            //                           .pin,
                            //                     )) {
                            //                       _aPinController.clear();
                            //                       Get.back();
                            //                       // _doWallet();
                            //                       appState.buyAirtime(
                            //                           context,
                            //                           amount,
                            //                           number.toString(),
                            //                           bill,
                            //                           biller);
                            //                     } else {
                            //                       _aPinController.clear();
                            //                       if (context.mounted) {
                            //                         customErrorDialog(
                            //                             context,
                            //                             "Invalid PIN",
                            //                             'Enter correct PIN to proceed');
                            //                       }
                            //                     }
                            //                   },
                            //                   validator: validatePinOne,
                            //                   onChanged: validatePinOne,
                            //                   controller: _aPinController,
                            //                   length: 4,
                            //                   closeKeyboardWhenCompleted: true,
                            //                   keyboardType:
                            //                       TextInputType.number,
                            //                 ),
                            //                 const SizedBox(
                            //                   height: 20,
                            //                 ),
                            //                 const SizedBox(
                            //                   height: 40,
                            //                 ),
                            //                 ElevatedButton(
                            //                   style: ElevatedButton.styleFrom(
                            //                     minimumSize:
                            //                         const Size(300, 50),
                            //                     backgroundColor: brandOne,
                            //                     elevation: 0,
                            //                     shape: RoundedRectangleBorder(
                            //                       borderRadius:
                            //                           BorderRadius.circular(
                            //                         10,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   onPressed: () {
                            //                     if (BCrypt.checkpw(
                            //                       _aPinController.text
                            //                           .trim()
                            //                           .toString(),
                            //                       userController
                            //                           .userModel!
                            //                           .userDetails![0]
                            //                           .wallet
                            //                           .pin,
                            //                     )) {
                            //                       _aPinController.clear();
                            //                       Get.back();
                            //                       // _doWallet();
                            //                       appState.buyAirtime(
                            //                           context,
                            //                           amount,
                            //                           number.toString(),
                            //                           bill,
                            //                           biller);
                            //                     } else {
                            //                       _aPinController.clear();
                            //                       if (context.mounted) {
                            //                         customErrorDialog(
                            //                             context,
                            //                             "Invalid PIN",
                            //                             'Enter correct PIN to proceed');
                            //                       }
                            //                     }
                            //                   },
                            //                   child: Text(
                            //                     'Proceed to Payment',
                            //                     textAlign: TextAlign.center,
                            //                     style: GoogleFonts.lato(
                            //                       color: Colors.white,
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.w700,
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //         color: brandOne,
                            //         borderRadius: BorderRadius.circular(15)),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(13),
                            //       child: Align(
                            //         child: Text(
                            //           'Pay',
                            //           textAlign: TextAlign.center,
                            //           style: GoogleFonts.lato(
                            //             color: Colors.white,
                            //             fontSize: 19,
                            //             fontWeight: FontWeight.w600,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
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

  GestureDetector alert(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: null,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.h),
                ),
                content: SizedBox(
                  height: 200.h,
                  width: 400.h,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.of(context).pop();
                      //   },
                      //   child: Align(
                      //     alignment: Alignment.topRight,
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(30.h),
                      //         color: Colors.red,
                      //       ),
                      //       child: Padding(
                      //         padding: EdgeInsets.all(10.h),
                      //         child: Icon(
                      //           Iconsax.close_circle,
                      //           color: Colors.red,
                      //           size: 20,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Payment Not completed',
                        style: GoogleFonts.lato(
                          color: brandOne,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        'Do you want to cancel this payment?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            color: brandOne,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 50),
                              backgroundColor: brandOne,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  50,
                                ),
                              ),
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Proceed to Pay',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 50),
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  50,
                                ),
                                side:
                                    const BorderSide(color: brandOne, width: 1),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: brandOne,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                ),
              );
            });
      },
      child: Icon(
        Icons.close,
        color: brandOne,
        size: 20,
      ),
    );
  }
}
