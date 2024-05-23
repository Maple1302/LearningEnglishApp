import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';

import 'package:maple/screen/login_page.dart';
import 'package:maple/utils/constants.dart';

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

    void goToLoginPage() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
    }

    Future<void> showMyDialog(String message) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button to close the dialog
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thông báo'),
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
                  if(message != emailNotFound){
                      goToLoginPage();
                  }
                  else{
                     Navigator.of(context).pop();
                  }
              
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
                                          showMyDialog(
                                              authViewModel.errorMessage!);
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
                              child: const Text("Xác nhận"),
                            ),
                          ),
                        );
                      },
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
