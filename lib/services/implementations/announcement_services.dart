import 'package:flutter/material.dart';

import '../../model/announcement_model.dart';

class AnnouncementService extends ChangeNotifier {
  List<AnnouncementModel> _announcements = [];

  List<AnnouncementModel> get announcements => _announcements;

  bool get hasUnreadAnnouncements => _announcements.isNotEmpty;

  // Add a method to fetch notifications from Firestore
  Future<void> fetchNotificationsFromFirestore() async {
    print('fetching');
    try {
      // Update the _announcements list
      // _announcements = fetchedNotifications;

      // Notify listeners to update the UI
      notifyListeners();
    } catch (error) {
      print('Error fetching announcements: $error');
    }
  }
}
