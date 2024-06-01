import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:maple/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _googleEmail = '';
  String _urlAvatar = '';
  String _notification = '';
  get notification => _notification;
  get googleEmail => _googleEmail;
  get urlAvatar => _urlAvatar;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    _notification = '';

    if (googleUser == null) {
      // Người dùng đã hủy đăng nhập
      throw 'login-failed';
    }
    _googleEmail = googleUser.email;
    _urlAvatar = googleUser.photoUrl!;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      return user;
    }

    return null;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = userCredential.user;

    // Kiểm tra xem email đã được xác minh chưa
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message:
            'Email chưa được xác minh. Một liên kết xác minh đã được gửi đến email của bạn.',
      );
    }

    return user;
  }

  Future<User?> registerWithEmail(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    _notification = '';

    if (user != null) {
      await user.sendEmailVerification();
      _notification = 'Email xác thực đã được gửi';
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

  Future<bool> canCompleteLesson(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('Users').doc(uid).get();
      if (doc.exists) {
        UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
        String today = DateTime.now().toIso8601String().substring(0, 10);
        if (user.lastCompletionDate == today) {
          return false;
        }
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Error checking completion status: $e');
    }
  }

  Future<void> completeLesson(String uid,String completedLesson) async {
    await _firestore.collection('Users').doc(uid).update({
      'lastCompletionDate': DateTime.now().toIso8601String().substring(0, 10),
      'completedLessons': FieldValue.increment(1),
      'streak': FieldValue.increment(1)
    });
  }

  Future<UserModel?> getUserFromFirestore(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('Users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('Users').doc(user.uid).update(user.toJson());
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  Future<void> saveUserToFirestore(User user, String userName) async {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    UserModel userModel = UserModel(
      uid: user.uid,
      email: user.email ?? googleEmail,
      signInMethod: user.email == null ? "google" : "email",
      completedLessons: '1;1;1;1',
      progress: '0%',
      username: userName,
      streak: '0',
      language: 'en',
      heart: '3',
      gem: '1000',
      dateCreate: formattedDate,
      urlAvatar: _urlAvatar,
      kN: '0',
      lastCompletionDate: '', role: 'user',
    );

    await _firestore
        .collection('Users')
        .doc(user.uid)
        .set(userModel.toJson(), SetOptions(merge: true));
  }
}
