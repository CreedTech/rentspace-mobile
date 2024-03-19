// import 'dart:async';
// import 'package:flutter/material.dart';

// class SessionHandler extends StatefulWidget {
//   final Widget child;
  
//   SessionHandler({required this.child});

//   @override
//   _SessionHandlerState createState() => _SessionHandlerState();
// }

// class _SessionHandlerState extends State<SessionHandler> {
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startSession();
//     _startSessionTimer();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   void _startSession() {
//     // Start session logic here (e.g., record session start time)
//     // SessionManager.startSession();
//   }

//   void _startSessionTimer() {
//     const sessionCheckInterval = Duration(minutes: 1); // Check session status every minute
//     _timer = Timer.periodic(sessionCheckInterval, (timer) async {
//       final isExpired = await SessionManager.isSessionExpired();
//       if (isExpired) {
//         // Handle session expiry (e.g., log out user or prompt for re-login)
//         _handleSessionExpired();
//       }
//     });
//   }

//   void _handleSessionExpired() {
//     // Perform actions for session expiry (e.g., log out user or prompt for re-login)
//     // For example, show a dialog to the user or navigate to the login screen
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Session Expired'),
//         content: Text('Your session has expired. Please log in again.'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Navigate to login screen or perform logout
//               // Navigator.of(context).pushReplacementNamed('/login');
//             },
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }
