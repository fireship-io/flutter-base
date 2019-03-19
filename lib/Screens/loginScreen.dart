import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../models/main.dart';

import '../Screens/PhoneAuthDialog.dart';

final MainModel _model = MainModel();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  phoneAuth() {
    Navigator.of(context).push(
      MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return PhoneAuthDialog();
          },
          fullscreenDialog: true),
    );
  }

  googleSignIn() {
    _model.googleSignIn().then((user) => {
      // if (user != null) {
        Navigator.of(context).pushReplacementNamed('/home')
      // }
    });
  }

  facebookSignIn() {
    _model.facebookSignIn().then((user) => {
      // if (user != null) {
        Navigator.of(context).pushReplacementNamed('/home')
      // }
    });
  }

  twitterSignIn() {
    _model.twitterSignIn().then((user) => {
      // if (user != null) {
        Navigator.of(context).pushReplacementNamed('/home')
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SignInButtonBuilder(
                  text: 'Sign in with Email',
                  icon: Icons.email,
                  onPressed: () => _model.emailSignIn(),
                  backgroundColor: Colors.blueGrey[700],
                ),
                SignInButtonBuilder(
                  text: 'Sign in with Phone',
                  icon: Icons.phone,
                  onPressed: () => phoneAuth(),
                  backgroundColor: Colors.green,
                ),
                SignInButton(
                  Buttons.Google,
                  onPressed: () => googleSignIn(),
                ),
                SignInButton(
                  Buttons.Facebook,
                  onPressed: () => facebookSignIn(),
                ),
                SignInButton(
                  Buttons.Twitter,
                  onPressed: () => twitterSignIn(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
