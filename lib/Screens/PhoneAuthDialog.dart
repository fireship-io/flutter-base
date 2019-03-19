import 'package:flutter/material.dart';

import '../models/main.dart';
final MainModel _model = MainModel();

// https://www.youtube.com/watch?v=3YH7lyyrCCM
class PhoneAuthDialog extends StatefulWidget {
  @override
  PhoneAuthDialogState createState() => new PhoneAuthDialogState();
}

class PhoneAuthDialogState extends State<PhoneAuthDialog> {
  String phoneNumber;
  String smsCode;
  String verificationId;

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
                decoration: InputDecoration(hintText: 'Enter a phonenumber'),
                onChanged: (value) {
                  this.phoneNumber = value;
                },
              ),
              RaisedButton(
                onPressed: () {
                  _model.verifyPhoneNumber(phoneNumber);
                },
                child: Text('Verify number'),
                textColor: Colors.white,
                elevation: 7.0,
                color: Colors.green,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Enter the SMS Code'),
                onChanged: (value) {
                  this.phoneNumber = value;
                },
              ),
              RaisedButton(
                onPressed: () {
                  _model.phoneNumberSignIn();
                },
                child: Text('Sign in'),
                textColor: Colors.white,
                elevation: 7.0,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
