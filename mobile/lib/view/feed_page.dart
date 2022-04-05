import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:peter/helpers/constants.dart';
import 'package:peter/helpers/toast_controller.dart';
import 'package:peter/view/navbar_view.dart';
import '../helpers/device_details.dart';
import '../helpers/get_date.dart';

class FeedPage extends StatefulWidget {
  final cardListFinder;
  final cardListAdopter;
  final sim;

  const FeedPage(
      {Key? key, this.cardListFinder, this.cardListAdopter, this.sim})
      : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

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

    //final destination = '$os/$brand/$id';

    // Only for dog
    const destination = 'dog/';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('dogx');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }

    showToast("Image uploaded correctly");
    setState(() {
      var q = [];
      var s = widget.cardListFinder;
      var s_l = <int>[];
      for (int i = 0; i < 6; i++) {
        s_l.add(s[i]['similarity']);
      }
      s_l.sort((a, b) => b.compareTo(a));
      print(s_l);

      for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 6; j++) {
          if (s_l[i] == s[j]['similarity']) {
            q.add(s[j]);
          }
        }
      }

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NavbarFeed(
                    sim: true,
                    cardListFinder: q,
                    cardListAdopter: widget.cardListAdopter,
                  )));
    });
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
      backgroundColor: beige,
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
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.bars,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 80.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Find your Pet using",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0)),
                    Text(" Finder",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0)),
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
              return _buildRooms(
                  context, index, widget.cardListFinder, widget.sim);
            }, childCount: 6),
          )
        ],
      ),
    );
  }

  Widget _buildRooms(BuildContext context, int index, cardL, sim) {
    var room = cardL[index % cardL.length];

    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            padding: EdgeInsets.all(3.0),
            child: Container(
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.teal[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Image.network(
                          room['imageURL'],
                          fit: BoxFit.cover,
                        ),
                        if (sim == true)
                          Positioned(
                            top: 5.0,
                            left: 5.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.percentage,
                                      size: 20,
                                      color: Colors.teal,
                                    ),
                                    Text(
                                      room['similarity'].toString(),
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 5.0,
                          right: 5.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Text(
                                    room['date'],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  const Icon(
                                    FontAwesomeIcons.clock,
                                    size: 16,
                                    color: Colors.teal,
                                  ),
                                ],
                              ),
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
                          Row(
                            children: [
                              Text(
                                room['name'],
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.teal),
                                onPressed: () {},
                                icon: Icon(
                                  FontAwesomeIcons.infoCircle,
                                  size: 24.0,
                                ),
                                label: Text('Info'), // <-- Text
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                room['location'],
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
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
                                  width: 7.0,
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
                                  width: 7.0,
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
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 15.0,
          ),
          Category(
            backgroundColor: pinkButton,
            icon: FontAwesomeIcons.dog,
            title: "Dog",
          ),
          SizedBox(
            width: 15.0,
          ),
          Category(
            backgroundColor: pinkButton,
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
            const SizedBox(
              height: 5.0,
            ),
            Text(widget.title, style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
}
