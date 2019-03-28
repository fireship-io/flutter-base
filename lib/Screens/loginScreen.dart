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
    auth.googleSignIn().then((user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  facebookSignIn() {
    auth.facebookSignIn().then((user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }).catchError((error) {
      print('FB error: $error');
      final snackBar = SnackBar(
        content: Text(error),
      );

      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  twitterSignIn() {
    auth.twitterSignIn().then((user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
      ),
    );
  }
}
