import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class BankTransfer extends StatefulWidget {
  String userId;
  BankTransfer({Key? key, required this.userId}) : super(key: key);

  @override
  _BankTransferState createState() => _BankTransferState();
}

class _BankTransferState extends State<BankTransfer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            snap: false,
            stretch: true,
            iconTheme: IconThemeData(color: Colors.white),
            expandedHeight: MediaQuery.of(context).size.height / 2.5,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: brandOne,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/icons/logo.png',
                      height: 80,
                    ),
                    Text(
                      "Bank transfer",
                      style: TextStyle(
                        fontSize: 40.0,
                        letterSpacing: 4.0,
                        color: brandTwo,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Transfer to the account details below. make sure to include you user ID in the description/narration. Note that it might take few minutes for your wallet to reflect the fund.",
                      style: TextStyle(
                        fontSize: 10.0,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 30,
                ),
                //bvn value
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: "RENTSPACE TECHNOLOGIES LTD"),
                          );
                          Fluttertoast.showToast(
                              msg: "copied to clipboard!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: brandTwo,
                              textColor: Colors.black,
                              fontSize: 16.0);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                "Account name:\nRENTSPACE TECHNOLOGIES LTDhthththththth",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.copy,
                                size: 14,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: "5401254162"),
                          );
                          Fluttertoast.showToast(
                              msg: "copied to clipboard!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: brandTwo,
                              textColor: Colors.black,
                              fontSize: 16.0);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Account number: 5401254162",
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.copy,
                                size: 14,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Bank name: PROVIDUS BANK",
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: "${widget.userId} + Space Wallet top-up",
                            ),
                          );
                          Fluttertoast.showToast(
                              msg: "copied to clipboard!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: brandTwo,
                              textColor: Colors.black,
                              fontSize: 16.0);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Naration/Description: Click to copy",
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.copy,
                                size: 14,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
