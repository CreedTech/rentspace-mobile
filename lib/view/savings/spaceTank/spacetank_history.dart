import 'package:flutter/material.dart';

class SpaceTankHistory extends StatefulWidget {
  const SpaceTankHistory({Key? key}) : super(key: key);

  @override
  _SpaceTankHistoryState createState() => _SpaceTankHistoryState();
}

class _SpaceTankHistoryState extends State<SpaceTankHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("History page"),
      ),
    );
  }
}
