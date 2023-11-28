import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/constants/theme_services.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/view/actions/wallet_funding.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateDVA extends StatefulWidget {
  const CreateDVA({Key? key}) : super(key: key);

  @override
  _CreateDVAState createState() => _CreateDVAState();
}

var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
CollectionReference users = FirebaseFirestore.instance.collection('accounts');
CollectionReference allUsers =
    FirebaseFirestore.instance.collection('accounts');
String _mssg = "";
String vName = "";
String vNum = "";
bool notLoading = true;

class _CreateDVAState extends State<CreateDVA> {
  final UserController userController = Get.find();
  final form = intl.NumberFormat.decimalPattern();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'dva';

  TextEditingController _usernameController = TextEditingController();
  var _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Random _rnd = Random();
  String _payUrl = "";
  String getRandom(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  createNewDVA() async {
    setState(() {
      notLoading = false;
    });
    const String apiUrl = 'https://api-d.squadco.com/virtual-account';
    const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "customer_identifier":
            "SPACER/${_usernameController.text.trim().toString().toUpperCase()} ${userController.user[0].userFirst} ${userController.user[0].userLast}",
        "first_name":
            "SPACER/ - ${_usernameController.text.trim().toString().toUpperCase()}",
        "last_name": userController.user[0].userLast,
        "mobile_num":
            "0${userController.user[0].userPhone.replaceFirst('+234', '')}",
        "email": userController.user[0].email,
        "bvn": userController.user[0].bvn,
        "dob": "03/10/1990",
        "address": "22 Kota street, UK",
        "gender": "1"
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> parsedJson = json.decode(response.body);
      var updateLiquidate = FirebaseFirestore.instance.collection('dva');
      setState(() {
        vNum = parsedJson['data']['virtual_account_number'];
        vName = parsedJson['data']['customer_identifier'];
      });
      await updateLiquidate.add({
        'dva_name': vName,
        'dva_date': formattedDate,
        'dva_number': vNum,
        'dva_username':
            _usernameController.text.trim().toString().toUpperCase(),
      }).then((value) async {
        var walletUpdate = FirebaseFirestore.instance.collection('accounts');
        await walletUpdate.doc(userId).update({
          'has_dva': 'true',
          'dva_name': vName,
          'dva_number': vNum,
          'dva_username':
              _usernameController.text.trim().toString().toUpperCase(),
          'dva_date': formattedDate,
          "activities": FieldValue.arrayUnion(
            [
              "$formattedDate \nDVA Created",
            ],
          ),
        });
        setState(() {
          notLoading = true;
        });
        _usernameController.clear();
        Get.bottomSheet(
          isDismissible: false,
          SizedBox(
            height: 400,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: Container(
                color: Theme.of(context).canvasColor,
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Icon(
                      Icons.check_circle_outline,
                      color: brandOne,
                      size: 80,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'DVA Created',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'DVA Name: ${vName}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'DVA Number: ${vNum}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'DVA Bank: GTBank',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GFButton(
                      onPressed: () {
                        for (int i = 0; i < 2; i++) {
                          Get.back();
                        }
                      },
                      icon: Icon(
                        Icons.arrow_right_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      color: brandOne,
                      text: "Done",
                      shape: GFButtonShape.pills,
                      fullWidthButton: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).catchError((error) {
        setState(() {
          notLoading = true;
        });
        Get.snackbar(
          "Oops",
          "Something went wrong, try again later",
          animationDuration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    } else {
      setState(() {
        notLoading = true;
      });
      Get.snackbar(
        "Error!",
        "something went wrong",
        animationDuration: Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }

  checkUserNameValidity() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection(collectionName).get();

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
      if (data != null &&
          data['dva_username'].toString().toLowerCase() ==
              _usernameController.text.trim().toLowerCase()) {
        setState(() {
          _mssg = "username exists, choose another.";
        });
      } else {
        setState(() {
          _mssg = "username is available.";
        });
      }
    }
  }

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
      return '';
    }

    final username = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _usernameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateUsername,
      onChanged: (e) {
        if (_usernameController.text.trim().length >= 7) {
          checkUserNameValidity();
        }
      },
      maxLength: 10,
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        label: Text(
          "Choose new username",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        prefixText: "SPACER/",
        prefixStyle: TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: brandOne, width: 2.0),
        ),
        filled: true,
        fillColor: brandThree,
        hintText: 'can contain letters and numbers',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );

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
            Icons.close,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/icons/RentSpace-icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          (notLoading)
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 60, 10, 2),
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Create a free Dedicated Virtual Account (DVA)",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "DefaultFontFamily",
                                letterSpacing: 0.5,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          Text(
                            "Choose New Username",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "DefaultFontFamily",
                              letterSpacing: 1.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          username,
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            _mssg,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "DefaultFontFamily",
                              letterSpacing: 0.5,
                              color: (_mssg == "username is available.")
                                  ? Theme.of(context).primaryColor
                                  : Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          GFButton(
                            onPressed: () {
                              if (validateUsername(_usernameController.text
                                          .trim()
                                          .replaceAll(',', '')) ==
                                      "" &&
                                  (_mssg == "username is available.")) {
                                createNewDVA();
                              } else {
                                Get.snackbar(
                                  "Invalid",
                                  "Fill the form properly to proceed",
                                  animationDuration: Duration(seconds: 1),
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
                            shape: GFButtonShape.pills,
                            fullWidthButton: true,
                            child: Text(
                              'Activate DVA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: "DefaultFontFamily",
                              ),
                            ),
                            color: brandOne,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/icons/RentSpace-icon.png"),
                        fit: BoxFit.cover,
                        opacity: 0.1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Creating DVA...",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "DefaultFontFamily",
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      CircularProgressIndicator(
                        color: brandOne,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
