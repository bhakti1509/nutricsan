// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:nutriscan/components/constants.dart';
import 'package:nutriscan/screens/additives.dart';
import 'package:nutriscan/screens/profile.dart';
import 'package:nutriscan/screens/search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  // Define your page content here
  List<Widget> widgetOptions = <Widget>[
    profile(),
    Search(),
    additives(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar? appBar;
    if (_selectedIndex == 2) {
      appBar = null;
    } else {
      appBar = AppBar(
        leading: Container(
          height: 35,
          width: 35,
          child: ClipOval(
            child: Image.asset(
              ("assets/images/ic_launcher.png"),
              height: 24,
              width: 24,
            ),
          ),
        ),
        backgroundColor: Blue1,
        title: Text(
          "NutriScan",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_sharp),
            label: 'Additives',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Blue1,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home Content'),
    );
  }
}

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Search Content'),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Content'),
    );
  }
}
