import 'package:flutter/material.dart';

import 'HomeActivity.dart';
import 'LoginActivity.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginActivity(),
        '/home': (context) => HomeActivity(),
      },
    );
  }
}

