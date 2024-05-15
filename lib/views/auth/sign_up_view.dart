import 'package:flutter/material.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<String?>(
                stream: authViewModel.isUserNameValid,
                builder: (context, snapshot) {
                  return TextFormField(
                    controller: usernameController,
                    onChanged: authViewModel.changeUsername,
                    decoration: InputDecoration(
                      labelText: 'Tên tài khoản',
                      errorText: snapshot.data,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              StreamBuilder<String?>(
                stream: authViewModel.isEmailValid,
                builder: (context, snapshot) {
                  return TextFormField(
                    controller: emailController,
                    onChanged: authViewModel.changeEmail,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: snapshot.data,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              StreamBuilder<String?>(
                stream: authViewModel.isPasswordValid,
                builder: (context, snapshot) {
                  return TextFormField(
                    controller: passwordController,
                    onChanged: authViewModel.changePassword,
                    decoration: InputDecoration(
                      labelText: 'Mật Khẩu',
                      errorText: snapshot.data,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              StreamBuilder<bool>(
                stream: authViewModel.isButtonSignUpEnabled,
                builder: (context, snapshot) {
                  return SizedBox(
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor, // Màu nền của ứng dụng
                        borderRadius:
                            BorderRadius.circular(10), // Độ cong của góc
                        border: Border.all(
                          color: Colors.grey, // Màu của viền
                          width: 1, // Độ rộng của viền
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: snapshot.data == true
                            ? () async {
                                final email = emailController.text;
                                final password = passwordController.text;
                                final username = usernameController.text;
                                try {
                                  await authViewModel
                                      .registerWithEmailAndPassword(
                                          email, password, username, context);
                                  if (authViewModel.currentUser != null) {
                                    Navigator.pushReplacementNamed(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        'home');
                                  }
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())));
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: Colors.grey,
                            disabledForegroundColor: Colors.black54,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Độ cong của góc
                              side: const BorderSide(
                                  color: Colors.grey, width: 2), // Đường viền
                            )),
                        child: const Text("Đăng Ký"),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                // Chữ hoặc widget mà bạn muốn người dùng click để chuyển màn hình
                child: const Text(
                  'Bạn đã có tài khoản ?',
                  style: TextStyle(
                      fontSize: 18.0, color: Color.fromARGB(255, 79, 79, 82)),
                ),
                onTap: () {
                  // Sử dụng Navigator để điều hướng đến SecondScreen
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          ),
        ),
        if (authViewModel.isLoading)
          Container(
            color: Colors.black54, // Màu làm mờ
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ]),
    );
  }
}
