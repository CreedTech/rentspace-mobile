/* checkRent() async {
    for (int j = 0; j < rentController.rent.length; j++) {
      getPayment(j);
    }
  }

  getPayment(i) async {
    var db = FirebaseFirestore.instance;
    db
        .collection("rent_funding")
        .where('rent_id', isEqualTo: rentController.rent[i].rentId)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          setState(() {
            savedAmount = docSnapshot.data()["amount"].toString();
            fundingId = docSnapshot.data()["rent_id"].toString();
            fundDate = docSnapshot.data()["date"].toString();
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    ).then((value) async {
      int newBalance =
          rentController.rent[i].savedAmount + int.tryParse(savedAmount)!;
      if ((int.tryParse(savedAmount)! > 0)) {
        var rentspaces = FirebaseFirestore.instance.collection('rent_space');
        var snapshot = await rentspaces
            .where('rentspace_id', isEqualTo: rentController.rent[i].rentId)
            .get();
        if ((int.tryParse(savedAmount)! > 0) &&
            (fundingId == rentController.rent[i].rentId)) {
          for (var doc in snapshot.docs) {
            await doc.reference.update({
              'paid_amount': newBalance,
              'has_paid': 'true',
              "history": FieldValue.arrayUnion(
                [
                  "$fundDate\nSpaceRent funded\n${ch8t.format(int.tryParse(savedAmount)).toString()}",
                ],
              ),
            }).then(
              (value) async {
                var rentspaces =
                    FirebaseFirestore.instance.collection('rent_funding');
                var snapshot = await rentspaces
                    .where('rent_id', isEqualTo: rentController.rent[i].rentId)
                    .get();
                for (var doc in snapshot.docs) {
                  await doc.reference.delete();
                }
              },
              //action end
            ).then((value) async {
              setState(() {
                savedAmount = "0";
                fundingId = "";
              });
              print("rent funded");
            });
          }
        }
      } else {
        print("No fund");
      }
    });
    print("Index $i, ID ${rentController.rent[i].rentId}");
  }


























  import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/constants/theme_services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'dart:io';
import 'package:getwidget/getwidget.dart';

class FundWallet extends StatefulWidget {
  const FundWallet({Key? key}) : super(key: key);

  @override
  _FundWalletState createState() => _FundWalletState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
String _isSet = "false";
var dum1 = "".obs;
CollectionReference users = FirebaseFirestore.instance.collection('accounts');
CollectionReference allUsers = FirebaseFirestore.instance.collection('accounts');

class _FundWalletState extends State<FundWallet> {
  final UserController userController = Get.find();
  final form = intl.NumberFormat.decimalPattern();

  var publicKey = "pk_live_14f4c5057cd5408b386fe86b6c286cdce9ad7ce0";
  final plugin = PaystackPlugin();
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardUi() {
    return PaymentCard(
      number: "",
      cvc: "",
      expiryMonth: 0,
      expiryYear: 0,
    );
  }

  TextEditingController _amountController = TextEditingController();

  @override
  initState() {
    
    super.initState();
    plugin.initialize(publicKey: publicKey);
  }

  @override
  Widget build(BuildContext context) {
    validateAmount(amountValue) {
      if (amountValue.isEmpty) {
        return 'amount cannot be empty';
      }
      if (int.tryParse(amountValue) == null) {
        return 'enter valid number';
      }
      if ((int.tryParse(amountValue)! >= 1) &&
          (int.tryParse(amountValue)! < 500)) {
        return 'minimum amount is ₦500';
      }
      if ((int.tryParse(amountValue) == 0)) {
        return 'amount cannot be zero';
      }
      if (int.tryParse(amountValue)!.isNegative) {
        return 'enter valid number';
      }
      return '';
    }

    final amount = TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _amountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAmount,
      style: TextStyle(
        color: Colors.black,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(
          "Enter amount",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        prefixText: "₦",
        prefixStyle: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
        border: InputBorder.none,
        filled: true,
        fillColor: brandThree,
        hintText: 'amount in Naira',
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 2, 20, 2),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              "Fund your SpaceWallet",
              style: TextStyle(
                
                fontSize: 20.0,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w100,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            amount,
            SizedBox(
              height: 20,
            ),
            GFButton(
              onPressed: () async {
                if (validateAmount(_amountController.text.trim()) == "") {
                  Charge charge = Charge()
                    ..amount =
                        int.tryParse(_amountController.text.trim())! * 100
                    ..email = userController.user[0].email
                    ..reference = _getReference()
                    ..card = _getCardUi();

                  CheckoutResponse response = await plugin.checkout(
                    context,
                    charge: charge,
                    method: CheckoutMethod.card,
                    hideEmail: false,
                    fullscreen: false,
                    logo: Image.asset(
                      'assets/icons/logo.png',
                      height: 30,
                    ),
                  );
                  if (response.status == true) {
                    var addOrder =
                        FirebaseFirestore.instance.collection('accounts');
                    var snapshot = await addOrder
                        .where('wallet_id',
                            isEqualTo: userController.user[0].walletID)
                        .get();

                    for (var doc in snapshot.docs) {
                      try {
                        await doc.reference.update({
                          'status': 'Card Payment',
                        });
                      } catch (error) {
                        Get.snackbar(
                          "Error",
                          error.toString(),
                          animationDuration: Duration(seconds: 1),
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    }
                  } else {
                    Get.snackbar(
                      "Cancelled",
                      "Wallet funding was cancelled",
                      animationDuration: Duration(seconds: 1),
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                } else {
                  Get.snackbar(
                    "Incomplete",
                    "Fill the form completely to proceed",
                    animationDuration: Duration(seconds: 1),
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              shape: GFButtonShape.pills,
              fullWidthButton: false,
              child: Text(
                'Fund now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              color: brandTwo,
            ),
          ],
        ),
      ),
    );
  }
}





























Charge charge = Charge()
                                              ..amount = 500 * 100
                                              ..email =
                                                  userController.user[0].email
                                              ..reference = _getReference()
                                              ..card = _getCardUi();

                                            CheckoutResponse response =
                                                await plugin.checkout(
                                              context,
                                              charge: charge,
                                              method: CheckoutMethod.card,
                                              hideEmail: false,
                                              fullscreen: false,
                                              logo: Image.asset(
                                                'assets/icons/logo.png',
                                                height: 30,
                                              ),
                                            );
                                            if (response.status == true) {
                                              var addOrder = FirebaseFirestore
                                                  .instance
                                                  .collection('accounts');
                                              var snapshot = await addOrder
                                                  .where('wallet_id',
                                                      isEqualTo: userController
                                                          .user[0].walletID)
                                                  .get();

                                              for (var doc in snapshot.docs) {
                                                try {
                                                  await doc.reference.update({
                                                    'status': 'Card Payment',
                                                  });
                                                } catch (error) {
                                                  Get.snackbar(
                                                    "Error",
                                                    error.toString(),
                                                    animationDuration:
                                                        Duration(seconds: 1),
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white,
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                  );
                                                }
                                              }
                                            } else {
                                              print("Incomplete");
                                              Get.snackbar(
                                                "Error",
                                                "Something went wrong",
                                                animationDuration:
                                                    Duration(seconds: 1),
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                              );
                                            }





















                                            var request = http.Request('GET', Uri.parse('https://irecharge.com.ng/pwr_api_sandbox/v2/vend_power.php?vendor_code=YOUR_VENDOR_CODE&reference_id=REFERENCE_ID&meter=CUSTOMER_METER_NO&access_token=19051504303296&disco=METER_DISCO&phone=YOUR_PHONE_NUMBER&email=YOUR_EMAIL_ADDRESS&response_format=json&hash=YOUR_GENERATED_HASH&amount=YOUR_AMOUNT'));


http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}




import 'package:convert/convert.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:math';

Future<void> _buyAirtime() async {
  final String url = "https://irecharge.com.ng/pwr_api_sandbox/v2/vtu";
  var codeChunk = utf8.encode("2211F1FC84");
  var referenceChunk = utf8.encode(generateRandomString(12));
  var numberChunk = utf8.encode("08100322782");
  var providerChunk = utf8.encode("MTN");
  var amountChunk = utf8.encode("100");
  var publicChunk = utf8.encode("399882ccaefacbabe657776db688f805");
  var privateChunk = utf8.encode(
      "9977b6e2578a15777365f4861c8ec9df4ab41cd0310f203d1222f6dffd6507d20cdd24cac0526cbfff9b37f745497aa29a671e5d0aaf3690b41a6cbd4cb9270a");

  var output = AccumulatorSink<Digest>();
  var input = sha1.startChunkedConversion(output);
  input.add(codeChunk);
  input.add(referenceChunk);
  input.add(numberChunk);
  input.add(providerChunk);
  input.add(amountChunk);
  input.add(publicChunk);
  input.add(privateChunk);

  input.close();
  var digestString = output.events.single;

  final Map<String, String> headers = {
    "Content-Type": "application/x-www-form-urlencoded",
  };
  final Map<String, String> data = {
    "vendor_code": "2211F1FC84",
    "reference_id": generateRandomString(12),
    "vtu_email": "hahnonimus@gmail.com",
    "vtu_network": "MTN",
    "vtu_amount": "100",
    "vtu_number": "08100322782",
    "hash": digestString.toString(),
  };
  final http.Response response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: data,
  );
  if (response.statusCode == 200) {
    print(await response.body.toString());
  } else {
    print(response.reasonPhrase);
  }
} 

///////////////////////////////////////////////////////////////////////////////////////////Build android/app/build.gradle
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterRoot = localProperties.getProperty('flutter.sdk')
if (flutterRoot == null) {
    throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}


 def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }
android {
    compileSdkVersion 33
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "com.rentspace.app.android"
        // You can update the following values to match your application needs.
        // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-build-configuration.
        minSdkVersion 21
        targetSdkVersion 33
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
        
        
    }

    
    /* buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig signingConfigs.debug
        }
    } */
    
        //i saw this line on stackoverflow to fix build error
     packagingOptions {
        pickFirst "META-INF/DEPENDENCIES"
    }
     signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
   buildTypes {
       release {
           signingConfig signingConfigs.release
       }
   } 
}

flutter {
    source '../..'
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    implementation platform('com.google.firebase:firebase-bom:31.2.2')
    //implementation platform('com.google.firebase:firebase-bom:31.5.0')
    implementation 'com.google.firebase:firebase-analytics-ktx'
    //implementation 'androidx.browser:browser:1.3.0'
}
apply plugin: 'com.google.gms.google-services'
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"




/////////////////////////////////////////////////////// Build android/build.gradle


buildscript {
    ext.kotlin_version = '1.8.20'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        //classpath 'com.android.tools.build:gradle:4.1.0'
        //classpath 'com.android.tools.build:gradle:7.1.2'
        //classpath 'com.android.tools.build:gradle:7.2.0-alpha06'
        classpath 'com.android.tools.build:gradle:7.2.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.3.15'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

task clean(type: Delete) {
    delete rootProject.buildDir
}






for (var doc in snapshot.docs) {
          var data = snapshot.docs.first.data() as Map;
          var value = data["referals"];
          var newValue = value! + 1;

          await doc.reference.update({
            'referals': newValue,
          }).then((value) {

            
            
          }).catchError((error) {
            
          });
        }







        if (docSnapshot.exists) {
              print("Got data");
              print("referals: " + userController.user[0].referals.toString());
              print("ID: " + userController.user[0].referalId);
              docSnapshot.reference.update({
                'referals': userController.user[0].referals += 1,
                'referar_id': "@" + userController.user[0].referalId + "@"
              });
            }





TextFormField(
      enableSuggestions: true,
      cursorColor: Colors.black,
      controller: _airtimeNumberController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateNumber,
      keyboardType: TextInputType.phone,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: 11,

      // update the state variable when the text changes

      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        prefix: Text(
          "" + varValue.toString(),
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        label: Text(
          "enter valid number",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        border: InputBorder.none,
        filled: true,
        fillColor: brandThree,
        hintText: '',
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
    );




    onTap: () {
                            Get.bottomSheet(
                              isDismissible: true,
                              SingleChildScrollView(
                                child: SizedBox(
                                  height: 500,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                                    child: Container(
                                      color: Theme.of(context).canvasColor,
                                      padding:
                                          EdgeInsets.fromLTRB(50, 5, 50, 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Image.asset(
                                            "assets/utility/mtn.jpg",
                                            height: 80,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Recharge and get 1 SpacePoint!',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            "Valid MTN Phone number",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          airtimePhone,
                                          SizedBox(
                                            height: 5,
                                          ),
                                          airtimeAmount,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "4 digit transaction PIN",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          pinInput,
                                          SizedBox(
                                            height: 20,
                                          ),
                                          RoundedLoadingButton(
                                            controller: _airtimeController,
                                            onPressed: () async {
                                              Timer(const Duration(seconds: 1),
                                                  () {
                                                _airtimeController.stop();
                                              });
                                              Get.back();

                                              if (validateAmount(_airtimeAmountController.text.trim()) == "" &&
                                                  validateNumber(
                                                          _airtimeNumberController
                                                              .text
                                                              .trim()) ==
                                                      "" &&
                                                  validatePin(_pinController
                                                          .text
                                                          .trim()) ==
                                                      "") {
                                                const String apiUrl =
                                                    'https://api.watupay.com/v1/watubill/vend';
                                                const String bearerToken =
                                                    'WTP-L-SK-1b434faeb3b8492bbc34b03973ff3683';
                                                final response =
                                                    await http.post(
                                                  Uri.parse(apiUrl),
                                                  headers: {
                                                    'Authorization':
                                                        'Bearer $bearerToken',
                                                    "Content-Type":
                                                        "application/json"
                                                  },
                                                  body: jsonEncode(<String,
                                                      String>{
                                                    "amount":
                                                        _airtimeAmountController
                                                            .text
                                                            .trim()
                                                            .toString(),
                                                    "channel": "bill-25",
                                                    "business_signature":
                                                        "a390960dfa37469d824ffe6cb80472f6",
                                                    "phone_number":
                                                        _airtimeNumberController
                                                            .text
                                                            .trim()
                                                            .toString()
                                                  }),
                                                );

                                                if (response.statusCode ==
                                                    200) {
                                                  var walletUpdate =
                                                      FirebaseFirestore.instance
                                                          .collection('accounts');
                                                  await walletUpdate
                                                      .doc(userId)
                                                      .update({
                                                    'wallet_balance': (((int.tryParse(
                                                                userController
                                                                    .user[0]
                                                                    .userWalletBalance))!) -
                                                            ((int.tryParse(
                                                                    _airtimeAmountController
                                                                        .text
                                                                        .trim()
                                                                        .toString()))! +
                                                                20))
                                                        .toString(),
                                                    'utility_points': (((int.tryParse(
                                                                userController
                                                                    .user[0]
                                                                    .utilityPoints)!)) +
                                                            1)
                                                        .toString(),
                                                  }).then((value) async {
                                                    var addUtility =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'utility');
                                                    await addUtility.add({
                                                      'user_id': userController
                                                          .user[0].rentspaceID,
                                                      'id': userController
                                                          .user[0].id,
                                                      'amount':
                                                          _airtimeAmountController
                                                              .text
                                                              .trim()
                                                              .toString(),
                                                      'biller': "MTN AIRTIME",
                                                      'transaction_id':
                                                          getRandom(8),
                                                      'date': formattedDate,
                                                      'description':
                                                          'bought airtime',
                                                    });
                                                  });
                                                  _airtimeAmountController
                                                      .clear();
                                                  _airtimeNumberController
                                                      .clear();
                                                  Get.snackbar(
                                                    "Success!",
                                                    "You just earned a Space point!",
                                                    animationDuration:
                                                        Duration(seconds: 2),
                                                    backgroundColor: brandOne,
                                                    colorText: Colors.white,
                                                    snackPosition:
                                                        SnackPosition.TOP,
                                                  );
                                                } else {
                                                  // Error handling
                                                  _airtimeAmountController
                                                      .clear();
                                                  _airtimeNumberController
                                                      .clear();

                                                  Get.snackbar(
                                                    "Error",
                                                    "${response.body}",
                                                    animationDuration:
                                                        Duration(seconds: 2),
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white,
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                  );
                                                }
                                              } else {
                                                Get.snackbar(
                                                  "Incomplete",
                                                  "Fill the field correctly to proceed",
                                                  animationDuration:
                                                      Duration(seconds: 2),
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                );
                                              }
                                            },
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Text(
                                              'Proceed to payment',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                              ),
                                            ),
                                            color: brandTwo,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );}



                            getFund() async {
    var userInfo = FirebaseFirestore.instance.collection('accounts');
    var dbGet = FirebaseFirestore.instance;
    dbGet
        .collection("webhook_collection")
        .where('trans_ref',
            isLessThanOrEqualTo:
                userController.user[0].userWalletNumber.toString())
        .get()
        .then((queryValue) {
      for (var valueSnapshot in queryValue.docs) {
        print(valueSnapshot.data()["trans_ref"].substring(0, 5) +
            userController.user[0].userWalletNumber.toString());
        for (int i = 0; i < queryValue.docs.length; i++) {
          transIds.add((valueSnapshot.data()["trans_ref"].substring(0, 5) +
              userController.user[0].userWalletNumber.toString()));
        }
      }
    }).then((value) {
      //print(transIds.toSet().toList().toString());
    });
  }

*/


/*
FloatingActionButton(
        onPressed: () {
          Get.to(RentSpaceSubscription());
        },
        child: Icon(
          Icons.add_outlined,
          size: 30,
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: brandTwo,
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
        




        Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/icons/RentSpace-icon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),



            height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icons/RentSpace-icon.png"),
            fit: BoxFit.cover,
          ),
        ),



package com.example.rentspace

import android.view.WindowManager.LayoutParams
import io.flutter.embedding.android.FlutterActivity

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        window.addFlags(LayoutParams.FLAG_SECURE)
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}




        */


        


        