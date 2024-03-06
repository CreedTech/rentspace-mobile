import 'dart:async';
import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:linear_step_indicator/linear_step_indicator.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentspace/view/kyc/kyc_payment.dart';

import '../../constants/colors.dart';
import '../../constants/widgets/custom_dialog.dart';

// const int STEPS = 4;

class KYCFormPage extends StatefulWidget {
  const KYCFormPage({super.key});

  @override
  State<KYCFormPage> createState() => _KYCFormPageState();
}

class _KYCFormPageState extends State<KYCFormPage> {
  // int counter = 4;
  // List list = [
  //   0,
  //   1,
  //   2,
  //   3,
  // ];
  // int page = 0;

  final pageController = PageController();
  // int initialPage = 0;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _oldAddressController = TextEditingController();
  final TextEditingController _currentAddressController =
      TextEditingController();
  final TextEditingController _landlordNameController = TextEditingController();
  final TextEditingController _landlordNumberController =
      TextEditingController();
  // final TextEditingController _landlordBankController =
  //     TextEditingController();
  final TextEditingController _employerController = TextEditingController();
  final TextEditingController _typeOfIdentificatonController =
      TextEditingController();
  final TextEditingController _identificatonNumberController =
      TextEditingController();
  final TextEditingController ninController =
      TextEditingController();
  final TextEditingController _salaryRangeController = TextEditingController();
  final kycFormKey1 = GlobalKey<FormState>();
  final kycFormKey2 = GlobalKey<FormState>();
  final kycFormKey3 = GlobalKey<FormState>();
  final kycFormKey4 = GlobalKey<FormState>();
  List<String> item = const <String>[
    'Driver\'s Liscense',
    'International Passport',
    'Voters Card',
    // 'Friends',
  ];
  List<String> salaryRange = const <String>[
    'Less than N100,000',
    'N100,000 -  N500,000',
    'N500,000 - N1,000,000',
    'N1,000,000 - N5,000,000',
    'More than N 5,000,000',
    // 'Friends',
  ];
  bool idSelected = false;
  String selectedId = '';
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (timeStamp) {
  //       Timer.periodic(
  //         const Duration(milliseconds: 350),
  //         (_) {
  //           if (mounted) {
  //             initialPage += 1;
  //             if (initialPage == STEPS - 1) {
  //             } else {
  //               pageController.jumpToPage(initialPage);
  //             }
  //           }
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    validateFullName(firstValue) {
      if (firstValue.isEmpty) {
        return 'Your Name cannot be empty';
      }

      return null;
    }

    validateEmployer(firstValue) {
      if (firstValue.isEmpty) {
        return 'Employer Info cannot be empty';
      }

      return null;
    }

    validateLandlordFullName(firstValue) {
      if (firstValue.isEmpty) {
        return 'Landlord\'s Name cannot be empty';
      }

      return null;
    }

    validateMail(emailValue) {
      if (emailValue == null || emailValue.isEmpty) {
        return 'Please enter an email address.';
      }
      if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
          .hasMatch(emailValue)) {
        return 'Please enter a valid email address.';
      }

      return null;
    }

    validateNewAddress(address) {
      if (address.isEmpty) {
        return 'Address cannot be empty';
      }

      return null;
    }

    validatePhone(phoneValue) {
      if (phoneValue.isEmpty) {
        return 'phone number cannot be empty';
      }
      if (phoneValue.length < 11) {
        return 'phone number is invalid';
      }
      if (int.tryParse(phoneValue) == null) {
        return 'enter valid phone number';
      }
      return null;
    }

    validateLandlordPhone(phoneValue) {
      if (phoneValue.isEmpty) {
        return 'landlord phone number cannot be empty';
      }
      if (phoneValue.length < 11) {
        return 'landlord phone number is invalid';
      }
      if (int.tryParse(phoneValue) == null) {
        return 'enter valid landlord phone number';
      }
      return null;
    }

    validateID(IdValue) {
      if (IdValue.isEmpty) {
        return 'Identification Number cannot be empty';
      }
      if (IdValue.length < 11) {
        return 'Identification Number is invalid';
      }
      if (int.tryParse(IdValue) == null) {
        return 'enter valid Identification Number';
      }
      return null;
    }
    validateNIN(IdValue) {
      if (IdValue.isEmpty) {
        return 'NIN cannot be empty';
      }
      if (IdValue.length < 11) {
        return 'NIN is invalid';
      }
      if (int.tryParse(IdValue) == null) {
        return 'enter valid NIN';
      }
      return null;
    }

    final fullname = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _fullNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        label: Text(
          "Enter your Full Name",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'legal first name',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateFullName,
    );
    final employer = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _employerController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        label: Text(
          "Enter your Employer",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'e.g RentSpace',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateEmployer,
    );

    final email = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        label: Text(
          "Enter your email",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'e.g mymail@inbox.com',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateMail,
    );

    final oldAddress = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),

      // minLines: 3,
      keyboardType: TextInputType.streetAddress,
      controller: _oldAddressController,
      maxLines: 1,
      decoration: InputDecoration(
        label: Text(
          "Enter your previous address",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        hintText: 'Enter your previous address...',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
      // validator: validateOldAddress,
      // labelText: 'Email Address',
    );
    final newAddress = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),

      // minLines: 3,
      keyboardType: TextInputType.streetAddress,
      controller: _currentAddressController,
      maxLines: 1,
      decoration: InputDecoration(
        label: Text(
          "Enter your current address",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        hintText: 'Enter your current address...',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
      validator: validateNewAddress,
      // labelText: 'Email Address',
    );
    final phoneNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _phoneNumberController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validatePhone,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 11,
      decoration: InputDecoration(
        label: Text(
          "Enter your Phone number",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        fillColor: brandThree,
        hintText: 'e.g 080 123 456 789 ',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final landlordNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _landlordNumberController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateLandlordPhone,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 11,
      decoration: InputDecoration(
        label: Text(
          "Enter your Landlord's Phone number",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        fillColor: brandThree,
        hintText: 'e.g 080 123 456 789',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final idNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _identificatonNumberController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateID,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.text,
      // maxLengthEnforcement: MaxLengthEnforcement.enforced,
      // maxLength: 11,
      decoration: InputDecoration(
        label: Text(
          "Your Valid Identification Number",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        filled: false,
        // fillColor: brandThree,
        hintText: 'e.g 12345678900',
        contentPadding: const EdgeInsets.all(14),
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
     final ninNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: ninController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateNIN,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.number,
      // maxLengthEnforcement: MaxLengthEnforcement.enforced,
      // maxLength: 11,
      decoration: InputDecoration(
        label: Text(
          "Your Valid NIN",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        filled: false,
        // fillColor: brandThree,
        hintText: 'e.g 12345678900',
        contentPadding: const EdgeInsets.all(14),
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    
    final landlordName = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _landlordNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateLandlordFullName,
      style: GoogleFonts.nunito(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.name,
      // maxLengthEnforcement: MaxLengthEnforcement.enforced,
      // maxLength: 11,
      decoration: InputDecoration(
        label: Text(
          "Landord Full Name",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        filled: false,
        // fillColor: brandThree,
        hintText: 'Enter your landlord full name',
        contentPadding: const EdgeInsets.all(14),
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          // backgroundColor: const Color(0xffE0E0E0),
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0.0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              size: 25,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: Text(
            'KYC Verification',
            style: GoogleFonts.nunito(
              color: Theme.of(context).primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: StepIndicatorPageView(
          spacing: 3,
          steps: 4,

          // nodeThickness: 5,
          activeBorderColor: brandOne,
          activeNodeColor: brandOne,
          // inActiveBorderColor: brandOne,
          inActiveNodeColor: const Color(0xFFD5D5D5),
          activeLineColor: brandOne,
          inActiveLineColor: const Color(0xFFD5D5D5),
          indicatorPosition: IndicatorPosition.top,
          labels: List<String>.generate(4, (index) => "Step ${index + 1}"),
          controller: pageController,
          complete: () {
            //typically, you'd want to put logic that returns true when all the steps
            //are completed here
            return Future.value(true);
          },
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Your KYC Verifications',
                        style: GoogleFonts.nunito(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          // fontFamily: "DefaultFontFamily",
                        ),
                      ),
                      Text(
                        'Start Your KYC Verification to get access to exclusive 30% loans on your rent.',
                        style: GoogleFonts.nunito(
                          color: const Color(0xff828282),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          // fontFamily: "DefaultFontFamily",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Form(
                            key: kycFormKey1,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 3),
                                      child: Text(
                                        'Full Name',
                                        style: GoogleFonts.nunito(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          // fontFamily: "DefaultFontFamily",
                                        ),
                                      ),
                                    ),
                                    fullname,
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 3),
                                      child: Text(
                                        'Email',
                                        style: GoogleFonts.nunito(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          // fontFamily: "DefaultFontFamily",
                                        ),
                                      ),
                                    ),
                                    email,
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 3),
                                      child: Text(
                                        'Current Address',
                                        style: GoogleFonts.nunito(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          // fontFamily: "DefaultFontFamily",
                                        ),
                                      ),
                                    ),
                                    newAddress,
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 3),
                                      child: Text(
                                        'Previous Address(Optional)',
                                        style: GoogleFonts.nunito(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          // fontFamily: "DefaultFontFamily",
                                        ),
                                      ),
                                    ),
                                    oldAddress,
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 3),
                                      child: Text(
                                        'Phone Number',
                                        style: GoogleFonts.nunito(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          // fontFamily: "DefaultFontFamily",
                                        ),
                                      ),
                                    ),
                                    phoneNumber,
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(350, 50),
                          backgroundColor: brandOne,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (kycFormKey1.currentState!.validate()) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            customErrorDialog(context, 'Error!',
                                "Please fill the form properly to proceed");
                          }
                          // _doSomething();
                        },
                        child: Text(
                          'Proceed',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Your Identity Informations',
                        style: GoogleFonts.nunito(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          // fontFamily: "DefaultFontFamily",
                        ),
                      ),
                      Text(
                        'Start Your KYC Verification to get access to exclusive 30% loans on your rent.',
                        style: GoogleFonts.nunito(
                          color: const Color(0xff828282),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          // fontFamily: "DefaultFontFamily",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Form(
                            key: kycFormKey2,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 3),
                                            child: Text(
                                              'Enter your NIN Number',
                                              style: GoogleFonts.nunito(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                // fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                          ),
                                          ninNumber,
                                        ],
                                      ),
                                      const SizedBox(
                                  height: 20,
                                ),
                                CustomDropdown(
                                  selectedStyle: GoogleFonts.nunito(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14),
                                  hintText: 'Select your valid identity type',
                                  hintStyle: GoogleFonts.nunito(
                                      // color: Theme.of(context).primaryColor,
                                      fontSize: 14),
                                  excludeSelected: true,
                                  fillColor: Colors.transparent,
                                  listItemStyle: GoogleFonts.nunito(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 14),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                  items: item,
                                  controller: _typeOfIdentificatonController,
                                  fieldSuffixIcon: Icon(
                                    Iconsax.arrow_down5,
                                    size: 25.h,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onChanged: (String val) {
                                    setState(() {
                                      idSelected = true;
                                      selectedId =
                                          _typeOfIdentificatonController.text;
                                    });
                                    print(val);
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                (idSelected == true)
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 3),
                                            child: Text(
                                              'Enter your $selectedId Number',
                                              style: GoogleFonts.nunito(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                // fontFamily: "DefaultFontFamily",
                                              ),
                                            ),
                                          ),
                                          idNumber,
                                        ],
                                      )
                                    : const Text(''),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(350, 50),
                          backgroundColor: brandOne,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (kycFormKey2.currentState!.validate()) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            customErrorDialog(context, 'Error!',
                                "Please fill the form properly to proceed");
                          }
                          // _doSomething();
                        },
                        child: Text(
                          'Proceed',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Employment Informations',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.nunito(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Fill in your employment informations.',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.nunito(
                          color: const Color(0xff828282),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Form(
                            key: kycFormKey3,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 3),
                                      child: Text(
                                        'Employer',
                                        style: GoogleFonts.nunito(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          // fontFamily: "DefaultFontFamily",
                                        ),
                                      ),
                                    ),
                                    employer,
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 3),
                                      child: Text(
                                        'Salary Range',
                                        style: GoogleFonts.nunito(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          // fontFamily: "DefaultFontFamily",
                                        ),
                                      ),
                                    ),
                                    CustomDropdown(
                                      selectedStyle: GoogleFonts.nunito(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14),
                                      hintText: 'Select your salary range',
                                      hintStyle: GoogleFonts.nunito(
                                          // color: Theme.of(context).primaryColor,
                                          fontSize: 14),
                                      excludeSelected: true,
                                      fillColor: Colors.transparent,
                                      listItemStyle: GoogleFonts.nunito(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 14),
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2),
                                      items: salaryRange,
                                      controller: _salaryRangeController,
                                      fieldSuffixIcon: Icon(
                                        Iconsax.arrow_down5,
                                        size: 25.h,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onChanged: (String val) {
                                        setState(() {
                                          idSelected = true;
                                          // selectedId =
                                          //     _typeOfIdentificatonController
                                          //         .text;
                                        });
                                        print(val);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(350, 50),
                          backgroundColor: brandOne,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (kycFormKey3.currentState!.validate()) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            customErrorDialog(context, 'Error!',
                                "Please fill the form properly to proceed");
                          }
                          // _doSomething();
                        },
                        child: Text(
                          'Proceed',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Employment Informations',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.nunito(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Fill in your employment informations.',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.nunito(
                          color: const Color(0xff828282),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Form(
                            key: kycFormKey4,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 3),
                                      child: Text(
                                        'Lanlord\'s Full Name',
                                        style: GoogleFonts.nunito(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    landlordName,
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 3),
                                      child: Text(
                                        'Lanlord\'s Phone Number',
                                        style: GoogleFonts.nunito(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    landlordNumber,
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(350, 50),
                          backgroundColor: brandOne,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (kycFormKey4.currentState!.validate()) {
                            // pageController.nextPage(
                            //   duration: const Duration(milliseconds: 300),
                            //   curve: Curves.easeInOut,
                            // );
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: null,
                                    scrollable: true,
                                    elevation: 0,
                                    content: SizedBox(
                                      height: 250.h,
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  // color: brandOne,
                                                ),
                                                child: Icon(
                                                  Iconsax.close_circle,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25.h,
                                          ),
                                          // Align(
                                          //   alignment: Alignment.center,
                                          //   child: Image.asset(
                                          //     'assets/cancel_round.png',
                                          //     width: 104,
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   height: 70.h,
                                          // ),
                                          Column(
                                            children: [
                                              Text(
                                                'KYC Payment',
                                                style: GoogleFonts.nunito(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'By Clicking CONTINUE, You agree to pay the sum ofN 10,000 only, for your KYC verification in order to be qualified for a loan',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.nunito(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(300, 50),
                                              maximumSize: const Size(400, 50),
                                              backgroundColor: brandOne,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.to(KYCPayment());
                                            },
                                            child: Text(
                                              'Continue',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.nunito(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            customErrorDialog(context, 'Error!',
                                "Please fill the form properly to proceed");
                          }
                          // _doSomething();
                        },
                        child: Text(
                          'Submit',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

Widget widgetOption(
    {required String title,
    required VoidCallback callAdd,
    required VoidCallback callRemove}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.03),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: 30,
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: callAdd, child: const Icon(Icons.add)),
              ElevatedButton(
                  onPressed: callRemove, child: const Icon(Icons.remove)),
            ],
          )
        ],
      ),
    ),
  );
}
