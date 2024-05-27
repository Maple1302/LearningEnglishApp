import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:maple/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String  _googleEmail = '';
  String _notification = '';
  get notification => _notification;
  get googleEmail => _googleEmail;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    _notification = '';
    
    if (googleUser == null) {
      // Người dùng đã hủy đăng nhập
      throw 'login-failed';
    }
    _googleEmail = googleUser.email;
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      return user;
    }

    return null;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      // Kiểm tra xem email đã được xác minh chưa
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Email not verified. A verification link has been sent to your email.',
        );
      }

      return user;
     
  }


  Future<User?> registerWithEmail(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    _notification = '';

    if (user != null) {
      await user.sendEmailVerification();
      _notification = 'Email verification sent';
      return user;
    }
    return null;
  }

  Future<void> resetPassword(String email) async {
    _notification = '';
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }

  Future<UserModel?> getUserFromFirestore(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('Users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> saveUserToFirestore(User user, String userName) async {
    
    UserModel userModel = UserModel(
      uid: user.uid,
      email: user.email ?? googleEmail,
      signInMethod: user.email == null ? "google" : "email",
      completedLessons: '0',
      progress: '0%',
      username: userName,
      streak: '0',
      language: 'en',
      heart: '3',
      gem: '1000',
    );

    await _firestore.collection('Users').doc(user.uid).set(userModel.toMap(), SetOptions(merge: true));
  }
}
