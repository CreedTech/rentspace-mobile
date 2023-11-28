import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';

class AllActivities extends StatefulWidget {
  List activities;
  int activitiesLength;
  AllActivities({
    Key? key,
    required this.activities,
    required this.activitiesLength,
  }) : super(key: key);

  @override
  _AllActivitiesState createState() => _AllActivitiesState();
}

class _AllActivitiesState extends State<AllActivities> {
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
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 10),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: widget.activities.length,
          itemBuilder: (BuildContext context, int index) {
            return (widget.activities.isNotEmpty)
                ? Container(
                    color: Theme.of(context).canvasColor,
                    padding: const EdgeInsets.fromLTRB(10.0, 10, 10.0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icons/iconset/Group462.png',
                          height: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.activities[index],
                          style: TextStyle(
                            fontFamily: "DefaultFontFamily",
                            fontSize: MediaQuery.of(context).size.height / 60,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10, 10.0, 0),
                    child: Text(
                      "Nothing to show here",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "DefaultFontFamily",
                        color: Colors.red,
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
