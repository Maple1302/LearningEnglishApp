import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';


import 'package:maple/views/auth/login_view.dart';

import 'package:provider/provider.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';


class ResetPasswordView extends StatelessWidget {
  static const String routeName = "/resetpassword";

  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    final FocusNode emailFocusNode = FocusNode();

    final TextEditingController emailController = TextEditingController();
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    void goToLoginPage() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
    }
void showErrorDialog(String message) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Lỗi'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Đồng ý'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5),
                    StreamBuilder<String?>(
                      stream: authViewModel.isEmailValid,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: emailController,
                          focusNode: emailFocusNode,
                          onChanged: authViewModel.changeEmail,
                          style: TextStyle(
                            color: emailFocusNode.hasFocus
                                ? Colors.white
                                : Colors.black,
                          ),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.email),
                            iconColor: HexColor("#b7d7d3"),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: emailFocusNode.hasFocus
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
                    const SizedBox(height: 24),
                    StreamBuilder<bool>(
                      stream: authViewModel.isButtonLoginEnabled,
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
                                      final email = emailController.text;

                                      try {
                                        await authViewModel
                                            .resetPassword(email);
                                        if (authViewModel.errorMessage !=
                                            null) {
                                          showErrorDialog(
                                              authViewModel.errorMessage!);
                                        }
                                      } catch (e) {
                                        showErrorDialog(e.toString());
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
                              child: const Text("Xác nhận"),
                            ),
                          ),
                        );
                      },
                    ),
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
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                              children: [
                                TextSpan(
                                  text: 'Đăng nhập',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  onEnter: (event) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Navigator.pushReplacementNamed(
                                          context, '/loginview');
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
