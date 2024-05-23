import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:maple/utils/constants.dart';
import 'package:provider/provider.dart';

import 'package:maple/viewmodels/auth_viewmodel.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmFocusNode = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  void goToHomePage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Text(
                      'Welcome!\nCreate an Account',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    StreamBuilder<String?>(
                      stream: authViewModel.isUserNameValid,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: _usernameController,
                          focusNode: _usernameFocusNode,
                          onChanged: authViewModel.changeUsername,
                          style: TextStyle(
                            color: _usernameFocusNode.hasFocus
                                ? Colors.white
                                : Colors.black,
                          ),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.person),
                            iconColor: HexColor("#b7d7d3"),
                            labelText: 'Tên tài khoản',
                            labelStyle: TextStyle(
                              color: _usernameFocusNode.hasFocus
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
                    const SizedBox(height: 5),
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
                    const SizedBox(height: 5),
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
                    const SizedBox(height: 5),
                    TextField(
                      controller: _passwordConfirmController,
                      focusNode: _passwordConfirmFocusNode,
                      obscureText: true,
                     
                      style: TextStyle(
                        color: _passwordConfirmFocusNode.hasFocus
                            ? Colors.white
                            : Colors.black,
                      ),
                      decoration: InputDecoration(
                        icon: const Icon(Icons.password),
                        iconColor: _passwordConfirmFocusNode.hasFocus
                            ? HexColor("#b7d7d3")
                            : Colors.black,
                        labelText: 'Nhập lại mật khẩu',
                        labelStyle: TextStyle(
                          color: _passwordConfirmFocusNode.hasFocus
                              ? Colors.white
                              : Colors.black,
                        ),
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
                    ),
                    const Spacer(),
                    const SizedBox(height: 24),
                    StreamBuilder<bool>(
                      stream: authViewModel.isButtonSignUpEnabled,
                      builder: (context, snapshot) {
                        return SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: snapshot.data == true
                                  ? () async {
                                      final email = _emailController.text;
                                      final password = _passwordController.text;
                                      final username = _usernameController.text;
                                      try {
                                        await authViewModel.registerWithEmail(
                                            email, password, username);
                                        if (authViewModel.errorMessage !=
                                            null) {
                                          showMyDialog(
                                              authViewModel.errorMessage!);
                                          if (authViewModel.errorMessage ==
                                              emailVerificationSent) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              Navigator.pushReplacementNamed(
                                                  context, '/');
                                            });
                                          }
                                        }
                                        if (authViewModel.user != null) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            Navigator.pushReplacementNamed(
                                                context, '/home');
                                          });
                                        }
                                      } catch (e) {
                                        showMyDialog(e.toString());
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                disabledBackgroundColor: Colors.grey,
                                disabledForegroundColor: Colors.black54,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: const Text("Sign Up"),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    
                    Visibility(
                      visible: !isKeyboardOpen,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          child: Text.rich(
                            TextSpan(
                              text: "Bạn đã có tài khoản? ",
                              style: const TextStyle(color: Colors.black,fontSize: 16),
                              children: [
                                TextSpan(
                                  text: 'Đăng nhập',
                                  style: const TextStyle(color: Colors.white,fontSize: 16),
                                  onEnter: (event) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Navigator.pushReplacementNamed(
                                          context, '/');
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
          ),
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
