import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:maple/firebase_options.dart';
import 'package:maple/models/questionmodel.dart';
import 'package:maple/viewmodels/lesson_viewmodel.dart';
import 'package:maple/viewmodels/map_viewmodel.dart';
import 'package:maple/viewmodels/question_viewmodel.dart';
import 'package:maple/viewmodels/section_viewmodel.dart';
import 'package:maple/viewmodels/topic_viewmodel.dart';

import 'package:maple/views/auth/reset_password_view.dart';
import 'package:maple/views/home/home.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
import 'package:maple/views/auth/login_view.dart';
import 'package:maple/views/auth/register_view.dart';


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
        ChangeNotifierProvider(
          create: (_) => QuestionViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => LessonViewModel(),
        ),ChangeNotifierProvider(
          create: (_) => TopicViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => SectionViewModel(),
        ),
         ChangeNotifierProvider(
          create: (_) => MapViewModel(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) =>
              const Home(), // Màn hình đăng nhập là màn hình mặc định
          '/loginview': (context) => const LoginView(),
          '/signup': (context) => const RegisterView(),
          
          ResultScreen.routeName: (context) =>
              const ResultScreen(score: 0, rateCompleted: 0, finalTime: ''),
          ResetPasswordView.routeName: (context) => const ResetPasswordView(),
          QuestionScreen.routeName: (context) =>  QuestionScreen(questionModel:QuestionModel(answersCardQuestions: [], id: '', completeConversationQuestions: [], completeMissingSentenceQuestions: [], imageSelectionQuestions: [], listeningQuestions: [], matchingPairQuestions: [], pronunciationQuestions: [], translationQuestions: [],))
        },
      ),
    );
  }
}
