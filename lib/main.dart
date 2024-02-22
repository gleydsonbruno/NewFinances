import 'package:definitivo_app_tcc/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'GFácil',
    theme: ThemeData(
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: Colors.white.withAlpha(190),
    ),
    home: const SignInScreen(),
  ));
}




