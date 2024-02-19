import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../controller/activities_controller.dart';

class AllActivities extends StatefulWidget {
  // List activities;
  // int activitiesLength;
  AllActivities({
    super.key,
    // required this.activitiesModel!.activities!,
    // required this.activitiesModel!.activities!Length,
  });

  @override
  _AllActivitiesState createState() => _AllActivitiesState();
}

class _AllActivitiesState extends State<AllActivities> {
  final ActivitiesController activitiesController = Get.find();
  @override
  initState() {
    super.initState();
  }

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
        centerTitle: true,
        title: Text(
          'Activities',
          style: GoogleFonts.nunito(
            color: brandOne,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: activitiesController.activitiesModel!.activities!.length,
          itemBuilder: (BuildContext context, int index) {
            return (activitiesController.activitiesModel!.activities!.isNotEmpty)
                ? Container(
                    color: Theme.of(context).canvasColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icons/iconset/Group462.png',
                          height: 48,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Text(
                            activitiesController.activitiesModel!.activities![index].description,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunito(
                              // fontFamily: "DefaultFontFamily",
                              fontSize: MediaQuery.of(context).size.height / 60,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10, 10.0, 0),
                    child: Text(
                      "Nothing to show here",
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        // fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
