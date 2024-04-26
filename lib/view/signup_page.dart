import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/view/terms_and_conditions.dart';
import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rentspace/view/login_page.dart';
import 'package:rentspace/constants/icons.dart';
import 'package:upgrader/upgrader.dart';

// import '../constants/db/firebase_db.dart';
import '../controller/auth/auth_controller.dart';
import 'package:http/http.dart' as http;

String dropdownValue = 'User';
bool isChecked = false;

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  // @override
  // _SignupPageConsumerState createState() => _SignupPageConsumerState();
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupPageState();
}

var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
// CollectionReference users = FirebaseFirestore.instance.collection('accounts');
// CollectionReference allUsers =
//     FirebaseFirestore.instance.collection('accounts');
String _mssg = "";
String vName = "";
String vNum = "";
bool notLoading = true;

class _SignupPageState extends ConsumerState<SignupPage> {
  // final UserController userController = Get.find();
  final form = intl.NumberFormat.decimalPattern();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'dva';

  Timer? timer;

  bool obscurity = true;
  Icon lockIcon = LockIcon().open;
  String enteredPin = '';
  bool isPinVisible = false;
  // ignore: prefer_typing_uninitialized_variables
  var onButtonPressed;
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();

  // final RoundedLoadingButtonController _btnController =
  //     RoundedLoadingButtonController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _referalController = TextEditingController();
  final TextEditingController _bvnController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final registerFormKey = GlobalKey<FormState>();
  final sessionStateStream = StreamController<SessionState>();
  final int minimumAge = 18;
  String? selectedGender;
  late int genderValue;
  DateTime? _dateTime;
  String _format = 'yyyy-MMMM-dd';
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  late StreamSubscription subscription;

  void visibility() {
    if (obscurity == true) {
      setState(() {
        obscurity = false;
        lockIcon = LockIcon().close;
      });
    } else {
      setState(() {
        obscurity = true;
        lockIcon = LockIcon().open;
      });
    }
  }

  @override
  initState() {
    super.initState();
    getConnectivity();
    _usernameController.clear();
    setState(() {
      _mssg = "";
      vNum = "";
      vName = "";
    });
  }

  void getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && !isAlertSet) {
          noInternetConnectionScreen(context);
          setState(() => isAlertSet = true);
        }
      },
    );
  }

  noInternetConnectionScreen(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(30.sp, 30.sp, 30.sp, 20.sp),
            elevation: 0.0,
            alignment: Alignment.bottomCenter,
            insetPadding: const EdgeInsets.all(0),
            title: null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            content: SizedBox(
              height: 170.h,
              child: Container(
                width: 400.w,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Text(
                      'No internet Connection',
                      style: GoogleFonts.poppins(
                          color: brandOne,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "Uh-oh! It looks like you're not connected. Please check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: brandOne,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 50),
                          maximumSize: const Size(400, 50),
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          // EasyLoading.dismiss();
                          setState(() => isAlertSet = false);
                          isDeviceConnected =
                              await InternetConnectionChecker().hasConnection;
                          if (!isDeviceConnected && isAlertSet == false) {
                            // showDialogBox();
                            noInternetConnectionScreen(context);
                            setState(() => isAlertSet = true);
                          }
                        },
                        child: Text(
                          "Try Again",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider.notifier);
    //Validator
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

    validatePhone(phoneValue) {
      if (phoneValue.isEmpty) {
        return 'phone cannot be empty';
      }
      if (phoneValue.length < 11) {
        return 'phone is invalid';
      }
      if (int.tryParse(phoneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    validateFirst(firstValue) {
      if (firstValue.isEmpty) {
        return 'first name cannot be empty';
      }

      return null;
    }

    validateLast(lastValue) {
      if (lastValue.isEmpty) {
        return 'last name cannot be empty';
      }

      return null;
    }

    validatePass(passValue) {
      RegExp uppercaseRegex = RegExp(r'[A-Z]');
      RegExp lowercaseRegex = RegExp(r'[a-z]');
      RegExp digitsRegex = RegExp(r'[0-9]');
      RegExp specialCharRegex = RegExp(r'[#\$%&*?@]');
      if (passValue == null || passValue.isEmpty) {
        return 'Input a valid password';
      } else if (passValue.length < 8) {
        return "Password must be at least 8 characters long.";
      } else if (!uppercaseRegex.hasMatch(passValue)) {
        return "Password must contain at least one uppercase letter.";
      } else if (!lowercaseRegex.hasMatch(passValue)) {
        return "Password must contain at least one lowercase letter.";
      } else if (!digitsRegex.hasMatch(passValue)) {
        return "Password must contain at least one number.";
      } else if (!specialCharRegex.hasMatch(passValue)) {
        return "Password must contain at least one special character (#\$%&*?@).";
      } else {
        return null;
      }
    }

    validateBvn(bvnValue) {
      if (bvnValue.isEmpty) {
        return 'BVN cannot be empty';
      }
      if (bvnValue.length < 11) {
        return 'BVN is invalid';
      }
      if (int.tryParse(bvnValue) == null) {
        return 'enter valid BVN';
      }
      return null;
    }

    validateAddress(address) {
      if (address.isEmpty) {
        return 'Address cannot be empty';
      }

      return null;
    }

    validateUsername(usernameValue) {
      bool hasSpecial =
          usernameValue.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      if (usernameValue.isEmpty) {
        return 'username cannot be empty';
      }

      if ((_usernameController.text.trim().replaceAll(',', '')).length < 7) {
        return 'username must contain at least 7 characters';
      }
      if (hasSpecial) {
        return 'username cannot include special character';
      }
      return null;
    }

    final username = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _usernameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.sp),
      keyboardType: TextInputType.text,
      validator: validateUsername,
      decoration: InputDecoration(
        label: Text(
          "Choose new username",
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        // prefixText: "SPACER/",
        prefixStyle: GoogleFonts.poppins(
          color: Theme.of(context).primaryColor,
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'can contain letters and numbers',
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    //Phone number
    final phoneNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _phoneController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validatePhone,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.sp),
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 11,
      decoration: InputDecoration(
        label: Text(
          "Enter your Phone number",
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 12.sp,
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
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        fillColor: brandThree,
        hintText: 'e.g 080 123 456 789 ',
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

//Address
    final referal = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _referalController,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.sp),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        // label: Text(
        //   "Referal code (Optional)",
        //   style: GoogleFonts.poppins(
        //     color: Colors.grey,
        //     fontSize: 12,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'You and your referrer earn 500 naira each',
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
    );

    //firstname
    final firstname = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _firstnameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.sp),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        label: Text(
          "Enter your First name",
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 12.sp,
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
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'legal first name',
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateFirst,
    );
    final lastname = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _lastnameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.sp),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        label: Text(
          "Enter Last name",
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 12.sp,
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
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'legal last name',
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateLast,
    );
    //email field
    final email = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.sp),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        label: Text(
          "Enter your email",
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 12.sp,
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
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'e.g mymail@inbox.com',
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateMail,
    );
    //password field
    final password = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscurity,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.sp),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        suffix: InkWell(
          onTap: visibility,
          child: lockIcon,
        ),
        suffixIconColor: Colors.black,
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
      validator: validatePass,
    );
    //Username

    final forgotLabel = InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                sessionStateStream: sessionStateStream,
                // loggedOutReason: "Logged out because of user inactivity",
              ),
            ));
      },
      child: const Text(
        'I have an account',
        style: TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          decoration: TextDecoration.underline,
        ),
      ),
    );
    void _showDatePicker() {
      DatePicker.showDatePicker(
        context,
        onMonthChangeStartWithFirstDate: true,
        pickerTheme: DateTimePickerTheme(
          backgroundColor: brandOne,
          itemTextStyle: GoogleFonts.poppins(color: Colors.white),
          itemHeight: 50.h,
          pickerHeight: 300.h,
          showTitle: true,
          cancel: Icon(
            Iconsax.close_circle,
            color: Colors.white,
            size: 30.sp,
          ),
          confirm: Text(
            'Done',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
        initialDateTime: selectedDate,
        minDateTime: DateTime(1900),
        maxDateTime: DateTime.now(),
        dateFormat: _format,
        locale: DateTimePickerLocale.en_us,
        onCancel: () => print('onCancel'),
        onChange: (dateTime, List<int> index) {
          setState(() {
            _dateTime = dateTime;
          });
        },
        onConfirm: (dateTime, List<int> index) {
          setState(() {
            _dateTime = dateTime;
          });
          print(dateTime);
        },
        onClose: () {
          if (_dateTime != null && _dateTime != selectedDate) {
            final int age = DateTime.now().year - _dateTime!.year;
            if (age < minimumAge) {
              // Show an error message or handle the validation as needed.
              if (!context.mounted) return;
              customErrorDialog(context, 'Error! :(',
                  "Age must be at least $minimumAge years.");
            } else {
              setState(() {
                selectedDate = _dateTime!;
                dateController.text =
                    DateFormat('dd/MM/yyyy').format(selectedDate);
              });
            }
          }
        },
      );
    }

    // Future<void> _selectDate(BuildContext context) async {
    //   final DateTime? picked = await showDatePicker(
    //       initialEntryMode: DatePickerEntryMode.calendarOnly,
    //       context: context,
    //       builder: (context, child) {
    //         return Theme(
    //           data: Theme.of(context).copyWith(
    //             colorScheme: const ColorScheme.dark(
    //               primaryContainer: brandTwo,
    //               primary: brandTwo, // header background color
    //               onPrimary: Colors.white,
    //               onBackground: brandTwo,
    //               // onSecondary: brandTwo,

    //               outline: brandTwo,
    //               background: brandTwo,
    //               onSurface: brandTwo, // body text color
    //             ),
    //             textButtonTheme: TextButtonThemeData(
    //               style: TextButton.styleFrom(
    //                 foregroundColor: brandTwo, // button text color
    //               ),
    //             ),
    //           ),
    //           child: child!,
    //         );
    //       },
    //       initialDate: selectedDate,
    //       firstDate: DateTime(1900),
    //       lastDate: DateTime.now());

    //   if (picked != null && picked != selectedDate) {
    //     final int age = DateTime.now().year - picked.year;
    //     if (age < minimumAge) {
    //       // Show an error message or handle the validation as needed.
    //       if (!context.mounted) return;
    //       showDialog(
    //           context: context,
    //           barrierDismissible: false,
    //           builder: (BuildContext context) {
    //             return AlertDialog(
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               title: null,
    //               elevation: 0,
    //               content: SizedBox(
    //                 height: 250,
    //                 child: Column(
    //                   children: [
    //                     GestureDetector(
    //                       onTap: () {
    //                         Navigator.of(context).pop();
    //                       },
    //                       child: Align(
    //                         alignment: Alignment.topRight,
    //                         child: Container(
    //                           decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(30),
    //                             // color: brandOne,
    //                           ),
    //                           child: Icon(
    //                             Iconsax.close_circle,
    //                             color: Theme.of(context).primaryColor,
    //                             size: 30.sp,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     Align(
    //                       alignment: Alignment.center,
    //                       child: Icon(
    //                         Iconsax.warning_24,
    //                         color: Colors.red,
    //                         size: 75.sp,
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 12.h,
    //                     ),
    //                     Text(
    //                       'Error! :(',
    //                       style: GoogleFonts.poppins(
    //                         color: Colors.red,
    //                         fontSize: 28.sp,
    //                         fontWeight: FontWeight.w600,
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 5.h,
    //                     ),
    //                     Text(
    //                       "Age must be at least $minimumAge years.",
    //                       textAlign: TextAlign.center,
    //                       style: GoogleFonts.poppins(
    //                           color: Colors.red, fontSize: 18.sp),
    //                     ),
    //                     SizedBox(
    //                       height: 10.h,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           });
    //     } else {
    //       setState(() {
    //         selectedDate = picked;
    //         dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    //       });
    //     }
    //   }
    // }

    final dob = TextFormField(
      controller: dateController,
      cursorColor: Theme.of(context).primaryColor,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.sp),
      readOnly: true,
      onTap: _showDatePicker,
      // onTap: () => _selectDate(context),
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        labelStyle: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: const Icon(
          Icons.calendar_today,
          color: brandOne,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
    );

    final bvn = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _bvnController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateBvn,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.sp),
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 11,
      decoration: InputDecoration(
        label: Text(
          "11 digits BVN",
          style: GoogleFonts.poppins(
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
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        filled: false,
        // fillColor: brandThree,
        hintText: 'e.g 12345678900',
        contentPadding: const EdgeInsets.all(14),
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    final address = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.sp),

      // minLines: 3,
      keyboardType: TextInputType.streetAddress,
      controller: _addressController,
      maxLines: 1,
      decoration: InputDecoration(
        label: Text(
          "Enter your address",
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        hintText: 'Enter your address...',
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.red, width: 2.0), // Change color to yellow
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
      validator: validateAddress,
      // labelText: 'Email Address',
    );

    final gender = CustomDropdown(
      selectedStyle: GoogleFonts.poppins(
          color: Theme.of(context).primaryColor, fontSize: 14.sp),
      hintText: 'Select your gender',
      hintStyle: GoogleFonts.poppins(
          // color: Theme.of(context).primaryColor,
          fontSize: 14.sp),
      excludeSelected: true,
      fillColor: Colors.transparent,
      listItemStyle: GoogleFonts.poppins(
          color: Theme.of(context).colorScheme.secondary, fontSize: 14.sp),
      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      items: const ['Male', 'Female'],
      controller: _genderController,
      fieldSuffixIcon: Icon(
        Iconsax.arrow_down5,
        size: 25.h,
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (String? newValue) {
        print(_genderController.text);
        setState(() {
          selectedGender = newValue!;
          genderValue = selectedGender == 'Male' ? 1 : 2;
        });
        print(genderValue);
      },
    );

    return UpgradeAlert(
      upgrader: Upgrader(
        showIgnore: false,
        durationUntilAlertAgain: const Duration(seconds: 5),
        debugLogging: true,
        // debugDisplayAlways:true,
        dialogStyle: UpgradeDialogStyle.cupertino,
        showLater: false,
        canDismissDialog: false,
        showReleaseNotes: true,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              size: 25.sp,
              color: Theme.of(context).primaryColor,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Sign up',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Form(
                  key: registerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 3.w),
                            child: Text(
                              'First Name',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                          firstname,
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 3.w),
                            child: Text(
                              'Last Name',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                          lastname,
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 3.w),
                            child: Text(
                              'User Name',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                          username,
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 3.w),
                            child: Text(
                              'Email Address',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
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
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 3.w),
                            child: Text(
                              'Phone Number',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                          phoneNumber,
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 3.w),
                            child: Text(
                              'Password',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                          password,
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 15.sp,
                                    color: Color(0xff828282),
                                  ),
                                  SizedBox(
                                    width: 320.w,
                                    child: Text(
                                      'Password -8 Characters, One Uppercase, One Lowercase, One Special Characters (#%&*?@)',
                                      softWrap: true,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xff828282),
                                        fontSize: 10.sp,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 3.w),
                            child: Text(
                              'Date Of Birth',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                        ],
                      ),
                      dob,
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 3.w),
                            child: Text(
                              'Residential Address',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                          address,
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 3.w),
                            child: Text(
                              'Gender',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                          gender,
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 3.w),
                            child: Text(
                              'Referral Code(Optional)',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                // fontFamily: "DefaultFontFamily",
                              ),
                            ),
                          ),
                          referal,
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.height / 80,
                            MediaQuery.of(context).size.height / 600,
                            MediaQuery.of(context).size.height / 80,
                            MediaQuery.of(context).size.height / 80,
                            // MediaQuery.of(context).size.height / 500,
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox.adaptive(
                                visualDensity:
                                    VisualDensity.adaptivePlatformDensity,
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                                overlayColor: MaterialStateColor.resolveWith(
                                  (states) => brandTwo,
                                ),
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return brandTwo;
                                  }
                                  return const Color(0xffF2F2F2);
                                }),
                                focusColor: MaterialStateColor.resolveWith(
                                  (states) => brandTwo,
                                ),
                                activeColor: MaterialStateColor.resolveWith(
                                  (states) => brandTwo,
                                ),
                                side: const BorderSide(
                                  color: Color(0xffBDBDBD),
                                ),
                              ),
                              Text(
                                'You agree to our ',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: Theme.of(context).primaryColor,

                                  // fontFamily: "DefaultFontFamily",
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(const TermsAndConditions());
                                },
                                // AutoSizeText(
                                //               maxLines: 1,
                                //               "Get Started",
                                //               minFontSize: 10,
                                //               maxFontSize: 14,
                                //               style: GoogleFonts.poppins(
                                //                   color: Colors.black,
                                //                   fontWeight: FontWeight.w600,
                                //                   fontSize: 14.sp),
                                //             ),
                                child: Text(
                                  'Terms of service',
                                  style: GoogleFonts.poppins(
                                    color: brandTwo,
                                    // fontFamily: "DefaultFontFamily",
                                    fontSize: 12.sp,
                                    // decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(300, 50),
                            backgroundColor: brandOne,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (registerFormKey.currentState!.validate()) {
                              if (isChecked == true) {
                                print(genderValue.toString());
                                print(dateController.text);
                                authState.signUp(
                                    context,
                                    _firstnameController.text.trim(),
                                    _lastnameController.text.trim(),
                                    _usernameController.text.trim(),
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                    _phoneController.text.trim(),
                                    dateController.text.trim(),
                                    _addressController.text.trim(),
                                    _genderController.text.trim(),
                                    referralCode:
                                        _referalController.text.trim() ?? '');
                              } else {
                                customErrorDialog(context, 'Error!',
                                    "You have to agree to the terms of service");
                              }
                            } else {
                              customErrorDialog(context, 'Error!',
                                  "Please fill the form properly to proceed");
                            }
                          },
                          child: Text(
                            'Create account',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
