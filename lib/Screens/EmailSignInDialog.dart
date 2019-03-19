import 'package:flutter/material.dart';
import 'package:validate/validate.dart';

import '../models/main.dart';

final MainModel _model = MainModel();

class EmailSignInDialog extends StatefulWidget {
  @override
  EmailSignInDialogState createState() => EmailSignInDialogState();
}

class EmailSignInDialogState extends State<EmailSignInDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  String password;

  emailSignIn() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    print('Email and password: $email $password');
    
    _model.emailSignIn(email, password).then((user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  String _validateEmail(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty || value.length < 6) {
      return 'The Password must be at least 6 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(25),
          child: Form(
            key: this._formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(hintText: 'Enter a e-mail'),
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
                  decoration: InputDecoration(hintText: 'Password'),
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
      ),
    );
  }
}
