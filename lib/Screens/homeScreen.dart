import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/main.dart';

final MainModel _model = MainModel();

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('users').document('3QIXNOKbokbZIi61UMz9cD9uobK2').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (!snapshot.hasData) return Text("Loading");
          var userDocument = snapshot.data;
          return Text(userDocument["email"]);
        },

        // stream: Firestore.instance.collection('users').snapshots(),
        // builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //   if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        //   switch (snapshot.connectionState) {
        //     case ConnectionState.waiting:
        //       return Text('Loading...');
        //     default:
        //       return ListView(
        //         children: snapshot.data.documents.map((DocumentSnapshot document) {
        //           return ListTile(
        //             title: Text(document['uid']),
        //             // subtitle: new Text(document['author']),
        //           );
        //         }).toList(),
        //       );
        //   }
        // },
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ScopedModelDescendant<MainModel>(
//       builder: (context, child, model) => Scaffold(
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text(_model.profile.toString()),
//                   RaisedButton(
//                     child: Text('Logout'),
//                     onPressed: () {
//                       _model.signOut();
//                       Navigator.of(context).pushReplacementNamed('/login');
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//     );
//   }
// }
