import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:peter/view/navbar_view.dart';
import '../firebase/firebase_firestore.dart';
import 'card_generator.dart';
import 'login_view.dart';

Future<dynamic> readFinderFeedData() async {
  var petList = await getFinderFeedData();
  return finderListGenerator(petList);
}

Future<dynamic> readAdopterFeedData() async {
  var petList = await getAdopterFeedData();
  return adopterListGenerator(petList);
}

var cardListFinder;
var cardListAdopter;

Future<void> loadingDialog(BuildContext context, int time, String next) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: 150,
          height: 250,
          child: Column(
            children: [
              Image.asset(
                'assets/images/loading.gif',
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
    cardListFinder = await readFinderFeedData();
    cardListAdopter = await readAdopterFeedData();
    log("test-feed");
    Future.delayed(const Duration(seconds: 2), () {
      log(cardListFinder.toString());
      log(cardListAdopter.toString());
    });
  }

  Future.delayed(Duration(seconds: time), () {
    if (next == "none") {
      Navigator.pop(context);
    } else if (next == "login") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else if (next == "pre-feed") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NavbarFeed(
                    cardListFinder: cardListFinder,
                    cardListAdopter: cardListAdopter,
                    sim: false,
                  )));
    }
  });
}
