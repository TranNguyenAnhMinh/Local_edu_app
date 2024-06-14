import 'package:flutter/material.dart';
import 'package:local_education_app/screens/exam/pages/intro_page.dart';
import 'package:local_education_app/screens/home/home_screen.dart';
import 'package:local_education_app/screens/notification/notification_screen.dart';
import 'package:local_education_app/screens/profile/profile_screen.dart';

class AppMainNav extends StatefulWidget {
  const AppMainNav({super.key});

  @override
  State<AppMainNav> createState() => _AppMainNavState();
}

class _AppMainNavState extends State<AppMainNav> {
  int _currentScreenIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        const HomeScreen(),
        const IntroPage(),
        const NotificationScreen(),
        const ProfileScreen(),
      ].elementAt(_currentScreenIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (int index) => setState(() {
          _currentScreenIndex = index;
        }),
        currentIndex: _currentScreenIndex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "Trang chủ",
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: "Kiểm tra",
            icon: Icon(Icons.menu_book_outlined),
          ),
          BottomNavigationBarItem(
            label: "Thông báo",
            icon: Icon(Icons.notifications_outlined),
          ),
          BottomNavigationBarItem(
            label: "Hồ sơ",
            icon: Icon(Icons.person_outlined),
          ),
        ],
      ),
    );
  }
}
