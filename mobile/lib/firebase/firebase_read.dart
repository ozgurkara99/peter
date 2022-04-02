import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

Future<void> readData() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("users");

// Get the data once
  DatabaseEvent event = await ref.once();

// Print the data of the snapshot
  log(event.snapshot.value.toString()); // { "name": "John" }
}
