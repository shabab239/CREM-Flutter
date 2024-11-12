import 'package:crem_flutter/util/ApiResponse.dart';
import 'package:flutter/material.dart';

import 'auth/AuthService.dart';
import 'layout/BaseContainer.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController usernameTec = TextEditingController()
    ..text = 'shabab';
  final TextEditingController passwordTec = TextEditingController()
    ..text = 'password';

  bool isLoading = false;

  @override
  void initState() async {
    if (await AuthService.isLoggedIn()) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      title: 'Login',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameTec,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordTec,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    final username = usernameTec.text.trim();
    final password = passwordTec.text;

    try {
      final ApiResponse apiResponse = await AuthService.login(username, password);
      if (apiResponse.successful) {
        AuthService.initSession(apiResponse);
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid username or password')));
        });
      }
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred during login')));
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
