import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peter/view/carer.dart';
import 'package:peter/view/feed_page.dart';
import 'package:peter/view/feed_page_adopter.dart';

class NavbarFeed extends StatefulWidget {
  final cardListFinder;
  final cardListAdopter;
  final sim;

  const NavbarFeed(
      {Key? key, this.cardListFinder, this.cardListAdopter, this.sim})
      : super(key: key);

  @override
  _NavbarFeedState createState() => _NavbarFeedState();
}

class _NavbarFeedState extends State<NavbarFeed> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            FeedPage(
                cardListFinder: widget.cardListFinder,
                cardListAdopter: widget.cardListAdopter,
                sim: widget.sim),
            FeedPageAdopter(
                cardListFinder: widget.cardListFinder,
                cardListAdopter: widget.cardListAdopter,
                sim: widget.sim),
            CarerPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Center(child: Text('Finder')),
              icon: Icon(FontAwesomeIcons.search),
              activeColor: Colors.teal,
              inactiveColor: Colors.grey),
          BottomNavyBarItem(
              title: Center(child: Text('Adopter')),
              icon: Icon(FontAwesomeIcons.handHoldingHeart),
              activeColor: Colors.orange,
              inactiveColor: Colors.grey),
          BottomNavyBarItem(
              title: Center(child: Text('Carer')),
              icon: Icon(FontAwesomeIcons.clinicMedical),
              activeColor: Colors.pink,
              inactiveColor: Colors.grey),
        ],
      ),
    );
  }
}
