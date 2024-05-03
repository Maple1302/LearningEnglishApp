// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:maple/helper/vaildation.dart';
import 'package:maple/models/usermodel.dart';
import 'package:maple/responsitory/auth_responsitory.dart';

class AuthViewModel extends ChangeNotifier {
 final AuthRepository _authRepository =AuthRepository();

  Stream<UserModel>? get authStateChangesWithModel =>
      _authRepository.authStateChangesWithModel;
  User? user;
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool _isLoading = false;
  AuthViewModel(){
   authStateChangesWithModel?.listen((user) {
    _currentUser = user;
   });
  }
  

  bool get isLoading => _isLoading;

  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();
  final _btnLoginSubject = BehaviorSubject<bool>();
  final _btnSignUpSubject = BehaviorSubject<bool>();
  final _usernameSubject = BehaviorSubject<String>();

  // Stream getters
  Stream<String> get emailStream => _emailSubject.stream;
  Stream<String> get passwordStream => _passwordSubject.stream;
  Stream<bool> get btnLoginStream => _btnLoginSubject.stream;
  Stream<bool> get btnSignUpStream => _btnSignUpSubject.stream;
  Stream<String> get usernameStream => _usernameSubject.stream;

  // Sink getters
  Function(String) get changeEmail => _emailSubject.sink.add;
  Function(String) get changePassword => _passwordSubject.sink.add;
  Function(bool) get changeSignUpbtn => _btnLoginSubject.sink.add;
  Function(String) get changeUsername => _usernameSubject.sink.add;
  Function(bool) get changebtnSignUp => _btnSignUpSubject.sink.add;

  // Validation logic
  Stream<String?> get isEmailValid =>
      _emailSubject.stream.map((email) => Validation().validateEmail(email));
  Stream<String?> get isPasswordValid => _passwordSubject.stream
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
  // Dispose
  @override
  void dispose() {
    super.dispose();
    _emailSubject.close();
    _passwordSubject.close();
    _btnLoginSubject.close();
    _btnSignUpSubject.close();
    _usernameSubject.close();
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      _currentUser = null;
      _isLoading = true;
      notifyListeners();
      final user =
          await _authRepository.signInWithEmailAndPassword(email, password);
      _isLoading = false;
      notifyListeners();
      if (user != null) {
        if (_authRepository.noti != "") {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(_authRepository.noti)));
          _currentUser = null;
        } else {
          _currentUser = user;
        }
      } else {
        _currentUser = null;
      }
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future registerWithEmailAndPassword(String email, String password,
      String username, BuildContext context) async {
    try {
      _currentUser = null;
      _isLoading = true;
      notifyListeners();
      await _authRepository.registerWithEmailAndPassword(
          email, password, username);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_authRepository.noti)));
      // _currentUser = user;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future signInWithGoogleAccount(BuildContext context) async {
    try {
      _currentUser = null;
      final user = await _authRepository.signInWithGoogleAccount();
      _currentUser = user;
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      _currentUser = null;
      _isLoading = true;
      notifyListeners();
      await _authRepository.signOut();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
