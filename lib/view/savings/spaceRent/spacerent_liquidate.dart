// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pinput/pinput.dart';
// import 'package:rentspace/constants/colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rentspace/constants/db/firebase_db.dart';
// import 'package:intl/intl.dart';
// import 'package:rentspace/controller/rent_controller.dart';
// import 'package:rentspace/controller/user_controller.dart';
// import 'package:rentspace/view/actions/onboarding_page.dart';

// 
// import 'dart:async';
// import 'dart:math';
// import 'package:http/http.dart' as http;
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'dart:convert';

// import '../../../constants/widgets/custom_dialog.dart';

// class RentLiquidate extends StatefulWidget {
//   int index, balance;
//   bool isWallet;
//   RentLiquidate({
//     super.key,
//     required this.index,
//     required this.balance,
//     required this.isWallet,
//   });

//   @override
//   _RentLiquidateState createState() => _RentLiquidateState();
// }

// var now = DateTime.now();
// var formatter = DateFormat('yyyy-MM-dd');
// String formattedDate = formatter.format(now);
// bool notLoading = true;

// int currentInterest = 1;
// int noPaid = 1;
// int noTarget = 1;
// int expectedInterest = 1;
// int deductibleInterest = 1;

// class _RentLiquidateState extends State<RentLiquidate> {
//   final RentController rentController = Get.find();
//   final UserController userController = Get.find();

//   String liquidateReason = "I have an emergency";
//   String liquidateLocation = "Space Wallet";

//   TextEditingController _amountController = TextEditingController();
//   TextEditingController _aPinController = TextEditingController();

//   var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
//   String walletID = "";
//   String userID = "";
//   String uId = "";
//   String sourceName = "";
//   String walletBalance = "0";
//   String accountToUse = "0";
//   String? selectedItem;

//   var _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
//   Random _rnd = Random();
//   String _payUrl = "";
//   String getRandom(int length) => String.fromCharCodes(
//         Iterable.generate(
//           length,
//           (_) => _chars.codeUnitAt(
//             _rnd.nextInt(_chars.length),
//           ),
//         ),
//       );

//   getCurrentUser() async {
//     var collection = FirebaseFirestore.instance.collection('accounts');
//     var docSnapshot = await collection.doc(userId).get();
//     if (docSnapshot.exists) {
//       Map<String, dynamic>? data = docSnapshot.data();
//       setState(() {
//         walletID = data?['wallet_id'];
//         userID = data?['rentspace_id'];
//         uId = data?['id'];
//         walletBalance = data?['wallet_balance'];
//       });
//     }
//   }

//   final TextEditingController _accountNumberController =
//       TextEditingController();
//   final RoundedLoadingButtonController _btnController =
//       RoundedLoadingButtonController();

//   List<String> _bankName = [];
//   String _currentBankName = 'Select bank';
//   String _currentBankCode = '';
//   List<String> _bankCode = [];
//   bool canShowOption = false;
//   bool isChecking = false;
//   String _bankAccountName = "";

//   getAccountDetails(String currentCode) async {
//     setState(() {
//       isChecking = true;
//       _bankAccountName = "";
//     });
//     const String apiUrl = 'https://api-d.squadco.com/payout/account/lookup';
//     const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'Authorization': 'Bearer $bearerToken',
//         "Content-Type": "application/json"
//       },
//       body: jsonEncode(<String, String>{
//         "bank_code": _currentBankName,
//         "account_number": _accountNumberController.text.trim().toString(),
//       }),
//     );

//     if (response.statusCode == 200) {
//       // Request successful, handle the response data
//       final Map<String, dynamic> jsonResponse = json.decode(response.body);
//       final userBankName = jsonResponse['data']["account_name"];
//       if (userBankName != null) {
//         setState(() {
//           _bankAccountName = userBankName;
//           isChecking = false;
//         });
//       } else {
//         // Error handling
//         setState(() {
//           _bankAccountName = "";
//           isChecking = false;
//         });
//         if (context.mounted) {
//           customErrorDialog(
//             context,
//             'Error!',
//             'Invalid account number',
//           );
//         }
//         // Get.snackbar(
//         //   "Error!",
//         //   "Invalid account number",
//         //   animationDuration: const Duration(seconds: 1),
//         //   backgroundColor: Colors.red,
//         //   colorText: Colors.white,
//         //   snackPosition: SnackPosition.BOTTOM,
//         // );
//       }

//       //print(response.body);
//     } else {
//       // Error handling
//       setState(() {
//         _bankAccountName = "";
//         isChecking = false;
//       });
//       if (context.mounted) {
//         customErrorDialog(
//           context,
//           'Error!',
//           'Something went wrong',
//         );
//       }
//       // Get.snackbar(
//       //   "Error!",
//       //   "something went wrong",
//       //   animationDuration: const Duration(seconds: 1),
//       //   backgroundColor: Colors.red,
//       //   colorText: Colors.white,
//       //   snackPosition: SnackPosition.BOTTOM,
//       // );
//       print(
//           'Request failed with status: ${response.statusCode}, ${response.body}');
//     }
//   }

//   getPayable() {
//     setState(() {
//       deductibleInterest =
//           ((0.025 * rentController.rent[widget.index].savedAmount.toInt()))
//               .toInt();
//     });
//   }

//   getBanksList() async {
//     const String bankApiUrl =
//         'https://api.watupay.com/v1/country/NG/financial-institutions';
//     const String bearerToken = 'WTP-L-PK-6a559c833bc54b2698e6a833f107f1e7';
//     final response = await http.get(
//       Uri.parse(bankApiUrl),
//       headers: {
//         'Authorization': 'Bearer $bearerToken',
//         "Content-Type": "application/json"
//       },
//     );

//     if (response.statusCode == 200) {
//       var jsonResponse = jsonDecode(response.body);
//       List<String> tempName = [];
//       List<String> tempCode = [];
//       tempName.add("Select bank");
//       for (var item in jsonResponse['data']) {
//         String localCode = item['local_code'] ?? 'N/A';
//         String name = item['name'];
//         if (localCode != "N/A") {
//           tempName.add(name);
//           tempCode.add(localCode);
//         }
//       }
//       setState(() {
//         _bankName = tempName;
//         _bankCode = tempCode;
//       });

//       print(_bankName);
//       setState(() {
//         canShowOption = true;
//       });
//     } else {
//       print('Failed to load data from the server');
//     }
//   }

//   @override
//   initState() {
//     super.initState();
//     notLoading = true;
//     setState(() {
//       currentInterest = 1;
//       noPaid = 1;
//       noTarget = 1;
//       expectedInterest = 1;
//       deductibleInterest = 1;
//     });
//     getPayable();
//     getCurrentUser();
//     getBanksList();

//     if (widget.isWallet) {
//       setState(() {
//         accountToUse = widget.balance.toString();
//       });
//     } else {
//       setState(() {
//         accountToUse = rentController.rent[widget.index].savedAmount.toString();
//       });
//     }
//   }

//   void _doLiquidateBank() async {
//     setState(() {
//       notLoading = false;
//     });
//     Timer(const Duration(seconds: 1), () {
//       _btnController.stop();
//     });
//     var updateLiquidate = FirebaseFirestore.instance.collection('liquidation');

//     const String apiUrl = 'https://api-d.squadco.com/payout/transfer';
//     const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'Authorization': 'Bearer $bearerToken',
//         "Content-Type": "application/json"
//       },
//       body: jsonEncode(<String, String>{
//         "remark": "SpaceRent Liquidation ",
//         "bank_code": _currentBankName,
//         "currency_id": "NGN",
//         "amount":
//             (int.tryParse(_amountController.text.trim())! * 100).toString(),
//         "account_number": _accountNumberController.text.trim().toString(),
//         "transaction_reference": "C6NZ61CS_${getRandom(11)}",
//         "account_name": _bankAccountName,
//       }),
//     );

//     if (response.statusCode == 200) {
//       await updateLiquidate.add({
//         'user_id': userID,
//         'date': formattedDate,
//         'amount': _amountController.text.trim(),
//         'reason': liquidateReason,
//         'charges': '20',
//         'bank_name': _currentBankName,
//         'status': 'success',
//         'name': 'SpaceRent Liquidation',
//         'trans_id': getRandom(10),
//         'id': uId,
//         'account_number': _accountNumberController.text.trim(),
//         'account_name': _bankAccountName,
//         'withdrawal_location': "Bank",
//         'liquidation_source': "SpaceRent"
//       }).then((value) async {
//         var walletUpdate = FirebaseFirestore.instance.collection('accounts');
//         await walletUpdate.doc(userId).update({
//           "activities": FieldValue.arrayUnion(
//             [
//               "$formattedDate \nBank Withdrawal\n${nairaFormaet.format(double.tryParse(_amountController.text.trim()))} from SpaceRent",
//             ],
//           ),
//         });
//       }).then((value) async {
//         final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//         final querySnapshot = await _firestore
//             .collection('rent_space')
//             .where('rentspace_id',
//                 isEqualTo: rentController.rent[widget.index].rentId)
//             .get();
//         var doc = querySnapshot.docs.first;
//         doc.reference.update({
//           'paid_amount': rentController.rent[widget.index].savedAmount -
//               ((int.tryParse(_amountController.text.trim()))!.toInt() + 20)
//         });

//         setState(() {
//           notLoading = true;
//         });
//         Get.back();
//         showTopSnackBar(
//           Overlay.of(context),
//           CustomSnackBar.success(
//             backgroundColor: brandOne,
//             message: 'Wallet withdrawal successful.',
//             textStyle: GoogleFonts.poppins(
//               fontSize: 14,
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         );
//         Get.snackbar(
//           "Success!",
//           'Liquidation successful.',
//           animationDuration: const Duration(seconds: 1),
//           backgroundColor: brandOne,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.TOP,
//         );
//       }).catchError((error) {
//         setState(() {
//           notLoading = true;
//         });
//         if (context.mounted) {
//           customErrorDialog(
//             context,
//             'Oops',
//             'Something went wrong, try again later',
//           );
//         }
//         // Get.snackbar(
//         //   "Oops",
//         //   "Something went wrong, try again later",
//         //   animationDuration: const Duration(seconds: 2),
//         //   backgroundColor: Colors.red,
//         //   colorText: Colors.white,
//         //   snackPosition: SnackPosition.BOTTOM,
//         // );
//       });
//     } else {
//       if (context.mounted) {
//         customErrorDialog(
//           context,
//           'Error!',
//           'Something went wrong',
//         );
//       }
//       // Get.snackbar(
//       //   "Error!",
//       //   "something went wrong",
//       //   animationDuration: const Duration(seconds: 1),
//       //   backgroundColor: Colors.red,
//       //   colorText: Colors.white,
//       //   snackPosition: SnackPosition.BOTTOM,
//       // );
//       print(
//           'Request failed with status: ${response.statusCode}, ${response.body}');
//     }
//   }

//   void _doLiquidateWallet() async {
//     Timer(const Duration(seconds: 1), () {
//       _btnController.stop();
//     });

//     var updateLiquidate = FirebaseFirestore.instance.collection('liquidation');
//     await updateLiquidate.add({
//       'user_id': userID,
//       'date': formattedDate,
//       'status': 'success',
//       'id': uId,
//       'name': 'SpaceRent Liquidation',
//       'trans_id': getRandom(10),
//       'amount': _amountController.text.trim(),
//       'reason': liquidateReason,
//       'withdrawal_location': "Space Wallet",
//       'liquidation_source': (widget.isWallet)
//           ? "Space Wallet"
//           : 'SpaceRent: ${rentController.rent[widget.index].rentId}',
//     }).then((value) async {
//       var walletUpdate = FirebaseFirestore.instance.collection('accounts');
//       await walletUpdate.doc(userId).update({
//         "activities": FieldValue.arrayUnion(
//           [
//             "$formattedDate \nWallet Withdrawal\n${nairaFormaet.format(double.tryParse(_amountController.text.trim()))} from SpaceRent",
//           ],
//         ),
//       });
//     }).then((value) {
//       Get.back();
//       Get.snackbar(
//         "Success!",
//         'Savings liquidation process has begun, you will be notified shortly.',
//         animationDuration: const Duration(seconds: 1),
//         backgroundColor: brandOne,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.TOP,
//       );
//     }).catchError((error) {
//       if (context.mounted) {
//         customErrorDialog(
//           context,
//           'Oops',
//           'Something went wrong, try again later',
//         );
//       }
//       // Get.snackbar(
//       //   "Oops",
//       //   "Something went wrong, try again later",
//       //   animationDuration: const Duration(seconds: 2),
//       //   backgroundColor: Colors.red,
//       //   colorText: Colors.white,
//       //   snackPosition: SnackPosition.BOTTOM,
//       // );
//     });
//   }

//   void _doWallet() async {
//     setState(() {
//       notLoading = false;
//     });
//     Timer(const Duration(seconds: 1), () {
//       _btnController.stop();
//     });
//     var updateLiquidate = FirebaseFirestore.instance.collection('liquidation');
//     const String apiUrl = 'https://api-d.squadco.com/payout/transfer';
//     const String bearerToken = 'sk_5e03078e1a38fc96de55b1ffaa712ccb1e30965d';

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'Authorization': 'Bearer $bearerToken',
//         "Content-Type": "application/json"
//       },
//       body: jsonEncode(<String, String>{
//         "remark": "SpaceRent Liquidation ",
//         "bank_code": _currentBankName,
//         "currency_id": "NGN",
//         "amount":
//             (int.tryParse(_amountController.text.trim())! * 100).toString(),
//         "account_number": _accountNumberController.text.trim().toString(),
//         "transaction_reference": "C6NZ61CS_${getRandom(11)}",
//         "account_name": _bankAccountName,
//       }),
//     );

//     if (response.statusCode == 200) {
//       await updateLiquidate.add({
//         'user_id': userID,
//         'date': formattedDate,
//         'amount': _amountController.text.trim(),
//         'reason': liquidateReason,
//         'charges': '20',
//         'bank_name': _currentBankName,
//         'name': 'SpaceRent Liquidation',
//         'status': 'success',
//         'trans_id': getRandom(10),
//         'id': uId,
//         'account_number': _accountNumberController.text.trim(),
//         'account_name': _bankAccountName,
//         'withdrawal_location': "Bank",
//         'liquidation_source': "SpaceRent"
//       }).then((value) async {
//         var walletUpdate = FirebaseFirestore.instance.collection('accounts');
//         await walletUpdate.doc(userId).update({
//           "activities": FieldValue.arrayUnion(
//             [
//               "$formattedDate \nBank Withdrawal\n${nairaFormaet.format(double.tryParse(_amountController.text.trim()))} from SpaceRent",
//             ],
//           ),
//         });
//       }).then((value) async {
//         final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//         final querySnapshot = await _firestore
//             .collection('rent_space')
//             .where('rentspace_id',
//                 isEqualTo: rentController.rent[widget.index].rentId)
//             .get();
//         var doc = querySnapshot.docs.first;
//         doc.reference.update({
//           'paid_amount': rentController.rent[widget.index].savedAmount -
//               ((int.tryParse(_amountController.text.trim()))!.toInt() + 20)
//         });
//         setState(() {
//           notLoading = true;
//         });
//         Get.back();
//         Get.snackbar(
//           "Success!",
//           'Liquidation successful.',
//           animationDuration: const Duration(seconds: 1),
//           backgroundColor: brandOne,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.TOP,
//         );
//       }).catchError((error) {
//         setState(() {
//           notLoading = true;
//         });
//         if (context.mounted) {
//           customErrorDialog(
//             context,
//             'Oops',
//             'Something went wrong, try again later',
//           );
//         }
//         // Get.snackbar(
//         //   "Oops",
//         //   "Something went wrong, try again later",
//         //   animationDuration: const Duration(seconds: 2),
//         //   backgroundColor: Colors.red,
//         //   colorText: Colors.white,
//         //   snackPosition: SnackPosition.BOTTOM,
//         // );
//       });
//     } else {
//       if (context.mounted) {
//         customErrorDialog(
//           context,
//           'Error!',
//           'Something went wrong',
//         );
//       }
//       // Get.snackbar(
//       //   "Error!",
//       //   "something went wrong",
//       //   animationDuration: const Duration(seconds: 1),
//       //   backgroundColor: Colors.red,
//       //   colorText: Colors.white,
//       //   snackPosition: SnackPosition.BOTTOM,
//       // );
//       print(
//           'Request failed with status: ${response.statusCode}, ${response.body}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     validateAmount(amountValue) {
//       if (amountValue.isEmpty) {
//         return 'amount cannot be empty';
//       }
//       if (int.tryParse(amountValue) == null) {
//         return 'enter valid number';
//       }
//       if (int.tryParse(amountValue)!.isNegative) {
//         return 'enter valid number';
//       }
//       if (int.tryParse(amountValue)! >
//           ((int.tryParse(accountToUse))! -
//               (0.025 * int.tryParse(accountToUse)!) -
//               20)) {
//         return 'you cannot withdraw more than your balance ';
//       }
//       return '';
//     }

//     validateNumber(accountValue) {
//       if (accountValue.isEmpty) {
//         return 'account number cannot be empty';
//       }
//       if (accountValue.length < 10) {
//         return 'account number is invalid';
//       }
//       if (int.tryParse(accountValue) == null) {
//         return 'enter valid account number';
//       }
//       return '';
//     }

//     validateName(nameValue) {
//       if (nameValue.isEmpty) {
//         return 'account name cannot be empty';
//       }

//       return '';
//     }

//     final bankOption = Container(
//       height: 50,
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.all(20),
//       child: DropdownButtonHideUnderline(
//         child: GFDropdown(
//           borderRadius: BorderRadius.circular(5),
//           border: const BorderSide(color: Colors.black12, width: 1),
//           dropdownButtonColor: Theme.of(context).canvasColor,
//           value: _currentBankName,
//           hint: Text(
//             'Choose bank',
//             style: TextStyle(
//               fontSize: MediaQuery.of(context).size.height / 60,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//           dropdownColor: Theme.of(context).canvasColor,
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.height / 60,
//             color: Theme.of(context).primaryColor,
//           ),
//           focusColor: brandOne,
//           onChanged: (newValue) {
//             setState(() {
//               _currentBankName = newValue.toString();
//               selectedItem = newValue as String?;
//               int index = _bankName.indexOf(selectedItem!);
//               _currentBankCode = _bankCode[index - 1];
//             });
//           },
//           items: _bankName
//               .map((value) => DropdownMenuItem(
//                     value: value,
//                     child: Text(value),
//                   ))
//               .toList(),
//         ),
//       ),
//     );

//     final fewBankOption = Container(
//       height: 50,
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.all(20),
//       child: DropdownButtonHideUnderline(
//         child: GFDropdown(
//           borderRadius: BorderRadius.circular(5),
//           border: const BorderSide(color: Colors.black12, width: 1),
//           dropdownButtonColor: Theme.of(context).canvasColor,
//           value: _currentBankName,
//           hint: Text(
//             'Choose bank',
//             style: TextStyle(
//               fontSize: MediaQuery.of(context).size.height / 60,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//           dropdownColor: Theme.of(context).canvasColor,
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.height / 60,
//             color: Theme.of(context).primaryColor,
//           ),
//           focusColor: brandOne,
//           items: const [
//             DropdownMenuItem(value: 'Select bank', child: Text('Select bank')),
//             DropdownMenuItem(value: '000013', child: Text('GTB')),
//             DropdownMenuItem(value: '000014', child: Text('Access Bank')),
//             DropdownMenuItem(value: '000023', child: Text('Providus Bank')),
//             DropdownMenuItem(value: '100004', child: Text('OPay')),
//           ],
//           onChanged: (newValue) {
//             setState(() {
//               _currentBankName = newValue.toString();
//             });
//             print(_currentBankName);
//           },
//         ),
//       ),
//     );

//     //input field
//     final accountNumber = TextFormField(
//       enableSuggestions: true,
//       cursorColor: Colors.black,
//       style: const TextStyle(
//         color: Colors.black,
//       ),
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       validator: validateNumber,
//       controller: _accountNumberController,
//       keyboardType: TextInputType.number,
//       onChanged: (e) {
//         if (_accountNumberController.text.trim().length == 10) {
//           getAccountDetails(_currentBankCode);
//         }
//       },
//       maxLength: 10,
//       decoration: InputDecoration(
//         //prefix: Icon(Icons.email),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           borderSide: const BorderSide(color: brandOne, width: 2.0),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: brandOne, width: 2.0),
//         ),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: brandOne, width: 2.0),
//         ),
//         errorBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: brandOne, width: 2.0),
//         ),
//         filled: true,
//         fillColor: brandThree,
//         hintText: 'Enter your account number...',
//         hintStyle: const TextStyle(
//           color: Colors.grey,
//         ),
//       ),
//     );
//     final reasonOption = Container(
//       height: 50,
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.all(20),
//       child: DropdownButtonHideUnderline(
//         child: GFDropdown(
//           borderRadius: BorderRadius.circular(5),
//           border: const BorderSide(color: Colors.black12, width: 1),
//           dropdownButtonColor: Theme.of(context).canvasColor,
//           value: liquidateReason,
//           hint: Text(
//             'Tell us why',
//             style: TextStyle(
//               fontSize: MediaQuery.of(context).size.height / 60,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//           dropdownColor: Theme.of(context).canvasColor,
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.height / 60,
//             color: Theme.of(context).primaryColor,
//           ),
//           focusColor: brandOne,
//           onChanged: (newValue) {
//             //updated(state);
//             setState(() {
//               liquidateReason = newValue.toString();
//             });
//           },
//           items: [
//             'I have an emergency',
//             'I no longer need to save',
//             'Its too hard for me to save',
//             'I have other reasons',
//           ]
//               .map((value) => DropdownMenuItem(
//                     value: value,
//                     child: Text(value),
//                   ))
//               .toList(),
//         ),
//       ),
//     );
//     final locationOption = Container(
//       height: 50,
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.all(20),
//       child: DropdownButtonHideUnderline(
//         child: GFDropdown(
//           borderRadius: BorderRadius.circular(5),
//           border: const BorderSide(color: Colors.black12, width: 1),
//           dropdownButtonColor: Theme.of(context).canvasColor,
//           value: liquidateLocation,
//           hint: Text(
//             'Where should we send your withdrawal?',
//             style: TextStyle(
//               fontSize: MediaQuery.of(context).size.height / 60,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//           dropdownColor: Theme.of(context).canvasColor,
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.height / 60,
//             color: Theme.of(context).primaryColor,
//           ),
//           focusColor: brandOne,
//           onChanged: (newValue) {
//             //updated(state);
//             setState(() {
//               liquidateLocation = newValue.toString();
//             });
//           },
//           items: [
//             'Space Wallet',
//             'Bank Account',
//           ]
//               .map((value) => DropdownMenuItem(
//                     value: value,
//                     child: Text(value),
//                   ))
//               .toList(),
//         ),
//       ),
//     );
//     final amount = TextFormField(
//       enableSuggestions: true,
//       cursorColor: Colors.black,
//       controller: _amountController,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       validator: validateAmount,
//       style: const TextStyle(
//         color: Colors.black,
//       ),
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         label: const Text(
//           "Enter amount",
//           style: TextStyle(
//             color: Colors.grey,
//           ),
//         ),
//         prefixText: "₦",
//         prefixStyle: const TextStyle(
//           color: Colors.grey,
//           fontSize: 13,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           borderSide: const BorderSide(color: brandOne, width: 2.0),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: brandOne, width: 2.0),
//         ),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: brandOne, width: 2.0),
//         ),
//         errorBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: brandOne, width: 2.0),
//         ),
//         filled: true,
//         fillColor: brandThree,
//         hintText: 'Amount in Naira',
//         hintStyle: const TextStyle(
//           color: Colors.grey,
//           fontSize: 13,
//         ),
//       ),
//     );

//     return Scaffold(
//       backgroundColor: Theme.of(context).canvasColor,
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: Theme.of(context).canvasColor,
//         leading: GestureDetector(
//           onTap: () {
//             Get.back();
//           },
//           child: Icon(
//             Icons.close,
//             size: 30,
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//       ),
//       body: (userController.user[0].status == "verified")
//           ? Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("assets/icons/RentSpace-icon.png"),
//                   fit: BoxFit.cover,
//                   opacity: 0.1,
//                 ),
//               ),
//               padding: const EdgeInsets.fromLTRB(10.0, 2, 10.0, 2),
//               child: (notLoading)
//                   ? Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: ListView(
//                         children: [
//                           const SizedBox(
//                             height: 50,
//                           ),
//                           (widget.isWallet)
//                               ? Text(
//                                   "Note that the withdrawal process will be according to our Terms of use",
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 20,
//                                     letterSpacing: 2.0,
//                                     color: Theme.of(context).primaryColor,
//                                   ),
//                                 )
//                               : Text(
//                                   "Note that the liquidation process will be according to our Terms of use",
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 20,
//                                     letterSpacing: 0.5,
//                                     color: Theme.of(context).primaryColor,
//                                   ),
//                                 ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Text(
//                             "Available balance: ${nairaFormaet.format((rentController.rent[widget.index].savedAmount.toInt()) - ((0.025 * rentController.rent[widget.index].savedAmount.toInt()) + 20))}",
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 30,
//                           ),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.fromLTRB(15.0, 2, 15.0, 2),
//                             child: (widget.isWallet)
//                                 ? Text(
//                                     "Why do you want to withdraw?",
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       //letterSpacing: 2.0,
//                                       color: Theme.of(context).primaryColor,
//                                     ),
//                                   )
//                                 : Text(
//                                     "Why do you want to liquidate?",
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       //letterSpacing: 2.0,
//                                       color: Theme.of(context).primaryColor,
//                                     ),
//                                   ),
//                           ),
//                           reasonOption,
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           (!widget.isWallet)
//                               ? Padding(
//                                   padding: const EdgeInsets.fromLTRB(
//                                       15.0, 2, 15.0, 2),
//                                   child: Text(
//                                     "Where should we send your withdrawal?",
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       //letterSpacing: 2.0,
//                                       color: Theme.of(context).primaryColor,
//                                     ),
//                                   ),
//                                 )
//                               : const SizedBox(),
//                           (!widget.isWallet)
//                               ? locationOption
//                               : const SizedBox(),
//                           (liquidateLocation == "Bank Account" ||
//                                   widget.isWallet)
//                               ? Column(
//                                   children: [
//                                     (canShowOption)
//                                         ? Column(
//                                             children: [
//                                               fewBankOption,
//                                               const SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.fromLTRB(
//                                                         15.0, 2, 15.0, 2),
//                                                 child: accountNumber,
//                                               ),
//                                             ],
//                                           )
//                                         : Padding(
//                                             padding: const EdgeInsets.fromLTRB(
//                                                 20.0, 10, 20.0, 10),
//                                             child: Text(
//                                               "Loading banks...",
//                                               style: GoogleFonts.poppins(
//                                                 fontSize: 16,
//                                                 //letterSpacing: 2.0,
//                                                 color: Theme.of(context)
//                                                     .primaryColor,
//                                               ),
//                                             ),
//                                           ),
//                                     (isChecking)
//                                         ? const Padding(
//                                             padding: EdgeInsets.fromLTRB(
//                                                 20.0, 0, 20.0, 10),
//                                             child: LinearProgressIndicator(
//                                               color: brandOne,
//                                               minHeight: 4,
//                                             ),
//                                           )
//                                         : const SizedBox(),
//                                     Padding(
//                                       padding: const EdgeInsets.fromLTRB(
//                                           20.0, 10, 20.0, 10),
//                                       child: Text(
//                                         _bankAccountName,
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 16.0,
//                                           letterSpacing: 0.5,
//                                           fontWeight: FontWeight.bold,
//                                           color: Theme.of(context).primaryColor,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               : const Text(""),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.fromLTRB(15.0, 2, 15.0, 2),
//                             child: (widget.isWallet)
//                                 ? Text(
//                                     "How much do you want to withdraw?",
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       //letterSpacing: 2.0,
//                                       color: Theme.of(context).primaryColor,
//                                     ),
//                                   )
//                                 : Text(
//                                     "How much do you want to liquidate?",
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       //letterSpacing: 2.0,
//                                       color: Theme.of(context).primaryColor,
//                                     ),
//                                   ),
//                           ),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.fromLTRB(15.0, 2, 15.0, 2),
//                             child: amount,
//                           ),
//                           const SizedBox(
//                             height: 50,
//                           ),
//                           RoundedLoadingButton(
//                             elevation: 0.0,
//                             successColor: brandOne,
//                             color: brandOne,
//                             controller: _btnController,
//                             onPressed: () {
//                               if (validateAmount(
//                                       _amountController.text.trim()) ==
//                                   "") {
//                                 if (liquidateLocation == "Bank Account" &&
//                                     validateName(_bankAccountName) == "" &&
//                                     validateNumber(_accountNumberController.text
//                                             .trim()) ==
//                                         "") {
//                                   Timer(const Duration(seconds: 1), () {
//                                     _btnController.stop();
//                                   });
//                                   Get.bottomSheet(
//                                     isDismissible: true,
//                                     SizedBox(
//                                       height: 300,
//                                       child: ClipRRect(
//                                         borderRadius: const BorderRadius.only(
//                                           topLeft: Radius.circular(30.0),
//                                           topRight: Radius.circular(30.0),
//                                         ),
//                                         child: Container(
//                                           color: Theme.of(context).canvasColor,
//                                           padding: const EdgeInsets.fromLTRB(
//                                               10, 5, 10, 5),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               const SizedBox(
//                                                 height: 50,
//                                               ),
//                                               Text(
//                                                 'Enter PIN to Proceed',
//                                                 style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontFamily:
//                                                       "DefaultFontFamily",
//                                                   color: Theme.of(context)
//                                                       .primaryColor,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                               Pinput(
//                                                 defaultPinTheme: PinTheme(
//                                                   width: 30,
//                                                   height: 30,
//                                                   textStyle: TextStyle(
//                                                     fontSize: 20,
//                                                     color: Theme.of(context)
//                                                         .primaryColor,
//                                                   ),
//                                                   decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                         color: brandOne,
//                                                         width: 2.0),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                   ),
//                                                 ),
//                                                 controller: _aPinController,
//                                                 length: 4,
//                                                 closeKeyboardWhenCompleted:
//                                                     true,
//                                                 keyboardType:
//                                                     TextInputType.number,
//                                               ),
//                                               const SizedBox(
//                                                 height: 20,
//                                               ),
//                                               Text(
//                                                 '(₦20 charges applied)',
//                                                 style: TextStyle(
//                                                   fontSize: 14,
//                                                   fontFamily:
//                                                       "DefaultFontFamily",
//                                                   color: Theme.of(context)
//                                                       .primaryColor,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                               const SizedBox(
//                                                 height: 30,
//                                               ),
//                                               GFButton(
//                                                 onPressed: () {
//                                                   if (_aPinController.text
//                                                           .trim()
//                                                           .toString() ==
//                                                       userController.user[0]
//                                                           .transactionPIN) {
//                                                     Get.back();
//                                                     _doLiquidateBank();
//                                                   } else {
//                                                     if (context.mounted) {
//                                                       customErrorDialog(
//                                                         context,
//                                                         'Invalid PIN',
//                                                         'Enter correct PIN',
//                                                       );
//                                                     }
//                                                     // Get.snackbar(
//                                                     //   "Invalid PIN",
//                                                     //   "Enter correct PIN",
//                                                     //   animationDuration:
//                                                     //       const Duration(
//                                                     //           seconds: 2),
//                                                     //   backgroundColor:
//                                                     //       Colors.red,
//                                                     //   colorText: Colors.white,
//                                                     //   snackPosition:
//                                                     //       SnackPosition.BOTTOM,
//                                                     // );
//                                                   }
//                                                 },
//                                                 icon: const Icon(
//                                                   Icons.arrow_right_outlined,
//                                                   size: 30,
//                                                   color: Colors.white,
//                                                 ),
//                                                 color: brandOne,
//                                                 text: "Proceed to Withdraw",
//                                                 shape: GFButtonShape.pills,
//                                                 fullWidthButton: false,
//                                               ),
//                                               const SizedBox(
//                                                 height: 20,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 } else if (liquidateLocation ==
//                                     "Space Wallet") {
//                                   if (validateName(_bankAccountName) == "" &&
//                                       validateNumber(_accountNumberController
//                                               .text
//                                               .trim()) ==
//                                           "" &&
//                                       widget.isWallet == true) {
//                                     Timer(const Duration(seconds: 1), () {
//                                       _btnController.stop();
//                                     });
//                                     Get.bottomSheet(
//                                       isDismissible: true,
//                                       SizedBox(
//                                         height: 300,
//                                         child: ClipRRect(
//                                           borderRadius: const BorderRadius.only(
//                                             topLeft: Radius.circular(30.0),
//                                             topRight: Radius.circular(30.0),
//                                           ),
//                                           child: Container(
//                                             color:
//                                                 Theme.of(context).canvasColor,
//                                             padding: const EdgeInsets.fromLTRB(
//                                                 10, 5, 10, 5),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: [
//                                                 const SizedBox(
//                                                   height: 50,
//                                                 ),
//                                                 Text(
//                                                   'Enter PIN to Proceed',
//                                                   style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontFamily:
//                                                         "DefaultFontFamily",
//                                                     color: Theme.of(context)
//                                                         .primaryColor,
//                                                   ),
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                                 Pinput(
//                                                   defaultPinTheme: PinTheme(
//                                                     width: 30,
//                                                     height: 30,
//                                                     textStyle: TextStyle(
//                                                       fontSize: 20,
//                                                       color: Theme.of(context)
//                                                           .primaryColor,
//                                                     ),
//                                                     decoration: BoxDecoration(
//                                                       border: Border.all(
//                                                           color: brandOne,
//                                                           width: 2.0),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                     ),
//                                                   ),
//                                                   controller: _aPinController,
//                                                   length: 4,
//                                                   closeKeyboardWhenCompleted:
//                                                       true,
//                                                   keyboardType:
//                                                       TextInputType.number,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 20,
//                                                 ),
//                                                 Text(
//                                                   '(₦20 charges applied)',
//                                                   style: TextStyle(
//                                                     fontSize: 14,
//                                                     fontFamily:
//                                                         "DefaultFontFamily",
//                                                     color: Theme.of(context)
//                                                         .primaryColor,
//                                                   ),
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 30,
//                                                 ),
//                                                 GFButton(
//                                                   onPressed: () {
//                                                     if (_aPinController.text
//                                                             .trim()
//                                                             .toString() ==
//                                                         userController.user[0]
//                                                             .transactionPIN) {
//                                                       Get.back();
//                                                       _doWallet();
//                                                     } else {
//                                                       if (context.mounted) {
//                                                         customErrorDialog(
//                                                           context,
//                                                           'Invalid PIN',
//                                                           'Enter correct PIN',
//                                                         );
//                                                       }
//                                                       // Get.snackbar(
//                                                       //   "Invalid PIN",
//                                                       //   "Enter correct PIN",
//                                                       //   animationDuration:
//                                                       //       const Duration(
//                                                       //           seconds: 2),
//                                                       //   backgroundColor:
//                                                       //       Colors.red,
//                                                       //   colorText: Colors.white,
//                                                       //   snackPosition:
//                                                       //       SnackPosition
//                                                       //           .BOTTOM,
//                                                       // );
//                                                     }
//                                                   },
//                                                   icon: const Icon(
//                                                     Icons.arrow_right_outlined,
//                                                     size: 30,
//                                                     color: Colors.white,
//                                                   ),
//                                                   color: brandOne,
//                                                   text: "Proceed to Withdraw",
//                                                   shape: GFButtonShape.pills,
//                                                   fullWidthButton: false,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 20,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     Timer(const Duration(seconds: 1), () {
//                                       _btnController.stop();
//                                     });
//                                     Get.bottomSheet(
//                                       isDismissible: true,
//                                       SizedBox(
//                                         height: 300,
//                                         child: ClipRRect(
//                                           borderRadius: const BorderRadius.only(
//                                             topLeft: Radius.circular(30.0),
//                                             topRight: Radius.circular(30.0),
//                                           ),
//                                           child: Container(
//                                             color:
//                                                 Theme.of(context).canvasColor,
//                                             padding: const EdgeInsets.fromLTRB(
//                                                 10, 5, 10, 5),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: [
//                                                 const SizedBox(
//                                                   height: 50,
//                                                 ),
//                                                 Text(
//                                                   'Enter PIN to Proceed',
//                                                   style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontFamily:
//                                                         "DefaultFontFamily",
//                                                     color: Theme.of(context)
//                                                         .primaryColor,
//                                                   ),
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                                 Pinput(
//                                                   defaultPinTheme: PinTheme(
//                                                     width: 30,
//                                                     height: 30,
//                                                     textStyle: TextStyle(
//                                                       fontSize: 20,
//                                                       color: Theme.of(context)
//                                                           .primaryColor,
//                                                     ),
//                                                     decoration: BoxDecoration(
//                                                       border: Border.all(
//                                                           color: brandOne,
//                                                           width: 2.0),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                     ),
//                                                   ),
//                                                   controller: _aPinController,
//                                                   length: 4,
//                                                   closeKeyboardWhenCompleted:
//                                                       true,
//                                                   keyboardType:
//                                                       TextInputType.number,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 20,
//                                                 ),
//                                                 Text(
//                                                   '(₦20 charges applied)',
//                                                   style: TextStyle(
//                                                     fontSize: 14,
//                                                     fontFamily:
//                                                         "DefaultFontFamily",
//                                                     color: Theme.of(context)
//                                                         .primaryColor,
//                                                   ),
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 30,
//                                                 ),
//                                                 GFButton(
//                                                   onPressed: () {
//                                                     if (_aPinController.text
//                                                             .trim()
//                                                             .toString() ==
//                                                         userController.user[0]
//                                                             .transactionPIN) {
//                                                       Get.back();
//                                                       _doLiquidateWallet();
//                                                     } else {
//                                                       if (context.mounted) {
//                                                         customErrorDialog(
//                                                           context,
//                                                           'Invalid PIN',
//                                                           'Enter correct PIN',
//                                                         );
//                                                       }
//                                                       // Get.snackbar(
//                                                       //   "Invalid PIN",
//                                                       //   "Enter correct PIN",
//                                                       //   animationDuration:
//                                                       //       const Duration(
//                                                       //           seconds: 2),
//                                                       //   backgroundColor:
//                                                       //       Colors.red,
//                                                       //   colorText: Colors.white,
//                                                       //   snackPosition:
//                                                       //       SnackPosition
//                                                       //           .BOTTOM,
//                                                       // );
//                                                     }
//                                                   },
//                                                   icon: const Icon(
//                                                     Icons.arrow_right_outlined,
//                                                     size: 30,
//                                                     color: Colors.white,
//                                                   ),
//                                                   color: brandOne,
//                                                   text: "Proceed to Withdraw",
//                                                   shape: GFButtonShape.pills,
//                                                   fullWidthButton: false,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 20,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                 } else {
//                                   if (context.mounted) {
//                                     customErrorDialog(
//                                       context,
//                                       'Invalid',
//                                       'Please fill the form properly to proceed',
//                                     );
//                                   }
//                                   // Get.snackbar(
//                                   //   "Invalid",
//                                   //   'Please fill the form properly to proceed',
//                                   //   animationDuration:
//                                   //       const Duration(seconds: 1),
//                                   //   backgroundColor: Colors.red,
//                                   //   colorText: Colors.white,
//                                   //   snackPosition: SnackPosition.BOTTOM,
//                                   // );
//                                 }
//                               } else {
//                                 Timer(const Duration(seconds: 1), () {
//                                   _btnController.stop();
//                                 });
//                                 if (context.mounted) {
//                                   customErrorDialog(
//                                     context,
//                                     'Invalid',
//                                     'Please fill the form properly to proceed',
//                                   );
//                                 }
//                                 // Get.snackbar(
//                                 //   "Invalid",
//                                 //   'Please fill the form properly to proceed',
//                                 //   animationDuration: const Duration(seconds: 1),
//                                 //   backgroundColor: Colors.red,
//                                 //   colorText: Colors.white,
//                                 //   snackPosition: SnackPosition.BOTTOM,
//                                 // );
//                               }
//                             },
//                             child: (widget.isWallet)
//                                 ?  Text(
//                                     'Withdraw',
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.white,
//                                     ),
//                                   )
//                                 :  Text(
//                                     'Liquidate',
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                           ),
//                           const SizedBox(
//                             height: 50,
//                           ),
//                         ],
//                       ),
//                     )
//                   : Container(
//                       height: double.infinity,
//                       width: double.infinity,
//                       decoration: const BoxDecoration(
//                         image: DecorationImage(
//                             image:
//                                 AssetImage("assets/icons/RentSpace-icon.png"),
//                             fit: BoxFit.cover,
//                             opacity: 0.1),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const SizedBox(
//                             height: 50,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Processing...",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 20,
//                                   color: Theme.of(context).primaryColor,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 30,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 50,
//                           ),
//                           const CircularProgressIndicator(
//                             color: brandOne,
//                           ),
//                         ],
//                       ),
//                     ),
//             )
//           : Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("assets/icons/RentSpace-icon.png"),
//                   fit: BoxFit.cover,
//                   opacity: 0.1,
//                 ),
//               ),
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         child: Flexible(
//                           child: Text(
//                             "kindly confirm your BVN to perform this action.",
//                             style: GoogleFonts.poppins(
//                               fontSize: 16.0,
//                               letterSpacing: 0.5,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   GFButton(
//                     onPressed: () async {
//                       // Get.to( BvnPage(email: userController.us));
//                     },
//                     text: "  Begin Verification  ",
//                     fullWidthButton: false,
//                     color: brandOne,
//                     shape: GFButtonShape.pills,
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
