import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import '../models/main.dart';
// final MainModel _model = MainModel();

// https://www.youtube.com/watch?v=3YH7lyyrCCM

class PhoneSignInDialog extends StatefulWidget {
  @override
  PhoneSignInDialogState createState() => PhoneSignInDialogState();
}

class PhoneSignInDialogState extends State<PhoneSignInDialog> {
  String phoneNumber;
  String smsCode;
  String verificationId;

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed in');
      });
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      print('verified');
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: this.phoneNumber,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: veriFailed
    );
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter sms Code'),
          content: TextField(
            onChanged: (value) {
              this.smsCode = value;
            },
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            FlatButton(
              child: Text('Done'),
              onPressed: () {
                FirebaseAuth.instance.currentUser().then((user) {
                  if (user != null) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/homepage');
                  } else {
                    Navigator.of(context).pop();
                    signIn();
                  }
                });
              },
            ),
          ],
        );
      });
  }

  signIn() {
    // FirebaseAuth.instance
    //     .signInWithPhoneNumber(verificationId: verificationId, smsCode: smsCode)
    //     .then((user) {
    //   Navigator.of(context).pushReplacementNamed('/homepage');
    // }).catchError((e) {
    //   print(e);
    // });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Enter your phonenumber'),
                onChanged: (value) {
                  this.phoneNumber = value;
                },
              ),
              Padding(padding: EdgeInsets.all(10)),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  onPressed: verifyPhone,
                  child: Text('Continue'),
                  textColor: Colors.white,
                  color: Colors.green,
                ),
              ),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                child: OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                  textColor: Colors.green,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
