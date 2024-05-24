import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:maple/firebase_options.dart';


import 'package:maple/views/auth/reset_password_view.dart';
import 'package:maple/views/home/home.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
import 'package:maple/views/auth/login_view.dart';
import 'package:maple/views/auth/register_view.dart';
import 'package:maple/views/lessons/hearingcheck.dart';

import 'package:maple/views/questions/questions_screen.dart';
import 'package:maple/views/questions/result_screen.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyHome());
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
          
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) =>
              const Home(), // Màn hình đăng nhập là màn hình mặc định
          '/loginview': (context) => const LoginView(),
          '/signup': (context) => const RegisterView(),
          //'/speechcheck':(context) => const PronunciationCheckView(sampleText: '',mean: '',),
          '/hearingcheck': (context) => const HearingCheckView(),
          ResultScreen.routeName: (context) =>
              const ResultScreen(score: 0, rateCompleted: 0, finalTime: ''),
          ResetPasswordView.routeName: (context) => const ResetPasswordView(),
          QuestionScreen.routeName: (context) => const QuestionScreen()
        },
      ),
    );
  }
  
}
