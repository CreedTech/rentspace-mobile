// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:math';
// import 'package:intl/intl.dart';
// import 'package:rentspace/constants/colors.dart';
// import 'package:rentspace/controller/user_controller.dart';
// import 'package:chat_bubbles/chat_bubbles.dart';

// import '../../constants/widgets/custom_dialog.dart';
// import '../../constants/widgets/custom_loader.dart';

// class ChatMain extends StatefulWidget {
//   const ChatMain({Key? key}) : super(key: key);

//   @override
//   _ChatMainState createState() => _ChatMainState();
// }

// int id = 0;
// const _chars = '1234567890';
// Random _rnd = Random();
// var now = DateTime.now();
// var formatter = DateFormat('yyyy-MM-dd');
// String formattedDate = formatter.format(now);
// String responseBody = "";
// var dum1 = "".obs;
// String previousAnnouncementText = '';
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// class _ChatMainState extends State<ChatMain> {
//   final TextEditingController _textController = TextEditingController();
//   final CollectionReference messages =
//       FirebaseFirestore.instance.collection('chat');
//   final UserController userController = Get.find();
//   final ScrollController _scrollController = ScrollController();

//   Future<void> _showChatNotification(String title, String body) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'chat_channel_id',
//       'Chat Notifications',
//       channelDescription: 'Notifications for chats',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       id++,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }

//   String getRandom(int length) => String.fromCharCodes(
//         Iterable.generate(
//           length,
//           (_) => _chars.codeUnitAt(
//             _rnd.nextInt(_chars.length),
//           ),
//         ),
//       );

//   @override
//   initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//     setState(() {
//       responseBody = "";
//     });
//     _textController.clear();
//   }

//   void _scrollListener() {
//     // if (_scrollController.offset >=
//     //         _scrollController.position.maxScrollExtent &&
//     //     !_scrollController.position.outOfRange) {
//     //   // User has scrolled to the bottom, do nothing
//     // } else {
//     //   // Scroll to the bottom when a new message is added
//     //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//     // }
//     // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
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
//           'How can we help?',
//           style: GoogleFonts.lato(
//             color: Theme.of(context).primaryColor,
//             fontSize: 16,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream:
//                   messages.orderBy('timestamp', descending: false).snapshots(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CustomLoader(),
//                   );
//                 }
//                 return ListView.separated(
//                   controller: _scrollController,
//                   physics: const BouncingScrollPhysics(),
//                   separatorBuilder: (context, index) {
//                     return const SizedBox(
//                         // height: 10,
//                         );
//                   },
//                   reverse: false,
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return ((snapshot.data!.docs[index]['user_id'] ==
//                             userController.user[0].id))
//                         ? (snapshot.data!.docs[index]['type'] == "user")
//                             ? _buildMessageRow(context, snapshot, index)
//                             : _buildAdminMessageRow(context, snapshot, index)
//                         : const SizedBox();
//                   },
//                 );
//               },
//             ),
//           ),
//           _buildTextComposer(),
//         ],
//       ),
//     );
//   }

//   Row _buildAdminMessageRow(BuildContext context,
//       AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(
//           width: 20,
//         ),
//         const CircleAvatar(
//           backgroundImage: AssetImage(
//             'assets/icons/RentSpace-icon2.png',
//           ),
//           backgroundColor: brandOne,
//           radius: 15,
//           // child: Image.asset('assets/icons/RentSpace-icon2.png'),
//         ),
//         const SizedBox(
//           width: 5,
//         ),
//         Container(
//           padding: const EdgeInsets.only(
//             top: 5,
//             bottom: 5,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 constraints: BoxConstraints(
//                   maxHeight: 250,
//                   minHeight: 40,
//                   minWidth: MediaQuery.of(context).size.width * 0.1,
//                   maxWidth: MediaQuery.of(context).size.width * 0.7,
//                 ),
//                 decoration: const BoxDecoration(
//                   color: brandOne,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     bottomRight: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     left: 15,
//                     top: 10,
//                     bottom: 5,
//                     right: 5,
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(right: 10),
//                         child: Text(
//                           snapshot.data!.docs[index]['body'],
//                           style: GoogleFonts.lato(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const Icon(
//                         Icons.done_all,
//                         color: Colors.white,
//                         size: 14,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 2,
//               ),
//               Text(
//                 snapshot.data!.docs[index]['timestamp'] != null
//                     ? DateFormat.jm().format(
//                         snapshot.data!.docs[index]['timestamp'].toDate())
//                     : '',
//                 style: GoogleFonts.lato(
//                   fontSize: 12,
//                   color: Colors.black.withOpacity(0.5),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           width: 30,
//         ),
//       ],
//     );
//   }

//   Row _buildMessageRow(BuildContext context,
//       AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         const SizedBox(
//           width: 30,
//         ),
//         Container(
//           padding: const EdgeInsets.only(
//             top: 5,
//             bottom: 5,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Container(
//                 constraints: BoxConstraints(
//                   minHeight: 40,
//                   maxHeight: 250,
//                   maxWidth: MediaQuery.of(context).size.width * 0.7,
//                   minWidth: MediaQuery.of(context).size.width * 0.1,
//                 ),
//                 decoration: const BoxDecoration(
//                   color: brandTwo,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     bottomLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     left: 15,
//                     top: 10,
//                     bottom: 5,
//                     right: 5,
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(right: 10),
//                         child: Text(
//                           snapshot.data!.docs[index]['body'],
//                           style: GoogleFonts.lato(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const Icon(
//                         Icons.done_all,
//                         color: Colors.white,
//                         size: 14,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 2,
//               ),
//               Text(
//                 snapshot.data!.docs[index]['timestamp'] != null
//                     ? DateFormat.jm().format(
//                         snapshot.data!.docs[index]['timestamp'].toDate())
//                     : '',
//                 style: GoogleFonts.lato(
//                   fontSize: 12,
//                   color: Colors.black.withOpacity(0.5),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           width: 5,
//         ),
//         CircleAvatar(
//           backgroundImage: NetworkImage(userController.user[0].image),
//           radius: 10,
//         ),
//         const SizedBox(
//           width: 20,
//         ),
//       ],
//     );
//   }

//   Widget _buildTextComposer() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       decoration: BoxDecoration(
//         // color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       padding: const EdgeInsets.symmetric(
//         vertical: 8,
//         horizontal: 20,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               cursorColor: Theme.of(context).primaryColor,
//               textInputAction: TextInputAction.send,
//               controller: _textController,
//               decoration: InputDecoration(
//                 contentPadding:
//                     const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: const BorderSide(color: brandOne, width: 2.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: const BorderSide(color: brandOne, width: 2.0),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: const BorderSide(
//                     color: Color(0xffE0E0E0),
//                   ),
//                 ),
//                 hintText: "Send a message",
//               ),
//               onEditingComplete: () => _handleSubmitted(_textController.text),
//             ),
//           ),
//           IconButton(
//             onPressed: () => _handleSubmitted(_textController.text),
//             icon: const Icon(Icons.send),
//           ),
//         ],
//       ),
//     );
//   }

//   sendResponse() async {
//     try {
//       await messages.add(
//         {
//           'body': responseBody.trim(),
//           'date': formattedDate,
//           'id': getRandom(12),
//           'type': 'admin',
//           'timestamp': FieldValue.serverTimestamp(),
//           'user_id': userController.user[0].id,
//         },
//       );
//       setState(() {
//         responseBody = "";
//       });
//     } catch (error) {
//       if (context.mounted) {
//         customErrorDialog(
//             context, 'Oops (:', "Failed to send message. Please try again.");
//       }
//       // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       //     content: Text('Failed to send message. Please try again.')));
//       setState(() {
//         responseBody = "";
//       });
//     }
//     setState(() {
//       responseBody = "";
//     });
//   }

//   getResponse(String message) {
//     Map<String, String> responses = {
//       "good": "Hello, how can I help you today?",
//       "hi": "Hi, what can I do for you?",
//     };
//     for (var entry in responses.entries) {
//       if (message.contains(entry.key)) {
//         setState(() {
//           responseBody = entry.value;
//         });
//       } else {
//         setState(() {
//           responseBody = "Thank you for your message.";
//         });
//       }
//     }
//     if (responseBody != previousAnnouncementText) {
//       _showChatNotification('Rentty', responseBody);

//       // Update the previous announcement text
//       previousAnnouncementText = responseBody;
//     }
//     sendResponse();
//   }

//   void _handleSubmitted(String text) async {
//     if (text.trim().isEmpty) return;
//     _textController.clear();

//     try {
//       await messages.add(
//         {
//           'body': text.trim(),
//           'date': formattedDate,
//           'id': getRandom(12),
//           'type': 'user',
//           'timestamp': FieldValue.serverTimestamp(),
//           'user_id': userController.user[0].id,
//         },
//       ).then((value) {
//         Future.delayed(const Duration(seconds: 3), () {
//           getResponse(text.trim());
//         });
//       });
//     } catch (error) {
//       if (context.mounted) {
//         customErrorDialog(
//             context, 'Oops (:', "Failed to send message. Please try again.");
//       }
//       // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//       //     content: Text('Failed to send message. Please try again.')));
//     }
//   }
// }
