import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maple/models/usermodel.dart';
import 'package:maple/models/usermodelmapper.dart';
import 'package:maple/utils/constants.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserModelMapper _userModelMapper = UserModelMapper();
  Stream<UserModel> get authStateChangesWithModel =>
      _auth.authStateChanges().transform(_userModelMapper.userMapper);
 
  

  String _notification = "";
  get noti => _notification;
  get auth => _auth;

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _notification = "";
      User? user = credential.user;
      String? uid = user?.uid;
      if (!credential.user!.emailVerified) {
        _notification = unauthenticatedEmail;
      }
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('Users').doc(uid).get();
      if (documentSnapshot.exists) {
        // Lấy dữ liệu từ document
        var userData = documentSnapshot.data() as Map<String, dynamic>;
        return UserModel(
            uid: user!.uid,
            email: email,
            completedLessons: userData[completedLesson],
            process: userData[process],
            username: userData[userName],
            language: 'en',
            heart: userData[heart],
            streak: userData[streak],
            gem: userData[gem]);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        rethrow;
      } else if (e.code == 'wrong-password') {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }

    return null;
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('Users').doc(credential.user!.uid).set({
        userName: username,
        email: email,
        completedLesson: "0",
        process: "0",
        language: 'en',
        heart: "5",
        streak: "0",
        gem: "500"
      });
      sendEmailverification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        rethrow;
      }
    }
  }

  Future<void> sendEmailverification() async {
    try {
      _auth.currentUser?.sendEmailVerification();
      _notification = emailVerificationSent;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserModel?> signInWithGoogleAccount() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(googleAuthProvider);
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('Users').doc(user.uid).get();
        if (documentSnapshot.exists) {
          // Lấy dữ liệu từ document
          var userData = documentSnapshot.data() as Map<String, dynamic>;
          return UserModel(
              uid: user.uid,
              email: user.email,
              completedLessons: userData[completedLesson],
              process: userData[process],
              username: userData[userName],
              language: 'en',
              heart: userData[heart],
              streak: userData[streak],
              gem: userData[gem]);
        } else {
          await _firestore.collection('Users').doc(user.uid).set({
            userName: user.displayName ?? "",
            email: user.email,
            completedLesson: "0",
            process: "0",
            language: 'en',
            heart: "5",
            streak: "0",
            gem: "500"
          });
        }
      } else {
        return null;
      }

      //goToHomePage();
    } catch (error) {
      rethrow;
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
