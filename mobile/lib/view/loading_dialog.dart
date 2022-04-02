import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:peter/view/feed_page.dart';
import 'package:peter/view/image_upload.dart';

import '../firebase/firebase_firestore.dart';
import 'card_generator.dart';
import 'login_view.dart';

Future<dynamic> read_data() async {
  var petList = await getData();
  return list_generator(petList);
}

var cardList;

Future<void> loadingDialog(BuildContext context, int time, String next) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    //  barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: 150,
          height: 250,
          child: Column(
            children: [
              Image.asset(
                'assets/images/loading_transparent.gif',
                fit: BoxFit.fitWidth,
                repeat: ImageRepeat.noRepeat,
              ),
            ],
          ),
        ),
      );
    },
  );

  if (next == "pre-feed") {
    cardList = await read_data();
    log("test-feed");
    Future.delayed(Duration(seconds: time), () {
      log(cardList.toString());
    });
  }

  Future.delayed(Duration(seconds: time), () {
    if (next == "none") {
      Navigator.pop(context);
    } else if (next == "login") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } //pop dialog
    else if (next == "feed") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FeedPage(
                    cardListAll: cardList,
                  )));
    } else if (next == "pre-feed") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FeedPage(
                    cardListAll: cardList,
                  )));
    }
  });
}
