import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maple/models/user_model.dart';
import 'package:maple/models/usermodelmapper.dart';
import 'package:maple/utils/constants.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _notification = '';
  get notification => _notification;

  final UserModelMapper _userModelMapper = UserModelMapper();
  Stream<UserModel> get authStateChangesWithModel =>
      _firebaseAuth.authStateChanges().transform(_userModelMapper.userMapper);

  Future<UserModel?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    _notification = '';

    if (googleUser == null) {
      // Người dùng đã hủy đăng nhập
      throw 'login-failed';
      //return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    User? user = userCredential.user;
    String? userName = user?.displayName ?? 'user';
    String email = googleUser.email;

    if (user != null) {
      return _saveUserToFirestore(user, userName, email);
    }

    return null;
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    _notification = '';
    if (user != null && user.emailVerified) {
      return _getUserFromFirestore(user.uid);
    }
    if (user != null && !user.emailVerified) {
      throw 'email-not-verified';
    }
    return null;
  }

  Future<UserModel?> registerWithEmail(
      String email, String password, String userName) async {
    bool isGoogleMethod = await isGoogleSignIn(email);
    if (!isGoogleMethod) {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      _notification = '';
      if (user != null) {
        await user.sendEmailVerification();
        _notification = emailVerificationSent;
        return _saveUserToFirestore(user, userName, '');
      }
    }
    else{
      _notification = 'Email đã được sử dụng để đăng nhập bằng tài khoản google ';
    }

    return null;
  }

  Future<bool> resetPassword(String email) async {
    _notification = '';
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users') // Thay 'users' bằng tên collection của bạn
        .where('email', isEqualTo: email)
        .get();
    bool isEmailMethod = await isEmailSignIn(email);

    if (querySnapshot.docs.isNotEmpty && isEmailMethod) {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } else {
      _notification = emailNotFound;
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  Future<bool> isEmailVerified() async {
    _notification = '';
    User? user = _firebaseAuth.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }

  Future<UserModel?> _saveUserToFirestore(
      User user, String userName, String email) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('Users').doc(user.uid).get();
    UserModel userModel;
    _notification = '';
    if (documentSnapshot.exists) {
      var userData = documentSnapshot.data() as Map<String, dynamic>;
      userModel = UserModel.fromMap(userData);
    } else {
      userModel = UserModel(
        uid: user.uid,
        email: user.email ?? email,
        signInMethod: user.email == null ? "google" : "email",
        completedLessons: '0',
        progress: '0%',
        username: userName,
        streak: '0',
        language: 'en',
        heart: '3',
        gem: '1000',
      );
      await _firestore
          .collection('Users')
          .doc(user.uid)
          .set(userModel.toMap(), SetOptions(merge: true));
    }

    return userModel;
  }

  Future<UserModel?> _getUserFromFirestore(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('Users').doc(uid).get();
    _notification = '';
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  } // Hàm này kiểm tra xem một email đã được đăng nhập bằng Google hay không

  Future<bool> isGoogleSignIn(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .where('signInMethod', isEqualTo: 'google')
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

// Hàm này kiểm tra xem một email đã được đăng nhập bằng email/mật khẩu hay không
  Future<bool> isEmailSignIn(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .where('signInMethod', isEqualTo: 'email')
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
