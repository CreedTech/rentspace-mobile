import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/widgets/custom_button.dart';
import 'package:rentspace/view/terms_and_conditions/terms_and_conditions.dart';
import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rentspace/constants/icons.dart';
import 'package:rentspace/widgets/custom_text_field_widget.dart';

import '../../../controller/auth/auth_controller.dart';
import '../../../widgets/custom_dialogs/index.dart';

bool isChecked = false;

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  bool obscurity = true;
  Icon lockIcon = LockIcon().open;
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _referalController = TextEditingController();
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
  final String _format = 'yyyy-MMMM-dd';
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
                          setState(() => isAlertSet = false);
                          isDeviceConnected =
                              await InternetConnectionChecker().hasConnection;
                          if (!isDeviceConnected && isAlertSet == false) {
                            if (context.mounted) {
                              noInternetConnectionScreen(context);
                            }
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

    void showDatePicker() {
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
        // ignore: avoid_print
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

    return Scaffold(
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
                    CustomTextFieldWidget(
                      controller: _firstnameController,
                      keyboardType: TextInputType.name,
                      obscureText: false,
                      filled: false,
                      readOnly: false,
                      labelText: 'First Name',
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 1,
                      validator: validateFirst,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextFieldWidget(
                      controller: _lastnameController,
                      keyboardType: TextInputType.name,
                      obscureText: false,
                      filled: false,
                      readOnly: false,
                      labelText: 'Last Name',
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 1,
                      validator: validateLast,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextFieldWidget(
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      filled: false,
                      readOnly: false,
                      labelText: 'User Name',
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 1,
                      validator: validateUsername,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextFieldWidget(
                      controller: _emailController,
                      obscureText: false,
                      filled: false,
                      readOnly: false,
                      labelText: 'Email',
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      validator: validateMail,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextFieldWidget(
                      controller: _phoneController,
                      obscureText: false,
                      filled: false,
                      readOnly: false,
                      labelText: 'Phone Number',
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 1,
                      validator: validatePhone,
                      keyboardType: TextInputType.phone,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      maxLength: 11,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextFieldWidget(
                      controller: _passwordController,
                      obscureText: obscurity,
                      filled: false,
                      readOnly: false,
                      labelText: 'Password',
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 1,
                      validator: validatePass,
                      keyboardType: TextInputType.text,
                      suffix: InkWell(
                        onTap: visibility,
                        child: lockIcon,
                      ),
                      suffixIconColor: Colors.black,
                    ),
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
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextFieldWidget(
                      controller: repeatPasswordController,
                      obscureText: obscurity,
                      filled: false,
                      readOnly: false,
                      labelText: 'Confirm Password',
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      suffix: InkWell(
                        onTap: visibility,
                        child: lockIcon,
                      ),
                      suffixIconColor: Colors.black,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextFieldWidget(
                      controller: dateController,
                      obscureText: false,
                      filled: false,
                      readOnly: true,
                      onTap: showDatePicker,
                      labelText: 'Date Of Birth',
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextFieldWidget(
                      keyboardType: TextInputType.streetAddress,
                      controller: _addressController,
                      obscureText: false,
                      filled: false,
                      readOnly: false,
                      labelText: 'Residential Address',
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 1,
                      validator: validateAddress,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextFieldWidget(
                      controller: _genderController,
                      obscureText: false,
                      filled: false,
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      onTap: () {
                        showModalBottomSheet(
                          isDismissible: true,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          context: context,
                          builder: (BuildContext context) {
                            return FractionallySizedBox(
                              heightFactor: 0.45,
                              child: Container(
                                // height: 350,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(19)),
                                child: ListView(
                                  children: [
                                    Text(
                                      'Select Gender',
                                      style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).canvasColor,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: genders.length,
                                        itemBuilder: (context, idx) {
                                          return Column(
                                            children: [
                                              ListTileTheme(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 13.0,
                                                        right: 13.0,
                                                        top: 4,
                                                        bottom: 4),
                                                selectedColor: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                child: ListTile(
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        child: Text(
                                                          genders[idx],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts.lato(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedGender =
                                                          genders[idx];
                                                      genderValue =
                                                          selectedGender ==
                                                                  'Male'
                                                              ? 1
                                                              : 2;
                                                    });
                                                    _genderController.text =
                                                        genders[idx];

                                                    Navigator.pop(
                                                      context,
                                                    );

                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              (idx != genders.length - 1)
                                                  ? Divider(
                                                      color: Theme.of(context)
                                                          .dividerColor,
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
                      labelText: 'Gender',
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextFieldWidget(
                      controller: _referalController,
                      obscureText: false,
                      filled: false,
                      readOnly: false,
                      labelText: 'Referral Code(Optional)',
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 1,
                      // validator: v,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Checkbox.adaptive(
                          visualDensity: VisualDensity.adaptivePlatformDensity,
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
    );
  }
}
