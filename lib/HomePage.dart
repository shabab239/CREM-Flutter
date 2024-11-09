import 'dart:convert';

import 'package:crem_flutter/auth/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/AuthService.dart';
import 'layout/BaseContainer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late SharedPreferences sp;
  User? user;

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    user = await AuthService.getStoredUser();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User not found"),
        ),
      );
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      title: 'Home',
      child: user != null
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome ${user?.name}'),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(),  // Show loading indicator until data is loaded
      ),
    );
  }
}
