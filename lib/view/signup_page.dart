import 'dart:convert';
import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/view/terms_and_conditions.dart';
import 'dart:async';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:get/get.dart';
import 'package:rentspace/constants/firebase_auth_constants.dart';
import 'package:flutter/material.dart';
import 'package:rentspace/view/login_page.dart';
import 'package:rentspace/constants/icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// import '../constants/db/firebase_db.dart';
import '../controller/auth/auth_controller.dart';
import '../controller/user_controller.dart';
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
  final TextEditingController _pinOneController = TextEditingController();
  final TextEditingController _pinTwoController = TextEditingController();
  final TextEditingController _referalController = TextEditingController();
  final TextEditingController _bvnController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final registerFormKey = GlobalKey<FormState>();
  final int minimumAge = 18;
  String? selectedGender;
  late int genderValue;

  // final _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  // final Random _rnd = Random();
  // final String _payUrl = "";
  // String getRandom(int length) => String.fromCharCodes(
  //       Iterable.generate(
  //         length,
  //         (_) => _chars.codeUnitAt(
  //           _rnd.nextInt(_chars.length),
  //         ),
  //       ),
  //     );

  // createNewDVA() async {
  //   setState(() {
  //     notLoading = false;
  //   });
  //   const String apiUrl = 'https://api-d.squadco.com/virtual-account';
  //   const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';
  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       'Authorization': 'Bearer $bearerToken',
  //       "Content-Type": "application/json"
  //     },
  //     body: jsonEncode(<String, String>{
  //       "customer_identifier":
  //           "SPACER/${_usernameController.text.trim().toString().toUpperCase()} ${_firstnameController.text.trim()} ${_lastnameController.text.trim()}",
  //       "first_name":
  //           "SPACER/ - ${_usernameController.text.trim().toString().toUpperCase()}",
  //       "last_name": _lastnameController.text.trim(),
  //       "mobile_num":
  //           "0${_phoneController.text.trim().replaceFirst('+234', '')}",
  //       "email": _emailController.text.trim(),
  //       "bvn": _bvnController.text.trim(),
  //       "dob": selectedDate.toString(),
  //       "address": _addressController.text,
  //       "gender": genderValue.toString()
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> parsedJson = json.decode(response.body);
  //     var updateLiquidate = FirebaseFirestore.instance.collection('dva');
  //     setState(() {
  //       vNum = parsedJson['data']['virtual_account_number'];
  //       vName = parsedJson['data']['customer_identifier'];
  //     });
  //     await updateLiquidate.add({
  //       'dva_name': vName,
  //       'dva_date': formattedDate,
  //       'dva_number': vNum,
  //       'dva_username':
  //           _usernameController.text.trim().toString().toUpperCase(),
  //     }).then((value) async {
  //       var walletUpdate = FirebaseFirestore.instance.collection('accounts');
  //       await walletUpdate.doc(userId).update({
  //         'has_dva': 'true',
  //         'dva_name': vName,
  //         'dva_number': vNum,
  //         'dva_username':
  //             _usernameController.text.trim().toString().toUpperCase(),
  //         'dva_date': formattedDate,
  //         "activities": FieldValue.arrayUnion(
  //           [
  //             "$formattedDate \nDVA Created",
  //           ],
  //         ),
  //       });
  //       setState(() {
  //         notLoading = true;
  //       });
  //       _usernameController.clear();
  //       // Get.bottomSheet(
  //       //   isDismissible: false,
  //       //   SizedBox(
  //       //     height: 400,
  //       //     child: ClipRRect(
  //       //       borderRadius: const BorderRadius.only(
  //       //         topLeft: Radius.circular(30.0),
  //       //         topRight: Radius.circular(30.0),
  //       //       ),
  //       //       child: Container(
  //       //         color: Theme.of(context).canvasColor,
  //       //         padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
  //       //         child: Column(
  //       //           crossAxisAlignment: CrossAxisAlignment.center,
  //       //           children: [
  //       //             const SizedBox(
  //       //               height: 30,
  //       //             ),
  //       //             const Icon(
  //       //               Icons.check_circle_outline,
  //       //               color: brandOne,
  //       //               size: 80,
  //       //             ),
  //       //             const SizedBox(
  //       //               height: 10,
  //       //             ),
  //       //             Text(
  //       //               'DVA Created',
  //       //               style: TextStyle(
  //       //                 fontSize: 20,
  //       //                 fontWeight: FontWeight.bold,
  //       //                 fontFamily: "DefaultFontFamily",
  //       //                 color: Theme.of(context).primaryColor,
  //       //               ),
  //       //               textAlign: TextAlign.center,
  //       //             ),
  //       //             const SizedBox(
  //       //               height: 20,
  //       //             ),
  //       //             Text(
  //       //               'DVA Name: ${vName}',
  //       //               style: TextStyle(
  //       //                 fontSize: 16,
  //       //                 fontWeight: FontWeight.bold,
  //       //                 fontFamily: "DefaultFontFamily",
  //       //                 color: Theme.of(context).primaryColor,
  //       //               ),
  //       //               textAlign: TextAlign.center,
  //       //             ),
  //       //             const SizedBox(
  //       //               height: 20,
  //       //             ),
  //       //             Text(
  //       //               'DVA Number: ${vNum}',
  //       //               style: TextStyle(
  //       //                 fontSize: 16,
  //       //                 fontWeight: FontWeight.bold,
  //       //                 fontFamily: "DefaultFontFamily",
  //       //                 color: Theme.of(context).primaryColor,
  //       //               ),
  //       //               textAlign: TextAlign.center,
  //       //             ),
  //       //             const SizedBox(
  //       //               height: 20,
  //       //             ),
  //       //             Text(
  //       //               'DVA Bank: GTBank',
  //       //               style: TextStyle(
  //       //                 fontSize: 16,
  //       //                 fontWeight: FontWeight.bold,
  //       //                 fontFamily: "DefaultFontFamily",
  //       //                 color: Theme.of(context).primaryColor,
  //       //               ),
  //       //               textAlign: TextAlign.center,
  //       //             ),
  //       //             const SizedBox(
  //       //               height: 30,
  //       //             ),
  //       //             GFButton(
  //       //               onPressed: () {
  //       //                 for (int i = 0; i < 2; i++) {
  //       //                   Get.back();
  //       //                 }
  //       //               },
  //       //               icon: const Icon(
  //       //                 Icons.arrow_right_outlined,
  //       //                 size: 30,
  //       //                 color: Colors.white,
  //       //               ),
  //       //               color: brandOne,
  //       //               text: "Done",
  //       //               shape: GFButtonShape.pills,
  //       //               fullWidthButton: true,
  //       //             ),
  //       //             const SizedBox(
  //       //               height: 20,
  //       //             ),
  //       //           ],
  //       //         ),
  //       //       ),
  //       //     ),
  //       //   ),
  //       // );
  //     }).catchError((error) {
  //       setState(() {
  //         notLoading = true;
  //       });
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
  //                             size: 30,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const Align(
  //                       alignment: Alignment.center,
  //                       child: Icon(
  //                         Iconsax.warning_24,
  //                         color: Colors.red,
  //                         size: 75,
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 12,
  //                     ),
  //                     Text(
  //                       'Oops!',
  //                       style: GoogleFonts.nunito(
  //                         color: Colors.red,
  //                         fontSize: 28,
  //                         fontWeight: FontWeight.w800,
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 5,
  //                     ),
  //                     Text(
  //                       "Something went wrong, try again later",
  //                       textAlign: TextAlign.center,
  //                       style:
  //                           GoogleFonts.nunito(color: Colors.red, fontSize: 18),
  //                     ),
  //                     const SizedBox(
  //                       height: 10,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           });

  //       // Get.snackbar(
  //       //   "Oops",
  //       //   "Something went wrong, try again later",
  //       //   animationDuration: const Duration(seconds: 2),
  //       //   backgroundColor: Colors.red,
  //       //   colorText: Colors.white,
  //       //   snackPosition: SnackPosition.BOTTOM,
  //       // );
  //     });
  //   } else {
  //     setState(() {
  //       notLoading = true;
  //     });
  //     // ignore: use_build_context_synchronously
  //     showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             title: null,
  //             elevation: 0,
  //             content: SizedBox(
  //               height: 250,
  //               child: Column(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: Align(
  //                       alignment: Alignment.topRight,
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(30),
  //                           // color: brandOne,
  //                         ),
  //                         child: const Icon(
  //                           Iconsax.close_circle,
  //                           color: brandOne,
  //                           size: 30,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const Align(
  //                     alignment: Alignment.center,
  //                     child: Icon(
  //                       Iconsax.warning_24,
  //                       color: Colors.red,
  //                       size: 75,
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 12,
  //                   ),
  //                   Text(
  //                     'Error!',
  //                     style: GoogleFonts.nunito(
  //                       color: Colors.red,
  //                       fontSize: 28,
  //                       fontWeight: FontWeight.w800,
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 5,
  //                   ),
  //                   Text(
  //                     "something went wrong",
  //                     textAlign: TextAlign.center,
  //                     style: GoogleFonts.nunito(color: brandOne, fontSize: 18),
  //                   ),
  //                   const SizedBox(
  //                     height: 10,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         });

  //     // Get.snackbar(
  //     //   "Error!",
  //     //   "something went wrong",
  //     //   animationDuration: const Duration(seconds: 1),
  //     //   backgroundColor: Colors.red,
  //     //   colorText: Colors.white,
  //     //   snackPosition: SnackPosition.BOTTOM,
  //     // );
  //     print(
  //         'Request failed with status: ${response.statusCode}, ${response.body}');
  //   }
  // }

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

  // checkUserNameValidity() async {
  //   QuerySnapshot querySnapshot =
  //       await _firestore.collection(collectionName).get();

  //   for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
  //     Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
  //     if (data != null &&
  //         data['dva_username'].toString().toLowerCase() ==
  //             _usernameController.text.trim().toLowerCase()) {
  //       setState(() {
  //         _mssg = "username exists, choose another.";
  //       });
  //     } else {
  //       setState(() {
  //         _mssg = "username is available.";
  //       });
  //     }
  //   }
  // }

  @override
  initState() {
    super.initState();
    _usernameController.clear();
    setState(() {
      _mssg = "";
      vNum = "";
      vName = "";
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

    validatePinOne(pinOneValue) {
      if (pinOneValue.isEmpty) {
        return 'pin cannot be empty';
      }
      if (pinOneValue.length < 4) {
        return 'pin is incomplete';
      }
      if (int.tryParse(pinOneValue) == null) {
        return 'enter valid number';
      }
      return null;
    }

    validatePinTwo(pinTwoValue) {
      if (pinTwoValue.isEmpty) {
        return 'pin cannot be empty';
      }
      if (pinTwoValue.length < 4) {
        return 'pin is incomplete';
      }
      if (int.tryParse(pinTwoValue) == null) {
        return 'enter valid number';
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
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.text,
      validator: validateUsername,
      // onChanged: (e) {
      //   if (_usernameController.text.trim().length >= 7) {
      //     checkUserNameValidity();
      //   }
      // },
      // maxLength: 10,
      decoration: InputDecoration(
        label: Text(
          "Choose new username",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        // prefixText: "SPACER/",
        prefixStyle: GoogleFonts.nunito(
          color: Theme.of(context).primaryColor,
          fontSize: 13,
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
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
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
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: 20,
        color: Theme.of(context).primaryColor,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: brandTwo, width: 1.0),
        borderRadius: BorderRadius.circular(5),
      ),
    );
    //Pin
    final pin_one = Pinput(
      defaultPinTheme: defaultPinTheme,
      controller: _pinOneController,
      length: 4,
      validator: validatePinOne,
      onChanged: validatePinOne,
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );
    //Pin
    final pin_two = Pinput(
      defaultPinTheme: defaultPinTheme,
      controller: _pinTwoController,
      length: 4,
      validator: validatePinTwo,
      onChanged: validatePinTwo,
      // onCompleted: _doSomething,
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
    );
//Address
    final referal = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _referalController,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        // label: Text(
        //   "Referal code (Optional)",
        //   style: GoogleFonts.nunito(
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
        hintText: 'You and your referrer earn 1 point each',
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
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
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        label: Text(
          "Enter your First name",
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
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
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
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        label: Text(
          "Enter Last name",
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
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
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
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
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
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
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

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          context: context,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primaryContainer: brandTwo,
                  primary: brandTwo, // header background color
                  onPrimary: Colors.white,
                  onBackground: brandTwo,
                  // onSecondary: brandTwo,

                  outline: brandTwo,
                  background: brandTwo,
                  onSurface: brandTwo, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: brandTwo, // button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
          initialDate: selectedDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now());
      if (picked != null && picked != selectedDate) {
        final int age = DateTime.now().year - picked.year;
        if (age < minimumAge) {
          // Show an error message or handle the validation as needed.
          if (!context.mounted) return;
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: null,
                  elevation: 0,
                  content: SizedBox(
                    height: 250,
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
                                borderRadius: BorderRadius.circular(30),
                                // color: brandOne,
                              ),
                              child: Icon(
                                Iconsax.close_circle,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Iconsax.warning_24,
                            color: Colors.red,
                            size: 75,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Error! :(',
                          style: GoogleFonts.nunito(
                            color: Colors.red,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Age must be at least $minimumAge years.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                              color: Colors.red, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              });

        
        } else {
          setState(() {
            selectedDate = picked;
            dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
          });
        }
      }
    }

    final dob = TextFormField(
      controller: dateController,
      cursorColor: Theme.of(context).primaryColor,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        labelStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontSize: 12,
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
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 11,
      decoration: InputDecoration(
        label: Text(
          "11 digits BVN",
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
        hintStyle: GoogleFonts.nunito(
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
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),

      // minLines: 3,
      keyboardType: TextInputType.streetAddress,
      controller: _addressController,
      maxLines: 1,
      decoration: InputDecoration(
        label: Text(
          "Enter your address",
          style: GoogleFonts.nunito(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        hintText: 'Enter your address...',
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
      selectedStyle: GoogleFonts.nunito(
          color: Theme.of(context).primaryColor, fontSize: 14),
      hintText: 'Select your gender',
      hintStyle: GoogleFonts.nunito(
          // color: Theme.of(context).primaryColor,
          fontSize: 14),
      excludeSelected: true,
      fillColor: Colors.transparent,
      listItemStyle: GoogleFonts.nunito(
          color: Theme.of(context).colorScheme.secondary, fontSize: 14),
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

    // DropdownButtonFormField(
    //   style: GoogleFonts.nunito(
    //     color: Theme.of(context).primaryColor,
    //     fontSize: 16,
    //     fontWeight: FontWeight.w600,
    //   ),
    //   items: ['Male', 'Female', 'Other']
    //       .map((value) => DropdownMenuItem(
    //             value: value,
    //             child: Text(value),
    //           ))
    //       .toList(),
    //   value: selectedGender,
    //   onChanged: (String? newValue) {
    //     setState(() {
    //       selectedGender = newValue!;
    //       genderValue = selectedGender == 'Male' ? 1 : 2;
    //     });
    //     print(genderValue);
    //   },
    //   decoration: InputDecoration(
    //     hintText: 'Choose Gender',
    //     hintStyle: GoogleFonts.nunito(
    //       color: Colors.grey,
    //       fontSize: 12,
    //       fontWeight: FontWeight.w400,
    //     ),
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(15.0),
    //       borderSide: const BorderSide(
    //         color: Color(0xffE0E0E0),
    //       ),
    //     ),
    //     focusedBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(15),
    //       borderSide: const BorderSide(color: brandOne, width: 2.0),
    //     ),
    //     enabledBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(15),
    //       borderSide: const BorderSide(
    //         color: Color(0xffE0E0E0),
    //       ),
    //     ),
    //     errorBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(15),
    //       borderSide: const BorderSide(
    //           color: Colors.red, width: 2.0), // Change color to yellow
    //     ),
    //     contentPadding: const EdgeInsets.all(14),
    //   ),
    // );

    void _doSomething() async {
      if (registerFormKey.currentState!.validate() && isChecked == true) {
        print(genderValue.toString());
        print(dateController.text);
        // authState.signUp(
        //     context,
        //     usernameController.text.trim(),
        //     emailController.text.trim(),
        //     passwordController.text.trim(),
        //     mobilenumberController.text.trim(),
        //     howDidyouHearCtl.text.trim(),);

        // showDialog(
        //     context: context,
        //     barrierDismissible: false,
        //     builder: (BuildContext context) {
        //       return Column(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: [
        //           AlertDialog.adaptive(
        //             contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
        //             elevation: 0,
        //             alignment: Alignment.bottomCenter,
        //             insetPadding: const EdgeInsets.all(0),
        //             scrollable: true,
        //             title: null,
        //             shape: const RoundedRectangleBorder(
        //               borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(30),
        //                 topRight: Radius.circular(30),
        //               ),
        //             ),
        //             content: SizedBox(
        //               child: SizedBox(
        //                 width: 400,
        //                 child: Column(
        //                   children: [
        //                     Padding(
        //                       padding: const EdgeInsets.symmetric(vertical: 40),
        //                       child: Column(
        //                         children: [
        //                           Padding(
        //                             padding: const EdgeInsets.symmetric(
        //                                 vertical: 15),
        //                             child: Align(
        //                               alignment: Alignment.topCenter,
        //                               child: Text(
        //                                 'Setup Your Transaction Pin',
        //                                 style: GoogleFonts.nunito(
        //                                   color: brandTwo,
        //                                   fontSize: 20,
        //                                   fontWeight: FontWeight.w800,
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                           const SizedBox(
        //                             height: 20,
        //                           ),
        //                           pin_one,
        //                           const SizedBox(
        //                             height: 30,
        //                           ),
        //                           Padding(
        //                             padding: const EdgeInsets.symmetric(
        //                                 vertical: 10),
        //                             child: Column(
        //                               children: [
        //                                 Padding(
        //                                   padding: const EdgeInsets.all(3),
        //                                   child: ElevatedButton(
        //                                     onPressed: () {
        //                                       Navigator.of(context).pop();
        //                                       showDialog(
        //                                           context: context,
        //                                           barrierDismissible: false,
        //                                           builder:
        //                                               (BuildContext context) {
        //                                             return Column(
        //                                               mainAxisAlignment:
        //                                                   MainAxisAlignment.end,
        //                                               children: [
        //                                                 AlertDialog.adaptive(
        //                                                   contentPadding:
        //                                                       const EdgeInsets
        //                                                           .fromLTRB(30,
        //                                                           30, 30, 20),
        //                                                   elevation: 0,
        //                                                   alignment: Alignment
        //                                                       .bottomCenter,
        //                                                   insetPadding:
        //                                                       const EdgeInsets
        //                                                           .all(0),
        //                                                   scrollable: true,
        //                                                   title: null,
        //                                                   shape:
        //                                                       const RoundedRectangleBorder(
        //                                                     borderRadius:
        //                                                         BorderRadius
        //                                                             .only(
        //                                                       topLeft: Radius
        //                                                           .circular(30),
        //                                                       topRight: Radius
        //                                                           .circular(30),
        //                                                     ),
        //                                                   ),
        //                                                   content: SizedBox(
        //                                                     child: SizedBox(
        //                                                       width: 400,
        //                                                       child: Column(
        //                                                         children: [
        //                                                           Padding(
        //                                                             padding: const EdgeInsets
        //                                                                 .symmetric(
        //                                                                 vertical:
        //                                                                     40),
        //                                                             child:
        //                                                                 Column(
        //                                                               children: [
        //                                                                 Padding(
        //                                                                   padding: const EdgeInsets
        //                                                                       .symmetric(
        //                                                                       vertical: 15),
        //                                                                   child:
        //                                                                       Align(
        //                                                                     alignment:
        //                                                                         Alignment.topCenter,
        //                                                                     child:
        //                                                                         Text(
        //                                                                       'Confirm Your Transaction Pin',
        //                                                                       style: GoogleFonts.nunito(
        //                                                                         color: brandTwo,
        //                                                                         fontSize: 20,
        //                                                                         fontWeight: FontWeight.w800,
        //                                                                       ),
        //                                                                     ),
        //                                                                   ),
        //                                                                 ),
        //                                                                 const SizedBox(
        //                                                                   height:
        //                                                                       20,
        //                                                                 ),
        //                                                                 pin_two,
        //                                                                 const SizedBox(
        //                                                                   height:
        //                                                                       30,
        //                                                                 ),
        //                                                                 Padding(
        //                                                                   padding: const EdgeInsets
        //                                                                       .symmetric(
        //                                                                       vertical: 10),
        //                                                                   child:
        //                                                                       Column(
        //                                                                     children: [
        //                                                                       Padding(
        //                                                                         padding: const EdgeInsets.all(3),
        //                                                                         child: ElevatedButton(
        //                                                                           onPressed: () {
        //                                                                             print(_pinOneController.text.trim());
        //                                                                             print(_pinTwoController.text.trim());
        //                                                                             if (_pinOneController.text.trim() != _pinTwoController.text.trim()) {
        //                                                                               showDialog(
        //                                                                                   context: context,
        //                                                                                   barrierDismissible: false,
        //                                                                                   builder: (BuildContext context) {
        //                                                                                     return AlertDialog(
        //                                                                                       shape: RoundedRectangleBorder(
        //                                                                                         borderRadius: BorderRadius.circular(10),
        //                                                                                       ),
        //                                                                                       title: null,
        //                                                                                       elevation: 0,
        //                                                                                       content: SizedBox(
        //                                                                                         height: 250,
        //                                                                                         child: Column(
        //                                                                                           children: [
        //                                                                                             GestureDetector(
        //                                                                                               onTap: () {
        //                                                                                                 Navigator.of(context).pop();
        //                                                                                               },
        //                                                                                               child: Align(
        //                                                                                                 alignment: Alignment.topRight,
        //                                                                                                 child: Container(
        //                                                                                                   decoration: BoxDecoration(
        //                                                                                                     borderRadius: BorderRadius.circular(30),
        //                                                                                                     // color: brandOne,
        //                                                                                                   ),
        //                                                                                                   child: const Icon(
        //                                                                                                     Iconsax.close_circle,
        //                                                                                                     color: brandOne,
        //                                                                                                     size: 30,
        //                                                                                                   ),
        //                                                                                                 ),
        //                                                                                               ),
        //                                                                                             ),
        //                                                                                             const Align(
        //                                                                                               alignment: Alignment.center,
        //                                                                                               child: Icon(
        //                                                                                                 Iconsax.warning_24,
        //                                                                                                 color: Colors.red,
        //                                                                                                 size: 75,
        //                                                                                               ),
        //                                                                                             ),
        //                                                                                             const SizedBox(
        //                                                                                               height: 12,
        //                                                                                             ),
        //                                                                                             Text(
        //                                                                                               'Error!',
        //                                                                                               style: GoogleFonts.nunito(
        //                                                                                                 color: Colors.red,
        //                                                                                                 fontSize: 28,
        //                                                                                                 fontWeight: FontWeight.w800,
        //                                                                                               ),
        //                                                                                             ),
        //                                                                                             const SizedBox(
        //                                                                                               height: 5,
        //                                                                                             ),
        //                                                                                             Text(
        //                                                                                               "Pin does not match",
        //                                                                                               textAlign: TextAlign.center,
        //                                                                                               style: GoogleFonts.nunito(color: brandOne, fontSize: 18),
        //                                                                                             ),
        //                                                                                             const SizedBox(
        //                                                                                               height: 10,
        //                                                                                             ),
        //                                                                                           ],
        //                                                                                         ),
        //                                                                                       ),
        //                                                                                     );
        //                                                                                   });

        //                                                                               // showTopSnackBar(
        //                                                                               //   Overlay.of(context),
        //                                                                               //   CustomSnackBar.error(
        //                                                                               //     // backgroundColor: brandOne,
        //                                                                               //     message: 'Pin does not match',
        //                                                                               //     textStyle: GoogleFonts.nunito(
        //                                                                               //       fontSize: 14,
        //                                                                               //       color: Colors.white,
        //                                                                               //       fontWeight: FontWeight.w700,
        //                                                                               //     ),
        //                                                                               //   ),
        //                                                                               // );
        //                                                                               // Get.snackbar(
        //                                                                               //   "Pin Mismatch",
        //                                                                               //   'Pin does not match',
        //                                                                               //   animationDuration: Duration(seconds: 1),
        //                                                                               //   backgroundColor: Colors.red,
        //                                                                               //   colorText: Colors.white,
        //                                                                               //   snackPosition: SnackPosition.TOP,
        //                                                                               // );
        //                                                                             } else {
        //                                                                               authController.register(_emailController.text.trim(), _passwordController.text.trim(), _firstnameController.text.trim(), _lastnameController.text.trim(), _phoneController.text.trim().substring(1), _pinTwoController.text.trim(), _referalController.text.trim(), _usernameController.text.trim(), _addressController.text.trim(), genderValue.toString(), dateController.text, context);
        //                                                                             }
        //                                                                           },
        //                                                                           style: ElevatedButton.styleFrom(
        //                                                                             backgroundColor: brandTwo,
        //                                                                             shape: RoundedRectangleBorder(
        //                                                                               borderRadius: BorderRadius.circular(8),
        //                                                                             ),
        //                                                                             padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        //                                                                             textStyle: const TextStyle(color: brandFour, fontSize: 13),
        //                                                                           ),
        //                                                                           child: const Text(
        //                                                                             "Finish",
        //                                                                             style: TextStyle(
        //                                                                               color: Colors.white,
        //                                                                               fontWeight: FontWeight.w700,
        //                                                                               fontSize: 16,
        //                                                                             ),
        //                                                                           ),
        //                                                                         ),
        //                                                                       ),
        //                                                                       const SizedBox(
        //                                                                         height: 10,
        //                                                                       ),
        //                                                                     ],
        //                                                                   ),
        //                                                                 ),
        //                                                               ],
        //                                                             ),
        //                                                           ),
        //                                                         ],
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                 )
        //                                               ],
        //                                             );
        //                                           });
        //                                     },
        //                                     style: ElevatedButton.styleFrom(
        //                                       backgroundColor: brandTwo,
        //                                       shape: RoundedRectangleBorder(
        //                                         borderRadius:
        //                                             BorderRadius.circular(8),
        //                                       ),
        //                                       padding:
        //                                           const EdgeInsets.symmetric(
        //                                               horizontal: 60,
        //                                               vertical: 15),
        //                                       textStyle: const TextStyle(
        //                                           color: brandFour,
        //                                           fontSize: 13),
        //                                     ),
        //                                     child: const Text(
        //                                       "Next",
        //                                       style: TextStyle(
        //                                         color: Colors.white,
        //                                         fontWeight: FontWeight.w700,
        //                                         fontSize: 16,
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 ),
        //                                 const SizedBox(
        //                                   height: 10,
        //                                 ),
        //                               ],
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           )
        //         ],
        //       );
        //     });
      } else {
        customErrorDialog(
            context, 'Error!', "Please fill the form properly to proceed");
      }
    }

    return Scaffold(
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
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: false,
        title: Text(
          'Sign up',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 16,
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 3),
                          child: Text(
                            'First Name',
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                        ),
                        firstname,
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
                            'Last Name',
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 3),
                          child: Text(
                            'User Name',
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 3),
                          child: Text(
                            'Email Address',
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 3),
                          child: Text(
                            'Password',
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
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
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 15,
                                  color: Color(0xff828282),
                                ),
                                SizedBox(
                                  width: 320,
                                  child: Text(
                                    'Password -8 Characters, One Uppercase, One Lowercase, One Special Characters (#%&*?@)',
                                    softWrap: true,
                                    style: GoogleFonts.nunito(
                                      color: const Color(0xff828282),
                                      fontSize: 12,
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 3),
                          child: Text(
                            'Date Of Birth',
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 3),
                          child: Text(
                            'Residential Address',
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 3),
                          child: Text(
                            'Gender',
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 3),
                          child: Text(
                            'Referral Code(Optional)',
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.height / 80,
                          MediaQuery.of(context).size.height / 600,
                          MediaQuery.of(context).size.height / 80,
                          // MediaQuery.of(context).size.height / 500,
                          0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            style: GoogleFonts.nunito(
                              fontSize: 12.sp,
                              color: Theme.of(context).primaryColor,

                              // fontFamily: "DefaultFontFamily",
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(const TermsAndConditions());
                            },
                            child: Text(
                              'Terms of service',
                              style: GoogleFonts.nunito(
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
                          if (registerFormKey.currentState!.validate() &&
                              isChecked == true) {
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
                                 referralCode: _referalController.text.trim() ?? ''
                                );
                          } else {
                            customErrorDialog(context, 'Error!',
                                "Please fill the form properly to proceed");
                          }
                        },
                        child: Text(
                          'Create account',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
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
    );
  }
}
