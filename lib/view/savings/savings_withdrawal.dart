// ignore_for_file: use_build_context_synchronously

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinput/pinput.dart';
import 'package:rentspace/constants/app_constants.dart';
import 'package:rentspace/constants/colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/widgets/custom_dialog.dart';
import 'package:rentspace/controller/wallet/wallet_controller.dart';
import 'package:rentspace/view/onboarding/FirstPage.dart';
// import 'package:rentspace/controller/user_controller.dart';
import 'package:rentspace/view/onboarding/bvn_page.dart';

import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../api/global_services.dart';
import '../../constants/widgets/custom_loader.dart';
import '../../controller/auth/user_controller.dart';

class WalletWithdrawal extends StatefulWidget {
  const WalletWithdrawal({Key? key}) : super(key: key);

  @override
  _WalletWithdrawalState createState() => _WalletWithdrawalState();
}

var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
bool notLoading = true;

class _WalletWithdrawalState extends State<WalletWithdrawal> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _aPinController = TextEditingController();
  final TextEditingController _bankListController = TextEditingController();
  final withdrawFormKey = GlobalKey<FormState>();
  List<String> _filteredBanks = [];

  String liquidateReason = "I have an emergency";
  var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
  // String walletID = "";
  // String userID = "";
  String? selectedItem;
  String sourceName = "";
  // String uId = "";
  // String walletBalance = "0";
  String accountToUse = "0";
  List<String> _bankName = [];
  String _currentBankName = 'Select bank';
  String _currentBankCode = '';

  List<String> _bankCode = [];
  bool canShowOption = false;
  bool isChecking = false;
  String _bankAccountName = "";

  getAccountDetails(String currentCode) async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken here');
    print(authToken);
    setState(() {
      isChecking = true;
      _bankAccountName = "";
    });
    final response = await http.post(
        Uri.parse(AppConstants.BASE_URL + AppConstants.VERFIY_ACCOUNT_DETAILS),
        headers: {
          'Authorization': 'Bearer $authToken',
          "Content-Type": "application/json"
        },
        body: json.encode({
          "financial_institution": currentCode,
          "account_id": _accountNumberController.text.trim().toString()
        }));
    print(currentCode);
    print(_accountNumberController.text.trim().toString());

    if (response.statusCode == 200) {
      // Request successful, handle the response data
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(jsonResponse['account'][0]['bank']);
      final userBankName = jsonResponse['account'][0]["account_name"];
      if (userBankName != null) {
        setState(() {
          _bankAccountName = userBankName;
          isChecking = false;
        });
      } else {
        // Error handling
        setState(() {
          _bankAccountName = "";
          isChecking = false;
        });
        if (context.mounted) {
          customErrorDialog(context, 'Error!', "Invalid account number");
        }
      }

      //print(response.body);
    } else {
      // Error handling
      setState(() {
        _bankAccountName = "";
        isChecking = false;
      });
      if (context.mounted) {
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
                            child: const Icon(
                              Iconsax.close_circle,
                              color: brandOne,
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
                        'Error!',
                        style: GoogleFonts.lato(
                          color: Colors.red,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Something went wrong",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(color: brandOne, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            });
      }

      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
  }

  Map<String, String> bankData = {
    '000001': 'Sterling Bank',
    '000002': 'Keystone Bank',
    '000003': 'FCMB',
    '000004': 'United Bank for Africa',
    '000005': 'Diamond Bank',
    '000006': 'JAIZ Bank',
    '000007': 'Fidelity Bank',
    '000008': 'Polaris Bank',
    '000009': 'Citi Bank',
    '000010': 'Ecobank Bank',
    '000011': 'Unity Bank',
    '000012': 'StanbicIBTC Bank',
    '000013': 'GTBank Plc',
    '000014': 'Access Bank',
    '000015': 'Zenith Bank Plc',
    '000016': 'First Bank of Nigeria',
    '000017': 'Wema Bank',
    '000018': 'Union Bank',
    '000019': 'Enterprise Bank',
    '000020': 'Heritage',
    '000021': 'Standard Chartered',
    '000022': 'Suntrust Bank',
    '000023': 'Providus Bank',
    '000024': 'Rand Merchant Bank',
    '000025': 'Titan Trust Bank',
    '000026': 'Taj Bank',
    '000027': 'Globus Bank',
    '000028': 'Central Bank of Nigeria',
    '000029': 'Lotus Bank',
    '000031': 'Premium Trust Bank',
    '000033': 'eNaira',
    '000034': 'Signature Bank',
    '000036': 'Optimus Bank',
    '050002': 'FEWCHORE FINANCE COMPANY LIMITED',
    '050003': 'SageGrey Finance Limited',
    '050005': 'AAA Finance',
    '050006': 'Branch International Financial Services',
    '050007': 'Tekla Finance Limited',
    '050009': 'Fast Credit',
    '050010': 'Fundquest Financial Services Limited',
    '050012': 'Enco Finance',
    '050013': 'Dignity Finance',
    '050013': 'Trinity Financial Services Limited',
    '400001': 'FSDH Merchant Bank',
    '060001': 'Coronation Merchant Bank',
    '060002': 'FBNQUEST Merchant Bank',
    '060003': 'Nova Merchant Bank',
    '060004': 'Greenwich Merchant Bank',
    '070007': 'Omoluabi savings and loans',
    '090001': 'ASOSavings & Loans',
    '090005': 'Trustbond Mortgage Bank',
    '090006': 'SafeTrust',
    '090107': 'FBN Mortgages Limited',
    '100024': 'Imperial Homes Mortgage Bank',
    '100028': 'AG Mortgage Bank',
    '070009': 'Gateway Mortgage Bank',
    '070010': 'Abbey Mortgage Bank',
    '070011': 'Refuge Mortgage Bank',
    '070012': 'Lagos Building Investment Company',
    '070013': 'Platinum Mortgage Bank',
    '070014': 'First Generation Mortgage Bank',
    '070015': 'Brent Mortgage Bank',
    '070016': 'Infinity Trust Mortgage Bank',
    '070019': 'MayFresh Mortgage Bank',
    '090003': 'Jubilee-Life Mortgage Bank',
    '070017': 'Haggai Mortgage Bank Limited',
    '070021': 'Coop Mortgage Bank',
    '070023': 'Delta Trust Microfinance Bank',
    '070024': 'Homebase Mortgage Bank',
    '070025': 'Akwa Savings & Loans Limited',
    '070026': 'FHA Mortgage Bank',
    '090108': 'New Prudential Bank',
    '070001': 'NPF MicroFinance Bank',
    '070002': 'Fortis Microfinance Bank',
    '070006': 'Covenant MFB',
    '070008': 'Page Financials',
    '090004': 'Parralex Microfinance bank',
    '090097': 'Ekondo MFB',
    '090110': 'VFD MFB',
    '090111': 'FinaTrust Microfinance Bank',
    '090112': 'Seed Capital Microfinance Bank',
    '090114': 'Empire trust MFB',
    '090115': 'TCF MFB',
    '090116': 'AMML MFB',
    '090117': 'Boctrust Microfinance Bank',
    '090118': 'IBILE Microfinance Bank',
    '090119': 'Ohafia Microfinance Bank',
    '090120': 'Wetland Microfinance Bank',
    '090121': 'Hasal Microfinance Bank',
    '090122': 'Gowans Microfinance Bank',
    '090123': 'Verite Microfinance Bank',
    '090124': 'Xslnce Microfinance Bank',
    '090125': 'Regent Microfinance Bank',
    '090126': 'Fidfund Microfinance Bank',
    '090127': 'BC Kash Microfinance Bank',
    '090128': 'Ndiorah Microfinance Bank',
    '090129': 'Money Trust Microfinance Bank',
    '090130': 'Consumer Microfinance Bank',
    '090131': 'Allworkers Microfinance Bank',
    '090132': 'Richway Microfinance Bank',
    '090133': 'AL-Barakah Microfinance Bank',
    '090134': 'Accion Microfinance Bank',
    '090135': 'Personal Trust Microfinance Bank',
    '090136': 'Microcred Microfinance Bank',
    '090137': 'PecanTrust Microfinance Bank',
    '090138': 'Royal Exchange Microfinance Bank',
    '090139': 'Visa Microfinance Bank',
    '090140': 'Sagamu Microfinance Bank',
    '090141': 'Chikum Microfinance Bank',
    '090142': 'Yes Microfinance Bank',
    '090143': 'Apeks Microfinance Bank',
    '090144': 'CIT Microfinance Bank',
    '090145': 'Fullrange Microfinance Bank',
    '090146': 'Trident Microfinance Bank',
    '090147': 'Hackman Microfinance Bank',
    '090148': 'Bowen Microfinance Bank',
    '090149': 'IRL Microfinance Bank',
    '090150': 'Virtue Microfinance Bank',
    '090151': 'Mutual Trust Microfinance Bank',
    '090152': 'Nagarta Microfinance Bank',
    '090153': 'FFS Microfinance Bank',
    '090154': 'CEMCS Microfinance Bank',
    '090155': 'Advans La Fayette Microfinance Bank',
    '090156': 'e-Barcs Microfinance Bank',
    '090157': 'Infinity Microfinance Bank',
    '090158': 'Futo Microfinance Bank',
    '090159': 'Credit Afrique Microfinance Bank',
    '090160': 'Addosser Microfinance Bank',
    '090161': 'Okpoga Microfinance Bank',
    '090162': 'Stanford Microfinance Bak',
    '090164': 'First Royal Microfinance Bank',
    '090165': 'Petra Microfinance Bank',
    '090166': 'Eso-E Microfinance Bank',
    '090167': 'Daylight Microfinance Bank',
    '090168': 'Gashua Microfinance Bank',
    '090169': 'Alpha Kapital Microfinance Bank',
    '090171': 'Mainstreet Microfinance Bank',
    '090172': 'Astrapolaris Microfinance Bank',
    '090173': 'Reliance Microfinance Bank',
    '090174': 'Malachy Microfinance Bank',
    '090175': 'HighStreet Microfinance Bank',
    '090176': 'Bosak Microfinance Bank',
    '090177': 'Lapo Microfinance Bank',
    '090178': 'GreenBank Microfinance Bank',
    '090179': 'FAST Microfinance Bank',
    '090180': 'Amju Unique Microfinance Bank',
    '090186': 'Girei Microfinance Bank',
    '090188': 'Baines Credit Microfinance Bank',
    '090189': 'Esan Microfinance Bank',
    '090190': 'Mutual Benefits Microfinance Bank',
    '090191': 'KCMB Microfinance Bank',
    '090192': 'Midland Microfinance Bank',
    '090193': 'Unical Microfinance Bank',
    '090194': 'NIRSAL Microfinance Bank',
    '090195': 'Grooming Microfinance Bank',
    '090196': 'Pennywise Microfinance Bank',
    '090197': 'ABU Microfinance Bank',
    '090198': 'RenMoney Microfinance Bank',
    '090205': 'New Dawn Microfinance Bank',
    '090251': 'UNN MFB',
    '090252': 'Yobe Microfinance Bank',
    '090254': 'Coalcamp Microfinance Bank',
    '090258': 'Imo State Microfinance Bank',
    '090259': 'Alekun Microfinance Bank',
    '090260': 'Above Only Microfinance Bank',
    '090261': 'Quickfund Microfinance Bank',
    '090262': 'Stellas Microfinance Bank',
    '090263': 'Navy Microfinance Bank',
    '090264': 'Auchi Microfinance Bank',
    '090265': 'Lovonus Microfinance Bank',
    '090266': 'Uniben Microfinance Bank',
    '090267': 'Kuda Microfinance Bank',
    '090268': 'Adeyemi College Staff Microfinance Bank',
    '090269': 'Greenville Microfinance Bank',
    '090270': 'AB Microfinance Bank',
    '090271': 'Lavender Microfinance Bank',
    '090272': 'Olabisi Onabanjo University Microfinance Bank',
    '090273': 'Emeralds Microfinance Bank',
    '090274': 'Prestige Microfinance Bank',
    '090276': 'Trustfund Microfinance Bank',
    '090277': 'Al-Hayat Microfinance Bank',
    '090278': 'Glory Microfinance Bank',
    '090279': 'Ikire Microfinance Bank',
    '090280': 'Megapraise Microfinance Bank',
    '090281': 'MintFinex Microfinance Bank',
    '090282': 'Arise Microfinance Bank',
    '090283': 'Nnew Women Microfinance Bank',
    '090285': 'First Option Microfinance Bank',
    '090286': 'Safe Haven Microfinance Bank',
    '090287': 'AssetMatrix Microfinance Bank',
    '090289': 'Pillar Microfinance Bank',
    '090290': 'FCT Microfinance Bank',
    '090291': 'Halal Credit Microfinance Bank',
    '090292': 'Afekhafe Microfinance Bank',
    '090293': 'Brethren Microfinance Bank',
    '090294': 'Eagle Flight Microfinance Bank',
    '090295': 'Omiye Microfinance Bank',
    '090296': 'Polyunwana Microfinance Bank',
    '090297': 'Alert Microfinance Bank',
    '090298': 'FedPoly Nasarawa Microfinance Bank',
    '090299': 'Kontagora Microfinance Bank',
    '090303': 'Purplemoney Microfinance Bank',
    '090304': 'Evangel Microfinance Bank',
    '090305': 'Sulspap Microfinance Bank',
    '090307': 'Aramoko Microfinance Bank',
    '090308': 'Brightway Microfinance Bank',
    '090310': 'EdFin Microfinance Bank',
    '090315': 'U & C Microfinance Bank',
    '090317': 'PatrickGold Microfinance Bank',
    '090318': 'Federal University Dutse Microfinance Bank',
    '090320': 'KadPoly Microfinance Bank',
    '090321': 'MayFair Microfinance Bank',
    '090322': 'Rephidim Microfinance Bank',
    '090323': 'Mainland Microfinance Bank',
    '090324': 'Ikenne Microfinance Bank',
    '090325': 'Sparkle',
    '090326': 'Balogun Gambari Microfinance Bank',
    '090327': 'Trust Microfinance Bank',
    '090328': 'Eyowo',
    '090329': 'Neptune Microfinance Bank',
    '090331': 'UNAAB Microfinance Bank',
    '090332': 'Evergreen Microfinance Bank',
    '090333': 'Oche Microfinance Bank',
    '090337': 'Iyeru Okin Microfinance Bank',
    '090352': 'Jessefield Microfinance Bank',
    '090336': 'BIPC Microfinance Bank',
    '090345': 'OAU Microfinance Bank',
    '090349': 'Nassarawa Microfinance Bank',
    '090360': 'CashConnect Microfinance Bank',
    '090362': 'Molusi Microfinance Bank',
    '090363': 'Headway Microfinance Bank',
    '090364': 'Nuture Microfinance Bank',
    '090365': 'Corestep Microfinance Bank',
    '090366': 'Firmus Microfinance Bank',
    '090369': 'Seedvest Microfinance Bank',
    '090370': 'Ilisan Microfinance Bank',
    '090372': 'Legend Microfinance Bank',
    '090373': 'Think Finance Microfinance Bank',
    '090374': 'Coastline Microfinance Bank',
    '090376': 'Apple Microfinance Bank',
    '090377': 'Isaleoyo Microfinance Bank',
    '090378': 'New Golden Pastures Microfinance Bank',
    '090385': 'GTI Microfinance Bank',
    '090386': 'Interland Microfinance Bank',
    '090389': 'EK-Reliable Microfinance Bank',
    '090391': 'Davodani Microfinance Bank',
    '090380': 'Conpro Microfinance Bank',
    '090393': 'Bridgeway Microfinance Bank',
    '090394': 'Amac Microfinance Bank',
    '090395': 'Borgu Microfinance Bank',
    '090396': 'Oscotech Microfinance Bank',
    '090399': 'Nwannegadi Microfinance Bank',
    '090398': 'Federal Polytechnic Nekede Microfinance Bank',
    '090401': 'Shepherd Trust Microfinance Bank',
    '090403': 'UDA Microfinance Bank',
    '090404': 'Olowolagba Microfinance Bank',
    '090405': 'MONIE POINT (Rolez Microfinance Bank)',
    '090406': 'Business Support Microfinance Bank',
    '090409': 'FCMB BETA',
    '090408': 'GMB Microfinance Bank',
    '090410': 'Maritime Microfinance Bank',
    '090411': 'Giginya Microfinance bank',
    '090412': 'Preeminent Microfinance Bank',
    '090444': 'BOI Microfinance Bank',
    '090448': 'Moyofade Microfinance Bank',
    '090455': 'Mkobo Microfinance Bank',
    '090463': 'Rehoboth Microfinance Bank',
    '090464': 'Unimaid Microfinance Bank',
    '090468': 'OLOFIN OWENA Microfinance Bank',
    '090473': 'Assets Microfinance Bank',
    '090338': 'UniUyo Microfinance Bank',
    '090466': 'YCT Microfinance Bank',
    '090467': 'Good Neigbours Microfinance Bank',
    '090471': 'Oluchukwu Microfinance Bank',
    '090465': 'Maintrust Microfinance Bank',
    '090469': 'Aniocha Microfinance bank',
    '090472': 'Caretaker Microfinance Bank',
    '090475': 'Giant Stride Microfinance Bank',
    '090181': 'Balogun Fulani Microfinance Bank',
    '090474': 'Verdant Microfinance Bank',
    '090470': 'Changan RTS Microfinance Bank',
    '090476': 'Anchorage Microfinance Bank',
    '090477': 'Light MFB',
    '090480': 'Cintrust Microfinance Bank',
    '090482': 'Fedeth Microfinance Bank',
    '090483': 'Ada Microfinance Bank',
    '090488': 'Ibu-Aje Microfinance Bank',
    '090489': 'Alvana Microfinance Bank',
    '090490': 'Chukwunenye MFB',
    '090491': 'Nsuk MFB',
    '090492': 'Oraukwu MFB',
    '090494': 'Boji MFB',
    '090495': 'Goodnews Microfinance Bank',
    '090496': 'Randalph Microfinance Bank',
    '090499': 'Pristine Divitis Microfinance Bank',
    '090502': 'Shalom Microfinance Bank',
    '090503': 'Projects Microfinance Bank',
    '090504': 'Zikora Microfinance Bank',
    '090505': 'Nigerian Prisons Microfinance Bank',
    '090506': 'Solid Allianze MFB',
    '090507': 'FIMS MFB',
    '090513': 'SEAP Microfinance Bank',
    '090515': 'RIMA Growth Pathway Microfinance Bank',
    '090516': 'Numo Microfinance Bank',
    '090517': 'Uhuru Microfinance Bank',
    '090518': 'Afemai Microfinance Bank',
    '090519': 'Iboma Fadama Microfinance Bank',
    '090523': 'Chase Microfinance Bank',
    '090524': 'Solidrock microfinance Bank',
    '090525': 'TripleA Microfinance Bank',
    '090526': 'Crescent Microfinance Bank',
    '090527': 'Ojokoro Microfinance Bank',
    '090528': 'Mgbidi Microfinance Bank',
    '090529': 'Ampersand Microfinance Bank',
    '090530': 'Confidence MFB',
    '090531': 'Aku Microfinance Bank',
    '090534': 'Polybadan Microfinance Bank',
    '090536': 'Ikoyi-Osun Microfinance Bank',
    '090537': 'Lobrem Microfinance Bank',
    '090538': 'Blueprint Investments Microfinance Bank',
    '090539': 'Enrich Microfinance Bank',
    '090540': 'Aztec Microfinance Bank',
    '090541': 'Excellent Microfinance Bank',
    '090542': 'Otuo Microfinance Bank',
    '090543': 'Iwoama Microfinance Bank',
    '090544': 'Aspire Microfinance Bank',
    '090545': 'Abulesoro Microfinance Bank',
    '090546': 'Ijebu-Ife Microfinance Bank',
    '090547': 'Rockshield Microfinance Bank',
    '090548': 'Ally Microfinance Bank',
    '090549': 'KC Microfinance Bank',
    '090550': 'Green Energy Microfinance Bank',
    '090551': 'FairMoney Microfinance Bank',
    '090553': 'Consistent Trust Microfinance Bank',
    '090554': 'Kayvee Microfinance Bank',
    '090555': 'BishopGate Microfinance Bank',
    '090556': 'Egwafin Microfinance Bank',
    '090557': 'Lifegate Microfinance Bank',
    '090558': 'Shongom Microfinance Bank',
    '090559': 'Shield Microfinance Bank',
    '090560': 'Tanadi Microfinance Bank',
    '090561': 'Akuchuckwu Microfinance Bank',
    '090562': 'Cedar Microfinance Bank',
    '090563': 'Balera Microfinance Bank',
    '090564': 'Supreme Microfinance Bank',
    '090565': 'Oke-Aro Oredegbe Microfinance Bank',
    '090566': 'Okuku Microfinance Bank',
    '090567': 'Orokam Microfinance Bank',
    '090568': 'Broadview Microfinance Bank',
    '090569': 'Qube Microfinance Bank',
    '090570': 'Iyamoye Microfinance Bank',
    '090571': 'Ilaro Poly Microfinance Bank',
    '090572': 'EWT Microfinance Bank',
    '090573': 'Snow MFB',
    '090575': 'First Midas Microfinance Bank',
    '090576': 'Octopus Microfinance Bank',
    '090579': 'Gbede Microfinance Bank',
    '090580': 'Otech Microfinance Bank',
    '090583': 'Stateside Microfinance Bank',
    '090574': 'GOLDMAN MFB',
    '090535': 'Nkpolu-Ust MFB',
    '090578': 'Iwade MFB Ltd',
    '090587': 'Microbiz MFB',
    '090588': 'Orisun MFB',
    '090589': 'Mercury MFB',
    '090591': 'Gabsyn Microfinance Bank Limited',
    '090593': 'Tasued Microfinance Bank',
    '090602': 'Kenechukwu Microfinance Bank',
    '090950': 'Waya Microfinance Bank',
    '090598': 'IBA Microfinance Bank',
    '090584': 'Island Microfinance Bank',
    '090600': 'Ave Maria Microfinance Bank',
    '090608': 'Akpo Microfinance Bank',
    '090609': 'Ummah Microfinance Bank',
    '090610': 'Amoye Microfinance Bank',
    '090612': 'Medef Microfinance Bank',
    '090532': 'IBOLO Microfinance Bank',
    '090581': 'Banc Corp MFB',
    '090614': 'Flourish MFB',
    '090615': 'Beststar MFB',
    '090616': 'Rayyan MFB',
    '090603': 'Macrod MFB',
    '090620': 'Iyin Ekiti MFB',
    '090611': 'Creditville MFB',
    '090623': 'MAB Allianz MFB',
    '100001': 'FET',
    '100002': 'Paga',
    '100003': 'Parkway-ReadyCash',
    '100004': 'Opay Digital Services LTD',
    '100005': 'Cellulant',
    '100006': 'eTranzact',
    '100007': 'Stanbic IBTC @ease wallet',
    '100008': 'Ecobank Xpress Account',
    '100009': 'GTMobile',
    '100010': 'TeasyMobile',
    '100011': 'Mkudi',
    '100012': 'VTNetworks',
    '100013': 'AccessMobile',
    '100014': 'FBNMobile',
    '100036': 'Kegow (Chamsmobile)',
    '100016': 'FortisMobile',
    '100017': 'Hedonmark',
    '100018': 'ZenithMobile',
    '100019': 'Fidelity Mobile',
    '100020': 'MoneyBox',
    '100021': 'Eartholeum',
    '100022': 'GoMoney',
    '100023': 'TagPay',
    '100025': 'Zinternet Nigera Limited',
    '100026': 'One Finance',
    '100029': 'Innovectives Kesh',
    '100030': 'EcoMobile',
    '100031': 'FCMB Easy Account',
    '100032': 'Contec Global Infotech Limited (NowNow)',
    '100033': 'PalmPay Limited',
    '100034': 'Zenith Eazy Wallet',
    '100052': 'Access Yello',
    '100035': 'M36',
    '100039': 'TitanPaystack',
    '080002': 'Taj_Pinspay',
    '100027': 'Intellifin',
    '110001': 'PayAttitude Online',
    '110002': 'Flutterwave Technology Solutions Limited',
    '110003': 'Interswitch Limited',
    '110004': 'First Apple Limited',
    '110005': '3line Card Management Limited',
    '110006': 'Paystack Payment Limited',
    '110007': 'Teamapt Limited',
    '110014': 'Cyberspace Limited',
    '110015': 'Vas2nets Limited',
    '110017': 'Crowdforce',
    '110032': 'Prophius',
    '090202': 'Accelerex Network Limited',
    '999999': 'NIP Virtual Bank',
    '120001': '9Payment Service Bank',
    '120002': 'HopePSB',
    '120003': 'MoMo PSB',
    '120004': 'SmartCash PSB'
  };

  getBanksList() async {
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken here');
    print(authToken);
    final response = await http.get(
      Uri.parse(AppConstants.BASE_URL + AppConstants.GET_BANKS_LIST),
      headers: {
        'Authorization': 'Bearer $authToken',
        "Content-Type": "application/json"
      },
    );
    print('response');
    // print(response);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('jsonResponse');
      // print(jsonResponse);
      List<String> tempName = [];
      List<String> tempCode = [];
      tempName.add("Select bank");
      for (var item in jsonResponse['banks']) {
        String localCode = item['local_code'] ?? 'N/A';
        // print('localCode');
        // print(localCode);
        String name = item['name'];
        if (localCode != "N/A") {
          tempName.add(name);
          tempCode.add(localCode);
        }
      }
      if (!mounted) return;
      setState(() {
        _bankName = tempName;
        _bankCode = tempCode;
        canShowOption = true;
      });
    } else {
      print('Failed to load data from the server');
    }
  }

  final _chars = '1234567890';
  final Random _rnd = Random();
  final String _payUrl = "";
  String getRandom(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  // final RoundedLoadingButtonController _btnController =
  //     RoundedLoadingButtonController();

  @override
  initState() {
    super.initState();
    notLoading = true;
    getBanksList();
  }

  void _onTextChanged() {
    print('changing');
    String userInput = _bankListController.text.toLowerCase();
    setState(() {
      _filteredBanks = bankData.values
          .where((bankName) => bankName.toLowerCase().contains(userInput))
          .toList();
    });
  }

  @override
  void dispose() {
    _bankListController.dispose();
    super.dispose();
  }

  String _getBankCode(String bankName) {
    return bankData.entries
        .firstWhere(
          (entry) => entry.value == bankName,
          orElse: () => "" as MapEntry<String, String>,
        )
        .key;
  }

  Future<bool> fetchUserData({bool refresh = true}) async {
    if (refresh) {
      await userController.fetchData();
      await walletController.fetchWallet();
      await rentController.fetchRent();
      setState(() {}); // Move setState inside fetchData
    }
    return true;
  }

  void _doWallet() async {
    // Get.back();
    EasyLoading.show(
      indicator: const CustomLoader(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
    String authToken =
        await GlobalService.sharedPreferencesManager.getAuthToken();
    print('authToken here');
    print(authToken);
    // setState(() {
    //   notLoading = false;
    // });

    final response = await http.post(
      Uri.parse(AppConstants.BASE_URL + AppConstants.WALLET_WITHDRAWAL),
      headers: {
        'Authorization': 'Bearer $authToken',
        "Content-Type": "application/json"
      },
      body: jsonEncode(<String, dynamic>{
        // "remark": "SpaceWallet Withdrawal",
        "bank_code": _currentBankCode,
        // "currency_id": "NGN",
        "amount":
            double.tryParse(_amountController.text.trim().replaceAll(',', '')),
        "accountNumber": _accountNumberController.text.trim().toString(),
        // "transaction_reference": "C6NZ61CS_${getRandom(11)}",
        // "account_name": _bankAccountName,
      }),
    );

    if (response.statusCode == 200) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: Colors.green,
          message: 'Wallet Transfer Successful',
          textStyle: GoogleFonts.lato(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
      await fetchUserData(refresh: true);
      EasyLoading.dismiss();
      Get.offAll(FirstPage());
    } else {
      if (context.mounted) {
        customErrorDialog(context, 'Error', 'Something went wrong');
      }
      print(
          'Request failed with status: ${response.statusCode}, ${response.body}');
    }
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
      if (int.tryParse(amountValue)!.isNegative) {
        return 'enter valid number';
      }
      if (int.tryParse(amountValue)! < 10) {
        return 'minimum amount is ₦10.00';
      }
      if (int.tryParse(amountValue)! >
          walletController.walletModel!.wallet![0].mainBalance) {
        return 'you cannot transfer more than your balance';
      }
      return null;
    }

    validateNumber(accountValue) {
      if (accountValue.isEmpty) {
        return 'account number cannot be empty';
      }
      if (accountValue.length < 10) {
        return 'account number is invalid';
      }
      if (int.tryParse(accountValue) == null) {
        return 'enter valid account number';
      }
      return null;
    }

    validateName(nameValue) {
      if (nameValue.isEmpty) {
        return 'account name cannot be empty';
      }

      return null;
    }

    final accountNumber = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      style:
          GoogleFonts.lato(color: Theme.of(context).primaryColor, fontSize: 14),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateNumber,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: _accountNumberController,
      keyboardType: TextInputType.number,
      onChanged: (e) {
        if (_accountNumberController.text.trim().length == 10) {
          getAccountDetails(_currentBankCode);
        }
      },
      maxLength: 10,
      decoration: InputDecoration(
        //prefix: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        contentPadding: const EdgeInsets.all(14),
        filled: false,
        hintText: 'Enter your account number...',
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

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

    final amount = TextFormField(
      enableSuggestions: true,
      cursorColor: Theme.of(context).primaryColor,
      controller: _amountController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateAmount,
      style:
          GoogleFonts.lato(color: Theme.of(context).primaryColor, fontSize: 14),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(
          "Enter amount",
          style: GoogleFonts.lato(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        prefixText: "₦ ",
        prefixStyle: GoogleFonts.lato(
          color: Theme.of(context).primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: brandOne, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        filled: false,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Amount in Naira',
        hintStyle: GoogleFonts.lato(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    return Scaffold(
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
        title: Text(
          'Transfer Funds',
          style: GoogleFonts.lato(
            color: brandOne,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: (userController.userModel!.userDetails![0].hasBvn == true)
          ? Stack(
              children: [
                // (notLoading)
                // ?
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Note that the transfer process will be according to our Terms of use",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Available balance: ${nairaFormaet.format(walletController.walletModel!.wallet![0].mainBalance - 20)}",
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Form(
                        key: withdrawFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text(
                                  "How much do you want to transfer?",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                              child: amount,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 5, 0.0, 5),
                              child: Text(
                                "Where should we send your transfer?",
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  //letterSpacing: 2.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            (canShowOption)
                                ? Column(
                                    children: [
                                      CustomDropdown(
                                        selectedStyle: GoogleFonts.lato(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 12),
                                        hintText: 'Select Bank',
                                        hintStyle:
                                            GoogleFonts.lato(fontSize: 12),
                                        excludeSelected: true,
                                        fillColor: Colors.transparent,
                                        listItemStyle: GoogleFonts.lato(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 12),
                                        items: _bankName,
                                        controller: _bankAccountController,
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                        fieldSuffixIcon: Icon(
                                          Iconsax.arrow_down5,
                                          size: 25.h,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onChanged: (newValue) {
                                          setState(() {
                                            _currentBankName =
                                                newValue.toString();
                                            selectedItem = newValue;
                                            int index = _bankName
                                                .indexOf(selectedItem!);
                                            _currentBankCode =
                                                _bankCode[index - 1];
                                          });
                                          print("_currentBankCode");
                                          print(_currentBankCode);
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 5, 0.0, 5),
                                        child: accountNumber,
                                      ),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 10, 20.0, 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Loading banks...",
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            //letterSpacing: 2.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CustomLoader(),
                                        ),
                                      ],
                                    ),
                                  ),
                            (isChecking)
                                ? const Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(20.0, 0, 20.0, 10),
                                    child: LinearProgressIndicator(
                                      color: brandOne,
                                      minHeight: 4,
                                    ),
                                  )
                                : const SizedBox(),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0, 20.0, 10),
                              child: Text(
                                _bankAccountName,
                                style: GoogleFonts.lato(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
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
                              FocusScope.of(context).unfocus();
                              if (withdrawFormKey.currentState!.validate()) {
                                // print('yo');
                                Get.bottomSheet(
                                  isDismissible: true,
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 300.h,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // const SizedBox(
                                            //   height: 50,
                                            // ),
                                            Text(
                                              'Enter PIN to Proceed',
                                              style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w700),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Pinput(
                                              useNativeKeyboard: false,
                                              obscureText: true,
                                              defaultPinTheme: PinTheme(
                                                width: 50,
                                                height: 50,
                                                textStyle: GoogleFonts.lato(
                                                  fontSize: 25,
                                                  color: brandOne,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              focusedPinTheme: PinTheme(
                                                width: 50,
                                                height: 50,
                                                textStyle: GoogleFonts.lato(
                                                  fontSize: 25,
                                                  color: brandOne,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: brandOne,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              submittedPinTheme: PinTheme(
                                                width: 50,
                                                height: 50,
                                                textStyle: GoogleFonts.lato(
                                                  fontSize: 25,
                                                  color: brandOne,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: brandOne,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              followingPinTheme: PinTheme(
                                                width: 50,
                                                height: 50,
                                                textStyle: GoogleFonts.lato(
                                                  fontSize: 25,
                                                  color: brandOne,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: brandTwo,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              onCompleted: (String val) {
                                                if (BCrypt.checkpw(
                                                  _aPinController.text
                                                      .trim()
                                                      .toString(),
                                                  walletController.walletModel!
                                                      .wallet![0].pin,
                                                )) {
                                                  // _aPinController.clear();
                                                  Get.back();
                                                  if (double.tryParse(
                                                          _amountController.text
                                                              .trim()
                                                              .replaceAll(
                                                                  ',', ''))! >
                                                      walletController
                                                          .walletModel!
                                                          .wallet![0]
                                                          .mainBalance) {
                                                    customErrorDialog(
                                                        context,
                                                        "Insufficient Fund",
                                                        'Fund your wallet to continue');
                                                  } else {
                                                    _doWallet();
                                                  }
                                                } else {
                                                  // _aPinController.clear();
                                                  if (context.mounted) {
                                                    customErrorDialog(
                                                        context,
                                                        "Invalid PIN",
                                                        'Enter correct PIN to proceed');
                                                  }
                                                }
                                              },
                                              validator: validatePinOne,
                                              onChanged: validatePinOne,
                                              controller: _aPinController,
                                              length: 4,
                                              closeKeyboardWhenCompleted: true,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            // SizedBox(
                                            //   height: 20,
                                            // ),
                                            // SizedBox(
                                            //   height: 40,
                                            // ),
                                            // ElevatedButton(
                                            //   style: ElevatedButton.styleFrom(
                                            //     minimumSize:
                                            //         const Size(300, 50),
                                            //     backgroundColor: brandOne,
                                            //     elevation: 0,
                                            //     shape: RoundedRectangleBorder(
                                            //       borderRadius:
                                            //           BorderRadius.circular(
                                            //         10,
                                            //       ),
                                            //     ),
                                            //   ),
                                            //   onPressed: () {
                                            //     if (BCrypt.checkpw(
                                            //       _aPinController.text
                                            //           .trim()
                                            //           .toString(),
                                            //       walletController.walletModel!
                                            //           .wallet![0].pin,
                                            //     )) {
                                            //       _aPinController.clear();
                                            //       Get.back();
                                            //       if (double.tryParse(
                                            //               _amountController.text
                                            //                   .trim()
                                            //                   .replaceAll(
                                            //                       ',', ''))! >
                                            //           walletController
                                            //               .walletModel!
                                            //               .wallet![0]
                                            //               .mainBalance) {
                                            //         customErrorDialog(
                                            //             context,
                                            //             "Insufficient Fund",
                                            //             'Fund your wallet to continue');
                                            //       } else {
                                            //         _doWallet();
                                            //       }
                                            //     } else {
                                            //       _aPinController.clear();
                                            //       if (context.mounted) {
                                            //         customErrorDialog(
                                            //             context,
                                            //             "Invalid PIN",
                                            //             'Enter correct PIN to proceed');
                                            //       }
                                            //     }
                                            //   },
                                            //   child: Text(
                                            //     'Proceed to Transfer',
                                            //     textAlign: TextAlign.center,
                                            //     style: GoogleFonts.lato(
                                            //       color: Colors.white,
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.w700,
                                            //     ),
                                            //   ),
                                            // ),

                                            // const SizedBox(
                                            //   height: 20,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                customErrorDialog(context, 'Invalid',
                                    'Please fill the form properly to proceed');
                                // showDialog(
                                //     context: context,
                                //     barrierDismissible: false,
                                //     builder: (BuildContext context) {
                                //       return AlertDialog(
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(10),
                                //         ),
                                //         title: null,
                                //         elevation: 0,
                                //         content: SizedBox(
                                //           height: 250,
                                //           child: Column(
                                //             children: [
                                //               GestureDetector(
                                //                 onTap: () {
                                //                   Navigator.of(context).pop();
                                //                 },
                                //                 child: Align(
                                //                   alignment: Alignment.topRight,
                                //                   child: Container(
                                //                     decoration: BoxDecoration(
                                //                       borderRadius:
                                //                           BorderRadius.circular(
                                //                               30),
                                //                       // color: brandOne,
                                //                     ),
                                //                     child: const Icon(
                                //                       Iconsax.close_circle,
                                //                       color: brandOne,
                                //                       size: 30,
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ),
                                //               const Align(
                                //                 alignment: Alignment.center,
                                //                 child: Icon(
                                //                   Iconsax.warning_24,
                                //                   color: Colors.red,
                                //                   size: 75,
                                //                 ),
                                //               ),
                                //               const SizedBox(
                                //                 height: 12,
                                //               ),
                                //               Text(
                                //                 'Invalid',
                                //                 style: GoogleFonts.lato(
                                //                   color: Colors.red,
                                //                   fontSize: 28,
                                //                   fontWeight: FontWeight.w700,
                                //                 ),
                                //               ),
                                //               const SizedBox(
                                //                 height: 5,
                                //               ),
                                //               Text(
                                //                 "Please fill the form properly to proceed",
                                //                 textAlign: TextAlign.center,
                                //                 style: GoogleFonts.lato(
                                //                     color: brandOne,
                                //                     fontSize: 18),
                                //               ),
                                //               const SizedBox(
                                //                 height: 10,
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       );
                                //     });
                              }
                            },
                            child: Text(
                              'Transfer',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                )
              ],
            )
          : Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "kindly confirm your BVN to perform this action.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
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
                      Get.to(BvnPage(
                          email:
                              userController.userModel!.userDetails![0].email));
                    },
                    child: Text(
                      'Begin Verification',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  // GFButton(
                  //   onPressed: () async {
                  //     Get.to(const BvnPage());
                  //   },
                  //   text: "  Begin Verification  ",
                  //   fullWidthButton: false,
                  //   color: brandOne,
                  //   shape: GFButtonShape.pills,
                  // ),
                ],
              ),
            ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
