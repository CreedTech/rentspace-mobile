import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:rentspace/constants/utils/snackbar.dart';
import 'package:rentspace/constants/widgets/separator.dart';
// import 'package:rentspace/controller/user_controller.dart';
// import 'package:rentspace/constants/theme_services.dart';
// import 'package:get_storage/get_storage.dart';
// import 'dart:io';
// import 'package:getwidget/getwidget.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/view/actions/card_topup.dart';
import 'package:rentspace/view/actions/wallet_funding.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

import '../../constants/widgets/custom_dialog.dart';

class FundWallet extends StatefulWidget {
  const FundWallet({Key? key}) : super(key: key);

  @override
  _FundWalletState createState() => _FundWalletState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
String _isSet = "false";
var dum1 = "".obs;

// CollectionReference users = FirebaseFirestore.instance.collection('accounts');
// CollectionReference allUsers =
//     FirebaseFirestore.instance.collection('accounts');

class _FundWalletState extends State<FundWallet> {
  final UserController userController = Get.find();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.close,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Fund Wallet',
          style: GoogleFonts.nunito(
              color: Theme.of(context).primaryColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: ListView(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: brandOne,
                    ),
                    child: const Icon(
                      Iconsax.bank,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Bank Transfer',
                    style: GoogleFonts.nunito(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    'Add money via your banking platforms',
                    style: GoogleFonts.nunito(
                      color: brandOne,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // onTap: () {
                  //       Get.to(const FinanceHealth());
                  //     },
                  // trailing: Icon(
                  //   Iconsax.arrow_right_3,
                  //   color: Theme.of(context).primaryColor,
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MySeparator(
                    height: 1,
                    color: Theme.of(context).cardColor,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rentspace Account Number',
                            style: GoogleFonts.nunito(
                              color: brandTwo,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                userController
                                    .userModel!.userDetails![0].dvaNumber,
                                style: GoogleFonts.nunito(
                                  color: brandOne,
                                  fontSize: 30.sp,
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: userController
                                          .userModel!.userDetails![0].dvaNumber
                                          .obs()
                                          .toString(),
                                    ),
                                  );

                                  Fluttertoast.showToast(
                                    msg: "Copied",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: brandOne,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                },
                                child: Icon(
                                  Icons.copy,
                                  size: 16.sp,
                                  color: brandOne,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bank',
                            style: GoogleFonts.nunito(
                              color: brandTwo,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Providus Bank',
                            style: GoogleFonts.nunito(
                              color: brandOne,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Name',
                            style: GoogleFonts.nunito(
                              color: brandTwo,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            userController.userModel!.userDetails![0].dvaName,
                            style: GoogleFonts.nunito(
                              color: brandOne,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MySeparator(
                    height: 1,
                    color: Theme.of(context).cardColor,
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: brandOne,
                    ),
                    child: const Icon(
                      Iconsax.card,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Top-up with Card',
                    style: GoogleFonts.nunito(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    'Add money via your bank card',
                    style: GoogleFonts.nunito(
                      color: brandOne,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Get.to(const CardTopUp());
                  },
                  trailing: Icon(
                    Iconsax.arrow_right_3,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
