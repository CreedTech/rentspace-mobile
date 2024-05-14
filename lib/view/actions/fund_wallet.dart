import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/widgets/separator.dart';

import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/view/actions/card_topup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class FundWallet extends StatefulWidget {
  const FundWallet({super.key});

  @override
  _FundWalletState createState() => _FundWalletState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'N');
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
var dum1 = "".obs;

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
          style: GoogleFonts.lato(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
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
                    style: GoogleFonts.lato(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    'Add money via your banking platforms',
                    style: GoogleFonts.lato(
                      color: brandOne,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
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
                            style: GoogleFonts.lato(
                              color: brandTwo,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                userController
                                    .userModel!.userDetails![0].dvaNumber,
                                style: GoogleFonts.lato(
                                  color: brandOne,
                                  fontSize: 25,
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.w600,
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
                                  size: 16,
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
                            style: GoogleFonts.lato(
                              color: brandTwo,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Providus Bank',
                            style: GoogleFonts.lato(
                              color: brandOne,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
                            style: GoogleFonts.lato(
                              color: brandTwo,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            userController.userModel!.userDetails![0].dvaName,
                            style: GoogleFonts.lato(
                              color: brandOne,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
                    style: GoogleFonts.lato(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    'Add money via your bank card',
                    style: GoogleFonts.lato(
                      color: brandOne,
                      fontSize: 12,
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
