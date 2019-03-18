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

  Future<void> _verifyPhoneNumber() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('entry'),
      //   actions: [
      //     FlatButton(
      //         onPressed: () {
      //           Navigator
      //               .of(context)
      //               .pop();
      //         },
      //         child: Text('SAVE',
      //             style: Theme
      //                 .of(context)
      //                 .textTheme
      //                 .subhead
      //                 .copyWith(color: Colors.white))),
      //   ],
      // ),
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
                  _model.phoneSignIn(phoneNumber);
                },
                child: Text('Verify number'),
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
