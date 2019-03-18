import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/main.dart';

import './Screens/homeScreen.dart';
import './Screens/loginScreen.dart';
// import './Screens/common.dart';

bool _isAuthenticated = false;
final MainModel _model = MainModel();

void main() async {
  _isAuthenticated = await _model.checkIfAuthenticated();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Map<String, dynamic> _profile;
  // bool _loading = false;

  // @override
  // initState() {
  //   super.initState();
  //   authService.profile.listen((state) => setState(() => _profile = state));
  //   authService.loading.listen((state) => setState(() => _loading = state));
  // }

  @override
  void initState() {
    super.initState();
    _model.checkIfAuthenticated().then((bool isAuthenticated) {
      print('isAuthenticated _MyAppState: $isAuthenticated');
      _isAuthenticated = isAuthenticated;
    }).catchError((onError) {
      print('MyApp error: ${onError.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        // initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginScreen(),
          '/home': (BuildContext context) => HomeScreen(),
        },
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) {
                return _isAuthenticated ? HomeScreen() : LoginScreen();
              });
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeScreen());
          }
        },
        onUnknownRoute: (RouteSettings settings) {
          print('onUnknownRoute');
          return MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen());
        },
      ),
    );
  }
}


