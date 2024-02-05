import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessFulScreen extends StatefulWidget {
  const SuccessFulScreen({super.key, required this.email});
    final String email;

  @override
  State<SuccessFulScreen> createState() => _SuccessFulScreenState();
}

class _SuccessFulScreenState extends State<SuccessFulScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
        
    );
  }
}