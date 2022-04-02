import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/image_upload.dart';
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
        primaryColor: primaryTeal[200],
        secondaryHeaderColor: Colors.amber,
      ),
      home: ImageUploads(),
    );
  }
}
