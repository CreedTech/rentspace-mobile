import 'package:intl/intl.dart';

String formatEndDate(String dateTimeString) {
  // Parse the date string into a DateTime object
  DateTime dateTime =
      DateTime.parse(dateTimeString).add(const Duration(hours: 1));

  // Define the date format you want
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');

  // Format the DateTime object into a string
  String formattedDateTime = formatter.format(dateTime);

  return formattedDateTime;
}
