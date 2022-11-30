import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'screen/Home.dart';
import 'screen/batches.dart';
import 'screen/settings.dart';

class navbar extends StatefulWidget {
  @override
  _navbarState createState() => _navbarState();
}

class _navbarState extends State<navbar> {
  int _selectedIndex = 0;
  DateTime currentBackPressTime;

  List<Widget> _widgetOptions = <Widget>[
    Home(),
    batches(),
    settings(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              title: Text('Dashboard'),
              icon: Icon(Icons.home_rounded),
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              title: Text('Batches'),
              icon: Icon(Icons.school_rounded),
              backgroundColor: Colors.yellow),
          BottomNavigationBarItem(
            title: Text('Settings'),
            icon: Icon(Icons.settings),
            backgroundColor: Colors.blue,
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: WillPopScope(
          onWillPop: onWillPop,
          child: _widgetOptions.elementAt(_selectedIndex)),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
