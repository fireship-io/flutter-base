import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../models/main.dart';

import '../Screens/PhoneAuthDialog.dart';
import '../Screens/EmailSignInDialog.dart';

final MainModel _model = MainModel();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
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

  googleSignIn() {
    _model.googleSignIn().then((user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  facebookSignIn() {
    _model.facebookSignIn().then((user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  twitterSignIn() {
    _model.twitterSignIn().then((user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(42, 46, 53, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(40),
                  width: MediaQuery.of(context).size.width / 3,
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
          ],
        ),
      ),
    );
  }
}
