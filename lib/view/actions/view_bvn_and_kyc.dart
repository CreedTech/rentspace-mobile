import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';

class ViewBvnAndKyc extends StatefulWidget {
  String idImage, bvn, kyc, hasVerifiedBvn, hasVerifiedKyc;
  ViewBvnAndKyc(
      {Key? key,
      required this.idImage,
      required this.bvn,
      required this.kyc,
      required this.hasVerifiedBvn,
      required this.hasVerifiedKyc})
      : super(key: key);

  @override
  _ViewBvnAndKycState createState() => _ViewBvnAndKycState();
}

class _ViewBvnAndKycState extends State<ViewBvnAndKyc> {
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
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          'Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
            fontSize: 16,
            fontFamily: "DefaultFontFamily",
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 100,
          ),
          //ID Cardvalue
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 5),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: brandOne, // Color of the border
                  width: 2.0, // Width of the border
                ),
                image: DecorationImage(
                  image: AssetImage('assets/icons/RentSpace-icon.png'),
                  fit: BoxFit.cover,
                ),
                //borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
              child: Image.network(
                widget.idImage,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
          ),
          //bvn value
          SizedBox(
            height: 10,
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: brandOne, // Color of the border
                  width: 2.0, // Width of the border
                ),
                image: DecorationImage(
                  image: AssetImage('assets/icons/RentSpace-icon.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(0),
              ),
              padding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
              child: SizedBox(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        gradientOne,
                        gradientTwo,
                      ],
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BVN: " + widget.bvn,
                        style: TextStyle(
                          fontSize: 15.0,
                          letterSpacing: 0.4,
                          height: 2,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DefaultFontFamily",
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.white,
                        height: 5.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "KYC: " + widget.kyc,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w100,
                          fontFamily: "DefaultFontFamily",
                          letterSpacing: 0.4,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
