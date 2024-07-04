import 'package:intl/intl.dart';

String formatDateTime(String dateTimeString) {
  // Parse the date string into a DateTime object (assume input is in UTC)
  DateTime utcDateTime = DateTime.parse(dateTimeString);

  // Convert UTC time to local time (UTC+1)
  DateTime localDateTime = utcDateTime.add(const Duration(hours: 1));

  // Define the date format you want
  final DateFormat formatter = DateFormat('MMMM dd, yyyy hh:mm a');

  // Format the local DateTime object into a string
  String formattedDateTime = formatter.format(localDateTime);

  return formattedDateTime;
}




  String formatMongoDBDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    int day = date.day;
    String daySuffix;

    if (day >= 11 && day <= 13) {
      daySuffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          daySuffix = 'st';
          break;
        case 2:
          daySuffix = 'nd';
          break;
        case 3:
          daySuffix = 'rd';
          break;
        default:
          daySuffix = 'th';
      }
    }

    String month = DateFormat('MMMM').format(date);
    return '$day$daySuffix $month';
  }