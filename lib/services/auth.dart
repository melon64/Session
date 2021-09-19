import 'package:firebase_auth/firebase_auth.dart';
import 'package:study/model/userFB.dart';
import 'package:study/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserFB _userFirebase(User myUser) {
    return UserFB(uid: myUser.uid);
  }

  Stream<UserFB> get user {
    return _auth.authStateChanges().map((User? user) => _userFirebase(user!));
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return _userFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFirebase(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      // String userUID = user!.uid;
      // print(userUID);

      await DatabaseService(uid: user!.uid).updateUserData('John Doe', 0, 0);

      return _userFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
