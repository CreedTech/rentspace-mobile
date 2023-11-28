import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:rentspace/constants/icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/view/actions/add_card.dart';
import 'package:rentspace/view/actions/bank_and_card.dart';

import 'dart:math';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:rentspace/view/actions/fund_wallet.dart';
import 'package:rentspace/view/home_page.dart';

var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);

String _IDImage = "";
String _mssg = "";
bool isChecking = false;
bool canProceed = false;
const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
Random _rnd = Random();

class BvnPage extends StatefulWidget {
  const BvnPage({Key? key}) : super(key: key);

  @override
  _BvnPageState createState() => _BvnPageState();
}

final TextEditingController _bvnController = TextEditingController();

class _BvnPageState extends State<BvnPage> {
  final UserController userController = Get.find();
  String getRandom(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  bvnDebit() async {
    var walletUpdate = FirebaseFirestore.instance.collection('accounts');

    await walletUpdate.doc(userId).update({
      'wallet_balance':
          (((int.tryParse(userController.user[0].userWalletBalance))!) - 45)
              .toString(),
      "activities": FieldValue.arrayUnion(
        [
          "$formattedDate\nBVN verification\nPaid ₦45",
        ],
      ),
    }).then((value) async {
      var bvnUpdate = FirebaseFirestore.instance.collection('bvn_debit');
      await bvnUpdate.add({
        'user_id': userController.user[0].rentspaceID,
        'id': userController.user[0].id,
        'amount': "35",
        'charge': '10',
        'type': "BVN verification",
        'transaction_id': getRandom(8),
        'date': formattedDate,
      });
    });
  }

  verifyBVN() async {
    setState(() {
      isChecking = true;
    });
    const String apiUrl = "https://api.watupay.com/v1/verify";
    const String bearerToken = "WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, String>{
        "channel": "bvn-data",
        "bvn": _bvnController.text.trim().toString(),
      }),
    );

    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final fullName = jsonResponse['data']["first_name"] +
          " " +
          jsonResponse['data']["last_name"] +
          " " +
          jsonResponse['data']["middle_name"];
      final phoneNumber = jsonResponse['data']["mobile"];
      if (phoneNumber != "") {
        bvnDebit();
      }
      setState(() {
        isChecking = false;
        canProceed = true;
        _mssg = fullName;
      });
      print(fullName);
    } else {
      // Error handling
      setState(() {
        isChecking = false;
        canProceed = false;
        _mssg = "Invalid BVN";
      });
      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }

  @override
  initState() {
    super.initState();
    setState(() {
      _mssg = "";
    });
    _bvnController.clear();
  }

  @override
  Widget build(BuildContext context) {
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
      return '';
    }

    //Phone number
    final bvn = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _bvnController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateBvn,
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 11,
      decoration: InputDecoration(
        label: Text(
          "11 digits BVN",
          style: TextStyle(
            color: Colors.grey,
          ),
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
        hintText: 'e.g 12345678900',
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
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          '',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
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
          ListView(
            children: [
              (isChecking)
                  ? LinearProgressIndicator(
                      color: brandOne,
                      minHeight: 4,
                    )
                  : SizedBox(),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Enter BVN",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "DefaultFontFamily",
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    bvn,
                    Text(
                      _mssg,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "DefaultFontFamily",
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "This BVN verification will attract a charge of ₦45 from your SpaceWallet",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: "DefaultFontFamily",
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    (canProceed)
                        ? GFButton(
                            onPressed: () {
                              if (validateBvn(_bvnController.text.trim()) ==
                                  "") {
                                Get.to(KycPage(
                                  bvnValue: _bvnController.text.trim(),
                                ));
                              } else {
                                Get.snackbar(
                                  "Invalid",
                                  'Please fill the form properly to proceed',
                                  animationDuration: Duration(seconds: 1),
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
                            shape: GFButtonShape.pills,
                            text: "Proceed",
                            fullWidthButton: true,
                            icon: Icon(
                              Icons.arrow_right_outlined,
                              color: Colors.white,
                              size: 14,
                            ),
                            color: brandOne,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: "DefaultFontFamily",
                            ),
                          )
                        : GFButton(
                            onPressed: () {
                              if ((int.tryParse(userController
                                      .user[0].userWalletBalance)!) >
                                  100) {
                                if (validateBvn(_bvnController.text.trim()) ==
                                    "") {
                                  verifyBVN();
                                } else {
                                  Get.snackbar(
                                    "Invalid",
                                    'Please fill all the form properly to proceed',
                                    animationDuration: Duration(seconds: 1),
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              } else {
                                Get.bottomSheet(
                                  SizedBox(
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Text(
                                            'Insufficient fund. You need to fund your wallet to perform this transaction.',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontFamily: "DefaultFontFamily",
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GFButton(
                                            onPressed: () {
                                              Get.back();
                                              Get.to(FundWallet());
                                            },
                                            shape: GFButtonShape.pills,
                                            text: "Fund Wallet",
                                            fullWidthButton: true,
                                            color: brandOne,
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: "DefaultFontFamily",
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            shape: GFButtonShape.pills,
                            text: "Verify BVN",
                            fullWidthButton: true,
                            icon: Icon(
                              Icons.arrow_right_outlined,
                              color: Colors.white,
                              size: 14,
                            ),
                            color: brandOne,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: "DefaultFontFamily",
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class KycPage extends StatefulWidget {
  String bvnValue;
  KycPage({Key? key, required this.bvnValue}) : super(key: key);

  @override
  _KycPageState createState() => _KycPageState();
}

final TextEditingController _kycController = TextEditingController();
bool _isUploading = false;

class _KycPageState extends State<KycPage> {
//upload image
  File? selectedImage;
  Future getImage() async {
    var _image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(_image!.path); // won't have any error now
    });
    uploadImg();
  }

  Future uploadImg() async {
    setState(() {
      _isUploading = true;
    });
    var userIdUpdate = FirebaseFirestore.instance.collection('accounts');

    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = basename(selectedImage!.path);
    Reference ref = storage.ref().child(fileName);
    UploadTask uploadTask = ref.putFile(selectedImage!);
    var downloadURL =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    var url = downloadURL.toString();
    await userIdUpdate.doc(userId).update({
      'id_card': url,
    }).then((value) {
      setState(() {
        _IDImage = url.toString();
        _isUploading = false;
      });

      Get.snackbar(
        "Image uploaded!",
        'Your ID card image has been uploaded successfully',
        animationDuration: Duration(seconds: 1),
        backgroundColor: brandOne,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }).catchError((error) {
      Get.snackbar(
        "Error",
        error.toString(),
        animationDuration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  //Phone number
  final kyc = TextFormField(
    enableSuggestions: true,
    cursorColor: Colors.black,
    controller: _kycController,
    style: TextStyle(
      color: Colors.black,
    ),
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
      label: Text(
        "KYC : residential address",
        style: TextStyle(
          color: Colors.black,
          fontFamily: "DefaultFontFamily",
        ),
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
      hintText: 'Enter your KYC',
      hintStyle: TextStyle(
        color: Colors.black,
        fontFamily: "DefaultFontFamily",
        fontSize: 13,
      ),
    ),
    maxLines: 5,
    maxLength: 200,
  );
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isUploading,
      progressIndicator: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
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
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: Text(
            '',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: "DefaultFontFamily",
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
            ListView(
              children: [
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: brandThree,
                            border: Border.all(
                              color: brandOne, // Color of the border
                              width: 2.0, // Width of the border
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Column(
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.black,
                                size: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Click to upload a valid government ID (e.g National ID card, Drivers' lisence, Voters' card, International passport). Make sure your face is properly shown on the ID card. Image upload dimension should be 800px x 500px.",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: "DefaultFontFamily",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      kyc,
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: GFButton(
                          onPressed: () {
                            if (_kycController.text.trim() != "" &&
                                _IDImage != "") {
                              Get.to(BvnAndKycConfirmPage(
                                  bvnValue: widget.bvnValue,
                                  kycValue: _kycController.text.trim(),
                                  idCardValue: _IDImage));
                            } else {
                              Get.snackbar(
                                "Uncompleted!",
                                'Please fill in your KYC correctly and upload a valid ID card image to verify.',
                                animationDuration: Duration(seconds: 1),
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          shape: GFButtonShape.pills,
                          text: "Next",
                          icon: Icon(
                            Icons.arrow_right_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                          color: brandOne,
                          fullWidthButton: true,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: "DefaultFontFamily",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BvnAndKycConfirmPage extends StatefulWidget {
  String bvnValue, kycValue, idCardValue;
  BvnAndKycConfirmPage({
    Key? key,
    required this.bvnValue,
    required this.kycValue,
    required this.idCardValue,
  }) : super(key: key);

  @override
  _BvnAndKycConfirmPageState createState() => _BvnAndKycConfirmPageState();
}

final TextEditingController _passwordController = TextEditingController();
bool obscurity = true;
Icon lockIcon = LockIcon().open;
String _userPassword = "";
String _cardHolder = "";
String _cardCvv = "";
String _cardExpire = "";
String _cardNumber = "";

class _BvnAndKycConfirmPageState extends State<BvnAndKycConfirmPage> {
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

  getUser() async {
    var collection = FirebaseFirestore.instance.collection('accounts');
    var docSnapshot = await collection.doc(userId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        _userPassword = data?['password'];
        _cardCvv = data?['card_cvv'];
        _cardExpire = data?['card_expire'];
        _cardHolder = data?['card_holder'];
        _cardNumber = data?['card_digit'];
      });
    }
  }

  Future verify() async {
    var userUpdate = FirebaseFirestore.instance.collection('accounts');

    await userUpdate.doc(userId).update({
      'kyc_details': widget.kycValue,
      'bvn': widget.bvnValue,
      'has_verified_bvn': 'true',
      'id_card': widget.idCardValue,
      'status': 'verified'
    }).then((value) {
      Get.snackbar(
        "Success",
        'BVN & KYC updated!',
        animationDuration: Duration(seconds: 1),
        backgroundColor: brandOne,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      Get.bottomSheet(
        SizedBox(
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: Container(
              color: brandOne,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Your BVN & KYC has been updated successfully. Proceed to add Card',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "DefaultFontFamily",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GFButton(
                          onPressed: () {
                            Get.back();
                            Get.to(AddCard());
                          },
                          shape: GFButtonShape.pills,
                          text: "Proceed",
                          fullWidthButton: false,
                          color: Colors.greenAccent,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: "DefaultFontFamily",
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GFButton(
                          onPressed: () {
                            for (int i = 0; i < 4; i++) {
                              Get.back();
                            }
                          },
                          shape: GFButtonShape.pills,
                          text: "Dismiss",
                          fullWidthButton: false,
                          color: Colors.red,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: "DefaultFontFamily",
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).catchError((error) {
      Get.snackbar(
        "Error",
        error.toString(),
        animationDuration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  //Textform field

  @override
  initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final password = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _passwordController,
      obscureText: obscurity,
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        suffix: InkWell(
          onTap: visibility,
          child: lockIcon,
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
        hintText: 'Enter password to submit',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Confirm details',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
            fontFamily: "DefaultFontFamily",
            fontWeight: FontWeight.bold,
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
          ListView(
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5, 0, 5),
                      child: Text(
                        "ID card:",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "DefaultFontFamily",
                          letterSpacing: 1.4,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    //ID Cardvalue
                    Container(
                      decoration: BoxDecoration(
                        color: brandThree,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                      child: Image.network(
                        widget.idCardValue,
                        height: 200,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            gradientOne,
                            gradientTwo,
                          ],
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BVN: " + widget.bvnValue,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: "DefaultFontFamily",
                              letterSpacing: 0.5,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "KYC: " + widget.kycValue,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: "DefaultFontFamily",
                              letterSpacing: 0.5,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    password,
                    SizedBox(
                      height: 60,
                    ),

                    GFButton(
                      onPressed: () {
                        if (_passwordController.text.trim() != "" &&
                            _userPassword != "" &&
                            _passwordController.text.trim() == _userPassword) {
                          verify();
                        } else {
                          Get.snackbar(
                            "Incorrect password!",
                            'Please enter the correct password to proceed.',
                            animationDuration: Duration(seconds: 1),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      shape: GFButtonShape.pills,
                      text: "Submit",
                      fullWidthButton: true,
                      icon: Icon(
                        Icons.arrow_right_outlined,
                        color: Colors.white,
                        size: 14,
                      ),
                      color: brandOne,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: "DefaultFontFamily",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
