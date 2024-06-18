// import 'package:rentspace/constants/colors.dart';
// import 'package:rentspace/view/faqs.dart';
// import 'package:rentspace/view/login_page.dart';
// import 'package:rentspace/view/signup_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:getwidget/getwidget.dart';


// class SliderDone extends StatefulWidget {
//   const SliderDone({super.key});

//   @override
//   State<SliderDone> createState() => _SliderDoneState();
// }

// class _SliderDoneState extends State<SliderDone> {
//   @override
//   initState() {
//     super.initState();
//   }









//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/slider_done.jpg"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 80,
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Image.asset(
//                     'assets/icons/RentSpaceWhite.png',
//                     height: 80,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Get.to(const FaqsPage());
//                     },
//                     child: Image.asset(
//                       'assets/icons/faq.png',
//                       height: 30,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height / 20,
//             ),
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "A New Way To Save and get Loan",
//                     style: GoogleFonts.lato(
//                         fontSize: 30.0,
//                         fontFamily: "DefaultFontFamily",
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height / 2.5,
//             ),
//             GFButton(
//               onPressed: () {
//                 Get.to(const LoginPage());
//               },
//               color: brandTwo,
//               blockButton: true,
//               text: "Login to My Account",
//               icon: const Icon(
//                 Icons.login_outlined,
//                 color: Colors.orange,
//               ),
//             ),
//             GFButton(
//               onPressed: () {
//                 Get.to(const SignupPage());
//               },
//               color: brandOne,
//               blockButton: true,
//               text: "Become a RentSpace user",
//               icon: const Icon(
//                 Icons.person_outline_rounded,
//                 color: Colors.orange,
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height / 10,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
