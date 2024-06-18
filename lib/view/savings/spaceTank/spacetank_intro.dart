// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:rentspace/constants/colors.dart';
// import 'package:rentspace/view/savings/spaceTank/spacetank_subscription.dart';

// class SpaceTankIntro extends StatefulWidget {
//   const SpaceTankIntro({Key? key}) : super(key: key);

//   @override
//   _SpaceTankIntroState createState() => _SpaceTankIntroState();
// }

// class _SpaceTankIntroState extends State<SpaceTankIntro> {
//   @override
//   initState() {
//     super.initState();
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
//             Icons.arrow_back,
//             size: 30,
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//         title: Text(
//           'Create Savings Plans',
//           style: GoogleFonts.lato(
//             color: Theme.of(context).primaryColor,
//             fontSize: 16,
//             fontFamily: "DefaultFontFamily",
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(
//               "assets/icons/savings/spacetank.png",
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               "SpaceTank",
//               style: GoogleFonts.lato(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 0.5,
//                 fontFamily: "DefaultFontFamily",
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Text(
//               "Save and get 12% upfront! Start today and receive an instant 12% boost to your wallet. Don’t wait, click now to kickstart your savings journey",
//               style: GoogleFonts.lato(
//                 fontSize: 14.0,
//                 letterSpacing: 0.5,
//                 fontFamily: "DefaultFontFamily",
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Image.asset(
//               "assets/icons/tank_intro.png",
//               width: MediaQuery.of(context).size.width,
//             ),
//             SizedBox(
//               height: 40,
//             ),
//             GFButton(
//               onPressed: () {
//                 Get.to(SpaceTankSubscription());
//               },
//               icon: Icon(
//                 Icons.add_circle_outline_outlined,
//                 size: 30,
//                 color: Colors.white,
//               ),
//               color: brandOne,
//               text: "Create new SpaceTank",
//               shape: GFButtonShape.square,
//               fullWidthButton: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
