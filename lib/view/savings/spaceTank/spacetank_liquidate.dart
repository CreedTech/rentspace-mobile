// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:intl/intl.dart';
// import 'package:rentspace/controller/tank_controller.dart';
// import 'package:jiffy/jiffy.dart';

// class SpaceTankLiquidate extends StatefulWidget {
//   int index;
//   SpaceTankLiquidate({Key? key, required this.index}) : super(key: key);

//   @override
//   _SpaceTankLiquidateState createState() => _SpaceTankLiquidateState();
// }

// var ch8t = NumberFormat.simpleCurrency(name: 'NGN');
// var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');
// var now = DateTime.now();
// var formatter = DateFormat('yyyy-MM-dd');
// String formattedDate = formatter.format(now);

// class _SpaceTankLiquidateState extends State<SpaceTankLiquidate> {
//   final TankController tankController = Get.find();
//   @override
//   void initState() {
//     super.initState();
//     print(now);
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
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.1,
//               child: Image.asset(
//                 'assets/icons/RentSpace-icon.png',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
//               child: Text(
//                 "This SpaceTank is fixed for ${tankController.tank[widget.index].duration} months. Your liquidation date is ${tankController.tank[widget.index].endDate}. Your savings will be disbursed after this date.",
//                 style: TextStyle(
//                   fontSize: 25,
//                   fontFamily: "DefaultFontFamily",
//                   letterSpacing: 0.5,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
