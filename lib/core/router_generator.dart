// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rentspace/view/auth/multiple_device_login_otp_page.dart';
import 'package:rentspace/view/auth/registration/login_page.dart';
import 'package:rentspace/view/auth/registration/signup_page.dart';
import 'package:rentspace/view/contact/contact_us.dart';
import 'package:rentspace/view/onboarding/FirstPage.dart';
import 'package:rentspace/view/onboarding/home_page.dart';
import 'package:rentspace/view/onboarding/onboarding_slider.dart';
import 'package:rentspace/view/onboarding/splash_screen.dart';
import 'package:rentspace/view/portfolio/portfolio_overview.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_creation.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_list.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_success_page.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_withdrawal.dart';
import 'package:rentspace/view/withdrawal/withdraw_continuation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/auth/password/change_password.dart';
import '../view/credit_score/credit_score_page.dart';
import '../view/faq/faqs.dart';
import '../view/history/all_activities.dart';
import '../view/loan/loan_details.dart';
import '../view/loan/loan_payment_confirmation_page.dart';
import '../view/loan/loan_success_page.dart';
import '../view/loan/loans_page.dart';
import '../view/referral/share_and_earn.dart';
import '../view/settings/personal_details.dart';
import '../view/settings/security.dart';
import '../view/settings/theme/theme_page.dart';
import '../view/utility/airtime.dart';
import '../view/wallet_funding/bank_transfer.dart';
import '../view/wallet_funding/fund_wallet.dart';
import '../view/withdrawal/select_account.dart';
import '../view/withdrawal/withdrawal_account.dart';

// static BuildContext? get ctx => myGoRouter.routerDelegate.navigatorKey.currentContext;

final GlobalKey<NavigatorState> _key = GlobalKey<NavigatorState>();

Future<bool> isAuthTokenAvailable() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('authToken');
  return token != null;
}

final routerGenerator = GoRouter(
  initialLocation: '/',
  navigatorKey: _key,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      name:
          'home', // Optional, add name to your routes. Allows you navigate by name instead of path
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: 'rentCreation',
      path: '/rentCreation',
      builder: (context, state) => const SpaceRentCreation(),
    ),
    GoRoute(
      name: 'rentList',
      path: '/rentList',
      builder: (context, state) => const RentSpaceList(),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: 'onboardingSlider',
      path: '/onboardingSlider',
      builder: (context, state) => const OnboardingSlider(),
    ),
    GoRoute(
      name: 'signup',
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      name: 'homepage',
      path: '/homepage',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: 'firstpage',
      path: '/firstpage',
      builder: (context, state) => const FirstPage(),
    ),
    GoRoute(
      name: 'contactUs',
      path: '/contactUs',
      builder: (context, state) => const ContactUsPage(),
    ),
    GoRoute(
      name: 'fundWallet',
      path: '/fundWallet',
      builder: (context, state) => const FundWallet(),
    ),
    GoRoute(
      name: 'bannkTransfer',
      path: '/bannkTransfer',
      builder: (context, state) => const BankTransfer(),
    ),
    GoRoute(
      name: 'portfolioOverview',
      path: '/portfolioOverview',
      builder: (context, state) => const PortfolioOverview(),
    ),
    GoRoute(
      name: 'creditScorePage',
      path: '/creditScorePage',
      builder: (context, state) => const CreditScorePage(),
    ),
    GoRoute(
      name: 'themePage',
      path: '/themePage',
      builder: (context, state) => const ThemePage(),
    ),
    GoRoute(
      name: 'changePassword',
      path: '/changePassword',
      builder: (context, state) => const ChangePassword(),
    ),
    GoRoute(
      name: 'withdrawalAccount',
      path: '/withdrawalAccount',
      builder: (context, state) => const WithdrawalAccount(),
    ),
    GoRoute(
      name: 'shareAndEarn',
      path: '/shareAndEarn',
      builder: (context, state) => const ShareAndEarn(),
    ),
    GoRoute(
      name: 'faqsPage',
      path: '/faqsPage',
      builder: (context, state) => const FaqsPage(),
    ),
    GoRoute(
      name: 'personalDetails',
      path: '/personalDetails',
      builder: (context, state) => const PersonalDetails(),
    ),
    GoRoute(
      name: 'securityPage',
      path: '/securityPage',
      builder: (context, state) => const Security(),
    ),
    GoRoute(
      name: 'selectAccount',
      path: '/selectAccount',
      builder: (context, state) => const SelectAccount(),
    ),
    GoRoute(
      name: 'loanPage',
      path: '/loanPage',
      builder: (context, state) => const LoansPage(),
    ),
    GoRoute(
      name: 'loanDetails',
      path: '/loanDetails',
      builder: (context, state) => const LoanDetails(),
    ),
    GoRoute(
      name: 'loanSuccessPage',
      path: '/loanSuccessPage',
      builder: (context, state) => const LoanSuccessPage(),
    ),
    GoRoute(
      name: 'loanConfirmationPage',
      path: '/loanConfirmationPage',
      builder: (context, state) => const LoanPaymentConfirmationPage(),
    ),
    GoRoute(
      name: 'airtimePage',
      path: '/airtimePage',
      builder: (context, state) => const AirtimePage(),
    ),
    GoRoute(
      name: 'allActivities',
      path: '/allActivities',
      builder: (context, state) => const AllActivities(),
    ),
    GoRoute(
      name: 'rentWithdrawal',
      path: '/rentWithdrawal',
      builder: (context, state) => const SpaceRentWithdrawal(),
    ),
    GoRoute(
      name: 'multipleDeviceLoginOtp',
      path: '/multipleDeviceLoginOtp', // Define email as a parameter
      builder: (context, state) {
        Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return MultipleDeviceLoginOtpPage(
          email: extra['email'],
        );
      },
    ),
    // GoRoute(
    //   name: 'spacerentSuccessfulPage',
    //   path: '/spacerentSuccessfulPage', // Define email as a parameter
    //   builder: (context, state) {
    //     Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
    //     return SpaceRentSuccessPage(
    //       rentValue: extra['amount'],
    //       savingsValue: extra['intervalAmount'],
    //       startDate: extra['date'],
    //       durationType: extra['interval'],
    //       paymentCount: extra['paymentCount'],
    //       rentName: extra['rentName'],
    //       duration: extra['duration'],
    //       receivalDate: extra['dueDate'],

    //       // par2: extra['par2'],
    //     );
    //   },
    // ),
    GoRoute(
      name: 'withdrawContinuationPage',
      path: '/withdrawContinuationPage', // Define email as a parameter
      builder: (context, state) {
        Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return WithdrawContinuationPage(
          bankCode: extra['bankCode'],
          accountNumber: extra['accountNumber'],
          bankName: extra['bankName'],
          accountHolderName: extra['accountHolderName'],
        );
      },
    ),
  ],
  // redirect: (context, state) async {
  //   // Check for auth token availability
  //   bool loggedIn = await isAuthTokenAvailable();

  //   // If the user is not logged in, redirect to login
  //   if (!loggedIn && state.matchedLocation != '/login') {
  //     return '/login';
  //   }

  //   // If the user is logged in and trying to access login, redirect to homepage
  //   if (loggedIn && state.matchedLocation == '/login') {
  //     return '/homepage';
  //   }

  //   // No redirection required
  //   return null;
  // },
);
