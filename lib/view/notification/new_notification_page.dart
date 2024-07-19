import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:rentspace/constants/colors.dart';

class NewNotificationPage extends StatefulWidget {
  const NewNotificationPage({Key? key, this.message}) : super(key: key);
  final String? message;

  @override
  _NewNotificationPageState createState() => _NewNotificationPageState();
}

class _NewNotificationPageState extends State<NewNotificationPage> {
  Map<String, dynamic>? parsedMessage;

  @override
  void initState() {
    super.initState();
    parseMessage();
  }

  void parseMessage() {
    if (widget.message != null) {
      // Remove curly braces from the string
      final cleanedMessage = widget.message!
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll(' ', '');

      // Split the string by comma to get key-value pairs
      List<String> keyValuePairs = cleanedMessage.split(',');
      // Remove curly braces and spaces from the string
      // final cleanedString = widget.message!
      //     .replaceAll('{', '')
      //     .replaceAll('}', '')
      //     .replaceAll(' ', '');

      // Split the string by commas to get key-value pairs
      // final keyValuePairs = cleanedString.split(',');

      // Parse each key-value pair
      // final Map<String, dynamic> parsedMap = {};
      // for (final pair in keyValuePairs) {
      //   final keyValue = pair.split(':');
      //   if (keyValue.length == 2) {
      //     final key = keyValue[0];
      //     final value = keyValue[1];
      //     parsedMap[key] = value;
      //   }
      // }

      // Create a map to store the values
      Map<String, dynamic> messageMap = {};

      // Iterate over the key-value pairs and add them to the map
      for (String pair in keyValuePairs) {
        List<String> keyValue = pair.trim().split(':');
        String key = keyValue[0].trim();
        String value = keyValue[1].trim();
        // Remove leading and trailing quotes if they exist
        if (value.startsWith('"') && value.endsWith('"')) {
          value = value.substring(1, value.length - 1);
        }
        messageMap[key] = value;
      }

      setState(() {
        parsedMessage = messageMap;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: brandOne,
          ),
        ),
      ),
      body: Center(
        child: parsedMessage != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Amount: ${parsedMessage!['amount']}'),
                  Text('Name: ${parsedMessage!['name']}'),
                  Text(
                      'notificationType: ${parsedMessage!['notificationType']}'),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
