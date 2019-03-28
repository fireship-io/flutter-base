import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../Screens/PhoneAuthDialog.dart';
import '../Screens/EmailSignInDialog.dart';

import '../models/auth.dart';

final auth = new AuthService();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  BuildContext scaffoldContext;

  _showInSnackBar(String value) {
    Scaffold.of(scaffoldContext).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  emailSignIn() {
    Navigator.of(context).push(
      MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return EmailSignInDialog();
          },
          fullscreenDialog: true),
    );
  }

  phoneSignIn() {
    Navigator.of(context).push(
      MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return PhoneSignInDialog();
          },
          fullscreenDialog: true),
    );
  }

  googleSignIn() async {
    try {
      await auth.googleSignIn();
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      print('Error: $e');
      this._showInSnackBar(e);
    }
  }

  facebookSignIn() async {
    try {
      await auth.facebookSignIn();
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      print('Error: $e');
      this._showInSnackBar(e);
    }
  }

  twitterSignIn() async {
    try {
      await auth.twitterSignIn();
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      print('Error: $e');
      this._showInSnackBar(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (BuildContext context) {
        scaffoldContext = context;
        return SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(30),
                  width: MediaQuery.of(context).size.width / 3,
                  height: 200,
                  child: Image.asset('assets/images/Fireship.jpeg'),
                ),
                SignInButtonBuilder(
                  text: 'Sign in with Email',
                  icon: Icons.email,
                  onPressed: () => emailSignIn(),
                  backgroundColor: Colors.blueGrey[700],
                ),
                SignInButtonBuilder(
                  text: 'Sign in with Phone',
                  icon: Icons.phone,
                  onPressed: () => phoneSignIn(),
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
          ),
        );
      }),
    );
  }
}
