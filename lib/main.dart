import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:memboost/View/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MemBoostApp());
}

class MemBoostApp extends StatelessWidget {
  MemBoostApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MemBoost',
        home: LoginScreen(),
        theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.deepOrange,
                accentColor: Colors.deepOrangeAccent,
                brightness: Brightness.light)));
  }
}
