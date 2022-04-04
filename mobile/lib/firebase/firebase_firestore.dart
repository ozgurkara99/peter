import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<dynamic> getFinderFeedData() async {
  final db = FirebaseFirestore.instance;

  var petList = {};

  await db
      .collection('users')
      .doc('1JCfGKVqtcW3BReDEcb6')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    petList[documentSnapshot['name']] = documentSnapshot['pets'];
  });

  await db
      .collection('users')
      .doc('Ce4olt40MEiIBhymZgaq')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    petList[documentSnapshot['name']] = documentSnapshot['pets'];
  });

  await db
      .collection('users')
      .doc('CwxaFB8ajd7XMnqhTHbV')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    petList[documentSnapshot['name']] = documentSnapshot['pets'];
  });

  await db
      .collection('users')
      .doc('DmGnneGp5YOY42CqXBjE')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    petList[documentSnapshot['name']] = documentSnapshot['pets'];
  });

  await db
      .collection('users')
      .doc('ecU9rbJQ02s6zhX6w9MI')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    petList[documentSnapshot['name']] = documentSnapshot['pets'];
  });

  return petList;
}

Future<dynamic> getAdopterFeedData() async {
  final db = FirebaseFirestore.instance;

  var petList = {};

  await db
      .collection('users_adopter')
      .doc('jKzK5bugqdpmeeCxW5TF')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    petList[documentSnapshot['name']] = documentSnapshot['pets'];
  });

  await db
      .collection('users_adopter')
      .doc('knrIkfgvi1iDO9qoo6TJ')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    petList[documentSnapshot['name']] = documentSnapshot['pets'];
  });

  await db
      .collection('users_adopter')
      .doc('znDSJRIvGvM34HC9oNmE')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    petList[documentSnapshot['name']] = documentSnapshot['pets'];
  });

  return petList;
}
