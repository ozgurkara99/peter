import 'dart:developer';

import 'package:flutter/material.dart';

import '../helpers/all_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.teal.shade700, Colors.teal.shade200],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter)),
        child: Column(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                height: 100,
                child: Image.asset('assets/images/logo.png')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Pet",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "er",
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16.0),
                prefixIcon: Container(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                            bottomRight: Radius.circular(10.0))),
                    child: const Icon(
                      Icons.person,
                      color: primaryTeal,
                    )),
                hintText: "enter your email",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16.0),
                prefixIcon: Container(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                            bottomRight: Radius.circular(10.0))),
                    child: const Icon(
                      Icons.lock,
                      color: primaryTeal,
                    )),
                hintText: "enter your password",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                color: Colors.white,
                textColor: primaryTeal,
                padding: const EdgeInsets.all(20.0),
                child: Text("Login".toUpperCase()),
                onPressed: () {
                  if (passwordController.text == "arda") {}
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  textColor: Colors.white70,
                  child: Text("Create Account".toUpperCase()),
                  onPressed: () {},
                ),
                Container(
                  color: Colors.white54,
                  width: 2.0,
                  height: 20.0,
                ),
                MaterialButton(
                  textColor: Colors.white70,
                  child: Text("Forgot Password".toUpperCase()),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
