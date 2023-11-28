import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/controller/utility_controller.dart';
import 'package:intl/intl.dart';

class UtilitiesHistory extends StatefulWidget {
  const UtilitiesHistory({Key? key}) : super(key: key);

  @override
  _UtilitiesHistoryState createState() => _UtilitiesHistoryState();
}

var nairaFormaet = NumberFormat.simpleCurrency(name: 'NGN');

class _UtilitiesHistoryState extends State<UtilitiesHistory> {
  final UtilityController utilityController = Get.find();

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
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/icons/RentSpace-icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction history',
                      style: TextStyle(
                        fontFamily: "DefaultFontFamily",
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: utilityController.utility.length,
                itemBuilder: (BuildContext context, int index) {
                  if (utilityController.utility.isEmpty) {
                    return Center(
                      child: Text(
                        "Nothing to show here",
                        style: TextStyle(
                          fontSize: 20,
                          color: brandOne,
                          fontFamily: "DefaultFontFamily",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10),
                      child: ListTile(
                        leading: Icon(
                          Icons.shopping_cart_checkout_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          "${utilityController.utility[index].biller} ${nairaFormaet.format(double.parse(utilityController.utility[index].amount.toString()))}",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "DefaultFontFamily",
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        subtitle: Text(
                          "${utilityController.utility[index].description} ${utilityController.utility[index].transactionId}",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "DefaultFontFamily",
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        trailing: Text(
                          utilityController.utility[index].date,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "DefaultFontFamily",
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
