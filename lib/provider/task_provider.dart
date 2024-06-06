import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:rentspace/view/dashboard/personal_details.dart';
import 'package:rentspace/view/dashboard/withdraw_page.dart';

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Map<String, dynamic>>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  TaskNotifier()
      : super([
          {
            'label': 'Add your profile picture',
            'subTitle': 'Complete your profile by adding a profile picture',
            'completed': false,
            'image': 'assets/face.png',
            'page': '/personalInfo'
          },
          {
            'label': 'Set up your withdrawal account',
            'subTitle': 'Save an account to withdraw your funds',
            'completed': false,
            'image': 'assets/bank_tilt.png',
            'page': '/withdrawal'
          },
        ]);

  void completeTask(String label) {
    state = state.where((task) => task['label'] != label).toList();
  }
}
