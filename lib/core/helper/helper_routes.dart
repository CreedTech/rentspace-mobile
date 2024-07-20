import 'package:flutter/material.dart';
import 'package:rentspace/view/referral/referral_record.dart';
import 'package:rentspace/view/receipts/transaction_receipt.dart';
import 'package:rentspace/view/settings/personal_details.dart';
import 'package:rentspace/view/withdrawal/withdraw_page.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_list.dart';
import 'package:rentspace/view/auth/registration/signup_page.dart';
import 'package:rentspace/view/utility/airtime.dart';
import 'package:rentspace/view/utility/cable.dart';
import 'package:rentspace/view/utility/data.dart';
import 'package:rentspace/view/utility/electricity.dart';

import '../../view/savings/spaceRent/spacerent_creation.dart';
import '../components/component_route_animation.dart';
import 'helper_route_path.dart';


import 'dart:async';
import 'package:flutter/services.dart';

class RouterGenerator {
  Route<dynamic> generate(RouteSettings settings) {
    // final arguments = settings.arguments;
    switch (settings.name) {
      case referral_record:
        return MaterialPageRoute(
          builder: (context) => const ReferralRecord(),
          settings: const RouteSettings(name: referral_record),
        );
      case withdrawal:
        return MaterialPageRoute(
          builder: (context) => const WithdrawalPage(
            withdrawalType: 'space wallet',
          ),
          settings: const RouteSettings(name: withdrawal),
        );
      case personalInfo:
        return MaterialPageRoute(
          builder: (context) => const PersonalDetails(),
          settings: const RouteSettings(name: personalInfo),
        );
      case rentList:
        return MaterialPageRoute(
          builder: (context) => const RentSpaceList(),
          settings: const RouteSettings(name: rentList),
        );
      case rentCreation:
        return MaterialPageRoute(
          builder: (context) => const SpaceRentCreation(),
          settings: const RouteSettings(name: rentCreation),
        );
      case register:
        return MaterialPageRoute(
          builder: (context) => const SignupPage(),
          settings: const RouteSettings(name: register),
        );
      case transactionDetails:
        return MaterialPageRoute(
          builder: (context) => const TransactionReceipt(),
          settings: const RouteSettings(name: transactionDetails),
        );
      case airtime:
        return MaterialPageRoute(
          builder: (context) => const AirtimePage(),
          settings: const RouteSettings(name: airtime),
        );
      case dataBundle:
        return MaterialPageRoute(
          builder: (context) => const DataBundleScreen(),
          settings: const RouteSettings(name: dataBundle),
        );
      case electricity:
        return MaterialPageRoute(
          builder: (context) => const Electricity(),
          settings: const RouteSettings(name: electricity),
        );
      case cable:
        return MaterialPageRoute(
          builder: (context) => const CableScreen(),
          settings: const RouteSettings(name: cable),
        );
      default:
        return onUnknownRoute(const RouteSettings(name: '/Feature'));
    }
  }

  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text('Feature Comming soon..'),
        ),
      ),
    );
  }

  // Handle incoming deep links
  // Future<void> initDeepLinks(BuildContext context) async {
  //   try {
  //     Uri? initialUri = await getInitialUri();
  //     _handleDeepLink(initialUri, context);
  //   } on PlatformException {
  //     // Handle exception - could occur if platform doesn't support deep linking
  //   }

  //   getUriLinksStream().listen((Uri? uri) {
  //     _handleDeepLink(uri, context);
  //   }, onError: (err) {
  //     // Handle stream error
  //   });
  // }

  // void _handleDeepLink(Uri? uri, BuildContext context) {
  //   if (uri != null) {
  //     // Example deep link handling
  //     if (uri.pathSegments.isNotEmpty) {
  //       switch (uri.pathSegments.first) {
  //         case 'referral':
  //           Navigator.of(context).pushNamed(referral_record);
  //           break;
  //         case 'withdrawal':
  //           Navigator.of(context).pushNamed(withdrawal);
  //           break;
  //         // Add cases for other deep link routes as needed...
  //         default:
  //           // Handle unknown deep links
  //           Navigator.of(context)
  //               .push(onUnknownRoute(RouteSettings(name: uri.path)));
  //           break;
  //       }
  //     }
  //   }
  // }
}

class CustomPageRouteBuilder extends PageRouteBuilder<dynamic> {
  final Widget? page;
  final ComponentPageTransitionAnimation? transitionAnimation;
  final RouteSettings? routeSettings;

  CustomPageRouteBuilder(
      this.page, this.transitionAnimation, this.routeSettings)
      : super(
          settings: routeSettings,
          pageBuilder:
              (final context, final animation, final secondaryAnimation) =>
                  page!,
          transitionsBuilder: (final context, final animation,
                  final secondaryAnimation, final child) =>
              ComponentRouteAnimation.getAnimation(
            context,
            animation,
            secondaryAnimation,
            child,
            transitionAnimation!,
          ),
        );
}
