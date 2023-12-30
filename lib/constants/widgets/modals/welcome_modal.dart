import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentspace/constants/colors.dart';

void welcomeModal() {
  Get.defaultDialog(
    title: "Verify",
    content: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Image.asset(
        "assets/ava_intro.png",
        height: 100,
      ),
    ),
    actions: <Widget>[
      GFButton(
        onPressed: () {
          Get.back();
          //startshowCase();
        },
        shape: GFButtonShape.pills,
        text: "Let's go",
        icon: const Icon(
          Icons.arrow_right_outlined,
          color: brandOne,
          size: 14,
        ),
        color: Colors.white,
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
      ), // handle the press
    ],
    barrierDismissible: true,
  );
}



/*   void welcomeModal() {
  Get.defaultDialog(
    title: "What's new 🤗",
    content: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: customer,
            placeholder: (context, url) =>
                Image.asset('assets/placeholder.png'),
            errorWidget: (context, url, error) =>
                Image.asset('assets/placeholder.png'),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Did you know you can now become an house owner sooner than you could imagine?\n1. Fewsure alows you to save towards a goal at your own pace.\n2. Purchase high quality building materials from vetted vendors for your building projects.",
          ),
        ],
      ),
    ),
    actions: <Widget>[
      IconButton(
        icon: const Icon(
          Icons.close_outlined,
          color: Colors.grey,
          size: 40,
        ),
        onPressed: () {
          Get.back();
        }, // handle the press
      ),
    ],
    barrierDismissible: true,
  );
}
 */