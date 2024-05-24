import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:maple/views/auth/reset_password_view.dart';
import 'package:provider/provider.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authViewModel.isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    void goToHomePage() {
      
        Navigator.pushReplacementNamed(context, '/home');
      
    }

    Future<void> showMyDialog(String message) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cảnh báo'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Widget googleSignInButton() {
      return Center(
        child: SizedBox(
          height: 55,
          width: double.infinity, // Set chiều rộng là không giới hạn
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SignInButton(
              Buttons.google,
              text: "Đăng nhập với Google",
              onPressed: () async {
                await authViewModel.signInWithGoogle();
                if (authViewModel.user != null) {
                  goToHomePage();
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.blue,
                  width: 3,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: CustomPaint(
                painter: BackgroundPainter(),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'AYA-KO',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Hello there!\nWelcome Back',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(
                      height: 19,
                    ),
                    StreamBuilder<String?>(
                      stream: authViewModel.isEmailValid,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          onChanged: authViewModel.changeEmail,
                          style: TextStyle(
                            color: _emailFocusNode.hasFocus
                                ? Colors.white
                                : Colors.black,
                          ),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.email),
                            iconColor: HexColor("#b7d7d3"),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: _emailFocusNode.hasFocus
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            errorText: snapshot.data,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<String?>(
                      stream: authViewModel.isPasswordValid,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: true,
                          onChanged: authViewModel.changePassword,
                          style: TextStyle(
                            color: _passwordFocusNode.hasFocus
                                ? Colors.white
                                : Colors.black,
                          ),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.password),
                            iconColor: HexColor("#b7d7d3"),
                            labelText: 'Mật khẩu',
                            labelStyle: TextStyle(
                              color: _passwordFocusNode.hasFocus
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            errorText: snapshot.data,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        );
                      },
                    ),
                    // const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushReplacementNamed(
                                context, ResetPasswordView.routeName);
                          });
                        },
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const Spacer(),
                    StreamBuilder<bool>(
                      stream: authViewModel.isButtonLoginEnabled,
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: snapshot.data == true
                                ? () async {
                                    final email = _emailController.text;
                                    final password = _passwordController.text;
                                    await authViewModel.signInWithEmail(
                                        email, password);
                                    if (authViewModel.errorMessage != null) {
                                      // ignore: use_build_context_synchronously
                                      showMyDialog(authViewModel.errorMessage!);
                                    } else if (authViewModel.user != null) {
                                      goToHomePage();
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Đăng nhập với email',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        );
                      },
                    ),

                    Visibility(
                        visible: !isKeyboardOpen,
                        child: Column(
                          children: [
                            const Row(
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    "Hoặc",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            googleSignInButton()
                          ],
                        )),
                    const Spacer(),
                    Visibility(
                      visible: !isKeyboardOpen,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          child: Text.rich(
                            TextSpan(
                              text: "Bạn chưa có tài khoản? ",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                              children: [
                                TextSpan(
                                  text: 'Đăng ký',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  onEnter: (event) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Navigator.pushReplacementNamed(
                                          context, '/signup');
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            
            child: authViewModel.isLoading
                ? Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlueAccent
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.25)
      ..quadraticBezierTo(
          size.width * 0.5, size.height * 0.5, size.width, size.height * 0.25)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
