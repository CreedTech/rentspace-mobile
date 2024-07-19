import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class RatingbreakdownPage extends StatefulWidget {
  const RatingbreakdownPage({super.key});

  @override
  State<RatingbreakdownPage> createState() => _RatingbreakdownPageState();
}

class _RatingbreakdownPageState extends State<RatingbreakdownPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios_sharp,
                size: 27,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                width: 4.h,
              ),
              Text(
                'Rating Breakdown',
                style: GoogleFonts.lato(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0.h,
          horizontal: 24.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'These are our rating factors',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      'Convallis',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      'ornare. Donec consequat in enim ullamcorper. Mi eget sed bibendum suscipit purus commodo morbi semper. Sit gravida lacinia nunc dictum. Risus pharetra suscipit tincidunt habitant. Phasellus pulvinar egestas orci fusce sit risus egestas. Quis odio sit suspendisse morbi viverra et ',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      'Convallis',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      'ornare. Donec consequat in enim ullamcorper. Mi eget sed bibendum suscipit purus commodo morbi semper. Sit gravida lacinia nunc dictum. Risus pharetra suscipit tincidunt habitant. Phasellus pulvinar egestas orci fusce sit risus egestas. Quis odio sit suspendisse morbi viverra et ',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      'Convallis',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      'ornare. Donec consequat in enim ullamcorper. Mi eget sed bibendum suscipit purus commodo morbi semper. Sit gravida lacinia nunc dictum. Risus pharetra suscipit tincidunt habitant. Phasellus pulvinar egestas orci fusce sit risus egestas. Quis odio sit suspendisse morbi viverra et ',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      'Convallis',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      'ornare. Donec consequat in enim ullamcorper. Mi eget sed bibendum suscipit purus commodo morbi semper. Sit gravida lacinia nunc dictum. Risus pharetra suscipit tincidunt habitant. Phasellus pulvinar egestas orci fusce sit risus egestas. Quis odio sit suspendisse morbi viverra et ',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      'Convallis',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      'ornare. Donec consequat in enim ullamcorper. Mi eget sed bibendum suscipit purus commodo morbi semper. Sit gravida lacinia nunc dictum. Risus pharetra suscipit tincidunt habitant. Phasellus pulvinar egestas orci fusce sit risus egestas. Quis odio sit suspendisse morbi viverra et ',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width - 50, 50),
                    backgroundColor: brandTwo,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Send',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
