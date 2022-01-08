import 'package:flutter/material.dart';
import 'package:memboost/Model/google_sign_in.dart';
import 'home_screen.dart';
import 'package:sign_button/sign_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(children: [
        Expanded(
            flex: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  child: Image.asset('lib/assets/ic_app_icon.png',
                      height: 200, width: 200, alignment: Alignment.center),
                ),
                Text("Welcome to MemBoost!",
                    style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.onSecondary))
              ],
            )),
        Expanded(
            flex: 30,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SignInButton(
                    buttonType: ButtonType.mail,
                    btnColor: Colors.white,
                    btnTextColor: Colors.black,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                  ),
                  SignInButton(
                    buttonType: ButtonType.google,
                    onPressed: () async {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      await provider.googleLogin();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                  ),
                  SignInButton(
                    buttonType: ButtonType.apple,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                  ),
                ]))
      ]),
    ));
  }
}
