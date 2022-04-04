import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:peter/view/navbar_view.dart';
import 'package:peter/view/onboarding_page.dart';
import 'firebase_options.dart';
import 'helpers/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(PeterApp());
}

class PeterApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peter',
      theme: ThemeData(
        primarySwatch: primaryTeal,
        primaryColor: primaryTeal,
        secondaryHeaderColor: Colors.orange,
        hintColor: Colors.orange,
      ),
      home: OnboardingPage(),
    );
  }
}
