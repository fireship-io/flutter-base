import 'package:flutter/material.dart';
import 'package:validate/validate.dart';

import '../models/auth.dart';

final auth = new AuthService();


class EmailSignInDialog extends StatefulWidget {
  @override
  EmailSignInDialogState createState() => EmailSignInDialogState();
}

class EmailSignInDialogState extends State<EmailSignInDialog> {
  BuildContext scaffoldContext;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  String password;

  _showInSnackBar(String value) {
    Scaffold.of(scaffoldContext).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  emailSignIn() async {
    if (this._formKey.currentState.validate()) {
      print('Form is valid');
      _formKey.currentState.save();

      try {
        await auth.emailSignIn(email, password);
        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        print('Error: $e');
        this._showInSnackBar(e);
      }
    }
  }

  _validateEmail(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail must be a valid address.';
    }
  }

  _validatePassword(String value) {
    if (value.isEmpty || value.length < 6) {
      return 'The Password must be at least 6 characters.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        scaffoldContext = context;
        return Center(
          child: Container(
            margin: EdgeInsets.all(25),
            child: Form(
              key: this._formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Enter an email'),
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    validator: (String value) {
                      _validateEmail(value);
                    },
                    onSaved: (String value) {
                      this.email = value;
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Enter your password'),
                    obscureText: true,
                    validator: (String value) {
                      _validatePassword(value);
                    },
                    onSaved: (String value) {
                      this.password = value;
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () => emailSignIn(),
                      child: Text('Continue'),
                      textColor: Colors.white,
                      elevation: 7.0,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    child: OutlineButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                      textColor: Colors.blueGrey[700],
                      color: Colors.blueGrey[700],
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
