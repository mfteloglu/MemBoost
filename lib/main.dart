import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:memboost/Model/google_sign_in.dart';
import 'package:memboost/View/login_screen.dart';
import 'package:memboost/ViewModel/decks_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await Firebase.initializeApp();
  runApp(MemBoostApp());
}

class MemBoostApp extends StatelessWidget {
  MemBoostApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => GoogleSignInProvider(),
          ),
          ChangeNotifierProvider(create: (context) => DecksViewModel())
        ],
        child: MaterialApp(
            title: 'MemBoost',
            home: LoginScreen(),
            theme: ThemeData(
                brightness: Brightness.light,
                colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.deepOrange,
                    accentColor: Colors.deepOrangeAccent,
                    brightness: Brightness.light))));
  }
}
