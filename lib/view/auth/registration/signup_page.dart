import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
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
import 'package:rentspace/constants/widgets/custom_button.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/view/terms_and_conditions/terms_and_conditions.dart';
import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rentspace/constants/icons.dart';
import 'package:upgrader/upgrader.dart';

// import '../constants/db/firebase_db.dart';
import '../../../controller/auth/auth_controller.dart';
// import 'package:http/http.dart' as http;

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
  // final TextEditingController _bvnController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  final registerFormKey = GlobalKey<FormState>();
  final sessionStateStream = StreamController<SessionState>();
  final int minimumAge = 18;
  List<String> genders = ['Male', 'Female'];
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
          if (!mounted) return;
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
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
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
                      style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "Uh-oh! It looks like you're not connected. Please check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(MediaQuery.of(context).size.width - 50, 50),
                          backgroundColor: brandTwo,
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
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 12,
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
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _usernameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500),
      keyboardType: TextInputType.text,
      validator: validateUsername,
      decoration: InputDecoration(
        // label: Text(
        //   "Choose new username",
        //   style: GoogleFonts.lato(
        //     color: Colors.grey,
        //     fontSize: 12,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        // prefixText: "SPACER/",
        prefixStyle: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffE0E0E0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffE0E0E0), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
    );

    //Phone number
    final phoneNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _phoneController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validatePhone,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500),
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 11,
      decoration: InputDecoration(
        // label: Text(
        //   "Enter your Phone number",
        //   style: GoogleFonts.lato(
        //     color: Colors.grey,
        //     fontSize: 12,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        fillColor: brandThree,
      ),
    );

//Address
    final referal = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _referalController,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        // label: Text(
        //   "Referal code (Optional)",
        //   style: GoogleFonts.lato(
        //     color: Colors.grey,
        //     fontSize: 12,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        // hintText: 'You and your referrer earn 500 naira each',
        // hintStyle: GoogleFonts.lato(
        //   color: Colors.grey,
        //   fontSize: 12,
        //   fontWeight: FontWeight.w400,
        // ),
      ),
      maxLines: 1,
    );

    //firstname
    final firstname = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _firstnameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        // label: Text(
        //   "Enter your First name",
        //   style: GoogleFonts.lato(
        //     color: Colors.grey,
        //     fontSize: 12,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        // hintText: 'legal first name',
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      maxLines: 1,
      validator: validateFirst,
    );
    final lastname = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _lastnameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        // label: Text(
        //   "Enter Last name",
        //   style: GoogleFonts.lato(
        //     color: Colors.grey,
        //     fontSize: 12,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        // hintText: 'legal last name',
        // hintStyle: GoogleFonts.lato(
        //   color: Colors.grey,
        //   fontSize: 12,
        //   fontWeight: FontWeight.w400,
        // ),
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 12,
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
      cursorColor: Theme.of(context).colorScheme.primary,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        // label: Text(
        //   "Enter your email",
        //   style: GoogleFonts.lato(
        //     color: Colors.grey,
        //     fontSize: 12,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        // hintText: 'e.g mymail@inbox.com',
        // hintStyle: GoogleFonts.lato(
        //   color: Colors.grey,
        //   fontSize: 12,
        //   fontWeight: FontWeight.w400,
        // ),
      ),
      maxLines: 1,
      validator: validateMail,
    );
    //password field
    final password = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: _passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscurity,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
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

    void _showDatePicker() {
      DatePicker.showDatePicker(
        context,
        onMonthChangeStartWithFirstDate: true,
        pickerTheme: DateTimePickerTheme(
          backgroundColor: brandOne,
          itemTextStyle: GoogleFonts.lato(color: Colors.white),
          itemHeight: 50.h,
          pickerHeight: 300.h,
          showTitle: true,
          cancel: const Icon(
            Iconsax.close_circle,
            color: Colors.white,
            size: 30,
          ),
          confirm: Text(
            'Done',
            style: GoogleFonts.lato(color: Colors.white),
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

    final dob = TextFormField(
      controller: dateController,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500),
      readOnly: true,
      onTap: _showDatePicker,
      // onTap: () => _selectDate(context),
      decoration: InputDecoration(
        // labelText: 'Date of Birth',
        // labelStyle: GoogleFonts.lato(
        //   color: Colors.grey,
        //   fontSize: 12,
        //   fontWeight: FontWeight.w400,
        // ),
        suffixIcon: Icon(
          Icons.calendar_today,
          color: Theme.of(context).colorScheme.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
    );

    final address = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500),

      // minLines: 3,
      keyboardType: TextInputType.streetAddress,
      controller: _addressController,
      maxLines: 1,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
      ),
      validator: validateAddress,
      // labelText: 'Email Address',
    );

    final confirmPassword = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: repeatPasswordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscurity,
      style: GoogleFonts.lato(
          color: Theme.of(context).colorScheme.primary, fontSize: 14),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }

        return null;
      },
    );

    final genderSelect = TextFormField(
      onTap: () {
        showModalBottomSheet(
          isDismissible: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.45,
              child: Container(
                // height: 350,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(19)),
                child: ListView(
                  children: [
                    Text(
                      'Select Gender',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: genders.length,
                        itemBuilder: (context, idx) {
                          return Column(
                            children: [
                              ListTileTheme(
                                contentPadding: const EdgeInsets.only(
                                    left: 13.0, right: 13.0, top: 4, bottom: 4),
                                selectedColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          genders[idx],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // selected: _selectedCarrier == name[idx],
                                  onTap: () {
                                    print(_genderController.text);
                                    setState(() {
                                      selectedGender = genders[idx];
                                      genderValue =
                                          selectedGender == 'Male' ? 1 : 2;
                                    });
                                    print(genderValue);

                                    _genderController.text = genders[idx];
                                    // });

                                    Navigator.pop(
                                      context,
                                    );

                                    setState(() {});
                                  },
                                ),
                              ),
                              (idx != genders.length - 1)
                                  ? Divider(
                                      color: Theme.of(context).dividerColor,
                                      height: 1,
                                      indent: 13,
                                      endIndent: 13,
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      readOnly: true,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      cursorColor: colorBlack,
      style: GoogleFonts.lato(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),

      controller: _genderController,
      textAlignVertical: TextAlignVertical.center,
      // textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(189, 189, 189, 30)
                : const Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        filled: false,
        fillColor: Colors.transparent,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      ),
      maxLines: 1,
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 27,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Sign up',
            style: GoogleFonts.lato(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 23.w),
              child: Image.asset(
                'assets/icons/logo_icon.png',
                height: 35.7.h,
              ),
            ),
          ],
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
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
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
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          lastname,
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Padding(
                      //             padding: EdgeInsets.symmetric(
                      //                 vertical: 3.h, horizontal: 3.w),
                      //             child: Text(
                      //               'First Name',
                      //               style: GoogleFonts.lato(
                      //                 color: Theme.of(context).colorScheme.primary,
                      //                 fontWeight: FontWeight.w600,
                      //                 fontSize: 12,
                      //               ),
                      //             ),
                      //           ),
                      //           firstname,
                      //         ],
                      //       ),
                      //     ),
                      //     SizedBox(width: 10.w),
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Padding(
                      //             padding: EdgeInsets.symmetric(
                      //                 vertical: 3.h, horizontal: 3.w),
                      //             child: Text(
                      //               'Last Name',
                      //               style: GoogleFonts.lato(
                      //                 color: Theme.of(context).colorScheme.primary,
                      //                 fontWeight: FontWeight.w600,
                      //                 fontSize: 12,
                      //                 // fontFamily: "DefaultFontFamily",
                      //               ),
                      //             ),
                      //           ),
                      //           lastname,
                      //         ],
                      //       ),
                      //     ),
                      //     // Column(
                      //     //   crossAxisAlignment: CrossAxisAlignment.start,
                      //     //   children: [
                      //     //     Padding(
                      //     //       padding: EdgeInsets.symmetric(
                      //     //           vertical: 3.h, horizontal: 3.w),
                      //     //       child: Text(
                      //     //         'First Name',
                      //     //         style: GoogleFonts.lato(
                      //     //           color: Theme.of(context).colorScheme.primary,
                      //     //           fontWeight: FontWeight.w600,
                      //     //           fontSize: 12,
                      //     //           // fontFamily: "DefaultFontFamily",
                      //     //         ),
                      //     //       ),
                      //     //     ),
                      //     //     firstname,
                      //     //   ],
                      //     // ),
                      //     // Column(
                      //     //   crossAxisAlignment: CrossAxisAlignment.start,
                      //     //   children: [
                      //     //     Padding(
                      //     //       padding: EdgeInsets.symmetric(
                      //     //           vertical: 3.h, horizontal: 3.w),
                      //     //       child: Text(
                      //     //         'First Name',
                      //     //         style: GoogleFonts.lato(
                      //     //           color: Theme.of(context).colorScheme.primary,
                      //     //           fontWeight: FontWeight.w600,
                      //     //           fontSize: 12,
                      //     //           // fontFamily: "DefaultFontFamily",
                      //     //         ),
                      //     //       ),
                      //     //     ),
                      //     //     firstname,
                      //     //   ],
                      //     // ),
                      //   ],
                      // ),

                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Padding(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 3.h, horizontal: 3.w),
                      //       child: Text(
                      //         'First Name',
                      //         style: GoogleFonts.lato(
                      //           color: Theme.of(context).colorScheme.primary,
                      //           fontWeight: FontWeight.w600,
                      //           fontSize: 12,
                      //           // fontFamily: "DefaultFontFamily",
                      //         ),
                      //       ),
                      //     ),
                      //     firstname,
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 20.h,
                      // ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Padding(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 3.h, horizontal: 3.w),
                      //       child: Text(
                      //         'Last Name',
                      //         style: GoogleFonts.lato(
                      //           color: Theme.of(context).colorScheme.primary,
                      //           fontWeight: FontWeight.w600,
                      //           fontSize: 12,
                      //           // fontFamily: "DefaultFontFamily",
                      //         ),
                      //       ),
                      //     ),
                      //     lastname,
                      //   ],
                      // ),

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
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
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
                              'Email',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
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
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
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
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
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
                                  const Icon(
                                    Icons.info_outline,
                                    size: 15,
                                    color: Color(0xff4E4B4B),
                                  ),
                                  SizedBox(
                                    width: 320.w,
                                    child: Text(
                                      'Password -8 Characters, One Uppercase, One Lowercase, One Special Characters (#%&*?@)',
                                      softWrap: true,
                                      style: GoogleFonts.lato(
                                        color: const Color(0xff828282),
                                        fontSize: 10,
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
                              'Confirm Password',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          confirmPassword,
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
                              'Date Of Birth',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
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
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
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
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          genderSelect,
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
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          referal,
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Wrap(
                        // alignment: WrapAlignment.center,
                        // runAlignment: WrapAlignment.center,
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
                            fillColor: MaterialStateProperty.resolveWith<Color>(
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
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,

                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(const TermsAndConditions());
                            },
                            child: Text(
                              'Terms of service',
                              style: GoogleFonts.lato(
                                color: brandTwo,
                                // fontFamily: "DefaultFontFamily",
                                fontSize: 12,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomButton(
                          text: 'Sign up',
                          onTap: () {
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
                        ),
                      ),
                      // Center(
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       minimumSize: const Size(300, 50),
                      //       backgroundColor: brandOne,
                      //       elevation: 0,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(
                      //           10,
                      //         ),
                      //       ),
                      //     ),
                      //     onPressed: () {
                      //       FocusScope.of(context).unfocus();
                      //       if (registerFormKey.currentState!.validate()) {
                      //         if (isChecked == true) {
                      //           print(genderValue.toString());
                      //           print(dateController.text);
                      //           authState.signUp(
                      //               context,
                      //               _firstnameController.text.trim(),
                      //               _lastnameController.text.trim(),
                      //               _usernameController.text.trim(),
                      //               _emailController.text.trim(),
                      //               _passwordController.text.trim(),
                      //               _phoneController.text.trim(),
                      //               dateController.text.trim(),
                      //               _addressController.text.trim(),
                      //               _genderController.text.trim(),
                      //               referralCode:
                      //                   _referalController.text.trim() ?? '');
                      //         } else {
                      //           customErrorDialog(context, 'Error!',
                      //               "You have to agree to the terms of service");
                      //         }
                      //       } else {
                      //         customErrorDialog(context, 'Error!',
                      //             "Please fill the form properly to proceed");
                      //       }
                      //     },
                      //     child: Text(
                      //       'Sign Up',
                      //       textAlign: TextAlign.center,
                      //       style: GoogleFonts.lato(
                      //         color: Colors.white,
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //     ),
                      //   ),
                      // ),

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
