import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CarerPage extends StatelessWidget {
  final String image = "assets/images/vet.jpeg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: <Widget>[
          Container(
              foregroundDecoration: BoxDecoration(color: Colors.black45),
              height: 400,
              child: Image.asset(image, fit: BoxFit.cover)),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 250),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "DOFU Veteriner",
                    style: TextStyle(
                        color: Colors.pink[50],
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: <Widget>[
                    const SizedBox(width: 16.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Text(
                        "8.4/85 reviews",
                        style: TextStyle(color: Colors.pink[50], fontSize: 13.0),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      color: Colors.pink[50],
                      icon: Icon(Icons.settings),
                      onPressed: () {},
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(32.0),
                  color: Colors.pink[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.pink,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.pink,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.pink,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.pink,
                                    ),
                                    Icon(
                                      Icons.star_border,
                                      color: Colors.pink,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text.rich(
                                  TextSpan(children: [
                                    WidgetSpan(
                                        child: Icon(
                                      Icons.location_on,
                                      size: 16.0,
                                      color: Colors.grey,
                                    )),
                                    TextSpan(text: "100.Yıl, Ankara")
                                  ]),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            FontAwesomeIcons.dog,
                            color: Colors.pink,
                          ),
                          SizedBox(width: 5),
                          Icon(
                            FontAwesomeIcons.cat,
                            color: Colors.pink,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.pink,
                            ),
                            onPressed: () {},
                            label: Text(
                              "Contact Now",
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            icon: Icon(FontAwesomeIcons.phone),
                          )),
                      const SizedBox(height: 30.0),
                      Text(
                        "DOFU Veteriner".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "We are a full-service pet hospital that offers comprehensive veterinary services for cats and dogs in Ceres and the surrounding areas.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 14.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "From preventive care and internal medicine to pain management and hospice care, our broad and varied service offering can meet all of your pet’s health needs in one place.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
