import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/auth.dart';
import 'movie_list.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Authentication _authService = Authentication('9a24ade377dba4dda1cda9abab88da97');
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _requestToken;
  String? _sessionId;

  Future<void> _signIn() async {
    try {
      _requestToken = await _authService.createRequestToken();
      if (_requestToken != null) {
      bool success = await _authService.validateRequestTokenWithLogin(
        _usernameController.text,
        _passwordController.text,
        _requestToken!
      );
        if (success) {
          _sessionId = await _authService.createSession(_requestToken!);
          if (_sessionId != null) {
            print("User has logged in with session Id: $_sessionId");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MovieList(),
              )
            );
          } else {
            print("Failed to create session");
          }
        } else {
          print("Failed to validate request token");
        }
      } else {
        print("Failed to create request token");
      }
    }
    catch(e) {
        print("Failed to Sign in.");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In to MovieDB"),
        ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username')),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height:20),
            ElevatedButton(
              onPressed:_signIn,
              child: Text('Log In')
            )
          ],)
        ,)
      );
  }
}