import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:rentspace/constants/colors.dart';
import 'package:rentspace/controller/user_controller.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({Key? key}) : super(key: key);

  @override
  _ChatMainState createState() => _ChatMainState();
}

const _chars = '1234567890';
Random _rnd = Random();
var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
String responseBody = "";

class _ChatMainState extends State<ChatMain> {
  final TextEditingController _textController = TextEditingController();
  final CollectionReference messages =
      FirebaseFirestore.instance.collection('chat');
  final UserController userController = Get.find();

  String getRandom(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  @override
  initState() {
    super.initState();
    setState(() {
      responseBody = "";
    });
    _textController.clear();
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
          'How can we help?',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
            fontFamily: "DefaultFontFamily",
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
          Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder(
                  stream: messages
                      .orderBy('timestamp', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        reverse: false,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ((snapshot.data!.docs[index]['user_id'] ==
                                  userController.user[0].id))
                              ? ((snapshot.data!.docs[index]['type'] == "user"))
                                  ? BubbleSpecialThree(
                                      text: snapshot.data!.docs[index]['body'],
                                      color: brandTwo,
                                      tail: true,
                                      isSender: true,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "DefaultFontFamily",
                                        fontSize: 16,
                                      ),
                                    )
                                  : BubbleSpecialThree(
                                      text: snapshot.data!.docs[index]['body'],
                                      color: customColorTwo,
                                      tail: true,
                                      isSender: false,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: "DefaultFontFamily",
                                      ),
                                    )
                              : SizedBox();
                        },
                      ),
                    );
                  },
                ),
              ),
              Divider(height: 1.0),
              _buildTextComposer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              //onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: "Send a message",
                fillColor: Theme.of(context).canvasColor,
                hintStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: "DefaultFontFamily",
                ),
              ),
              style: TextStyle(
                fontFamily: "DefaultFontFamily",
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: brandTwo,
              ),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  sendResponse() async {
    try {
      await messages.add(
        {
          'body': responseBody.trim(),
          'date': formattedDate,
          'id': getRandom(12),
          'type': 'admin',
          'timestamp': FieldValue.serverTimestamp(),
          'user_id': userController.user[0].id,
        },
      );
      setState(() {
        responseBody = "";
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to send message. Please try again.')));
      setState(() {
        responseBody = "";
      });
    }
    setState(() {
      responseBody = "";
    });
  }

  getResponse(String message) {
    Map<String, String> responses = {
      "good": "Hello, how can I help you today?",
      "hi": "Hi, what can I do for you?",
    };
    for (var entry in responses.entries) {
      if (message.contains(entry.key)) {
        setState(() {
          responseBody = entry.value;
        });
      } else {
        setState(() {
          responseBody = "Thank you for your message.";
        });
      }
    }
    sendResponse();
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;
    _textController.clear();

    try {
      await messages.add(
        {
          'body': text.trim(),
          'date': formattedDate,
          'id': getRandom(12),
          'type': 'user',
          'timestamp': FieldValue.serverTimestamp(),
          'user_id': userController.user[0].id,
        },
      ).then((value) {
        Future.delayed(Duration(seconds: 3), () {
          getResponse(text.trim());
        });
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to send message. Please try again.')));
    }
  }
}
