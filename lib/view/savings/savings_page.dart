import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/colors.dart';

import 'package:get/get.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_list.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../controller/auth/user_controller.dart';
import '../../controller/wallet/wallet_controller.dart';
import '../../widgets/custom_dialogs/index.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({
    super.key,
  });

  @override
  _SavingsPageState createState() => _SavingsPageState();
}

List savingOptions = [
  {
    'imageIcon': 'assets/icons/space_rent.png',
    'title': 'SpaceRent',
    'content': 'Save 70% of your rent and get 30% loan.',
    'locationInitial': 'SpaceRentIntro',
    'location': 'RentSpaceList',
  },
  {
    'imageIcon': 'assets/icons/space_deposit.png',
    'title': 'Space Deposit',
    'content':
        'Save 70% of rent for a minimum of 90 days at an interest of 14% and get 100% (Terms and conditions apply)',
    'locationInitial': 'SpaceDepositIntro',
    'location': 'SpaceDepositList',
  },
];

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');

double rentBalance = 0;
double targetBalance = 0;
double totalSavings = 0;
double totalAssets = 0;
bool hideBalance = false;

class _SavingsPageState extends State<SavingsPage> {
  final RentController rentController = Get.find();
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();

  getSavings() {
    if (rentController.rentModel!.rents!.isNotEmpty) {
      for (int j = 0; j < rentController.rentModel!.rents!.length; j++) {
        rentBalance += rentController.rentModel!.rents![j].paidAmount;
        targetBalance += rentController.rentModel!.rents![j].amount;
      }
    } else {
      setState(() {
        rentBalance = 0;
        targetBalance = 0;
      });
    }

    setState(() {
      totalSavings = (rentBalance);
      totalAssets =
          (walletController.walletModel!.wallet![0].mainBalance + rentBalance);
    });
  }

  @override
  initState() {
    super.initState();
    rentBalance = 0;
    targetBalance = 0;
    totalSavings = 0;
    totalAssets = 0;
    hideBalance = false;
    getSavings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Text(
            'Savings',
            style: GoogleFonts.lato(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: 24.w, top: 0, right: 24.w, bottom: 20.h),
            child: IntrinsicHeight(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: brandOne,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15.w, top: 14.h, right: 0.w, bottom: 14.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Space Rent',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: colorWhite,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    nairaFormaet.format(totalSavings),
                                    style: GoogleFonts.roboto(
                                      fontSize: 30,
                                      color: colorWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Space Deposit',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: const Color(0xffB9B9B9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '0',
                                  style: GoogleFonts.lato(
                                    fontSize: 30,
                                    color: const Color(0xffB9B9B9),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 40.h,
                      right: -10.w,
                      child: Transform.scale(
                        scale: MediaQuery.of(context).size.width /
                            300, // Adjust the reference width as needed
                        child: Image.asset(
                          'assets/logo_blue.png',
                          width: 103.91, // Width without scaling
                          height: 144.17, // Height without scaling
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 10.h),
            child: Text(
              'Top Savings',
              style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              // top: 45,
              bottom: 25,
              right: 24.w,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      (userController
                                  .userModel!.userDetails![0].hasVerifiedBvn ==
                              true)
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RentSpaceList(),
                              ),
                            )
                          : customErrorDialog(
                              context,
                              'Verification!',
                              'You need to verify your BVN in order to use this service!',
                            );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffEEF8FF),
                            ),
                            child: Image.asset(
                              'assets/icons/space_rent.png',
                              width: 19.5,
                              height: 19.5,
                              color: brandTwo,
                            ),
                          ),
                          title: Text(
                            'Space Rent',
                            style: GoogleFonts.lato(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            'Save 70% of your rent and get up to 30% loan.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(
                            Iconsax.arrow_right_3,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17.w),
                    child: Divider(
                      thickness: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showTopSnackBar(
                        Overlay.of(context),
                        CustomSnackBar.success(
                          backgroundColor: brandOne,
                          message: 'Coming soon !!',
                          textStyle: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffEEF8FF),
                            ),
                            child: Image.asset(
                              'assets/icons/lock_deposit_icon.png',
                              width: 19.5,
                              height: 19.5,
                            ),
                          ),
                          title: Text(
                            'Space Deposit',
                            style: GoogleFonts.lato(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            'Lock your money safely for later use.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xffEEF8FF),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "Coming Soon",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: brandOne,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
