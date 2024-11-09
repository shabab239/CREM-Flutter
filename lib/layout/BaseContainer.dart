import 'package:flutter/material.dart';

class BaseContainer extends StatelessWidget {
  final Widget child;
  final String title;

  const BaseContainer({
    Key? key,
    required this.child,
    this.title = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          //centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}
