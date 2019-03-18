import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[LoginButtons(), UserProfile()],
          ),
        ),
      ),
    );
  }
}

class UserProfile extends StatefulWidget {
  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profile;
  bool _loading = false;

  /// Phone auth
  String phoneNumber;
  String smsCode;
  String verificationId;

  @override
  initState() {
    super.initState();
    authService.profile.listen((state) => setState(() => _profile = state));

    authService.loading.listen((state) => setState(() => _loading = state));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(padding: EdgeInsets.all(20), child: Text(_profile.toString())),
      Container(
          padding: EdgeInsets.all(20),
          child: Text('Loading: ${_loading.toString()}')),
    ]);
  }
}

class LoginButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SignInButtonBuilder(
          text: 'Sign in with Email',
          icon: Icons.email,
          onPressed: () => authService.emailSignIn(),
          backgroundColor: Colors.blueGrey[700],
        ),
        SignInButtonBuilder(
          text: 'Sign in with Phone',
          icon: Icons.phone,
          onPressed: () => authService.phoneSignIn(),
          backgroundColor: Colors.green,
        ),
        SignInButton(
          Buttons.Google,
          onPressed: () => authService.googleSignIn(),
        ),
        SignInButton(
          Buttons.Facebook,
          onPressed: () => authService.facebookSignIn(),
        ),
        SignInButton(
          Buttons.Twitter,
          onPressed: () => authService.twitterSignIn(),
        ),
      ],
    );

    // return StreamBuilder(
    //     stream: authService.user,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         return MaterialButton(
    //           onPressed: () => authService.signOut(),
    //           color: Colors.red,
    //           textColor: Colors.white,
    //           child: Text('Signout'),
    //         );
    //       } else {
    //         return MaterialButton(
    //           onPressed: () => authService.googleSignIn(),
    //           color: Colors.white,
    //           textColor: Colors.black,
    //           child: Text('Login with Google'),
    //         );
    //       }
    //     });
  }
}
