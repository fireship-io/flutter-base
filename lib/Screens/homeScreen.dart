import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/main.dart';
import '../models/auth.dart';

final MainModel _model = MainModel();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var auth = new AuthService();

  Widget _userPhoto(photoUrl) {
    if (photoUrl != null) {
      return Container(
        margin: EdgeInsets.all(10),
        child: Image.network(photoUrl),
      );
    } else {
      return Container();
    }
  }

  Widget _userCard(doc) {
    return Center(
      child: Card(
        elevation: 8.0,
        child: FractionallySizedBox(
          widthFactor: 0.8,
          heightFactor: 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _userPhoto(doc["photoURL"].toString()),
              Text(doc['displayName'].toString()),
              Text(doc['email'].toString()),
              Text(doc['lastSeen'].toString()),
              Text(doc['uid']),
              SizedBox(height: 20),
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

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    print(screenSize);
    print(viewInsets);

    return Scaffold(
      body: FutureBuilder<Map>(
        future: auth.getUserData(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('No userdata found...'));
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Awaiting result...');
            case ConnectionState.done:
              var doc = snapshot.data;
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return _userCard(doc);
          }
          return null;
        },
      ),
    );
  }
}
