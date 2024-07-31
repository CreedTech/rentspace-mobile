import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/view/dashboard/bank_transfer_popup.dart';

import '../../api/global_services.dart';
import '../../constants/colors.dart';

void fundWalletPopup(
  BuildContext context,
) {
  showModalBottomSheet(
    enableDrag: false,
    isDismissible: false,
    barrierColor: Colors.transparent,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    context: context,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.93,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 25.h),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(19),
          ),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.5.w,
                                vertical: 4.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: brandTwo,
                                borderRadius: BorderRadius.circular(
                                  80,
                                ),
                              ),
                              child: Text(
                                '1',
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: colorWhite,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                // padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: brandTwo,
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: const CircleAvatar(
                                  backgroundColor: brandTwo,
                                  radius: 6,
                                  child: Icon(
                                    Icons.check,
                                    color: colorWhite,
                                    size: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 28,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                            child: LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                return Flex(
                                  direction: Axis.horizontal,
                                  children: List.generate(
                                    5,
                                    (_) {
                                      return const SizedBox(
                                        width: 5,
                                        height: 1,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: brandTwo,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.5.w,
                            vertical: 4.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: brandTwo,
                            borderRadius: BorderRadius.circular(
                              80,
                            ),
                          ),
                          child: Text(
                            '2',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: colorWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await GlobalService.sharedPreferencesManager
                          .setIsFirstTimeSignUp(value: false)
                          .then(
                            (value) => context.go('/firstpage'),
                          );
                      // Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      color: Color(0xffA2A1A1),
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 22.h,
              ),
              Text(
                'Add Money',
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: colorBlack,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                'Choose how you want to fund your wallet',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: colorBlack,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colorWhite,
                    ),
                    child: ListTile(
                      onTap: () {
                        // Navigator.pop(context);
                        bankTransferPopup(context);
                      },
                      contentPadding:
                          const EdgeInsets.only(left: 15, right: 11),
                      tileColor: colorWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xffEEF8FF).withOpacity(0.1)
                              : const Color(0xffEEF8FF),
                        ),
                        child: Image.asset(
                          'assets/icons/send.png',
                          width: 19.5,
                          height: 19.5,
                          // color: brandTwo,
                        ),
                      ),
                      title: Text(
                        'Bank Transfer',
                        style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'From your bank app or internet bank',
                        style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colorWhite,
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 15, right: 11),
                      tileColor: Theme.of(context).canvasColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xffEEF8FF).withOpacity(0.1)
                              : const Color(0xffEEF8FF),
                        ),
                        child: Image.asset(
                          'assets/icons/ussd_icon.png',
                          width: 19.5,
                          height: 19.5,
                          // color: brandTwo,
                        ),
                      ),
                      title: Text(
                        'USSD',
                        style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Use your banks ussd code',
                        style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
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
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colorWhite,
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 15, right: 11),
                      tileColor: Theme.of(context).canvasColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xffEEF8FF).withOpacity(0.1)
                              : const Color(0xffEEF8FF),
                        ),
                        child: Image.asset(
                          'assets/icons/card_icon.png',
                          width: 19.5,
                          height: 19.5,
                        ),
                      ),
                      title: Text(
                        'Card',
                        style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'From your debit card',
                        style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
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
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
