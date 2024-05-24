import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maple/helper/vaildation.dart';
import 'package:maple/responsitories/auth_responsitory.dart';
import 'package:maple/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  Stream<UserModel>? get authStateChangesWithModel =>
      _authRepository.authStateChangesWithModel;
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
    notifyListeners();
    authStateChangesWithModel?.listen((event) {
       
      _user = event;
      _isLoggedIn = _user != null;
      _isLoading = false;
       errorMessage = null;
       notifyListeners();
    });
    _isLoading = false;
      notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();
      _user = await _authRepository.signInWithGoogle();
      _isLoading = false;
      errorMessage = null;
      // On success:
      _isLoggedIn = true;
    } catch (e) {
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;

      _user = await _authRepository.signInWithEmail(email, password);

      if (_user != null) {
        errorMessage = null;
        // On success:
        _isLoggedIn = true;
        notifyListeners();
      }

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "Người dùng không tồn tại!\nHoặc email này phải đăng nhập với phương thức khác";

          break;
        case 'wrong-password':
          errorMessage = "Mật khẩu sai!";
          break;
        default:
          errorMessage = "Lỗi không xác định. Vui lòng thử lại sau!";
          break;
      }
    } catch (e) {
      switch (e) {
        case 'email-not-verified':
          errorMessage =
              "Email chưa được xác thực.\nVui lòng xác thực email trước khi đăng nhập!";
          _isLoggedIn = false;
          _user = null;
          await _authRepository.signOut();
          break;
        case 'user-not-found':
          _isLoggedIn = false;
          _user = null;
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> registerWithEmail(
      String email, String password, String userName) async {
    try {
      _isLoading = true;
      _user =
          await _authRepository.registerWithEmail(email, password, userName);
      if (_authRepository.notification != '') {
        errorMessage = _authRepository.notification;
      }
      errorMessage = null;
      _isLoading = false;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "Email này đã được sử dụng bởi tài khoản khác!";
          break;
        case 'weak-password':
          errorMessage = "Mật khẩu quá ngắn!";
          break;
        default:
          errorMessage = "Lỗi không xác định!";
          break;
      }
      _isLoading = false;
    } catch (e) {
      switch (e) {
        case 'user-not-found':
          _isLoggedIn = false;
          _user = null;
      }
    }
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      await _authRepository.resetPassword(email);
      _isLoading = false;
      if (_authRepository.notification != '') {
        errorMessage = _authRepository.notification;
      } else {
        errorMessage =
            "Email reset mật khẩu đã được gửi!\nVui lòng kiểm tra email để đặt lại mật khẩu!";
      }
    } on FirebaseAuthException catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      await _authRepository.signOut();
      _isLoading = false;
      _user = null;
      errorMessage = null;
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      switch (e) {
        case 'user-not-found':
          _isLoggedIn = false;
          _user = null;
      }
      _isLoading = false;
    }
  }
}
