import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/view/actions/idle_page.dart';
import 'package:rentspace/view/actions/biometrics_page.dart';
import 'package:rentspace/view/actions/confirm_reset_page.dart';
import 'package:rentspace/view/home_page.dart';
import 'package:rentspace/view/intro_slider.dart';
import 'package:rentspace/view/no_connection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:rentspace/constants/firebase_auth_constants.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:intl/intl.dart';

bool hasConnection = false.obs();
//final loggedinUser = GetStorage();
final _activities = [];
const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
Random _rnd = Random();
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);

class AuthController extends GetxController {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  CollectionReference users = FirebaseFirestore.instance.collection('accounts');
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  static AuthController instance = Get.find();

  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;

    if (_connectionStatus == ConnectivityResult.none) {
      hasConnection = false;
    } else {
      hasConnection = true;
    }
  }

  _setInitialScreen(User? user) async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();

      print(result.toString());
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    if (result.toString() == "ConnectivityResult.none") {
      Get.off(NoConnection());
    } else {
      if (user == null) {
        Get.offAll(() => IntroScreen());
      } else {
        Get.offAll(() => BiometricsPage());
      }
    }
  }

//5DSF76SFYW
  String getRandom(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  register(String email, password, _firstnameController, _lastnameController,
      _phoneController, _pinOneController, _referalController) async {
    try {
      //showLoading();

      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        FirebaseFirestore.instance
            .collection('accounts')
            .doc(value.user!.uid)
            .set({
          'image':
              'https://firebasestorage.googleapis.com/v0/b/rentspace-1aebe.appspot.com/o/assets%2FProfile-Avatar-PNG.png?alt=media&token=cccd3d63-3775-4329-ac16-0ba55809e07a',
          'rentspace_id': generateRandomString(11),
          'wallet_id': generateRandomString(10),
          'password': password,
          'id': value.user!.uid,
          'wallet_balance': '0',
          'firstname': _firstnameController,
          'lastname': _lastnameController,
          'address': '',
          'transaction_pin': _pinOneController,
          'phone': '+234$_phoneController',
          'email': value.user!.email,
          'id_card': '',
          'activities': FieldValue.arrayUnion(
            ["$formattedDate\nRentSpace account created"],
          ),
          'has_rent': 'false',
          'account_number': '',
          'dva_name': '',
          'dva_number': '',
          'dva_username': '',
          'dva_date': '',
          'bank_name': '',
          'account_name': '',
          'bvn': '',
          'has_verified_bvn': 'false',
          'has_verified_kyc': 'false',
          'has_verified_email': 'false',
          'has_verified_phone': 'false',
          'has_dva': 'false',
          //requires encryption
          'card_digit': '',
          'card_cvv': '',
          'card_expire': '',
          'card_holder': '',
          'kyc_details': '',
          //portfolio
          'loan_amount': '0',
          'total_savings': '0',
          'total_interest': '0',
          'total_profits': '0',
          'network_health': '',
          'total_debts': '0',
          'total_investments': '0',
          'total_assets': '0',
          'total_mortgage': '0',
          'total_insurance': '0',
          'utility_points': '0',
          'referals': 0,
          'account_date': formattedDate,
          'referar_id': _referalController,
          'referal_code': getRandom(10).toString(),
          'status': 'unverified',
          'finance_health': '0',
        }).then((value) async {
          print("Signed up");

          //loggedinUser.write('userName', _firstnameController.toString());
        });
      });
    } catch (error) {
      int startBracketIndex = error.toString().indexOf('[');
      int endBracketIndex = error.toString().indexOf(']');
      String nError = "";
      if (startBracketIndex != -1 && endBracketIndex != -1) {
        nError = error.toString().substring(0, startBracketIndex) +
            error.toString().substring(endBracketIndex + 1);
      } else {
        nError = error.toString();
      }
      Get.snackbar(
        "Oops",
        nError,
        animationDuration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      int startBracketIndex = error.toString().indexOf('[');
      int endBracketIndex = error.toString().indexOf(']');
      String nError = "";
      if (startBracketIndex != -1 && endBracketIndex != -1) {
        nError = error.toString().substring(0, startBracketIndex) +
            error.toString().substring(endBracketIndex + 1);
      } else {
        nError = error.toString();
      }
      Get.snackbar(
        "Oops",
        nError,
        animationDuration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  reset(String email) async {
    try {
      //showLoading();
      await auth
          .sendPasswordResetEmail(email: email)
          .then((value) => Get.to(ConfirmResetPage()));
    } catch (error) {
      int startBracketIndex = error.toString().indexOf('[');
      int endBracketIndex = error.toString().indexOf(']');
      String nError = "";
      if (startBracketIndex != -1 && endBracketIndex != -1) {
        nError = error.toString().substring(0, startBracketIndex) +
            error.toString().substring(endBracketIndex + 1);
      } else {
        nError = error.toString();
      }
      Get.snackbar(
        "Oops",
        nError,
        animationDuration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void signOut() async {
    await auth.signOut();
  }

  String generateRandomString(int length) {
    final _random = Random();
    const _availableChars = '1234567890';
    final randomString = List.generate(length,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();

    return randomString;
  }
}
