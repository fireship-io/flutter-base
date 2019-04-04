import 'package:flutter/material.dart';

import '../models/auth.dart';

final auth = new AuthService();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  _userPhoto(photoUrl) {
    if (photoUrl != 'null') {
      return Container(
        margin: EdgeInsets.all(10),
        child: Image.network(photoUrl),
      );
    } else if (photoUrl == 'null') {
      return Container(
        margin: EdgeInsets.all(10),
        child: CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.help_outline, size: 40),
        ),
      );
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
              Text(doc['phoneNumber'].toString()),
              Text(doc['lastSeen'].toString()),
              Text(doc['uid']),
              SizedBox(height: 20),
              RaisedButton(
                child: Text('Logout'),
                onPressed: () {
                  auth.signOut();
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
    return Scaffold(
      body: FutureBuilder<Map>(
        future: auth.getUserData(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('No userdata found...'));
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: Text('Loading...'));
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
