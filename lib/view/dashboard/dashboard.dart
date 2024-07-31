import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:rentspace/api/global_services.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:rentspace/controller/auth/user_controller.dart';
import 'package:rentspace/controller/rent/rent_controller.dart';
import 'package:rentspace/controller/wallet/wallet_controller.dart';
import 'package:rentspace/model/user_details_model.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentspace/view/dashboard/fund_wallet_popup.dart';
import 'package:rentspace/view/onboarding/FirstPage.dart';
import 'package:rentspace/widgets/custom_dialogs/fund_your_account_dialog.dart';
import 'package:rentspace/widgets/custom_dialogs/start_saving_today.dart';
import 'package:rentspace/widgets/separator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/utils/formatDateTime.dart';
import '../../provider/task_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dialogs/index.dart';
import '../../widgets/custom_loader.dart';
import '../auth/pin/transaction_pin.dart';
import '../receipts/transaction_receipt.dart';
import '../savings/spaceRent/spacerent_confirmation.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  _DashboardConsumerState createState() => _DashboardConsumerState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
final UserController userController = Get.put(UserController());
final WalletController walletController = Get.put(WalletController());
final RentController rentController = Get.put(RentController());

int id = 0;

String _greeting = "";
String referalCode = "";
int referalCount = 0;
int userReferal = 0;
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
var dum1 = "".obs;
String previousAnnouncementText = '';
bool showBalance = true;
int currentPos = 0;

class _DashboardConsumerState extends ConsumerState<Dashboard> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  String? fullName = '';
  double rentBalance = 0;
  List<UserDetailsModel> userInfo = [];
  bool isAlertSet = false;
  bool isRefresh = false;
  List rentspaceProducts = ['Space Wallet', 'Space Rent', 'Space Deposit'];
  String selectedIndex = 'Space Wallet';
  final Box<dynamic> settingsHiveBox = Hive.box('settings');

  final form = intl.NumberFormat.decimalPattern();
  bool isContainerVisible = true;
  late bool isFirstTimeSignUp = true;
  late bool hasCompletedFirstPopup = false;

  greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      setState(() {
        _greeting = 'Good morning';
      });
    } else if (hour < 17) {
      setState(() {
        _greeting = 'Good Afternoon';
      });
    } else {
      setState(() {
        _greeting = 'Good evening';
      });
    }
  }

  Future<void> popupDisplayFunction() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstTimeSignUp = prefs.getBool('IS_FIRST_TIME_SIGN_UP') ?? true;
      hasCompletedFirstPopup =
          prefs.getBool('HAS_COMPLETED_HALF_POPUP') ?? false;
    });

    if (rentController.rentModel!.rents!.isEmpty) {
      if (isFirstTimeSignUp == true && hasCompletedFirstPopup != true) {
        await Future.delayed(const Duration(seconds: 10));
        showModalBottomSheet(
          enableDrag: false,
          isDismissible: false,
          // backgroundColor: Colors.blue,
          barrierColor: Colors.transparent,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.93,
              child: Container(
                // height: 350,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 25.h),
                decoration: BoxDecoration(
                  color: colorWhite,
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hi there!',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: colorBlack,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await GlobalService.sharedPreferencesManager
                                .setIsFirstTimeSignUp(value: false)
                                .then(
                                  (value) => Navigator.pop(context),
                                );
                          },
                          child: const Icon(
                            Icons.close,
                            color: Color(0xffA2A1A1),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      'Let\'s get you started on \n your saving journey.',
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: colorBlack,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      'Complete these steps to get started.',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: colorBlack,
                      ),
                    ),
                    SizedBox(
                      height: 42.h,
                    ),
                    Text(
                      'Steps:',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorBlack,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 14.h,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                  vertical: 11,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromRGBO(240, 255, 238, 10),
                                ),
                                // child: const Icon(
                                //   Iconsax.security,
                                //   color: brandOne,
                                // ),
                                child: Image.asset(
                                  'assets/icons/house.png',
                                  width: 20,
                                  height: 20,
                                  // scale: 4,
                                  // color: brandOne,
                                ),
                              ),
                              SizedBox(
                                width: 14.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Create Space Rent',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: colorBlack,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  Text(
                                    'Start saving for your rent.',
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff4B4B4B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 14.h,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                  vertical: 11,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xffEEF8FF),
                                ),
                                // child: const Icon(
                                //   Iconsax.security,
                                //   color: brandOne,
                                // ),
                                child: Image.asset(
                                  'assets/icons/send.png',
                                  width: 20,
                                  height: 20,
                                  // scale: 4,
                                  // color: brandOne,
                                ),
                              ),
                              SizedBox(
                                width: 14.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Fund Space Wallet',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: colorBlack,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  Text(
                                    'Fund your saving wallet.',
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff4B4B4B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width - 50, 50),
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

                            spacerentCreationPopup(context);
                          },
                          child: Text(
                            'Get Started',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: colorWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      if (hasCompletedFirstPopup != true) {
        await Future.delayed(const Duration(seconds: 10));
        fundWalletPopup(context);
      }
    }
    if (isFirstTimeSignUp == false && hasCompletedFirstPopup == true) {
      await Future.delayed(const Duration(seconds: 2));
      showRandomPopup(context);
    }
  }

  void showRandomPopup(BuildContext context) {
    final random = Random();
    final popupChoice = random.nextInt(2); // Generates 0 or 1
    print(popupChoice);

    if (popupChoice == 0) {
      if (rentController.rentModel!.rents!.isEmpty) {
        startSavingToday(context);
      }
    } else {
      if (walletController.walletModel!.wallet![0].mainBalance == 0) {
        fundYourAccountDialog(context);
      }
    }
  }

  Future<dynamic> spacerentCreationPopup(BuildContext context) {
    String _amountValue = "";
    double _rentValue = 0.0;

    String paymentCount = "";
//savings goals
    double _dailyValue = 0.0;
    double _savingValue = 0.0;
    bool showSaveButton = false;
    int numberInDays = 0;
    int _duration = 5;
    var receivalDate =
        Jiffy.parseFromDateTime(DateTime.now()).add(months: _duration).dateTime;
    final rentFormKey = GlobalKey<FormState>();
    final TextEditingController rentAmountController = TextEditingController();
    final TextEditingController rentNameController = TextEditingController();
    final TextEditingController endDateController = TextEditingController();

    final UserController userController = Get.put(UserController());
    WalletController walletController = Get.put(WalletController());
    final TextEditingController intervalController = TextEditingController();
    final TextEditingController durationController = TextEditingController();

    DateTime _endDate = DateTime.now();
    List<String> intervalLabels = ['Weekly', 'Monthly'];
    List<String> durations = ['5 months', '6 months', '7 months', '8 months'];

    int calculateMonthsDifference(DateTime startDate, int duration) {
      DateTime endDate =
          Jiffy.parseFromDateTime(startDate).add(months: duration).dateTime;

      final startYear = startDate.year;
      final startMonth = startDate.month;
      final endYear = endDate.year;
      final endMonth = endDate.month;

      final monthsDifference =
          ((endYear - startYear) * 12) + (endMonth - startMonth);
      return monthsDifference.abs();
    }

    int calculateWeeksDifferences(DateTime startDate, int duration) {
      DateTime endDate =
          Jiffy.parseFromDateTime(startDate).add(months: duration).dateTime;

      receivalDate = endDate;
      return endDate.difference(startDate).inDays ~/ 7;
    }

    int calculateDaysDifference() {
      final differenceDays = _endDate
          .add(const Duration(days: 1))
          .difference(DateTime.now())
          .inDays;

      return differenceDays.abs();
    }

    validateFunc(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if (text.length < 1) {
        return 'Too short';
      }
      if ((int.tryParse(text.trim().replaceAll(',', ''))! >= 1) &&
          (int.tryParse(text.trim().replaceAll(',', ''))! < 150000)) {
        return 'minimum amount is ₦150,000';
      }
      if (int.tryParse(text.trim().replaceAll(',', '')) == null) {
        return 'enter valid number';
      }
      if (int.tryParse(text.trim().replaceAll(',', '')) == 0) {
        return 'number cannot be zero';
      }
      if (int.tryParse(text.trim().replaceAll(',', ''))!.isNegative) {
        return 'enter positive number';
      }
      return null;
    }

    validateEndDate(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      return null;
    }

    //validation function
    validateName(text) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if (text.length < 1) {
        return 'Too short';
      }

      return null;
    }

// calculate rent
    Future<void> calculateRent(rent) async {
      setState(() {
        _amountValue = rentAmountController.text;
        _rentValue = rent;
        if (intervalController.text.toLowerCase() == "weekly") {
          paymentCount =
              calculateWeeksDifferences(_endDate, _duration).toString();

          _savingValue =
              ((rent) / calculateWeeksDifferences(_endDate, _duration));
        } else {
          paymentCount =
              calculateMonthsDifference(_endDate, _duration).toString();
          _savingValue =
              ((rent) / calculateMonthsDifference(_endDate, _duration));
        }
        _dailyValue = ((rent) / calculateDaysDifference());
      });
    }

    Future<void> selectEndDate(BuildContext context) async {
      final DateTime now = DateTime.now();

      final DateTime? picked = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primaryContainer: brandTwo,
                primary: brandTwo, // header background color
                onPrimary: Colors.white,
                onBackground: brandTwo,

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
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 30)),
      );
      if (picked != null &&
          picked != now &&
          !picked.difference(now).inDays.isNaN) {
        setState(() {
          _endDate = picked;
          Duration difference = picked.difference(now);
          numberInDays = difference.inDays + 1;
          if (validateFunc(
                  rentAmountController.text.trim().replaceAll(',', '')) ==
              null) {
            showSaveButton = true;
            endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
          } else {
            if (context.mounted) {
              customErrorDialog(
                  context, 'Invalid', "Please enter valid amount to proceed.");
            }
          }
        });
      }
    }

    final rentName = TextFormField(
      enableSuggestions: true,
      cursorColor: colorBlack,
      controller: rentNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 12,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      validator: validateName,
      style: GoogleFonts.lato(
          color: colorBlack, fontSize: 14, fontWeight: FontWeight.w500),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: '',
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    final rentAmount = TextFormField(
      enableSuggestions: true,
      cursorColor: colorBlack,
      controller: rentAmountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateFunc,
      // update the state variable when the text changes
      onChanged: (text) {
        setState(() {
          _amountValue = "";
          _rentValue = 0.0;
          showSaveButton = false;
          endDateController.clear();
        });
        setState(() => _amountValue = text);
      },
      style: GoogleFonts.lato(
          color: colorBlack, fontSize: 14, fontWeight: FontWeight.w500),
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsFormatter()],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromRGBO(189, 189, 189, 100),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        prefixText: "₦ ",
        prefixStyle: GoogleFonts.roboto(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        // hintText: 'Rent amount in Naira',
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    return showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.93,
          child: Container(
            // height: 350,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 25.h),
            decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(19),
            ),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.5.w,
                              vertical: 4.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: brandTwo,
                              borderRadius: BorderRadius.circular(
                                80,
                              ),
                            ),
                            child: Text(
                              '1',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colorWhite,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          SizedBox(
                            width: 28,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 1,
                              ),
                              child: LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  return Flex(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    direction: Axis.horizontal,
                                    children: List.generate(
                                      3,
                                      (_) {
                                        return const SizedBox(
                                          width: 5,
                                          height: 1,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: Color(0xffC9C9C9),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.5.w,
                              vertical: 4.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffC9C9C9),
                              borderRadius: BorderRadius.circular(
                                80,
                              ),
                            ),
                            child: Text(
                              '2',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colorWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await GlobalService.sharedPreferencesManager
                            .setIsFirstTimeSignUp(value: false)
                            .then(
                              (value) => context.go('/firstpage'),
                            );
                        // Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Color(0xffA2A1A1),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 22.h,
                ),
                // SingleChildScrollView()
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Space Rent',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: colorBlack,
                      ),
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                          key: rentFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/space_rent_img_round.png',
                                width: 86.w,
                              ),
                              SizedBox(
                                height: 32.h,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 3),
                                    child: Text(
                                      'Space Rent Name',
                                      style: GoogleFonts.lato(
                                        color: colorBlack,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  rentName,
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 3),
                                    child: Text(
                                      'Rent Amount',
                                      style: GoogleFonts.lato(
                                        color: colorBlack,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  rentAmount,
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
                                        vertical: 4, horizontal: 3),
                                    child: Text(
                                      'Start Date',
                                      style: GoogleFonts.lato(
                                        color: colorBlack,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: endDateController,
                                    cursorColor:
                                        Theme.of(context).colorScheme.primary,
                                    validator: validateEndDate,
                                    style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    readOnly: true,
                                    // onTap: _showDatePicker,
                                    onTap: () => selectEndDate(context),
                                    decoration: InputDecoration(
                                      // labelText: 'Select Start Date',
                                      labelStyle: GoogleFonts.lato(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      suffixIcon: Icon(
                                        Icons.calendar_today,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: Color.fromRGBO(
                                              189, 189, 189, 100),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: brandOne, width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Color.fromRGBO(
                                              189, 189, 189, 100),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 1.0),
                                      ),
                                      filled: false,
                                      contentPadding: const EdgeInsets.all(14),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 3),
                                    child: Text(
                                      'Select Frequency',
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    onTap: () {
                                      showModalBottomSheet(
                                        isDismissible: true,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.45,
                                            child: Container(
                                              // height: 350,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 20),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(19),
                                              ),
                                              child: ListView(
                                                children: [
                                                  Text(
                                                    'Select Frequency',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 16,
                                                        color: colorBlack,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: colorWhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: ListView.builder(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          intervalLabels.length,
                                                      itemBuilder:
                                                          (context, idx) {
                                                        return Column(
                                                          children: [
                                                            ListTileTheme(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          13.0,
                                                                      right:
                                                                          13.0,
                                                                      top: 4,
                                                                      bottom:
                                                                          4),
                                                              selectedColor:
                                                                  brandOne,
                                                              child: ListTile(
                                                                title: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.4,
                                                                      child:
                                                                          Text(
                                                                        intervalLabels[
                                                                            idx],
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts
                                                                            .lato(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              colorBlack,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onTap: () {
                                                                  setState(
                                                                      () {});

                                                                  intervalController
                                                                          .text =
                                                                      intervalLabels[
                                                                          idx];
                                                                  // });

                                                                  Navigator.pop(
                                                                    context,
                                                                  );

                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                            ),
                                                            (idx !=
                                                                    intervalLabels
                                                                            .length -
                                                                        1)
                                                                ? Divider(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                    height: 1,
                                                                    indent: 13,
                                                                    endIndent:
                                                                        13,
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
                                      color: colorBlack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),

                                    controller: intervalController,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.text,

                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Color.fromRGBO(
                                              189, 189, 189, 100),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: brandOne, width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Color.fromRGBO(
                                              189, 189, 189, 100),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 1.0),
                                      ),
                                      suffixIcon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 24,
                                        color: colorBlack,
                                      ),
                                      filled: false,
                                      fillColor: Colors.transparent,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 14),
                                    ),
                                    maxLines: 1,
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 3),
                                    child: Text(
                                      'Select Duration',
                                      style: GoogleFonts.lato(
                                        color: colorBlack,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    onTap: () {
                                      showModalBottomSheet(
                                        isDismissible: true,
                                        backgroundColor:
                                            const Color(0xffF6F6F8),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.7,
                                            child: Container(
                                              // height: 350,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 20),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffF6F6F8),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          19)),
                                              child: ListView(
                                                children: [
                                                  Text(
                                                    'Select Duration',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 16,
                                                        color: colorBlack,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: colorWhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: ListView.builder(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          durations.length,
                                                      itemBuilder:
                                                          (context, idx) {
                                                        return Column(
                                                          children: [
                                                            ListTileTheme(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          13.0,
                                                                      right:
                                                                          13.0,
                                                                      top: 4,
                                                                      bottom:
                                                                          4),
                                                              selectedColor:
                                                                  brandOne,
                                                              child: ListTile(
                                                                title: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.4,
                                                                      child:
                                                                          Text(
                                                                        durations[
                                                                            idx],
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts.lato(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: colorBlack),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    _duration = int.parse(durations[
                                                                            idx]
                                                                        .split(
                                                                            ' ')[0]);
                                                                  });

                                                                  durationController
                                                                          .text =
                                                                      durations[
                                                                          idx];

                                                                  Navigator.pop(
                                                                    context,
                                                                  );

                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                            ),
                                                            (idx !=
                                                                    durations
                                                                            .length -
                                                                        1)
                                                                ? const Divider(
                                                                    color: Color(
                                                                        0xffC9C9C9),
                                                                    height: 1,
                                                                    indent: 13,
                                                                    endIndent:
                                                                        13,
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
                                      color: colorBlack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),

                                    controller: durationController,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Color.fromRGBO(
                                              189, 189, 189, 100),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: brandOne, width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Color.fromRGBO(
                                              189, 189, 189, 100),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 1.0),
                                      ),
                                      suffixIcon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 24,
                                        color: colorBlack,
                                      ),
                                      filled: false,
                                      fillColor: Colors.transparent,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 14),
                                    ),
                                    maxLines: 1,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: CustomButton(
                          text: 'Proceed',
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            if (rentFormKey.currentState!.validate()) {
                              await calculateRent(double.tryParse(
                                      rentAmountController.text
                                          .trim()
                                          .replaceAll(',', '')))
                                  .then(
                                (value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SpaceRentConfirmationPage(
                                        rentValue: _rentValue,
                                        savingsValue: _savingValue,
                                        startDate: endDateController.text,
                                        receivalDate: receivalDate,
                                        durationType: intervalController.text,
                                        paymentCount: paymentCount,
                                        rentName: rentNameController.text,
                                        duration: _duration,
                                        fromPopup: true,
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              customErrorDialog(context, "Invalid",
                                  "Please Fill All Required Fields");
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isDisposed = false;
  Future<void> fetchUserData() async {
    if (!_isDisposed) {
      // Check if the widget is disposed before proceeding
      setState(() {});
      await userController.fetchData();
      await walletController.fetchWallet();
      await rentController.fetchRent();
      if (userController.userModel!.userDetails![0].withdrawalAccount != null) {
        ref
            .read(taskProvider.notifier)
            .completeTask('Set up your withdrawal account');
      }
      if (userController.userModel!.userDetails![0].imageUpdated == true) {
        ref
            .read(taskProvider.notifier)
            .completeTask('Add your profile picture');
      }
      // userController.userModel!.userDetails![0].
      popupDisplayFunction();

      setState(() {}); // Move setState inside fetchData
    }
  }

  getSavings() async {
    await rentController.fetchRent().then((value) {
      if (rentController.rentModel!.rents!.isNotEmpty) {
        for (int j = 0; j < rentController.rentModel!.rents!.length; j++) {
          setState(() {
            rentBalance += rentController.rentModel!.rents![j].paidAmount;
          });
        }
      }
      // }
      else {
        setState(() {
          rentBalance = 0;
        });
      }
    });
  }

  Future<void> setTransationPin() async {
    await Future.delayed(const Duration(seconds: 1));
    if (userController.userModel!.userDetails![0].isPinSet == true) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TransactionPin()),
        );
      }
    }
  }

  @override
  initState() {
    super.initState();

    bool? showBalanceStorage =
        settingsHiveBox.get('showBalance', defaultValue: true);
    setState(() {
      rentBalance = 0;
    });
    fetchUserData();
    selectedIndex = rentspaceProducts[0];
    getSavings();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      userController.fetchData();
      walletController.fetchWallet();
      rentController.fetchRent();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      userController.fetchData();
      walletController.fetchWallet();
      rentController.fetchRent();
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        userController.fetchData();
        walletController.fetchWallet();
        rentController.fetchRent();
      }
    });

    getConnectivity();

    // print("isLoading");
    showBalance = showBalanceStorage!;
    // print(userController.isLoading.value);

    greeting();
    // _fetchNews();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            // showDialogBox();
            if (mounted) {
              noInternetConnectionScreen(context);
            }
            setState(() => isAlertSet = true);
          }
        },
      );

  Future<void> onRefresh() async {
    refreshController.refreshCompleted();
    // if (Provider.of<ConnectivityProvider>(context, listen: false).isOnline) {
    if (mounted) {
      setState(() {
        isRefresh = true;
      });
    }
    userController.fetchData();
    walletController.fetchWallet();
    rentController.fetchRent();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: brandOne,
      body: Obx(
        () => LiquidPullToRefresh(
          height: 100,
          animSpeedFactor: 2,
          color: brandOne,
          backgroundColor: colorWhite,
          showChildOpacityTransition: false,
          onRefresh: onRefresh,
          child: SafeArea(
            top: false,
            bottom: false,
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: brandOne,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -30,
                        right: -50,
                        child: Image.asset(
                          'assets/logo_transparent.png',
                          width: 255.47,
                          height: 291.7.h,
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              24.0.w,
                              0.0.h,
                              24.0.w,
                              0.0.h,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Hi ${userController.userModel!.userDetails![0].firstName.obs}, $dum1",
                                              style: GoogleFonts.lato(
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.w500,
                                                color: colorWhite,
                                              ),
                                            ),
                                            Text(
                                              _greeting,
                                              style: GoogleFonts.lato(
                                                fontSize: 12.0,
                                                // letterSpacing: 1.0,
                                                fontWeight: FontWeight.w500,
                                                color: colorWhite,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context.push('/contactUs');
                                      },
                                      child: Image.asset(
                                        'assets/icons/message_icon.png',
                                        width: 24,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 23.h,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Space Wallet',
                                          style: GoogleFonts.lato(
                                            color: colorWhite,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showBalance = !showBalance;
                                            });
                                            settingsHiveBox.put(
                                                'showBalance', showBalance);
                                          },
                                          child: Icon(
                                            showBalance
                                                ? Iconsax.eye
                                                : Iconsax.eye_slash,
                                            color: colorWhite,
                                            size: 20,
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      showBalance
                                          ? nairaFormaet
                                              .format((selectedIndex ==
                                                          rentspaceProducts[0]
                                                      ? walletController
                                                          .walletModel!
                                                          .wallet![0]
                                                          .mainBalance
                                                      : selectedIndex ==
                                                              rentspaceProducts[
                                                                  1]
                                                          ? rentBalance
                                                          : selectedIndex ==
                                                                  rentspaceProducts[
                                                                      2]
                                                              ? 0
                                                              : walletController
                                                                  .walletModel!
                                                                  .wallet![0]
                                                                  .mainBalance) ??
                                                  0)
                                              .toString()
                                          : "******",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                          color: colorWhite,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            context.push('/fundWallet');
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 39, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(
                                                      0x1A000000), // Color with 15% opacity
                                                  blurRadius: 19.0,
                                                  spreadRadius: -4.0,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.add_circle,
                                                  color: brandTwo,
                                                  size: 26,
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Text(
                                                  'Add Money ',
                                                  style: GoogleFonts.lato(
                                                    color: brandTwo,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 22.h,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: (screenHeight >= 1000)
                                ? MediaQuery.of(context).size.height / 1.2
                                : (screenHeight <= 700)
                                    ? MediaQuery.of(context).size.height / 1.2
                                    : MediaQuery.of(context).size.height / 1.4,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                24.0.w,
                                0.0.h,
                                24.0.w,
                                0.0.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Consumer(
                                    builder: (context, watch, child) {
                                      final slides = ref.watch(taskProvider);
                                      return slides.isEmpty
                                          ? const SizedBox()
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CarouselSlider(
                                                  options: CarouselOptions(
                                                    viewportFraction: 1,
                                                    height: 71,
                                                    enableInfiniteScroll: false,
                                                    enlargeCenterPage: false,
                                                    onPageChanged:
                                                        (index, reason) {
                                                      setState(() {
                                                        currentPos = index;
                                                      });
                                                    },
                                                  ),
                                                  items: slides.map((slide) {
                                                    return Builder(
                                                      builder: (BuildContext
                                                          context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            context.push(
                                                                slide['page']);
                                                            // Navigator.pushNamed(
                                                            //   context,
                                                            //   slide['page'],
                                                            // );
                                                          },
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        0,
                                                                    vertical:
                                                                        0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .canvasColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment
                                                              //         .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  flex: 2,
                                                                  child: Image
                                                                      .asset(
                                                                    slide[
                                                                        'image'],
                                                                    width:
                                                                        66.43.h,
                                                                    height:
                                                                        66.43.h,
                                                                  ),
                                                                ),
                                                                // const SizedBox(
                                                                //     width: 5),
                                                                Flexible(
                                                                  flex: 8,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        slide[
                                                                            'label'],
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts
                                                                            .lato(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .primary,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              9.h),
                                                                      Text(
                                                                        slide[
                                                                            'subTitle'],
                                                                        style: GoogleFonts
                                                                            .lato(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Theme.of(context).primaryColorLight,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: slides
                                                      .asMap()
                                                      .entries
                                                      .map((entry) {
                                                    return GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        width: 6.0.w,
                                                        height: 6.0.h,
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 10.0,
                                                            horizontal: 2.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: currentPos ==
                                                                  entry.key
                                                              ? brandOne
                                                              : const Color(
                                                                  0xffD9D9D9),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            );
                                    },
                                  ),
                                  Text(
                                    'Quick Actions',
                                    style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          minimumSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.45,
                                              45),
                                          backgroundColor:
                                              Theme.of(context).canvasColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          context.push('/airtimePage');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 18),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                'assets/icons/call_icon.png',
                                                width: 24,
                                                height: 24.h,
                                              ),
                                              SizedBox(
                                                height: 14.h,
                                              ),
                                              Text(
                                                'Buy Airtime',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.lato(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          minimumSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.45,
                                              45),
                                          backgroundColor:
                                              Theme.of(context).canvasColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          context.push('/rentCreation');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 18),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                'assets/icons/space_rent.png',
                                                width: 24,
                                                height: 24.h,
                                              ),
                                              SizedBox(
                                                height: 14.h,
                                              ),
                                              Text(
                                                'New Space Rent',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.lato(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Transactions',
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context.push('/allActivities');
                                        },
                                        child: Text(
                                          'View All',
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: brandTwo,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  (userController.userModel!.userDetails![0]
                                          .walletHistories.isEmpty)
                                      ? SizedBox(
                                          height: 240.h,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Image.asset(
                                                'assets/icons/history_icon.png',
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? const Color(0xffffffff)
                                                    : const Color(0xffEEF8FF),
                                                height: 33.5.h,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: 180,
                                                  child: Text(
                                                    "Your transactions will be displayed here",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SingleChildScrollView(
                                          child: Container(
                                            // height: 249,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).canvasColor,
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: (userController
                                                          .userModel!
                                                          .userDetails![0]
                                                          .walletHistories
                                                          .length <
                                                      3)
                                                  ? userController
                                                      .userModel!
                                                      .userDetails![0]
                                                      .walletHistories
                                                      .length
                                                  : 3,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final history = userController
                                                    .userModel!
                                                    .userDetails![0]
                                                    .walletHistories[index];

                                                final item = userController
                                                    .userModel!
                                                    .userDetails![0]
                                                    .walletHistories[index];
                                                final itemLength = item.length;

                                                bool showDivider = true;

                                                if (index <
                                                    userController
                                                            .userModel!
                                                            .userDetails![0]
                                                            .walletHistories
                                                            .length -
                                                        1) {
                                                  if ((itemLength == 1 &&
                                                          index % 2 == 0) ||
                                                      (itemLength == 2 &&
                                                          (index + 1) % 2 ==
                                                              0) ||
                                                      (itemLength >= 3 &&
                                                          (index + 1) % 3 ==
                                                              0)) {
                                                    showDivider = false;
                                                  }
                                                } else {
                                                  showDivider = false;
                                                }
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const TransactionReceipt(),
                                                        settings: RouteSettings(
                                                          arguments: userController
                                                                  .userModel!
                                                                  .userDetails![0]
                                                                  .walletHistories[
                                                              index],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    children: [
                                                      // const SizedBox(
                                                      //   height: 24,
                                                      // ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              flex: 7,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Flexible(
                                                                    flex: 2,
                                                                    child: (history['transactionGroup'].toString().toLowerCase() ==
                                                                            'bill')
                                                                        ? ClipOval(
                                                                            child:
                                                                                Image.asset(
                                                                              (history['biller'].toString().toLowerCase() == 'mtnng')
                                                                                  ? 'assets/utility/mtn.jpg'
                                                                                  : (history['biller'].toString().toLowerCase() == 'airng')
                                                                                      ? 'assets/utility/airtel.jpg'
                                                                                      : (history['biller'].toString().toLowerCase() == 'glo_vbank')
                                                                                          ? 'assets/utility/glo.jpg'
                                                                                          : (history['biller'].toString().toLowerCase() == '9mobile_nigeria')
                                                                                              ? 'assets/utility/9mobile.jpg'
                                                                                              : 'assets/icons/RentSpace-icon.jpg',
                                                                              width: 40,
                                                                              height: 40,
                                                                              fit: BoxFit.fitWidth, // Ensure the image fits inside the circle
                                                                            ),
                                                                          )
                                                                        : Container(
                                                                            padding:
                                                                                const EdgeInsets.all(12),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: (history['transactionType'] == 'Credit') ? brandTwo : brandTwo,
                                                                            ),
                                                                            child: (history['transactionType'] == 'Credit')
                                                                                ? const Icon(
                                                                                    Icons.call_received,
                                                                                    color: Color(0xff80FF00),
                                                                                    size: 20,
                                                                                  )
                                                                                : const Icon(
                                                                                    Icons.arrow_outward_sharp,
                                                                                    color: colorWhite,
                                                                                    size: 20,
                                                                                  ),
                                                                          ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          12),
                                                                  Flexible(
                                                                    flex: 8,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "${history['description'] ?? history['message'] ?? 'No Description Found'} "
                                                                              .capitalize!,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              GoogleFonts.lato(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Theme.of(context).colorScheme.primary,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5.h),
                                                                        Text(
                                                                          formatDateTime(
                                                                              history['createdAt']),
                                                                          style: GoogleFonts.lato(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Theme.of(context).primaryColorLight),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 3,
                                                              child: (history[
                                                                          'transactionType'] ==
                                                                      'Credit')
                                                                  ? Text(
                                                                      "+ ${nairaFormaet.format(double.parse(history['amount'].toString()))}",
                                                                      style: GoogleFonts
                                                                          .roboto(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: const Color(
                                                                            0xff56AB00),
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      nairaFormaet
                                                                          .format(
                                                                              double.parse(history['amount'].toString())),
                                                                      style: GoogleFonts
                                                                          .roboto(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary,
                                                                      ),
                                                                    ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      if (showDivider)
                                                        Divider(
                                                          thickness: 1,
                                                          color:
                                                              Theme.of(context)
                                                                  .dividerColor,
                                                          indent: 17,
                                                          endIndent: 17,
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    // valueNotifier.dispose();
    _isDisposed = true;
    super.dispose();
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
}
