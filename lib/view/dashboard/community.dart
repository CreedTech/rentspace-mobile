import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RentSpaceCommunity extends StatefulWidget {
  const RentSpaceCommunity({Key? key}) : super(key: key);

  @override
  _RentSpaceCommunityState createState() => _RentSpaceCommunityState();
}

class _RentSpaceCommunityState extends State<RentSpaceCommunity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.close,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Text(
            "We are building the community!\nBuild with us by referring others!",
            style: GoogleFonts.lato(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          /* Image.asset(
            "assets/giphy.gif",
          ) */
        ],
      ),
    );
  }
}
