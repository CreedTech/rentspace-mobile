import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class CopyWidget extends StatelessWidget {
  const CopyWidget({
    super.key, required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(
           ClipboardData(
            text: text,
          ),
        );
        Fluttertoast.showToast(
          msg: "Copied to clipboard!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          textColor: Theme.of(context).canvasColor,
          fontSize: 16.0,
        );
      },
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          Image.asset(
            'assets/icons/copy_icon.png',
            width: 24,
            height: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(
            width: 6,
          ),
          Text(
            'Copy',
            style: GoogleFonts.lato(
              color: brandTwo,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
