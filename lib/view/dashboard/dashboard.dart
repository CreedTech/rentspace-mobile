import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/view/actions/fund_wallet.dart';

import 'package:rentspace/view/dashboard/all_activities.dart';
import 'package:rentspace/constants/theme_services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentspace/view/dva/create_dva.dart';
import 'package:rentspace/view/savings/savings_withdrawal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
final themeChange = Get.put(ThemeServices());

final hasFeedsStorage = GetStorage();

String _greeting = "";
bool _hasReferred = false;
String referalCode = "";
int referalCount = 0;
int userReferal = 0;
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
String _isSet = "false";
var dum1 = "".obs;
CollectionReference users = FirebaseFirestore.instance.collection('accounts');
CollectionReference allUsers =
    FirebaseFirestore.instance.collection('accounts');
final CollectionReference announcements =
    FirebaseFirestore.instance.collection('announcements');

class _DashboardState extends State<Dashboard> {
  final UserController userController = Get.find();
  final form = intl.NumberFormat.decimalPattern();
  List<dynamic> _articles = [];
  greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      setState(() {
        _greeting = 'Good morning 🌅, ';
      });
    } else if (hour < 17) {
      setState(() {
        _greeting = 'Good afternoon ☀️, ';
      });
    } else {
      setState(() {
        _greeting = 'Good evening 🌙, ';
      });
    }
  }

  Future<void> _fetchNews() async {
    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=us&category=business&q=finance&apiKey=64963c2e074348b5946d8307df0b5bea'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _articles = json.decode(response.body)['articles'];
      });
    } else {
      setState(() {
        _articles = [];
      });
      print(response.reasonPhrase);
    }
  }

  late ValueNotifier<double> valueNotifier;
  @override
  initState() {
    super.initState();

    userController.user.isEmpty
        ? valueNotifier = ValueNotifier(0.0)
        : valueNotifier = ValueNotifier(
            double.tryParse(userController.user[0].finance_health)!);
    greeting();
    _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        //backgroundColor: brandFour,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                gradientOne,
                gradientTwo,
              ],
            ),
          ),
          child: Padding(
            //padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        gradientOne,
                        gradientTwo,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    userController.user[0].image,
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hi, ${userController.user[0].userFirst}👋$dum1",
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      letterSpacing: 1.0,
                                      fontFamily: "DefaultFontFamily",
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "Let's help you save money",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      letterSpacing: 1.0,
                                      color: Colors.white,
                                      fontFamily: "DefaultFontFamily",
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      (userController.user[0].hasDva == 'true')
                          ? FlipCard(
                              front: Neumorphic(
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.concave,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(12)),
                                    depth: 0,
                                    lightSource: LightSource.topLeft,
                                    color: Colors.white),
                                child: Container(
                                  height: 220,
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 20.0, 20.0, 20.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    image: const DecorationImage(
                                      image: AssetImage("assets/card.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                'assets/icons/logo.png',
                                                height: 24,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Space Wallet$dum1${(userController.user[0].hasDva == 'true') ? " - DVA" : ""}",
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  letterSpacing: 1.0,
                                                  fontFamily:
                                                      "DefaultFontFamily",
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                (userController
                                                            .user[0].hasDva ==
                                                        'true')
                                                    ? '${userController.user[0].dvaNumber.substring(0, 3)}-${userController.user[0].dvaNumber.substring(3, 6)}-${userController.user[0].dvaNumber.substring(6, 10)}'
                                                    : '${userController.user[0].userWalletNumber.substring(0, 3)}-${userController.user[0].userWalletNumber.substring(3, 6)}-${userController.user[0].userWalletNumber.substring(6, 10)}',
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  letterSpacing: 0.8,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      "DefaultFontFamily",
                                                  color: Colors.greenAccent,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              (userController.user[0].hasDva ==
                                                      'true')
                                                  ? InkWell(
                                                      onTap: () {
                                                        Clipboard.setData(
                                                          ClipboardData(
                                                            text: userController
                                                                .user[0]
                                                                .dvaNumber,
                                                          ),
                                                        );
                                                        Fluttertoast.showToast(
                                                          msg:
                                                              "Account Number copied to clipboard!",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              brandOne,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                      },
                                                      child: const Icon(
                                                        Icons.copy,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 280,
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 0.0, 0.0, 0.0),
                                            decoration: BoxDecoration(
                                              color: brandFour,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              nairaFormaet
                                                  .format(int.tryParse(
                                                      userController.user[0]
                                                          .userWalletBalance))
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 30.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.9,
                                                fontFamily: "DefaultFontFamily",
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                (userController
                                                            .user[0].hasDva ==
                                                        'false')
                                                    ? "${userController.user[0].userFirst.toUpperCase()} ${userController.user[0].userLast.toUpperCase()}"
                                                    : userController
                                                        .user[0].dvaName
                                                        .toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  letterSpacing: 0.5,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      "DefaultFontFamily",
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              back: Neumorphic(
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.concave,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(12)),
                                    depth: 0,
                                    lightSource: LightSource.topLeft,
                                    color: Theme.of(context).canvasColor),
                                child: Container(
                                  height: 220,
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 10.0, 0.0, 10.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    image: const DecorationImage(
                                      image: AssetImage("assets/card.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 5.0),
                                            child: Text(
                                              "Property of RentSpace",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                //letterSpacing: 1.0,
                                                fontFamily: "DefaultFontFamily",
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        color: Colors.black,
                                        height: 40,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40.0, 20.0, 40.0, 5.0),
                                        child: Container(
                                          color: Colors.white,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.fromLTRB(
                                              5.0, 4.0, 5.0, 4.0),
                                          child: Text(
                                            (userController.user[0].userId !=
                                                    "")
                                                ? userController.user[0].userId
                                                    .substring(0, 3)
                                                : "000",
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: "DefaultFontFamily",
                                              //letterSpacing: 1.0,

                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 5.0),
                                        child: Text(
                                          "Disclaimer: Space wallet is 'NOT' a bank account and as such, cannot be used as one. With space wallet, you can perform in app transactions including but not limited to utility payment, savings subscription and top-up",
                                          style: TextStyle(
                                            fontSize: 8.0,
                                            fontFamily: "DefaultFontFamily",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 213,
                              decoration: BoxDecoration(
                                color: const Color(0xff258AE8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container()),
                                ],
                              ),
                              // width: ,
                            ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Quick Options",
                              style: TextStyle(
                                fontSize: 18.0,
                                letterSpacing: 0.5,
                                fontFamily: "DefaultFontFamily",
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              //Wallet top up
                              Get.bottomSheet(
                                SizedBox(
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                                    child: Container(
                                      color: Theme.of(context).canvasColor,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 50,
                                          ),
                                          Text(
                                            'Securely top up your wallet',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontFamily: "DefaultFontFamily",
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          //card
                                          InkWell(
                                            onTap: () async {
                                              Get.back();
                                              Get.to(const FundWallet());
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.8,
                                              decoration: BoxDecoration(
                                                color: brandOne,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 5, 20, 5),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.credit_card_outlined,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Proceed to Top up',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily:
                                                          "DefaultFontFamily",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width / 2.5,
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                color: brandFour,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                      "assets/icons/iconset/fundwallet.png"),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const Text(
                                    "Fund Wallet",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      letterSpacing: 0.5,
                                      color: Colors.white,
                                      fontFamily: "DefaultFontFamily",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              (int.tryParse(userController
                                          .user[0].userWalletBalance)! >
                                      0)
                                  ? Get.to(const WalletWithdrawal())
                                  : Get.snackbar(
                                      "Wallet Empty!",
                                      'You need to fund your wallet first!',
                                      animationDuration:
                                          const Duration(seconds: 1),
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                            },
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width / 2.5,
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                color: brandFive,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/icons/iconset/uil_money-withdrawal.png",
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const Text(
                                    "Withdraw Funds",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      letterSpacing: 0.5,
                                      fontFamily: "DefaultFontFamily",
                                      color: Colors.white,
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
                      (userController.user[0].bvn != "" &&
                              userController.user[0].hasDva == 'false')
                          ? Container(
                              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: brandThree,
                              ),
                              child: ListTile(
                                onTap: () {
                                  Get.to(const CreateDVA());
                                },
                                leading: const Icon(
                                  Icons.person_add_outlined,
                                  color: Colors.black,
                                ),
                                title: const Text(
                                  "Activate DVA",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "DefaultFontFamily",
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: const Text(
                                  "Free Dynamic Virtual Account (DVA)",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    letterSpacing: 0.5,
                                    fontFamily: "DefaultFontFamily",
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_right_outlined,
                                  color: Colors.black,
                                ),
                                tileColor: Colors.red,
                              ),
                            )
                          : const SizedBox(
                              height: 1,
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          //Get.to(RentSpaceCommunity());
                          Get.snackbar(
                            "Coming soon!",
                            'This feature is coming soon to RentSpace!',
                            animationDuration: const Duration(seconds: 1),
                            backgroundColor: brandOne,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: brandOne,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.forum_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "RentSpace community",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "DefaultFontFamily",
                                        letterSpacing: 0.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "View the amazing community\nof other Spacers!",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  letterSpacing: 0.5,
                                  fontFamily: "DefaultFontFamily",
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: brandOne,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: const Text(
                                "Announcement",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "DefaultFontFamily",
                                  letterSpacing: 0.2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            StreamBuilder(
                              stream: announcements.snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                return (!snapshot.hasData)
                                    ? const SizedBox()
                                    : Text(
                                        snapshot.data!.docs[0]['body'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: "DefaultFontFamily",
                                        ),
                                      );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Account Activities",
                              style: TextStyle(
                                fontSize: 14.0,
                                letterSpacing: 0.5,
                                fontFamily: "DefaultFontFamily",
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(AllActivities(
                                  activities: userController.user[0].activities,
                                  activitiesLength:
                                      userController.user[0].activities.length,
                                ));
                              },
                              child: Text(
                                "see all",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  letterSpacing: 1.0,
                                  fontFamily: "DefaultFontFamily",
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount:
                            (userController.user[0].activities.length < 3)
                                ? userController.user[0].activities.length
                                : 3,
                        itemBuilder: (BuildContext context, int index) {
                          return (userController
                                  .user[0].activities[index].isNotEmpty)
                              ? Container(
                                  color: Theme.of(context).canvasColor,
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 10, 10.0, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/icons/iconset/Group462.png',
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        userController
                                            .user[0].activities[index],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 10, 10.0, 0),
                                  child: Text(
                                    "Nothing to show here",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: "DefaultFontFamily",
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                        },
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      (_articles.isNotEmpty)
                          //&&(hasFeedsStorage.read('hasFeeds') == true)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "My Feeds",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "DefaultFontFamily",
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Finance headlines for you",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "DefaultFontFamily",
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: _articles.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final article = _articles[index];
                                    return ListTile(
                                      leading: Icon(
                                        Icons.newspaper_outlined,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      title: Text(
                                        article['title'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "DefaultFontFamily",
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          : const Text(""),
                    ],
                  ),
                ),
                Container(
                  color: Theme.of(context).canvasColor,
                  height: 80,
                )
                //end of community
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }
}
