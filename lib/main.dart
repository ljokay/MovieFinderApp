import 'package:flutter/material.dart';
import 'movie_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
    apiKey: 'key',
    appId: 'id',
    messagingSenderId: 'sendid',
    projectId: 'myapp',
    storageBucket: 'myapp-b9yt18.appspot.com',
  )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Movies',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const Home(),
      );
  }
}
class Home extends StatelessWidget {
  const Home({super.key});

    @override
    Widget build(BuildContext context) {
      return const LoginScreen();
    }
}

