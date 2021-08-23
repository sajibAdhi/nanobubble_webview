import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NanoBubble extends StatefulWidget {
  @override
  _NanoBubbleState createState() => _NanoBubbleState();
}

class _NanoBubbleState extends State<NanoBubble> {
  late StreamSubscription connectivitySubscription;

  late ConnectivityResult _previousResult;

  bool dilagueShow = false;

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
      return false;
    } on SocketException catch (_) {
      return Future.value(false);
    }
  }

  @override
  void initState() {
    super.initState();

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connResult) {
      if (connResult == ConnectivityResult.none) {
        dilagueShow = true;
        _showDialog();
      } else if (_previousResult == ConnectivityResult.none) {
        checkInternet().then((result) => {
              if (result == true)
                {
                  if (dilagueShow == true) {Navigator.pop(context)}
                }
            });
      }

      _previousResult = connResult;
    });
  }

  @override
  void dispose() {
    super.dispose();

    connectivitySubscription.cancel();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text("No Internet Connection Available"),
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
      body: WebView(
        initialUrl: 'http://nanobubble.ie/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
