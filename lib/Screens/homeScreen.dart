import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/main.dart';

final MainModel _model = MainModel();

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Logout'),
                    onPressed: () {
                      _model.signOut();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
