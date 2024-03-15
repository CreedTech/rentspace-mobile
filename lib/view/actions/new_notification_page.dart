import 'package:flutter/material.dart';
import 'package:rentspace/constants/constants.dart';

class NewNotificationPage extends StatefulWidget {
  const NewNotificationPage({super.key, required this.message});
  final String message;

  @override
  State<NewNotificationPage> createState() => _NewNotificationPageState();
}

class _NewNotificationPageState extends State<NewNotificationPage> {
  // String message = "";

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final arguments = ModalRoute.of(context)!.settings.arguments;
  //   print('arguments');
  //   print(arguments);

  //   if (arguments != null) {
  //     Map? pushArguments = arguments as Map;

  //     setState(() {
  //       message = pushArguments["message"];
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
            child: Text(
          widget.message,
          style: TextStyle(color: Colors.black, fontSize: 100),
        )),
      ),
    );
  }
}
