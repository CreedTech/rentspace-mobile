import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/view/dashboard/dashboard.dart';

import '../../api/global_services.dart';
import '../../constants/colors.dart';

void bankTransferPopup(
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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Flexible(
                      flex: 2,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 27,
                        color: colorBlack,
                      ),
                    ),
                    Flexible(
                      flex: 8,
                      child: Text(
                        'Bank Transfer',
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: colorBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 240,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Account Number',
                          style: GoogleFonts.lato(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userController
                                  .userModel!.userDetails![0].dvaNumber,
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: userController.userModel!
                                            .userDetails![0].dvaNumber,
                                      ),
                                    );
                                    Fluttertoast.showToast(
                                      msg: "Copied to clipboard!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.SNACKBAR,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: brandOne,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/icons/copy_icon.png',
                                    width: 24,
                                    height: 24,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'Copy',
                                  style: GoogleFonts.lato(
                                    color: brandTwo,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bank',
                          style: GoogleFonts.lato(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Providus Bank',
                          style: GoogleFonts.lato(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Account Name',
                          style: GoogleFonts.lato(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          userController.userModel!.userDetails![0].dvaName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
