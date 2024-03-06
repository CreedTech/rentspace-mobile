// import 'package:badges/badges.dart' as badge;
// import 'package:flutter/material.dart';
// import 'package:rentspace/constants/colors.dart';
// import 'package:get/get.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:rentspace/controller/tank_controller.dart';
// import 'package:intl/intl.dart';
// import 'package:rentspace/view/savings/spaceTank/spacetank_liquidate.dart';
// import 'package:rentspace/view/savings/spaceTank/spacetank_subscription.dart';

// class SpaceTankList extends StatefulWidget {
//   const SpaceTankList({Key? key}) : super(key: key);

//   @override
//   _SpaceTankListState createState() => _SpaceTankListState();
// }

// var ch8t = NumberFormat.simpleCurrency(name: 'NGN');
// var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
// var now = DateTime.now();
// var formatter = DateFormat('yyyy-MM-dd');
// String formattedDate = formatter.format(now);
// var changeOne = "".obs();
// String savedAmount = "0";
// String fundingId = "";
// String fundDate = "";

// class _SpaceTankListState extends State<SpaceTankList> {
//   final TankController tankController = Get.find();

//   @override
//   initState() {
//     super.initState();
//     setState(() {
//       savedAmount = '0';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
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
//       body: Obx(
//         () => Container(
//           height: double.infinity,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("assets/icons/RentSpace-icon.png"),
//               fit: BoxFit.cover,
//               opacity: 0.1,
//             ),
//           ),
//           child: ListView.builder(
//               shrinkWrap: true,
//               physics: ClampingScrollPhysics(),
//               itemCount: tankController.tank.length,
//               itemBuilder: (context, int index) {
//                 return (tankController.tank.isNotEmpty)
//                     ? Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                             child: badge.Badge(
//                               badgeColor: Colors.red,
//                               badgeContent: InkWell(
//                                 onTap: () {
//                                   Get.to(SpaceTankLiquidate(index: index));
//                                 },
//                                 child: Icon(
//                                   Icons.eject_outlined,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               position: badge.BadgePosition.topEnd(),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: brandOne,
//                                 ),
//                                 padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       height: 2,
//                                     ),
//                                     GFListTile(
//                                       title: Text(
//                                         tankController.tank[index].planName +
//                                             changeOne,
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       avatar: Image.asset(
//                                         "assets/icons/savings/spacetank.png",
//                                         height: 25,
//                                         width: 25,
//                                       ),
//                                       subTitle: Padding(
//                                         padding:
//                                             EdgeInsets.fromLTRB(0, 5, 0, 5),
//                                         child: Text(
//                                           nairaFormaet.format(tankController
//                                                   .tank[index].targetAmount) +
//                                               " Fixed",
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             fontFamily: "DefaultFontFamily",
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                       padding:
//                                           EdgeInsets.fromLTRB(5, 10, 5, 10),
//                                     ),
//                                     Padding(
//                                       padding:
//                                           EdgeInsets.fromLTRB(10, 0, 10, 0),
//                                       child: GFAccordion(
//                                         expandedIcon: Container(
//                                           decoration: BoxDecoration(
//                                             color: brandThree,
//                                             borderRadius:
//                                                 BorderRadius.circular(20.0),
//                                           ),
//                                           padding: EdgeInsets.all(2),
//                                           child: Icon(
//                                             Icons.remove,
//                                             color: brandOne,
//                                           ),
//                                         ),
//                                         collapsedIcon: Container(
//                                           decoration: BoxDecoration(
//                                             color: brandThree,
//                                             borderRadius:
//                                                 BorderRadius.circular(20.0),
//                                           ),
//                                           padding: EdgeInsets.all(2),
//                                           child: Icon(
//                                             Icons.add,
//                                             color: brandOne,
//                                           ),
//                                         ),
//                                         title: "View details",
//                                         textStyle: TextStyle(
//                                           color: Colors.black,
//                                           fontFamily: "DefaultFontFamily",
//                                         ),
//                                         contentBackgroundColor: brandThree,
//                                         expandedTitleBackgroundColor:
//                                             brandThree,
//                                         collapsedTitleBackgroundColor:
//                                             brandThree,
//                                         onToggleCollapsed: (e) {},
//                                         contentChild: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'SpaceTank ID: ${tankController.tank[index].tankId}',
//                                               style: TextStyle(
//                                                 fontFamily: "DefaultFontFamily",
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 20,
//                                             ),
//                                             Text(
//                                               'Created: ${tankController.tank[index].date}',
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 20,
//                                             ),
//                                             Text(
//                                               'Duration: ${tankController.tank[index].duration} months',
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontFamily: "DefaultFontFamily",
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 20,
//                                             ),
//                                             Text(
//                                               'Upfront: ${nairaFormaet.format(double.parse(tankController.tank[index].upfront.toString()))}',
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontFamily: "DefaultFontFamily",
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 20,
//                                             ),
//                                             Text(
//                                               'Liquidation date: ${tankController.tank[index].endDate}',
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontFamily: "DefaultFontFamily",
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 20,
//                                             ),
//                                             Text(
//                                               'Amount: ${nairaFormaet.format(double.parse(tankController.tank[index].targetAmount.toString()))}',
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontFamily: "DefaultFontFamily",
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 20,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                         ],
//                       )
//                     : Center(
//                         child: Text(
//                           "Nothing to show here",
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontFamily: "DefaultFontFamily",
//                             color: Colors.red,
//                           ),
//                         ),
//                       );
//               }),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Get.to(SpaceTankSubscription());
//         },
//         child: Icon(
//           Icons.add_outlined,
//           size: 30,
//           color: Colors.white,
//         ),
//         backgroundColor: brandOne,
//       ),
//     );
//   }
// }
