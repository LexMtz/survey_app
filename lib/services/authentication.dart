import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<FirebaseUser> getCurrentUser() async {
  final FirebaseUser user = await _auth.currentUser();
  if (user != null) {
  }
  return user;
}

Future<bool> isUserSignedIn() async {
  final FirebaseUser currentUser = await _auth.currentUser();
  return currentUser != null;
}

void signOut() {
  try {
    _auth.signOut();
  } catch (error) {
    print(error);
  }
}

void onAuthenticationChange(Function(FirebaseUser) isLogin) {
  _auth.onAuthStateChanged.listen((FirebaseUser user) {
    if (user != null) {
      isLogin(user);
    } else {
      isLogin(null);
    }
  });
}

Future<FirebaseUser> signInAnonymously() async {
  final FirebaseUser user = (await _auth.signInAnonymously()).user;
  return user;
}
