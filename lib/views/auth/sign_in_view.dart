import 'package:flutter/material.dart';
import 'package:maple/models/usermodel.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final authViewModel = Provider.of<AuthViewModel>(context);

    void goToHomePage() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }

    Widget googleSignInButton() {
      return Center(
        child: SizedBox(
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor, // Màu nền của ứng dụng
              borderRadius: BorderRadius.circular(10), // Độ cong của góc
            ),
            child: SignInButton(
              Buttons.google,
              text: "Đăng nhập với Google",
              onPressed: () async {
                await authViewModel.signInWithGoogleAccount(context);
                if (authViewModel.currentUser != null) {
                  goToHomePage();
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Độ cong của góc
                side: const BorderSide(
                    color: Colors.grey, width: 3), // Đường viền
              ),
            ),
          ),
        ),
      );
    }

    return Stack(children: [
      Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AuthViewModel>(
            builder: (context, userViewModel, _) {
              return StreamBuilder<UserModel>(
                stream: userViewModel.authStateChangesWithModel,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasError) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Đăng nhập",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w900),
                          ),
                          StreamBuilder<String?>(
                            stream: authViewModel.isEmailValid,
                            builder: (context, snapshot) {
                              return TextFormField(
                                controller: emailController,
                                onChanged: authViewModel.changeEmail,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email),
                                  labelText: 'Email',
                                  errorText: snapshot.data,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            onChanged: authViewModel.changePassword,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.password),
                              labelText: 'Mật Khẩu',
                            ),
                          ),
                          const SizedBox(height: 24),
                          StreamBuilder<bool>(
                            stream: authViewModel.isButtonLoginEnabled,
                            builder: (context, snapshot) {
                              return Center(
                                child: SizedBox(
                                  height: 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor, // Màu nền của ứng dụng
                                      borderRadius: BorderRadius.circular(
                                          10), // Độ cong của góc
                                      border: Border.all(
                                        color: Colors.grey, // Màu của viền
                                        width: 1, // Độ rộng của viền
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: snapshot.data == true
                                          ? () async {
                                              final email =
                                                  emailController.text;
                                              final password =
                                                  passwordController.text;
                                              await authViewModel
                                                  .signInWithEmailAndPassword(
                                                      email, password, context);
                                              if (authViewModel.currentUser !=
                                                  null) {
                                                goToHomePage();
                                              }
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                          disabledBackgroundColor: Colors.grey,
                                          disabledForegroundColor:
                                              Colors.black54,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10), // Độ cong của góc
                                            side: const BorderSide(
                                                color: Colors.grey,
                                                width: 2), // Đường viền
                                          )),
                                      child: const Text("Đăng nhập"),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "Hoặc",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          googleSignInButton(),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            // Chữ hoặc widget mà bạn muốn người dùng click để chuyển màn hình
                            child: const Text(
                              'Bạn chưa có tài khoản ?',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color.fromARGB(255, 79, 79, 82)),
                            ),
                            onTap: () {
                              // Sử dụng Navigator để điều hướng đến SecondScreen
                              Navigator.pushReplacementNamed(
                                  context, '/signup');
                            },
                          ),
                        ],
                      );
                    }

                    UserModel? userModel = snapshot.data;

                    if (userModel != null) {
                      goToHomePage();
                      return Container();
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Đăng nhập",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w900),
                          ),
                          StreamBuilder<String?>(
                            stream: authViewModel.isEmailValid,
                            builder: (context, snapshot) {
                              return TextFormField(
                                controller: emailController,
                                onChanged: authViewModel.changeEmail,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email),
                                  labelText: 'Email',
                                  errorText: snapshot.data,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            onChanged: authViewModel.changePassword,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.password),
                              labelText: 'Mật Khẩu',
                            ),
                          ),
                          const SizedBox(height: 24),
                          StreamBuilder<bool>(
                            stream: authViewModel.isButtonLoginEnabled,
                            builder: (context, snapshot) {
                              return Center(
                                child: SizedBox(
                                  height: 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor, // Màu nền của ứng dụng
                                      borderRadius: BorderRadius.circular(
                                          10), // Độ cong của góc
                                      border: Border.all(
                                        color: Colors.grey, // Màu của viền
                                        width: 1, // Độ rộng của viền
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: snapshot.data == true
                                          ? () async {
                                              final email =
                                                  emailController.text;
                                              final password =
                                                  passwordController.text;
                                              await authViewModel
                                                  .signInWithEmailAndPassword(
                                                      email, password, context);
                                              if (authViewModel.currentUser !=
                                                  null) {
                                                goToHomePage();
                                              }
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                          disabledBackgroundColor: Colors.grey,
                                          disabledForegroundColor:
                                              Colors.black54,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10), // Độ cong của góc
                                            side: const BorderSide(
                                                color: Colors.grey,
                                                width: 2), // Đường viền
                                          )),
                                      child: const Text("Đăng nhập"),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "Hoặc",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          googleSignInButton(),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            // Chữ hoặc widget mà bạn muốn người dùng click để chuyển màn hình
                            child: const Text(
                              'Bạn chưa có tài khoản ?',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color.fromARGB(255, 79, 79, 82)),
                            ),
                            onTap: () {
                              // Sử dụng Navigator để điều hướng đến SecondScreen
                              Navigator.pushReplacementNamed(
                                  context, '/signup');
                            },
                          ),
                        ],
                      );
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              );
            },
          ),
        ),
      ),
      if (authViewModel.isLoading)
        Container(
          color: Colors.black54, // Màu làm mờ
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
    ]);
  }
}
