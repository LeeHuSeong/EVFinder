import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signUp(String email, String password) async {
      try {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        return cred.user;
      } catch (e) {
        rethrow;
      }
  }

  Future<void> signOut() async {
      await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}