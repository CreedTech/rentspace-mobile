// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rentspace/view/auth/password/change_password.dart';
import 'package:rentspace/view/withdrawal/withdrawal_account.dart';
import '../../controller/auth/auth_controller.dart';
import '../../controller/auth/user_controller.dart';
import '../withdrawal/withdraw_page.dart';

class Security extends ConsumerStatefulWidget {
  const Security({super.key});

  @override
  ConsumerState<Security> createState() => _SecurityState();
}

final LocalAuthentication _localAuthentication = LocalAuthentication();

class _SecurityState extends ConsumerState<Security> {
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider.notifier);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                width: 4.h,
              ),
              Text(
                'Security',
                style: GoogleFonts.lato(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 24.w,
          ),
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 17, top: 10, right: 17, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).canvasColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0,
                          // horizontalTitleGap: 0,
                          minLeadingWidth: 0,
                          onTap: () {
                            context.push('/changePassword');
                          },
                          title: Text(
                            "Change Password",
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),

                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).dividerColor,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0,
                          // horizontalTitleGap: 0,
                          minLeadingWidth: 0,
                          onTap: () {
                            authState.forgotPin(
                                context,
                                userController
                                    .userModel!.userDetails![0].email);
                          },
                          title: Text(
                            'Change Transaction Pin',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),

                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).dividerColor,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          minVerticalPadding: 0,
                          // horizontalTitleGap: 0,
                          minLeadingWidth: 0,
                          onTap: () {
                            (userController.userModel!.userDetails![0]
                                        .withdrawalAccount ==
                                    null)
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const WithdrawalPage(
                                              withdrawalType: 'space wallet',
                                            )),
                                  )
                                : context.push('/withdrawalAccount');
                          },
                          title: Text(
                            'Withdrawal Account',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),

                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
