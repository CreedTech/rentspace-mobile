import 'package:flutter/material.dart';
import 'dart:io';

import 'package:google_fonts/google_fonts.dart';

class InActivePage extends StatefulWidget {
  const InActivePage({Key? key}) : super(key: key);

  @override
  _InActivePageState createState() => _InActivePageState();
}

class _InActivePageState extends State<InActivePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: Container(
          padding: const EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Text(
              "RentSpace is temporarily under maintenance. We will be back shortly.😊",
              style: GoogleFonts.lato(
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
