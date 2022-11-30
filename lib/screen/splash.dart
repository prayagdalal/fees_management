import 'dart:async';
import 'dart:ui';

import 'package:fees_management/NavigationBarWidget.dart';
import 'package:flutter/material.dart';

class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => navbar())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/FM1.png",
              width: 140,
              height: 140,
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Fees Management',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[850]),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
