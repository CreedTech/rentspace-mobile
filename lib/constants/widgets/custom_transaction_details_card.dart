import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/rent/rent_controller.dart';
import '../colors.dart';

class CustomTransactionDetailsCard extends StatefulWidget {
  final int current;
  const CustomTransactionDetailsCard({super.key, required this.current});

  @override
  State<CustomTransactionDetailsCard> createState() =>
      _CustomTransactionDetailsCardState();
}

class _CustomTransactionDetailsCardState
    extends State<CustomTransactionDetailsCard> {
  @override
  initState() {
    super.initState();
    if (kDebugMode) {
      print('rentController.rent[widget.current].hasPaid');
    }
    if (kDebugMode) {
      print(rentController.rentModel!.rents![widget.current].id);
    }
  }

  final RentController rentController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
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
        title: const Text(
          'Transaction Details',
          style: TextStyle(
            color: brandOne,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: const Column(
        children: [
          // Text(rentController.rent[widget.current].hasPaid),
        ],
      ),
    );
  }
}
