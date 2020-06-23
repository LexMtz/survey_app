import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:survey_app/services/authentication.dart';

const String kAuthError = 'error';
const String kAuthSuccess = 'success';
const String kAuthLoading = 'loading';
const String kAuthSignInAnonymous = 'anonymous';

class AuthenticationState with ChangeNotifier {
  String _authStatus;
  static String _userId;
  bool isLoading = false;

  String get authStatus => _authStatus;
  static String get userId => _userId;

  AuthenticationState() {
    clearState();

    onAuthenticationChange((user) {
      if (user != null) {
        _authStatus = kAuthSuccess;
        checkAuthentication();
      } else {
        clearState();
      }
      notifyListeners();
    });
  }

  void checkAuthentication() async {
    _authStatus = kAuthLoading;

    if (await isUserSignedIn()) {
      _authStatus = kAuthSuccess;
      FirebaseUser user = await getCurrentUser();
      _userId = user != null ? user.uid : '';
    } else {
      _authStatus = kAuthError;
    }
    notifyListeners();
  }

  void clearState() {
    _authStatus = null;
    _userId = null;
  }

  void login() {
    signInAnonymously();
  }

  void logout() {
    clearState();
    signOut();
  }

  void refresh() {
    notifyListeners();
  }
}
