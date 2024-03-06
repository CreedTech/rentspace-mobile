import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/controller/deposit_controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/view/savings/spaceDeposit/spacedeposit_history.dart';
import 'package:rentspace/view/savings/spaceDeposit/spacedeposit_liquidate.dart';
import 'package:rentspace/view/savings/spaceDeposit/spacedeposit_payment.dart';
import 'package:rentspace/view/savings/spaceDeposit/spacedeposit_subscription.dart';

class SpaceDepositList extends StatefulWidget {
  const SpaceDepositList({Key? key}) : super(key: key);

  @override
  _SpaceDepositListState createState() => _SpaceDepositListState();
}

var ch8t = NumberFormat.simpleCurrency(name: 'NGN');
var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
var changeOne = "".obs();
String savedAmount = "0";
String fundingId = "";
String fundDate = "";

class _SpaceDepositListState extends State<SpaceDepositList> {
  // final DepositController depositController = Get.find();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: Theme.of(context).canvasColor,
      //   leading: GestureDetector(
      //     onTap: () {
      //       Get.back();
      //     },
      //     child: Icon(
      //       Icons.close,
      //       size: 30,
      //       color: Theme.of(context).primaryColor,
      //     ),
      //   ),
      // ),
      // body: Obx(
      //   () => Container(
      //     height: double.infinity,
      //     width: double.infinity,
      //     decoration: BoxDecoration(
      //       image: DecorationImage(
      //         image: AssetImage("assets/icons/RentSpace-icon.png"),
      //         fit: BoxFit.cover,
      //         opacity: 0.1,
      //       ),
      //     ),
      //     child: ListView.builder(
      //         shrinkWrap: true,
      //         physics: ClampingScrollPhysics(),
      //         itemCount: depositController.deposit.length,
      //         itemBuilder: (context, int index) {
      //           return (depositController.deposit.isNotEmpty)
      //               ? Column(
      //                   children: [
      //                     Padding(
      //                       padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
      //                       child: badge.Badge(
      //                         badgeColor: Colors.red,
      //                         badgeContent: (depositController
      //                                     .deposit[index].savedAmount ==
      //                                 0)
      //                             ? InkWell(
      //                                 onTap: () {
      //                                   Get.bottomSheet(
      //                                     SizedBox(
      //                                       height: 200,
      //                                       child: ClipRRect(
      //                                         borderRadius: BorderRadius.only(
      //                                           topLeft: Radius.circular(30.0),
      //                                           topRight: Radius.circular(30.0),
      //                                         ),
      //                                         child: Container(
      //                                           color: Theme.of(context)
      //                                               .canvasColor,
      //                                           padding: EdgeInsets.fromLTRB(
      //                                               10, 5, 10, 5),
      //                                           child: Column(
      //                                             children: [
      //                                               SizedBox(
      //                                                 height: 50,
      //                                               ),
      //                                               Text(
      //                                                 'Are you sure you want to delete this SpaceDeposit?',
      //                                                 style: TextStyle(
      //                                                   fontSize: 14,
      //                                                   fontFamily:
      //                                                       "DefaultFontFamily",
      //                                                   color: Theme.of(context)
      //                                                       .primaryColor,
      //                                                 ),
      //                                               ),
      //                                               SizedBox(
      //                                                 height: 30,
      //                                               ),
      //                                               //card
      //                                               Row(
      //                                                 mainAxisAlignment:
      //                                                     MainAxisAlignment
      //                                                         .center,
      //                                                 children: [
      //                                                   InkWell(
      //                                                     onTap: () {
      //                                                       Get.back();
      //                                                     },
      //                                                     child: Container(
      //                                                       width: MediaQuery.of(
      //                                                                   context)
      //                                                               .size
      //                                                               .width /
      //                                                           4,
      //                                                       decoration:
      //                                                           BoxDecoration(
      //                                                         color: brandTwo,
      //                                                         borderRadius:
      //                                                             BorderRadius
      //                                                                 .circular(
      //                                                                     20),
      //                                                       ),
      //                                                       padding: EdgeInsets
      //                                                           .fromLTRB(20, 5,
      //                                                               20, 5),
      //                                                       child: Text(
      //                                                         'No',
      //                                                         style: TextStyle(
      //                                                           fontSize: 12,
      //                                                           fontFamily:
      //                                                               "DefaultFontFamily",
      //                                                           color: Colors
      //                                                               .white,
      //                                                         ),
      //                                                       ),
      //                                                     ),
      //                                                   ),
      //                                                   SizedBox(
      //                                                     width: 20,
      //                                                   ),
      //                                                   InkWell(
      //                                                     onTap: () async {
      //                                                       Get.back();
      //                                                       var rentspaces =
      //                                                           FirebaseFirestore
      //                                                               .instance
      //                                                               .collection(
      //                                                                   'spacedeposit');
      //                                                       var snapshot = await rentspaces
      //                                                           .where(
      //                                                               'savings_id',
      //                                                               isEqualTo: depositController
      //                                                                   .deposit[
      //                                                                       index]
      //                                                                   .depositId)
      //                                                           .get();
      //                                                       for (var doc
      //                                                           in snapshot
      //                                                               .docs) {
      //                                                         await doc
      //                                                             .reference
      //                                                             .delete()
      //                                                             .then(
      //                                                                 (value) {
      //                                                           Get.back();
      //                                                           Get.snackbar(
      //                                                             "SpaceDeposit Deleted!",
      //                                                             'Selected spacedeposit has been deleted!',
      //                                                             animationDuration:
      //                                                                 Duration(
      //                                                                     seconds:
      //                                                                         1),
      //                                                             backgroundColor:
      //                                                                 brandOne,
      //                                                             colorText:
      //                                                                 Colors
      //                                                                     .white,
      //                                                             snackPosition:
      //                                                                 SnackPosition
      //                                                                     .TOP,
      //                                                           );
      //                                                         }).catchError(
      //                                                                 (error) {
      //                                                           Get.snackbar(
      //                                                             "Error",
      //                                                             error
      //                                                                 .toString(),
      //                                                             animationDuration:
      //                                                                 Duration(
      //                                                                     seconds:
      //                                                                         2),
      //                                                             backgroundColor:
      //                                                                 Colors
      //                                                                     .red,
      //                                                             colorText:
      //                                                                 Colors
      //                                                                     .white,
      //                                                             snackPosition:
      //                                                                 SnackPosition
      //                                                                     .BOTTOM,
      //                                                           );
      //                                                         });
      //                                                       }
      //                                                     },
      //                                                     child: Container(
      //                                                       width: MediaQuery.of(
      //                                                                   context)
      //                                                               .size
      //                                                               .width /
      //                                                           4,
      //                                                       decoration:
      //                                                           BoxDecoration(
      //                                                         color: Colors.red,
      //                                                         borderRadius:
      //                                                             BorderRadius
      //                                                                 .circular(
      //                                                                     20),
      //                                                       ),
      //                                                       padding: EdgeInsets
      //                                                           .fromLTRB(20, 5,
      //                                                               20, 5),
      //                                                       child: Text(
      //                                                         'Yes',
      //                                                         style: TextStyle(
      //                                                           fontSize: 12,
      //                                                           fontFamily:
      //                                                               "DefaultFontFamily",
      //                                                           color: Colors
      //                                                               .white,
      //                                                         ),
      //                                                       ),
      //                                                     ),
      //                                                   ),
      //                                                 ],
      //                                               ),

      //                                               //card
      //                                             ],
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     ),
      //                                   );
      //                                 },
      //                                 child: Icon(
      //                                   Icons.delete_outlined,
      //                                   color: Colors.white,
      //                                 ),
      //                               )
      //                             : InkWell(
      //                                 onTap: () {
      //                                   Get.to(DepositLiquidate(
      //                                     index: index,
      //                                     isWallet: false,
      //                                     balance: 0,
      //                                   ));
      //                                 },
      //                                 child: Icon(
      //                                   Icons.eject_outlined,
      //                                   color: Colors.white,
      //                                 ),
      //                               ),
      //                         position: badge.BadgePosition.topEnd(),
      //                         child: Container(
      //                           decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(10),
      //                             color: brandOne,
      //                           ),
      //                           padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      //                           child: Column(
      //                             crossAxisAlignment: CrossAxisAlignment.center,
      //                             children: [
      //                               SizedBox(
      //                                 height: 4,
      //                               ),
      //                               GFListTile(
      //                                 title: Text(
      //                                   depositController
      //                                           .deposit[index].planName +
      //                                       changeOne,
      //                                   style: TextStyle(
      //                                     fontSize: 18,
      //                                     fontFamily: "DefaultFontFamily",
      //                                     color: Colors.white,
      //                                   ),
      //                                 ),
      //                                 avatar: Image.asset(
      //                                   "assets/icons/savings/spacedeposit.png",
      //                                   height: 25,
      //                                   width: 25,
      //                                 ),
      //                                 subTitle: Padding(
      //                                   padding:
      //                                       EdgeInsets.fromLTRB(0, 5, 0, 5),
      //                                   child: Text(
      //                                     nairaFormaet.format(depositController
      //                                             .deposit[index]
      //                                             .targetAmount) +
      //                                         " Target",
      //                                     style: TextStyle(
      //                                       fontSize: 12,
      //                                       fontFamily: "DefaultFontFamily",
      //                                       color: Colors.white,
      //                                     ),
      //                                   ),
      //                                 ),
      //                                 description: LinearPercentIndicator(
      //                                   center: Text(
      //                                     ' ${((depositController.deposit[index].savedAmount / depositController.deposit[index].targetAmount) * 100).toInt()}%',
      //                                     style: TextStyle(
      //                                       fontSize: MediaQuery.of(context)
      //                                               .size
      //                                               .width /
      //                                           30,
      //                                       fontFamily: "DefaultFontFamily",
      //                                     ),
      //                                   ),
      //                                   percent: ((depositController
      //                                               .deposit[index]
      //                                               .savedAmount /
      //                                           depositController.deposit[index]
      //                                               .targetAmount))
      //                                       .toDouble(),
      //                                   animation: true,
      //                                   barRadius: Radius.circular(10.0),
      //                                   lineHeight:
      //                                       MediaQuery.of(context).size.width /
      //                                           25,
      //                                   fillColor: Colors.transparent,
      //                                   progressColor: Colors.greenAccent,
      //                                 ),
      //                                 icon: (depositController
      //                                             .deposit[index].hasPaid ==
      //                                         'true')
      //                                     ? Icon(
      //                                         Icons.check_circle,
      //                                         color: Colors.green,
      //                                         size: 30,
      //                                       )
      //                                     : Icon(
      //                                         Icons.error_outlined,
      //                                         color: Colors.red,
      //                                         size: 30,
      //                                       ),
      //                                 color: Colors.transparent,
      //                                 padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      //                               ),
      //                               Padding(
      //                                 padding:
      //                                     EdgeInsets.fromLTRB(20, 0, 20, 0),
      //                                 child: Row(
      //                                   mainAxisAlignment:
      //                                       MainAxisAlignment.spaceBetween,
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment.center,
      //                                   children: [
      //                                     GFButton(
      //                                       onPressed: () {
      //                                         Get.to(SpaceDepositHistory(
      //                                           current: index,
      //                                         ));
      //                                       },
      //                                       shape: GFButtonShape.pills,
      //                                       fullWidthButton: false,
      //                                       borderSide: BorderSide(
      //                                         color: brandTwo,
      //                                         width: 3.0,
      //                                       ),
      //                                       child: Text(
      //                                         '    History    ',
      //                                         style: TextStyle(
      //                                           color: Colors.white,
      //                                           fontSize: 13,
      //                                           fontFamily: "DefaultFontFamily",
      //                                         ),
      //                                       ),
      //                                       color: brandOne,
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding:
      //                                     EdgeInsets.fromLTRB(10, 0, 10, 0),
      //                                 child: GFAccordion(
      //                                   expandedIcon: Container(
      //                                     decoration: BoxDecoration(
      //                                       color: brandThree,
      //                                       borderRadius:
      //                                           BorderRadius.circular(20.0),
      //                                     ),
      //                                     padding: EdgeInsets.all(2),
      //                                     child: Icon(
      //                                       Icons.remove,
      //                                       color: brandOne,
      //                                     ),
      //                                   ),
      //                                   collapsedIcon: Container(
      //                                     decoration: BoxDecoration(
      //                                       color: brandThree,
      //                                       borderRadius:
      //                                           BorderRadius.circular(20.0),
      //                                     ),
      //                                     padding: EdgeInsets.all(2),
      //                                     child: Icon(
      //                                       Icons.add,
      //                                       color: brandOne,
      //                                     ),
      //                                   ),
      //                                   title: "View details",
      //                                   textStyle: TextStyle(
      //                                     color: Colors.black,
      //                                     fontFamily: "DefaultFontFamily",
      //                                   ),
      //                                   contentBackgroundColor: brandThree,
      //                                   expandedTitleBackgroundColor:
      //                                       brandThree,
      //                                   collapsedTitleBackgroundColor:
      //                                       brandThree,
      //                                   onToggleCollapsed: (e) {},
      //                                   contentChild: Column(
      //                                     crossAxisAlignment:
      //                                         CrossAxisAlignment.start,
      //                                     children: [
      //                                       Text(
      //                                         'SpaceDeposit ID: ${depositController.deposit[index].depositId}',
      //                                         style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontFamily: "DefaultFontFamily",
      //                                         ),
      //                                       ),
      //                                       SizedBox(
      //                                         height: 20,
      //                                       ),
      //                                       Text(
      //                                         'Created: ${depositController.deposit[index].date}',
      //                                         style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontFamily: "DefaultFontFamily",
      //                                         ),
      //                                       ),
      //                                       SizedBox(
      //                                         height: 20,
      //                                       ),
      //                                       Text(
      //                                         'Target no of payments: ${depositController.deposit[index].numPayment}',
      //                                         style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontFamily: "DefaultFontFamily",
      //                                         ),
      //                                       ),
      //                                       SizedBox(
      //                                         height: 20,
      //                                       ),
      //                                       Text(
      //                                         'No of payments: ${depositController.deposit[index].currentPayment}',
      //                                         style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontFamily: "DefaultFontFamily",
      //                                         ),
      //                                       ),
      //                                       SizedBox(
      //                                         height: 20,
      //                                       ),
      //                                       Text(
      //                                         'Payment intervals: ${nairaFormaet.format(double.parse(depositController.deposit[index].intervalAmount.toString()))} ${depositController.deposit[index].interval}',
      //                                         style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontFamily: "DefaultFontFamily",
      //                                         ),
      //                                       ),
      //                                       SizedBox(
      //                                         height: 20,
      //                                       ),
      //                                       Text(
      //                                         'Paid Amount: ${nairaFormaet.format(double.parse(depositController.deposit[index].savedAmount.toString()))}',
      //                                         style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontFamily: "DefaultFontFamily",
      //                                         ),
      //                                       ),
      //                                       SizedBox(
      //                                         height: 20,
      //                                       ),
      //                                       Text(
      //                                         'Target Amount: ${nairaFormaet.format(double.parse(depositController.deposit[index].targetAmount.toString()))}',
      //                                         style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontFamily: "DefaultFontFamily",
      //                                         ),
      //                                       ),
      //                                       SizedBox(
      //                                         height: 20,
      //                                       ),
      //                                       Text(
      //                                         'Remaining Amount: ${nairaFormaet.format(double.parse((depositController.deposit[index].targetAmount - depositController.deposit[index].savedAmount).toString()))}',
      //                                         style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontFamily: "DefaultFontFamily",
      //                                         ),
      //                                       ),
      //                                       SizedBox(
      //                                         height: 20,
      //                                       ),
      //                                       Text(
      //                                         'Interest accrued: ${nairaFormaet.format(double.parse(depositController.deposit[index].interest.toString()))}',
      //                                         style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontFamily: "DefaultFontFamily",
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                     SizedBox(
      //                       height: 20,
      //                     ),
      //                   ],
      //                 )
      //               : Center(
      //                   child: Text(
      //                     "Nothing to show here",
      //                     style: TextStyle(
      //                       fontSize: 22,
      //                       color: Colors.red,
      //                       fontFamily: "DefaultFontFamily",
      //                     ),
      //                   ),
      //                 );
      //         }),
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Get.to(SpaceDepositSubscription());
      //   },
      //   child: Icon(
      //     Icons.add_outlined,
      //     size: 30,
      //     color: Colors.white,
      //   ),
      //   backgroundColor: brandOne,
      // ),
   
    );
  }
}
