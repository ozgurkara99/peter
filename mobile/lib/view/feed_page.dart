import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peter/helpers/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:peter/view/card_generator.dart';
import 'package:peter/view/loading_dialog.dart';
import '../firebase/firebase_firestore.dart';
import '../helpers/device_details.dart';
import '../helpers/get_date.dart';

class FeedPage extends StatefulWidget {
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  var petList = {};
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    read_data();
  }

  Future imgFromGallery(context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        showAlertDialog(context);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera(context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        showAlertDialog(context);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<dynamic> read_data() async {
    petList = await getData();
    loadingDialog(context, 2, 'none');
    list_generator(petList);
  }

  Future uploadFile() async {
    if (_photo == null) return;

    Map deviceDetails = await getDeviceDetails();

    // Get unique id of phone
    final id = deviceDetails['id'];
    // Get os of phone
    final os = deviceDetails['os'];
    // Get model of phone
    final model = deviceDetails['model'];
    // Get brand/name of phone
    final brand = deviceDetails['brand'];

    final date = getDateInString();

    final destination = '$os/$brand/$id';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(date);
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  void showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.pop(context);
        setState(() {
          _photo = null;
        });
      },
    );
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        uploadFile();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Warning!"),
      content: const Text("Would you like to search for this image?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery(context);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 180.0,
            backgroundColor: Colors.teal,
            leading: IconButton(
              icon: const Icon(
                FontAwesomeIcons.user,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            floating: true,
            flexibleSpace: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 80.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Search your Pet using",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0)),
                    Text(" Peter",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.camera,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          showPicker(context);
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.qrcode,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          showPicker(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10.0,
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCategories(),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return _buildRooms(context, index);
            }, childCount: 10),
          )
        ],
      ),
    );
  }

  Widget _buildRooms(BuildContext context, int index) {
    var room = rooms[index % rooms.length];
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.all(3.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.orange[300],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Image.network(
                            room['imageURL'],
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: Icon(
                              Icons.star,
                              color: Colors.grey.shade800,
                              size: 20.0,
                            ),
                          ),
                          const Positioned(
                            right: 8,
                            top: 8,
                            child: Icon(
                              Icons.star_border,
                              color: Colors.white,
                              size: 24.0,
                            ),
                          ),
                          Positioned(
                            bottom: 20.0,
                            right: 5.0,
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Text(
                                    room['date'],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  const Icon(
                                    FontAwesomeIcons.clock,
                                    size: 16,
                                    color: primaryTeal,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              room['title'],
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            const Text("Bouddha, Kathmandu"),
                            SizedBox(
                              height: 10.0,
                            ),
                            if (room['vaccinated'])
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    "Vaccinated:",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 2.0,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.solidCheckCircle,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            if (!room['vaccinated'])
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    "Vaccinated:",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 2.0,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.solidTimesCircle,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          SizedBox(
            width: 15.0,
          ),
          Category(
            backgroundColor: Colors.pink,
            icon: FontAwesomeIcons.dog,
            title: "Dog",
          ),
          SizedBox(
            width: 15.0,
          ),
          Category(
            backgroundColor: Colors.pink,
            title: "Cat",
            icon: FontAwesomeIcons.cat,
          ),
        ],
      ),
    );
  }
}

class Category extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color? backgroundColor;

  const Category(
      {Key? key, required this.icon, required this.title, this.backgroundColor})
      : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.all(10.0),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              widget.icon,
              color: Colors.white,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(widget.title, style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
}
