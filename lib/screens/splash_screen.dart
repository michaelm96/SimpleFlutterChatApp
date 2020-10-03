import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Text('Loading...'),
    );
  }
}
