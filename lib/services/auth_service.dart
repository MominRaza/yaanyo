import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaanyo/models/app_user.dart';

import '../constants.dart';
import 'database/user_database_service.dart';

final authServiceProvider =
    ChangeNotifierProvider<AuthService>((ref) => AuthService());

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _userDBService = UserDatabaseService();

  Stream<User> userStream() => _firebaseAuth.authStateChanges();

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User> signUpWithEmailAndPassword(
      {String email, String password, String name}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      final appUser = AppUser(
          name: name,
          email: email,
          uid: user.uid,
          profilePic: kDefaultProfilePic);
      await _userDBService.addUserToDatabase(appUser: appUser);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      await _firebaseAuth.signOut();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
