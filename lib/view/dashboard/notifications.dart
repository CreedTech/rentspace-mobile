import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // final NotificationController notificationController = Get.find();
  @override
  Widget build(BuildContext context) {
    // print(notificationController.notification);
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            color: Theme.of(context).primaryColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 2.h,
        ),
        child: Stack(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 2),
            //   child: Consumer<NotificationService>(
            //       builder: (context, notificationService, _) {
            //     // print('notification');
            //     // NotificationService().fetchNotificationsFromFirestore();
            //     return ListView.builder(
            //         itemCount: notificationService.notifications.length,
            //         itemBuilder: (context, index) {
            //           final notifications =
            //               notificationService.notifications[index];
            //           // print(notifications);
            //           final formattedTime =
            //               _formatTime(notifications.timestamp);
            //           return Padding(
            //             padding: const EdgeInsets.symmetric(vertical: 5),
            //             child: ListTile(
            //               minLeadingWidth: 0,
            //               contentPadding: EdgeInsets.zero,
            //               leading: Stack(
            //                 children: [
            //                   Container(
            //                     // width: 48,
            //                     // height: 48,
            //                     padding: EdgeInsets.all(15.sp),
            //                     decoration: const BoxDecoration(
            //                       color: brandThree,
            //                       borderRadius: BorderRadius.all(
            //                         Radius.circular(50),
            //                       ),
            //                     ),
            //                     child: Image.asset(
            //                       'assets/icons/notification-box.png',
            //                       color: brandOne,
            //                       // width: 24.w,
            //                       // scale: 4,
            //                     ),
            //                   ),
            //                   !notifications.isRead
            //                       ? Positioned(
            //                           right: 5,
            //                           child: Container(
            //                             width: 8,
            //                             height: 8,
            //                             decoration: const BoxDecoration(
            //                               color: Colors.red,
            //                               borderRadius: BorderRadius.all(
            //                                 Radius.circular(50),
            //                               ),
            //                             ),
            //                           ),
            //                         )
            //                       : const SizedBox(),
            //                 ],
            //               ),
            //               title: Text(
            //                 notifications.title,
            //                 style: GoogleFonts.poppins(
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //               subtitle: Text(
            //                 notifications.message,
            //                 style: GoogleFonts.poppins(
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w400,
            //                 ),
            //               ),
            //               trailing: Text(formattedTime),
            //             ),
            //           );
            //         });
            //   }),
            // ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }
}
