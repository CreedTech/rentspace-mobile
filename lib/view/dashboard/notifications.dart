import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rentspace/controller/notification_controller.dart';

import '../../constants/colors.dart';
import '../../model/notification_model.dart';
import '../../services/implementations/notification_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationController notificationController = Get.find();
  @override
  Widget build(BuildContext context) {
    print(notificationController.notification);
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
          style: GoogleFonts.nunito(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 32,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Consumer<NotificationService>(
                  builder: (context, notificationService, _) {
                print('notification');
                // NotificationService().fetchNotificationsFromFirestore();
                return ListView.builder(
                    itemCount: notificationService.notifications.length,
                    itemBuilder: (context, index) {
                      final notifications =
                          notificationService.notifications[index];
                      print(notifications);
                      final formattedTime =
                          _formatTime(notifications.timestamp);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          minLeadingWidth: 0,
                          contentPadding: EdgeInsets.zero,
                          leading: Stack(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: brandTwo,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/icons/RentSpace-icon2.png',
                                  color: notifications.isRead
                                      ? Colors.black
                                      : Colors.white,
                                  // width: 24.w,
                                  scale: 4,
                                ),
                              ),
                              !notifications.isRead
                                  ? Positioned(
                                      right: 5,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          title: Text(
                            notifications.title,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            notifications.message,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: Text(formattedTime),
                        ),
                      );
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }
}

// List<NotificationModel> deliveryNotifications = [
//   NotificationModel(
//     title: 'Order Shipped',
//     message:
//         'Tracking number BLQ65807654 has been generated for your order',
//     timestamp: DateTime.now().subtract(const Duration(hours: 2)).toString(),
//     isRead: true,
//   ),
//   NotificationModel(
//     title: 'Delivery Update',
//     message: 'Your package is out for delivery.',
//     timestamp: DateTime.now().subtract(const Duration(minutes: 45)).toString(),
//     isRead: false,
//   ),
//   NotificationModel(
//     title: 'Delivery Successful',
//     message: 'Your order has been successfully delivered.',
//     timestamp: DateTime.now().subtract(const Duration(minutes: 20)).toString(),
//     isRead: false,
//   ),
//   NotificationModel(
//     title: 'Delivery Successful',
//     message: 'Your order has been successfully delivered.',
//     timestamp: DateTime.now().subtract(const Duration(minutes: 20)).toDate(),
//     isRead: false,
//   ),
//   NotificationModel(
//     title: 'Delivery Successful',
//     message: 'Your order has been successfully delivered.',
//     timestamp: DateTime.now().subtract(const Duration(minutes: 20)).toString(),
//     isRead: false,
//   ),
//   // Add more notifications as needed
// ];
