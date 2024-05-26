import 'package:flutter/material.dart';
import 'package:rentspace/view/actions/referral_record.dart';
import 'package:rentspace/view/savings/spaceRent/spacerent_list.dart';
import 'package:rentspace/view/signup_page.dart';
import 'package:rentspace/view/utility/airtime.dart';
import 'package:rentspace/view/utility/cable.dart';
import 'package:rentspace/view/utility/data.dart';
import 'package:rentspace/view/utility/electricity.dart';

import '../components/component_route_animation.dart';
import 'helper_route_path.dart';

class RouterGenerator {
  Route<dynamic> generate(RouteSettings settings) {
    // final arguments = settings.arguments;
    switch (settings.name) {
 
      case referral_record:
        return MaterialPageRoute(
          builder: (context) => const ReferralRecord(),
          settings: const RouteSettings(name: referral_record),
        );
      case rentList:
        return MaterialPageRoute(
          builder: (context) => const RentSpaceList(),
          settings: const RouteSettings(name: rentList),
        );
      case register:
        return MaterialPageRoute(
          builder: (context) => const SignupPage(),
          settings: const RouteSettings(name: register),
        );
      // case phone_number_otp:
      //   return MaterialPageRoute(
      //     builder: (context) => PhoneNumberOtpView(
      //       phone_number: arguments as String,
      //     ),
      //     settings: const RouteSettings(name: phone_number_otp),
      //   );
      // case finish:
      //   return MaterialPageRoute(
      //     builder: (context) => FinishRegistrationView(
      //       phone_number: arguments as String,
      //     ),
      //     settings: const RouteSettings(name: finish),
      //   );
      // case login:
      //   return MaterialPageRoute(
      //     builder: (context) => const LoginPage(),
      //     settings: const RouteSettings(name: login),
      //   );
      // case forgotPass:
      //   return MaterialPageRoute(
      //     builder: (context) => const ForgotPasswordView(),
      //     settings: const RouteSettings(name: forgotPass),
      //   );
      // case forgotPass_otp_verify:
      //   return MaterialPageRoute(
      //     builder: (context) => ForgotPasswordOtpVerification(
      //       email: arguments as String,
      //     ),
      //     settings: const RouteSettings(name: forgotPass_otp_verify),
      //   );
      // case otp_verify:
      //   return MaterialPageRoute(
      //     builder: (context) => OtpView(
      //       email: arguments as String,
      //     ),
      //     settings: const RouteSettings(name: otp_verify),
      //   );
      // case reset_password:
      //   return MaterialPageRoute(
      //     builder: (context) =>
      //         ResetPasswordView(email: arguments as String, token: arguments),
      //     settings: const RouteSettings(name: reset_password),
      //   );
      // case home:
      //   return MaterialPageRoute(
      //     builder: (context) => const NavigationViews(),
      //     settings: const RouteSettings(name: home),
      //   );
      // case history:
      //   return MaterialPageRoute(
      //     builder: (context) => const HistoryView(),
      //     settings: const RouteSettings(name: history),
      //   );
      // case order:
      //   return MaterialPageRoute(
      //     builder: (context) => OrderView(
      //       pickup_address: arguments as String,
      //       delivery_address: arguments,
      //       lng: arguments,
      //       lat: arguments,
      //       house_number: arguments,
      //       street: arguments,
      //       area: arguments,
      //     ),
      //     settings: const RouteSettings(name: order),
      //   );
      // case order_two:
      //   return MaterialPageRoute(
      //     builder: (context) => OrderTwoView(
      //       pickup_address: arguments as String,
      //       delivery_address: arguments,
      //       title: arguments,
      //       weight: arguments,
      //       lng: arguments,
      //       lat: arguments,
      //       house_number: arguments,
      //       street: arguments,
      //       area: arguments,
      //     ),
      //     settings: const RouteSettings(name: order_two),
      //   );
      // case order_three:
      //   return MaterialPageRoute(
      //     builder: (context) => OrderThreeView(
      //       pickup_address: arguments as String,
      //       delivery_address: arguments,
      //       title: arguments,
      //       weight: arguments,
      //       sender_full_name: arguments,
      //       sender_phone_number: arguments,
      //       receiver_full_name: arguments,
      //       receiver_phone_number: arguments,
      //       note: arguments,
      //       terminal_lng: arguments,
      //       terminal_lat: arguments,
      //       lat: arguments,
      //       lng: arguments,
      //       house_number: arguments,
      //       street: arguments,
      //       area: arguments,
      //     ),
      //     settings: const RouteSettings(name: order_three),
      //   );
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
      // case utilitytransactionReceipt:
      //   return MaterialPageRoute(
      //     builder: (context) => const UtilityTransactionReceipt(),
      //     settings: const RouteSettings(name: utilitytransactionReceipt),
      //   );
      // case my_information:
      //   return MaterialPageRoute(
      //     builder: (context) => const MyInformationView(),
      //     settings: const RouteSettings(name: my_information),
      //   );
      // case terms_conditions:
      //   return MaterialPageRoute(
      //     builder: (context) => const TermsAndConditionsView(),
      //     settings: const RouteSettings(name: terms_conditions),
      //   );
      // case faqs:
      //   return MaterialPageRoute(
      //     builder: (context) => const FAQView(),
      //     settings: const RouteSettings(name: faqs),
      //   );
      // case about_us:
      //   return MaterialPageRoute(
      //     builder: (context) => const AboutUsView(),
      //     settings: const RouteSettings(name: about_us),
      //   );
      // case help:
      //   return MaterialPageRoute(
      //     builder: (context) => const HelpView(),
      //     settings: const RouteSettings(name: help),
      //   );
      // case change_phone_number:
      //   return MaterialPageRoute(
      //     builder: (context) => const ChangePhoneNumber(),
      //     settings: const RouteSettings(name: change_phone_number),
      //   );
      // case change_phone_otp:
      //   return MaterialPageRoute(
      //     builder: (context) => ChangePhoneOtpView(
      //       phone_number: arguments as String,
      //     ),
      //     settings: const RouteSettings(name: change_phone_otp),
      //   );
      // case search:
      //   return MaterialPageRoute(
      //     builder: (context) => const SearchView(),
      //     settings: const RouteSettings(name: search),
      //   );
      // case details:
      //   return MaterialPageRoute(
      //     builder: (context) => DetailsView(
      //       id: arguments as int,
      //     ),
      //     settings: const RouteSettings(name: details),
      //   );
      // case package_details:
      //   return MaterialPageRoute(
      //     builder: (context) => PackageDetailsView(
      //       id: arguments as int,
      //     ),
      //     settings: const RouteSettings(name: package_details),
      //   );
      // case pickup_terminal:
      //   return MaterialPageRoute(
      //     builder: (context) => PickupTerminalView(
      //       deliveryAddress: arguments as String,
      //     ),
      //     settings: const RouteSettings(name: pickup_terminal),
      //   );
      // case delivery_address:
      //   return MaterialPageRoute(
      //     builder: (context) => DeliveryAddressView(
      //       pickupAddress: arguments as String,
      //     ),
      //     settings: const RouteSettings(name: delivery_address),
      //   );
      // case connecting_dispatch:
      //   return MaterialPageRoute(
      //     builder: (context) => ConnectingDispatchView(
      //       title: arguments as String,
      //     ),
      //     settings: const RouteSettings(name: connecting_dispatch),
      //   );
      // case delivery_success:
      //   return MaterialPageRoute(
      //     builder: (context) => DeliverySuccessView(
      //       title: arguments as String,
      //     ),
      //     settings: const RouteSettings(name: delivery_success),
      //   );
      // case delivered:
      //   return MaterialPageRoute(
      //     builder: (context) => const DeliveredView(),
      //     settings: const RouteSettings(name: delivery_success),
      //   );
      // case ratings:
      //   return MaterialPageRoute(
      //     builder: (context) => const RatingsView(),
      //     settings: const RouteSettings(name: ratings),
      //   );
      // case notifications:
      //   return MaterialPageRoute(
      //     builder: (context) => const NotificationsView(),
      //     settings: const RouteSettings(name: notifications),
      //   );
      // case success:
      //   return MaterialPageRoute(
      //     builder: (context) => CustomSuccessScreen(
      //       title: arguments as String,
      //       info: arguments,
      //       route: arguments,
      //       buttonTitle: arguments,
      //     ),
      //     settings: const RouteSettings(name: success),
      //   );
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
