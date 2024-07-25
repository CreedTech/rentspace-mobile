import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            'page': '/personalDetails'
          },
          {
            'label': 'Set up your withdrawal account',
            'subTitle': 'Save an account to withdraw your funds',
            'completed': false,
            'image': 'assets/bank_tilt.png',
            'page': '/withdrawalPage'
          },
        ]);

  void completeTask(String label) {
    state = state.where((task) => task['label'] != label).toList();
  }
}
