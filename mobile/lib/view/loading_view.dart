import 'dart:async';
import 'package:flutter/material.dart';

import 'login_view.dart';

class LoadingDog extends StatefulWidget {
  @override
  _LoadingDogState createState() => new _LoadingDogState();
}

class _LoadingDogState extends State<LoadingDog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 1),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(children: <Widget>[
          const Divider(
            height: 240.0,
            color: Colors.white,
          ),
          Image.asset(
            'assets/images/loading.gif',
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
          ),

          const Divider(
            height: 105.2,
            color: Colors.white,
          ),
        ]),
      ),
    );
  }
}
