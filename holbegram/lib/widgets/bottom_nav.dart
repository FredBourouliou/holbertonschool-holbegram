import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import '../screens/pages/add_image.dart';
import '../screens/pages/favorite.dart';
import '../screens/pages/feed.dart';
import '../screens/pages/profile_screen.dart';
import '../screens/pages/search.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
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

  void onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  static const _accent = Color.fromARGB(218, 226, 37, 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: const [
          Feed(),
          Search(),
          AddImage(),
          Favorite(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) {
          onPageChanged(index);
          _pageController.jumpToPage(index);
        },
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text(
              'Home',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
            ),
            activeColor: _accent,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.search),
            title: const Text(
              'Search',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
            ),
            activeColor: _accent,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.add),
            title: const Text(
              'Add',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
            ),
            activeColor: _accent,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text(
              'Favorite',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
            ),
            activeColor: _accent,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title: const Text(
              'Profile',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
            ),
            activeColor: _accent,
            inactiveColor: Colors.black,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
