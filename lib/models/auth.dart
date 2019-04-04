import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class AuthService {
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

  String _verificationId;
  String verificationId;

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
      return true;
    } else {
      return false;
    }
  }

  Future<FirebaseUser> emailSignIn(String email, String password) async {
    try {
      FirebaseUser user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      updateUserData(user);
      return user;
    } on PlatformException catch (e) {
      throw e.message;
    } catch (error) {
      throw 'Unknown user or wrong password.';
    }
  }

  Future<String> verifyPhoneNumber(String phoneNumber) async {
    final PhoneVerificationCompleted verificationCompleted = (FirebaseUser user) {
      print('Auth: verificationCompleted');
      return 'signInWithPhoneNumber auto succeeded: $user';
    };

    final PhoneVerificationFailed verificationFailed = (AuthException authException) {
      print('Auth: verificationFailed');
      return 'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
    };

    final PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      print('Auth: codeSent: $verificationId');
      this._verificationId = verificationId;
      return 'Please check your phone for the verification code.';
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      print('Auth: codeAutoRetrievalTimeout');
      this._verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    
    return('Auth: after verifyPhoneNumber');
  }

  Future<String> signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: this._verificationId,
      smsCode: smsCode,
    );

    try {
      FirebaseUser user = await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      if (user != null) {
        print('~~~~~~~ User: $user');
        updateUserData(user);
        return 'Successfully signed in, uid: ' + user.uid;
      } else {
        return 'Sign in failed';
      }
    } on PlatformException catch (e) {
      throw e.message;
    } catch (error) {
      throw 'Unknown user or wrong password.';
    }
  }

  Future<FirebaseUser> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      FirebaseUser user = await _auth.signInWithCredential(credential);
      updateUserData(user);

      return user;
    } on PlatformException catch (e) {
      throw e.message;
    } catch (error) {
      throw error;
    }
  }

  Future<FirebaseUser> facebookSignIn() async {
    try {
      final loginResult = await _facebookSignIn
          .logInWithReadPermissions(['email', 'public_profile']);

      switch (loginResult.status) {
        case FacebookLoginStatus.loggedIn:
          final AuthCredential credential = FacebookAuthProvider.getCredential(
              accessToken: loginResult.accessToken.token);

          final FirebaseUser user =
              await _auth.signInWithCredential(credential);
          updateUserData(user);
          return user;
          break;
        case FacebookLoginStatus.cancelledByUser:
          throw 'User cancelled Facebook login.';
          break;
        case FacebookLoginStatus.error:
          throw (loginResult.errorMessage);
          break;
      }
    } on PlatformException catch (e) {
      throw e.message;
    } catch (error) {
      throw error;
    }
  }

  Future<FirebaseUser> twitterSignIn() async {
    try {
      final TwitterLoginResult loginResult = await twitterLogin.authorize();

      switch (loginResult.status) {
        case TwitterLoginStatus.loggedIn:
          final AuthCredential credential = TwitterAuthProvider.getCredential(
              authToken: loginResult.session.token,
              authTokenSecret: loginResult.session.secret);

          final FirebaseUser user =
              await _auth.signInWithCredential(credential);
          updateUserData(user);
          return user;

          break;
        case TwitterLoginStatus.cancelledByUser:
          throw ('Cancelled by user');
          break;
        case TwitterLoginStatus.error:
          throw ('${loginResult.errorMessage}');
          break;
      }
    } on PlatformException catch (e) {
      throw e.message;
    } catch (error) {
      throw 'Something went wrong.';
    }
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  Future<Map> getUserData() async {
    FirebaseUser user = await _auth.currentUser();
    var doc =
        await Firestore.instance.collection('users').document(user.uid).get();
    return doc.data;
  }

  Future<void> signOut() async {
    _auth.signOut();
    return;
  }
}
