import '../resources/constants.dart';
import 'package:disease_app/ui/views/news_screen.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.appName),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Text("Hello World!"),
          ),
          NiceButton(
            width: 255,
            elevation: 8.0,
            radius: 52.0,
            text: "Lastest News",
            background: Colors.blue,
            onPressed: () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => NewsScreen(),
                  transitionsBuilder: (_, animation, __, child) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                )
            ),
          ),
        ]
    )
    );
  }
}