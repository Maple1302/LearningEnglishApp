import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:maple/helper/vaildation.dart';
import 'package:maple/models/user_model.dart';
import 'package:maple/repositories/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  Stream<User?> get authStateChanges => _authRepository.authStateChanges;
  UserModel? _user;
  String? errorMessage;
  bool _isLoggedIn = false;
  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();
  final _passwordConfirmSubject = BehaviorSubject<String>();
  final _btnLoginSubject = BehaviorSubject<bool>();
  final _btnSignUpSubject = BehaviorSubject<bool>();
  final _btnResetPasswordSubject = BehaviorSubject<bool>();
  final _usernameSubject = BehaviorSubject<String>();

  // Stream getters
  Stream<String> get emailStream => _emailSubject.stream;
  Stream<String> get passwordStream => _passwordSubject.stream;
  Stream<String> get passwordconfirmStream => _passwordConfirmSubject.stream;
  Stream<bool> get btnLoginStream => _btnLoginSubject.stream;
  Stream<bool> get btnResetPasswordStream => _btnResetPasswordSubject.stream;
  Stream<bool> get btnSignUpStream => _btnSignUpSubject.stream;
  Stream<String> get usernameStream => _usernameSubject.stream;

  // Sink getters
  Function(String) get changeEmail => _emailSubject.sink.add;
  Function(String) get changePassword => _passwordSubject.sink.add;
  Function(String) get changePasswordConfirm =>
      _passwordConfirmSubject.sink.add;
  Function(bool) get changeSignUpbtn => _btnLoginSubject.sink.add;
  Function(bool) get changeResetPasswordbtn =>
      _btnResetPasswordSubject.sink.add;
  Function(String) get changeUsername => _usernameSubject.sink.add;
  Function(bool) get changebtnSignUp => _btnSignUpSubject.sink.add;

  // Validation logic
  Stream<String?> get isEmailValid =>
      _emailSubject.stream.map((email) => Validation().validateEmail(email));
  Stream<String?> get isPasswordValid => _passwordSubject.stream
      .map((password) => Validation().validatePassword(password));
  Stream<String?> get isPasswordMatched => _passwordConfirmSubject.stream
      .map((password) => Validation().validatePassword(password));
  Stream<String?> get isUserNameValid => _usernameSubject.stream
      .map((username) => Validation().validateUsername(username));

  Stream<bool> get isButtonLoginEnabled =>
      Rx.combineLatest([isEmailValid], (List<Object?> emailValid) {
        return emailValid.first == null;
      });

  Stream<bool> get isButtonSignUpEnabled => Rx.combineLatest3(
        isEmailValid,
        isPasswordValid,
        isUserNameValid,
        (emailValid, passwordValid, userNameValid) =>
            emailValid == null &&
            passwordValid == null &&
            userNameValid == null,
      );

  @override
  void dispose() {
    super.dispose();
    _emailSubject.close();
    _passwordSubject.close();
    _btnLoginSubject.close();
    _btnSignUpSubject.close();
    _usernameSubject.close();
  }

  AuthViewModel() {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();
    authStateChanges.listen((user) async {
      _isLoading = true;
      if (user != null) {
        _user = await _authRepository.getUserFromFirestore(user.uid);
        if (_user == null) {
          await Future.delayed(const Duration(seconds: 2));
          // Handle case where user data is not found in Firestore
          _isLoggedIn = false;
          _isLoading = false;
          notifyListeners();
        } else {
           await Future.delayed(const Duration(seconds: 2));
          _isLoggedIn = true;
          _isLoading = false;
          notifyListeners();
        }
      } else {
         await Future.delayed(const Duration(seconds: 2));
        _isLoggedIn = false;
        _isLoading = false;
        notifyListeners();
      }
       await Future.delayed(const Duration(seconds: 2));
      _isLoading = false;
      notifyListeners();
    });
    // _isLoading = false;
    //notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      errorMessage = null;
      notifyListeners();
      User? user = await _authRepository.signInWithGoogle();
      if (user != null) {
        await _authRepository.saveUserToFirestore(
            user, user.displayName ?? 'user');
        _user = await _authRepository.getUserFromFirestore(user.uid);
        _isLoggedIn = true;
      }
      _isLoading = false;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage =
              "Tài khoản đã được sử dụng với phương thức đăng nhập khác";
          _isLoading = false;
          break;
        case 'invalid-credential':
          errorMessage = "Chứng chỉ không hợp lệ";
          _isLoading = false;
          break;
        case 'email-not-verified':
          errorMessage = "email chưa được xác thực";
          _isLoading = false;
          break;
        default:
          // Handle other Firebase errors
          break;
      }
    } catch (e) {
      // Handle other errors such as network issues
      errorMessage = 'Error signing in with Google: $e';
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      errorMessage = null;
      notifyListeners();
      User? user = await _authRepository.signInWithEmail(email, password);
      if (user != null) {
        _user = await _authRepository.getUserFromFirestore(user.uid);
        _isLoggedIn = true;
      }
      _isLoading = false;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      switch (e.code) {
        case 'invalid-email':
          errorMessage = " Email không tồn tại";
          _isLoading = false;
          break;
        case 'email-not-verified':
          errorMessage = " Email chưa được xác thực";
          _isLoading = false;
          break;
        case 'user-disabled':
          errorMessage = " Email đang bị vô hiệu hóa";
          _isLoading = false;
          break;
        case 'user-not-found':
          errorMessage = " Tài khoản không tồn tại";
          _isLoading = false;
          break;
        case 'wrong-password':
          errorMessage = " Mật khẩu sai vui lòng kiểm tra lại";
          _isLoading = false;
          break;
        default:
          errorMessage = " Lỗi không xác định";
          _isLoading = false;
          break;
      }
    } catch (e) {
      errorMessage = "Lỗi:${e.toString()}";
      _isLoading = false;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> registerWithEmail(
      String email, String password, String userName) async {
    try {
      _isLoading = true;
      errorMessage = null;
      notifyListeners();
      User? user = await _authRepository.registerWithEmail(email, password);
      if (user != null) {
        await _authRepository.saveUserToFirestore(user, userName);
        _user = await _authRepository.getUserFromFirestore(user.uid);
        _isLoggedIn = true;
      }
      _isLoading = false;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = " Email đã được sử dụng";
          _isLoading = false;
          break;
        case 'invalid-email':
          errorMessage = " Email không tồn tại";
          _isLoading = false;
          break;
        case 'weak-password':
          errorMessage = " Mật khẩu quá ngắn";
          _isLoading = false;
          break;
        default:
          errorMessage = " Lỗi không xác định";
          _isLoading = false;
          break;
      }
    } catch (e) {
      // Handle other errors such as network issues
      errorMessage = " Lỗi kết nối, vui lòng thử lại sau";
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      errorMessage = null;
      await _authRepository.resetPassword(email);
      _isLoading = false;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors

      switch (e.code) {
        case 'invalid-email':
          errorMessage = " Email đã không tồn tại";
          _isLoading = false;
          break;
        case 'user-not-found':
          errorMessage = " Tài khoản không tồn tại";
          _isLoading = false;
          break;
        default:
          errorMessage = " Lỗi kết nối.\nVui lòng thử lại sau";
          _isLoading = false;
          break;
      }
    } catch (e) {
      // Handle other errors
      errorMessage = " Lỗi kết nối.\nVui lòng thử lại sau";
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      errorMessage = null;
      await _authRepository.signOut();
      _user = null;
      _isLoggedIn = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
