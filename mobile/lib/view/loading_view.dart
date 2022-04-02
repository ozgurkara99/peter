import 'dart:async';
import 'package:flutter/material.dart';

import 'login_view.dart';

class LoadingDog extends StatefulWidget {
  final String next;

  LoadingDog({Key? key, required this.next}) : super(key: key);

  @override
  _LoadingDogState createState() => _LoadingDogState(next);
}

class _LoadingDogState extends State<LoadingDog> {
  String next;

  _LoadingDogState(this.next);

  getPage(next) {
    if (next == "login") {
      return LoginPage();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 1),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => getPage(next)),
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
