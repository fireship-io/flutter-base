import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:rxdart/rxdart.dart';

class AuthService extends Model {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookSignIn = FacebookLogin();
  final twitterLogin = TwitterLogin(
    consumerKey: '9NCZQIjJLPCDFvMPLjUAos7j0',
    consumerSecret: 'Fq7ceSAQgMkyQF4W8GPYtQgMPnS253E308IRYwzbfKkuJLr5GO',
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  // constructor
  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
          .collection('users')
          .document(u.uid)
          .snapshots()
          .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }

  Future<bool> checkIfAuthenticated() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      updateUserData(user);
      print('User loggin in');
      return true;
    } else {
      print('User not logged in');
      return false;
    }
  }

  Future<FirebaseUser> emailSignIn() async {
    print('Email sign in');
  }

  Future<FirebaseUser> phoneSignIn(phoneNumber) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      return verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeSend]) {
      return verId;
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      updateUserData(user);
      print('User verified');
    };

    final PhoneVerificationFailed verifiedFailed = (AuthException exeption) {
      print('Phone exeption error: ${exeption.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifiedFailed,
    );

    print('Phone sign in');
  }

  Future<FirebaseUser> googleSignIn() async {
    try {
      loading.add(true);
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      FirebaseUser user = await _auth.signInWithCredential(credential);
      updateUserData(user);
      print("user name: ${user.displayName}");

      loading.add(false);
      return user;
    } catch (error) {
      return error;
    }
  }

  Future<FirebaseUser> facebookSignIn() async {
    try {
      loading.add(true);
      final loginResult = await _facebookSignIn.logInWithReadPermissions(['email', 'public_profile']);

      switch (loginResult.status) {
        case FacebookLoginStatus.loggedIn:
          final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: loginResult.accessToken.token
          );

          final FirebaseUser user = await _auth.signInWithCredential(credential);
          updateUserData(user);
          print("user name: ${user.displayName}");
          return user;

          break;
        case FacebookLoginStatus.cancelledByUser:
          print('object');
          break;
        case FacebookLoginStatus.error:
          print(loginResult.errorMessage);
          break;
      }

      loading.add(false);
    } catch (error) {
      return error;
    }
  }

  Future<FirebaseUser> twitterSignIn() async {
    try {
      loading.add(true);
      
      final TwitterLoginResult loginResult = await twitterLogin.authorize();

      switch (loginResult.status) {
        case TwitterLoginStatus.loggedIn:
          final session = loginResult.session;
          print('${session.token}, ${session.secret}');

          final AuthCredential credential = TwitterAuthProvider.getCredential(
            authToken: loginResult.session.token,
            authTokenSecret: loginResult.session.secret
          );

          final FirebaseUser user = await _auth.signInWithCredential(credential);
          updateUserData(user);
          print("user name: ${user.displayName}");
          return user;

          break;
        case TwitterLoginStatus.cancelledByUser:
          print('Cancelled by user');
          break;
        case TwitterLoginStatus.error:
          print('${loginResult.errorMessage}');
          break;
      }

      loading.add(false);
    } catch (error) {
      return error;
    }
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      return 'SignOut';
    } catch (e) {
      return e.toString();
    }
  }

}

// TODO refactor global to InheritedWidget
// final AuthService authService = AuthService();

