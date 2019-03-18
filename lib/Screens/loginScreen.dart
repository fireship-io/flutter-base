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
  void _openPhoneAuthDialog() {
    Navigator.of(context).push(
      MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return PhoneAuthDialog();
          },
          fullscreenDialog: true),
    );
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
                  onPressed: () => _openPhoneAuthDialog(),
                  backgroundColor: Colors.green,
                ),
                SignInButton(
                  Buttons.Google,
                  onPressed: () => _model.googleSignIn(),
                ),
                SignInButton(
                  Buttons.Facebook,
                  onPressed: () => _model.facebookSignIn(),
                ),
                SignInButton(
                  Buttons.Twitter,
                  onPressed: () => _model.twitterSignIn(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
