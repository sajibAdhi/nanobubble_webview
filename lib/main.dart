import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'nano_bubble.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "InternetUi",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.purpleAccent,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ConnectivityResult previous;

  @override
  void initState() {
    super.initState();
    try {
      InternetAddress.lookup('google.com').then((result) {
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // internet conn available
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => NanoBubble(),
          ));
        } else {
          // no conn
          _showDialog();
        }
      }).catchError((error) {
        // no conn
        _showDialog();
      });
    } on SocketException catch (_) {
      // no internet
      _showDialog();
    }

    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connResult) {
      if (connResult == ConnectivityResult.none) {
      } else if (previous == ConnectivityResult.none) {
        // internet conn
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => NanoBubble(),
        ));
      }

      previous = connResult;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text("No Internet Connection Detected"),
        actions: <Widget>[
          TextButton(
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: Text('Exit'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Checking your Internet Connection",
                style: TextStyle(fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
