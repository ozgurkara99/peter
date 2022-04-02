import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:peter/view/image_upload.dart';
import 'package:peter/view/login_view.dart';
import 'package:peter/view/login_view.dart';
import 'package:peter/view/onboarding.dart';
import 'firebase_options.dart';
import 'helpers/all_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peter',
      theme: ThemeData(
        primarySwatch: primaryTeal,
        primaryColor: primaryTeal,
        secondaryHeaderColor: Colors.orange,
        hintColor: Colors.orange,
      ),
      home: OnboardingView(),
    );
  }
}
