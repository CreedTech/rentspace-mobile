import 'dart:io';
import 'package:rentspace/controller/auto_controller.dart';
import 'package:rentspace/controller/box_controller.dart';
import 'package:rentspace/controller/deposit_controller.dart';
import 'package:rentspace/controller/rent_controller.dart';
import 'package:rentspace/controller/tank_controller.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/controller/utility_controller.dart';
import 'package:rentspace/controller/withdrawal_controller.dart';
import 'package:rentspace/view/actions/immediate_wallet_funding.dart';
import 'package:rentspace/view/actions/in_active_page.dart';
import 'package:rentspace/view/dashboard/dashboard.dart';
import 'package:rentspace/view/dashboard/user_profile.dart';
import 'package:rentspace/view/portfolio/portfolio_page.dart';
import 'package:rentspace/view/savings/savings_page.dart';
import 'package:rentspace/view/utility/utilities_page.dart';
import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:once/once.dart';
import 'package:intl/intl.dart';
import 'package:getwidget/getwidget.dart';
import 'package:upgrader/upgrader.dart';

final LocalAuthentication _localAuthentication = LocalAuthentication();
final UserController userController = Get.find();
String _message = "Not Authorized";
bool _hasBiometric = false;
final hasBiometricStorage = GetStorage();
String _userWalletBalance = "";
String _email = "";
String fundedAmount = "0";
String randomRef = "";
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
String _newWalletBalance = "0";
bool hasLoaded = false;
bool _hasOpened = false;
final openedAppStorage = GetStorage();
final hasReferredStorage = GetStorage();
String _isSet = "false";
String imgUrl =
    "https://firebasestorage.googleapis.com/v0/b/rentspace-1aebe.appspot.com/o/assets%2Fblack%20man%20(1).png?alt=media&token=ae5ac473-406e-4e70-ad92-8a8b1b7db9d9";
List<String> transIds = [];
List<Widget> listWidgets = [
  Dashboard(),
  SavingsPage(),
  PortfolioPage(),
  UtilitiesPage(),
  UserProfile()
];
int _selectedIndex = 0;

class CounterNew extends GetxController {
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  GlobalKey _five = GlobalKey();
  GlobalKey _six = GlobalKey();
  GlobalKey _seven = GlobalKey();
  GlobalKey _eight = GlobalKey();
  GlobalKey _nine = GlobalKey();
  GlobalKey _ten = GlobalKey();

  get fewsureHelper1 => _eight;
  get fewsureHelper2 => _nine;
  get fewsureHelper3 => _ten;
  get fewsureHelper4 => _six;
  get fewsureHelper5 => _seven;
}

//Showcase player controller

final counter = Get.put(CounterNew());

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool _hasPutController = false;
  @override
  initState() {
    super.initState();
    Get.put(UserController());
    Get.put(WithdrawalController());
    Get.put(UtilityController());
    Get.put(RentController());
    Get.put(AutoController());
    Get.put(BoxController());
    Get.put(TankController());
    Get.put(DepositController());

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _hasPutController = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    Get.put(UtilityController());
    Get.put(WithdrawalController());
    Get.put(RentController());
    Get.put(AutoController());
    Get.put(BoxController());
    Get.put(TankController());
    Get.put(DepositController());
    return (!_hasPutController)
        ? Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 30,
                  width: 90,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icons/RentSpace-1011.png"),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome Spacer",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                CircularProgressIndicator(
                  color: brandOne,
                )
              ],
            ),
          )
        : Scaffold(
            body: ShowCaseWidget(
              autoPlay: false,
              onFinish: () {
                Get.defaultDialog(
                  titlePadding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  title: "Discover",
                  content: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: [
                        Image.asset(
                          "assets/discover.png",
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Dynamic Virtual Account (DVA): This provides a streamlined solution for receiving funds directly, utilizing a unique assigned bank account. It's accessible to anyone seeking to send you funds.",
                          style: TextStyle(
                            fontSize: 13.0,
                            letterSpacing: 0.5,
                            fontFamily: "DefaultFontFamily",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Fund Wallet: Fuel Your Financial Adventure with Fund Wallet! Click here to top up your funds and embark on your financial journey today!",
                          style: TextStyle(
                            fontSize: 13.0,
                            letterSpacing: 0.5,
                            fontFamily: "DefaultFontFamily",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Withdrawal: Experience Effortless Fund Withdrawals in an Instant access! Take control of your finances by clicking here to start the withdrawal process, granting you immediate access to your funds.",
                          style: TextStyle(
                            fontSize: 13.0,
                            letterSpacing: 0.5,
                            fontFamily: "DefaultFontFamily",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: GFButton(
                        onPressed: () {
                          Get.back();
                        },
                        fullWidthButton: true,
                        shape: GFButtonShape.pills,
                        text: "That's Nice",
                        icon: Icon(
                          Icons.arrow_right_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        color: brandOne,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                  barrierDismissible: false,
                );
              },
              builder: Builder(
                builder: (context) => HomePage(),
              ),
            ),
          );
  }
}

//Second page
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  checkStatus() {
    final FirebaseFirestore firestoreFile = FirebaseFirestore.instance;
    DocumentReference docReference =
        firestoreFile.collection('maintenance').doc('27-09-2023-maintenance');

    docReference.snapshots().listen((snapshot) {
      var data = snapshot.data() as Map<String, dynamic>?;
      var newStatus = data?['status'];

      if (newStatus != "active") {
        Get.to(InActivePage());
      } else {
        print("All good!!!");
      }
    });
  }

  mustRefer() async {
    //get the referal code in the users collection
    if (userController.user[0].referalId != "") {
      CollectionReference allUsersR =
          FirebaseFirestore.instance.collection('accounts');

      var snapshot = await allUsersR
          .where('referal_code',
              isEqualTo: userController.user[0].referalId.toUpperCase())
          .get();
      var collection = FirebaseFirestore.instance.collection('accounts');

      var docSnapshot = await collection.doc(userId).get();
      for (var doc in snapshot.docs) {
        var data = snapshot.docs.first.data() as Map;
        var value = data["referals"];
        var newValue = value! + 1;

        await doc.reference.update({
          'referals': newValue,
        }).then((value) {
          docSnapshot.reference.update({
            'referals': 1,
            'referar_id': "@" + userController.user[0].referalId + "@"
          });
          //R09K673ELR
          Get.snackbar(
            "All set!",
            'Your account has been setup successfully!',
            animationDuration: Duration(seconds: 1),
            backgroundColor: brandOne,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }).catchError((error) {
          Get.snackbar(
            "Oops...",
            "Something went wrong",
            animationDuration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        });
      }
    } else {
      print("No referal");
    }
  }

  checkIsOpenedApp() {
    if (openedAppStorage.read('hasOpenedApp') == null) {
      openedAppStorage.write('hasOpenedApp', false);
      if ((openedAppStorage.read('hasOpenedApp') == false)) {
        setState(
          () {
            _hasOpened = true;
            openedAppStorage.write('hasOpenedApp', _hasOpened);
          },
        );
        mustRefer();
        Get.defaultDialog(
          titlePadding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          title: "Welcome Spacer!",
          content: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              children: [
                Image.asset(
                  "assets/ava_intro.png",
                  fit: BoxFit.fill,
                  height: 200,
                  width: 200,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "I'm Ava. I'm happy to see you on our platform and will help you get started on the app. Take a few moments to see the basics.",
                  style: TextStyle(
                    fontSize: 13.0,
                    letterSpacing: 0.5,
                    fontFamily: "DefaultFontFamily",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: GFButton(
                onPressed: () {
                  Get.back();
                  startShowCase();
                },
                fullWidthButton: true,
                shape: GFButtonShape.pills,
                text: "Start",
                icon: Icon(
                  Icons.arrow_right_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                color: brandOne,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
          barrierDismissible: false,
        );
      } else {
        return;
      }
    } else {
      print(openedAppStorage.read('hasOpenedApp').toString());
    }
    //print()
  }

  startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ShowCaseWidget.of(context).startShowCase([
        counter._one,
        counter._two,
        counter._three,
        counter._four,
        counter._five,
        /* counter._six,
        counter._seven,
        counter._eight, */
      ]);
    });
  }

  @override
  initState() {
    super.initState();
    transIds.clear();
    checkStatus();
    setState(() {
      fundedAmount = "0";
    });
    Future.delayed(Duration(seconds: 1), () {
      checkIsOpenedApp();
    });
  }

  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print(canCheckBiometrics);
    _authenticateMe();
    return canCheckBiometrics;
  }

  Future<void> _authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Authentication required",
      );
      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });
      if (_message == "Authorized") {
        Get.to(HomePage());
      } else {
        Get.snackbar(
          "Error",
          "Biometrics failed",
          animationDuration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Biometrics failed",
        animationDuration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.bottomSheet(
          SizedBox(
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: Container(
                color: Theme.of(context).canvasColor,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
                      child: Text(
                        'Are you sure you want to exit?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontFamily: "DefaultFontFamily",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GFButton(
                            onPressed: () {
                              Get.back();
                            },
                            shape: GFButtonShape.pills,
                            text: "Cancel",
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
                              exit(0);
                            },
                            shape: GFButtonShape.pills,
                            text: "Exit",
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
        return false;
      },
      child: UpgradeAlert(
        upgrader: Upgrader(
          showIgnore: false,
          durationUntilAlertAgain: const Duration(seconds: 5),
          debugLogging: true,
          dialogStyle: UpgradeDialogStyle.cupertino,
          showLater: false,
          canDismissDialog: false,
          showReleaseNotes: true,
        ),
        child: Scaffold(
          body: listWidgets[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Showcase(
                  key: counter._one,
                  title: 'Home',
                  description: 'All your dashboard in one place.',
                  disableAnimation: false,
                  showcaseBackgroundColor: brandOne,
                  showArrow: true,
                  textColor: Colors.white,
                  overlayPadding: EdgeInsets.all(5),
                  animationDuration: Duration(seconds: 2),
                  child: Image.asset(
                    "assets/icons/home_icon.png",
                    height: 30,
                    width: 30,
                  ),
                ),
                label: "Home",
                backgroundColor: brandFour,
              ),
              BottomNavigationBarItem(
                icon: Showcase(
                  key: counter._two,
                  title: 'Savings',
                  textColor: Colors.white,
                  description: 'Create, manange and grow your savings',
                  disableAnimation: false,
                  showcaseBackgroundColor: brandOne,
                  showArrow: true,
                  overlayPadding: EdgeInsets.all(5),
                  animationDuration: Duration(seconds: 2),
                  child: Image.asset(
                    "assets/icons/savings_icon.png",
                    height: 30,
                    width: 30,
                  ),
                ),
                label: "Savings",
                backgroundColor: brandFour,
              ),
              BottomNavigationBarItem(
                icon: Showcase(
                  key: counter._three,
                  title: 'Portfolio',
                  textColor: Colors.white,
                  description:
                      'Build your portfolio, improve your finance health',
                  disableAnimation: false,
                  showcaseBackgroundColor: brandOne,
                  showArrow: true,
                  overlayPadding: EdgeInsets.all(5),
                  animationDuration: Duration(seconds: 2),
                  child: Image.asset(
                    "assets/icons/portfolio_icon.png",
                    height: 30,
                    width: 30,
                  ),
                ),
                label: "Portfolio",
                backgroundColor: brandFour,
              ),
              BottomNavigationBarItem(
                icon: Showcase(
                  key: counter._four,
                  title: 'Utility',
                  textColor: Colors.white,
                  description:
                      'Pay your bills directly from your wallet and earn 1 SpacePoint!',
                  disableAnimation: false,
                  showcaseBackgroundColor: brandOne,
                  showArrow: true,
                  overlayPadding: EdgeInsets.all(5),
                  animationDuration: Duration(seconds: 2),
                  child: Image.asset(
                    "assets/icons/utility_icon.png",
                    height: 30,
                    width: 30,
                  ),
                ),
                label: "Utility",
                backgroundColor: brandFour,
              ),
              BottomNavigationBarItem(
                icon: Showcase(
                  key: counter._five,
                  title: 'Profile',
                  textColor: Colors.white,
                  description: 'Manage your account information',
                  disableAnimation: false,
                  showcaseBackgroundColor: brandOne,
                  showArrow: true,
                  overlayPadding: EdgeInsets.all(5),
                  animationDuration: Duration(seconds: 2),
                  child: Image.asset(
                    "assets/icons/profile_icon.png",
                    height: 30,
                    width: 30,
                  ),
                ),
                label: "Profile",
                backgroundColor: brandFour,
              ),
            ],
            currentIndex: _selectedIndex,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedItemColor: Colors.black,
            unselectedLabelStyle: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
            selectedLabelStyle: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
            onTap: _onItemTapped,
            key: _bottomNavigationKey,
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
