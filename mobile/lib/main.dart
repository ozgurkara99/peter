import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD
import 'package:mobile/image_upload.dart';
import 'firebase_options.dart';
import 'helpers/all_colors.dart';
=======
import 'package:peter/view/feed_page.dart';
import 'package:peter/view/onboarding_page.dart';
import 'firebase_options.dart';
import 'helpers/constants.dart';
>>>>>>> 9eac019d2b8717d7316329d5773318bbf6141728

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
<<<<<<< HEAD
      title: 'Peter',
      theme: ThemeData(
        primarySwatch: primaryTeal,
        primaryColor: primaryTeal[200],
        secondaryHeaderColor: Colors.amber,
      ),
      home: ImageUploads(),
=======
      debugShowCheckedModeBanner: false,
      title: 'Peter',
      theme: ThemeData(
        primarySwatch: primaryTeal,
        primaryColor: primaryTeal,
        secondaryHeaderColor: Colors.orange,
        hintColor: Colors.orange,
      ),
      home: OnboardingPage(),
>>>>>>> 9eac019d2b8717d7316329d5773318bbf6141728
    );
  }
}
