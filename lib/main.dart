import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_hut/screens/user/auth.dart';
import 'package:food_hut/screens/user/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
      },
    )
  );
}
