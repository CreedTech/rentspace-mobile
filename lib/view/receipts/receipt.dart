// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/colors.dart';

import '../../constants/bank_constants.dart';
import '../../constants/utils/formatDateTime.dart';
import '../../controller/auth/user_controller.dart';

import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class Receipt extends StatefulWidget {
  const Receipt({super.key, required this.type});
  final String type;

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  final GlobalKey _globalKey = GlobalKey();
  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 5.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      if (kDebugMode) {
        print('Error capturing image: $e');
      }
      return null;
    }
  }

  Future<void> _downloadImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 5.0);
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      if (kDebugMode) {
        print(result);
      }
    }
  }

  Future<void> _sharePdf() async {
    final pngBytes = await _capturePng();
    if (pngBytes != null) {
      final pdf = pw.Document();
      final imagePdf = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(imagePdf),
            );
          },
        ),
      );

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/receipt.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareFiles([file.path]);
    } else {
      if (kDebugMode) {
        print('Failed to capture image for PDF.');
      }
    }
  }

  Future<void> _shareImage() async {
    final pngBytes = await _capturePng();
    if (pngBytes != null) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/screenshot.png');
      await file.writeAsBytes(pngBytes);
    } else {
      if (kDebugMode) {
        print('Failed to capture image.');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    captureInfo();
  }

  Future<void> captureInfo() async {
    await Future.delayed(const Duration(seconds: 1));
    if (widget.type == 'share') {
      await _sharePdf();
    } else {
      _downloadImage();
    }
  }

  final UserController userController = Get.put(UserController());
  var currencyFormat = NumberFormat.simpleCurrency(name: 'NGN');
  String? bankName;
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    Map<String, dynamic>? transactionData;

    // Check if arguments are not null and of the correct type
    if (arguments != null && arguments is Map<String, dynamic>) {
      transactionData = arguments;
    }

    final bankCode = transactionData!['bankName'] ??
        ''; // Extract bank code from the response

// Check if the bank code exists in your bank data map
    if (BankConstants.bankData.containsKey(bankCode)) {
      // Bank details found, you can now use them
      bankName = BankConstants.bankData[bankCode];
      // print('Bank Name: $bankName');
    } else {
      // No matching bank found for the given code
      // print('No bank found for code: $bankCode');
    }

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),
      appBar: AppBar(),
      body: RepaintBoundary(
        key: _globalKey,
        child: SafeArea(
          child: Container(
            color: const Color(0xffF6F6F8),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 18, right: 18, top: 11, bottom: 30),
              child: ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.center,
                        image: AssetImage('assets/rentspace_bg.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/rentspace_receipt.png',
                              width: 81,
                              height: 23,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Amount',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: colorBlack,
                              ),
                            ),
                            Text(
                              currencyFormat.format(
                                (transactionData['amount']),
                              ),
                              style: GoogleFonts.roboto(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: brandOne,
                              ),
                            ),
                            Text(
                              formatDateTime(transactionData['createdAt']),
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: colorBlack,
                              ),
                            ),
                            const SizedBox(
                              height: 36,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        'Beneficiary Details',
                                        style: GoogleFonts.lato(
                                          color: const Color(0xff4B4B4B),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            (transactionData['transactionGroup']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    'bill')
                                                ? transactionData[
                                                        'userUtilityNumber'] ??
                                                    '00000000000'
                                                : '${transactionData['accountName'] ?? 'Rentspace'}'
                                                    .capitalize,
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: colorBlack,
                                            ),
                                          ),
                                          Text(
                                            (transactionData['transactionGroup']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    'bill')
                                                ? transactionData['biller'] ??
                                                    'Bill'
                                                : '(${bankName ?? transactionData['bankName'] ?? 'Payment'} | ${transactionData['accountNumber'] ?? 'Rent'} )'
                                                    .toString()
                                                    .toUpperCase(),
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: colorBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  child: Divider(
                                    thickness: 1,
                                    color: Color(0xffC9C9C9),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        'Sender Details',
                                        style: GoogleFonts.lato(
                                          color: const Color(0xff4B4B4B),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            (transactionData['transactionGroup']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    'bill')
                                                ? transactionData[
                                                        'userUtilityNumber'] ??
                                                    '00000000000'
                                                : '${transactionData['accountName'] ?? 'Rentspace'}'
                                                    .capitalize,
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: colorBlack,
                                            ),
                                          ),
                                          Text(
                                            (transactionData['transactionGroup']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    'bill')
                                                ? ''
                                                : '(${transactionData['paymentGateway'] ?? 'Rentspace'} | ${userController.userModel!.userDetails![0].dvaNumber})'
                                                    .capitalize!,
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: colorBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  child: Divider(
                                    thickness: 1,
                                    color: Color(0xffC9C9C9),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 11),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Text(
                                          'Fees',
                                          style: GoogleFonts.lato(
                                            color: const Color(0xff4B4B4B),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              currencyFormat.format(
                                                      double.parse(
                                                          transactionData[
                                                              'fees'])) ??
                                                  currencyFormat.format(0),
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.roboto(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: colorBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  child: Divider(
                                    thickness: 1,
                                    color: Color(0xffC9C9C9),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 11),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Text(
                                          'Transaction Reference',
                                          style: GoogleFonts.lato(
                                            color: const Color(0xff4B4B4B),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              transactionData[
                                                  'transactionReference'],
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: colorBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  child: Divider(
                                    thickness: 1,
                                    color: Color(0xffC9C9C9),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 11),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Text(
                                          'Transaction Type',
                                          style: GoogleFonts.lato(
                                            color: const Color(0xff4B4B4B),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${transactionData['transactionGroup'] ?? 'Rentspace'}'
                                                  .toString()
                                                  .capitalize!,
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: colorBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  child: Divider(
                                    thickness: 1,
                                    color: Color(0xffC9C9C9),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 11),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Text(
                                          'Payment Method',
                                          style: GoogleFonts.lato(
                                            color: const Color(0xff4B4B4B),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              (transactionData[
                                                              'transactionGroup']
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'bill')
                                                  ? 'Space Points'
                                                  : 'Space Wallet',
                                              textAlign: TextAlign.end,
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: colorBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  child: Divider(
                                    thickness: 1,
                                    color: Color(0xffC9C9C9),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 38,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Download the RentSpace app to save for your rent\nand access our loan services. \nEnjoy cashbacks for Airtime Purchases.\nBuild a strong saving habit.',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff4B4B4B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
