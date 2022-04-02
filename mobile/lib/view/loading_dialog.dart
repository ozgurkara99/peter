import 'package:flutter/material.dart';
import 'package:peter/view/feed_page.dart';
import 'package:peter/view/image_upload.dart';

import 'login_view.dart';

void loadingDialog(BuildContext context, int time, String next) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: 100,
          height: 250,
          child: Column(
            children: [
              Image.asset(
                'assets/images/loading.gif',
                fit: BoxFit.fitWidth,
                repeat: ImageRepeat.noRepeat,
              ),
              //Text("Loading"),
            ],
          ),
        ),
      );
    },
  );
  Future.delayed(Duration(seconds: time), () {
    if (next == "none") {
      Navigator.pop(context);
    } else if (next == "login") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } //pop dialog
    else if (next == "feed") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => FeedPage()));
    }
  });
}
