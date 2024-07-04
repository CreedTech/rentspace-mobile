 import 'package:intl/intl.dart';

String calculateDifferenceInDays(String providedDateString) {
    // Extract the date components from the provided date string
    List<String> parts = providedDateString.split(' ');
    int day = int.parse(parts[2]);
    int year = int.parse(parts[3]);
    Map<String, int> months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12
    };
    int month = months[parts[1]]!;

    // Construct a DateTime object
    DateTime providedDate = DateTime.utc(year, month, day);

    // Get today's date
    DateTime today = DateTime.now();

    // Calculate the difference in days
    Duration difference = providedDate.difference(today);

    // Convert the difference to days
    int differenceInDays = difference.inDays.abs();

    return '$differenceInDays';
  }


  
  int calculateDaysDifference(String endDateString, String startDateString) {
    // Parse the provided date strings into DateTime objects
    DateFormat format = DateFormat('dd/MM/yyyy');
    DateTime startDate = format.parse(startDateString);
    DateTime endDate = format.parse(endDateString);

    // Calculate the difference in days
    Duration difference = endDate.difference(startDate);

    // Convert the difference to days
    int differenceInDays = difference.inDays.abs();

    return differenceInDays;
  }
