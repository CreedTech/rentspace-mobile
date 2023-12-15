// import 'dart:async';

// import 'package:flutter/material.dart';

// class ButtonCountDown extends StatefulWidget {
//   final String buttonText;
//   final Color buttonColor;
//   final Color buttonTextColor;
//   fin
//   final VoidCallback onTap;

//   const ButtonCountDown({
//     Key? key,
//     required this.buttonText,
//     required this.buttonColor,
//     required this.onTap,
//     required this.buttonTextColor,
//   }) : super(key: key);

//   @override
//   State<ButtonCountDown> createState() => _ButtonCountDownState();
// }

// class _ButtonCountDownState extends State<ButtonCountDown> {
//   late int countdown;
//   late Timer timer;

//   void startCountdown() {
//     countdown = 5;
//     const duration = Duration(seconds: 1);

//     timer = Timer.periodic(duration, (timer) {
//       if (countdown > 0) {
//         setState(() {
//           countdown--;
//         });
//       } else {
//         timer.cancel();
//         // Perform the navigation or any other action when the countdown is complete
//         Navigator.pushNamed(context, RouteList.login);
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     startCountdown();
//   }

//   @override
//   void dispose() {
//     timer.cancel(); // Cancel the timer to avoid memory leaks
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       child: ClipPath(
//         clipper: CountDownCustomClip(),
//         child: Container(
//           height: 70.h,
//           width: MediaQuery.of(context).size.width * 0.8,
//           color: widget.buttonColor,
//           alignment: Alignment.center,
//           child: Text(
//             '${widget.buttonText} $countdown s',
//             style: GoogleFonts.nunito(
//               color: widget.buttonTextColor,
//               fontWeight: FontWeight.w700,
//               fontSize: 21.sp,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
