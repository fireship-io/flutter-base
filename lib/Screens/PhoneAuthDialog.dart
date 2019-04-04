import 'package:flutter/material.dart';
import '../models/auth.dart';

final auth = new AuthService();

class PhoneSignInDialog extends StatefulWidget {
  @override
  PhoneSignInDialogState createState() => PhoneSignInDialogState();
}

class PhoneSignInDialogState extends State<PhoneSignInDialog> {
  BuildContext scaffoldContext;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  _showInSnackBar(String value) {
    Scaffold.of(scaffoldContext).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  _verifyPhoneNumber() async {
    try {
      if (_phoneNumberController.text != '') {
        print(_phoneNumberController.text);
        var message = await auth.verifyPhoneNumber(_phoneNumberController.text);
        _showInSnackBar(message);
      }
    } catch (e) {
      this._showInSnackBar('Error: $e');
    }
  }

  _signInWithPhoneNumber() async {
    try {
      await auth.signInWithPhoneNumber(_smsController.text);
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      this._showInSnackBar('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        scaffoldContext = context;
        return SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(labelText: 'Phone number (+x xxx-xxx-xxxx)'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Phone number (+x xxx-xxx-xxxx)';
                        }
                      },
                    ),
                  ),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      child: Text('Verify phone number'),
                      onPressed: () => _verifyPhoneNumber(),
                      textColor: Colors.white,
                      elevation: 7.0,
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      controller: _smsController,
                      decoration:
                          InputDecoration(labelText: 'Verification code'),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () async {
                        _signInWithPhoneNumber();
                      },
                      child: Text('Sign in with phone number'),
                      textColor: Colors.white,
                      elevation: 7.0,
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
      }),
    );
  }
}
