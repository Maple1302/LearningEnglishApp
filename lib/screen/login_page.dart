import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maple/views/home/home.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text("Google Sign In"),
      ),
      body: _user != null ? _userInfor() : _googleSignInButton(),
    );
  }

  Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: "Sign in with Google",
          onPressed: _handleGoogleSignIn,
        ),
      ),
    );
  }

  Widget _userInfor() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        
        children: [
          Container(
            
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(_user!.photoURL!),
                 fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 30,),
          Text(_user!.email!),
          Text(_user!.displayName ?? ""),
          //Text(_user!.photoURL!),
          ElevatedButton(onPressed: _auth.signOut, child: const Text("Sign Out"))
        ],
      ),
    );
      
  }
  void goToHomePage(){
    Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          
  }
  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(googleAuthProvider);
      goToHomePage();
    } catch (error) {
      rethrow;
    }
  }
}
