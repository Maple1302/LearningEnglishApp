import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maple/firebase_options.dart';
import 'package:maple/views/home/home.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
import 'package:maple/views/auth/sign_in_view.dart';
import 'package:maple/views/auth/sign_up_view.dart';
import 'package:maple/views/lessons/hearingcheck.dart';
import 'package:maple/views/questions/speech_check.dart';
import 'package:maple/views/questions/questions_screen.dart';
import 'package:provider/provider.dart';

//Material app
//scaffold full display
//appbar
//image
//decription image
//progress
//richtext
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // runApp( ChangeData());
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primaryColor: Colors.blue, 
      ),
    home: const QuestionsScreen(),
  ));
}
//runApp(const ChangeData());

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) =>const SignInView(), // Màn hình đăng nhập là màn hình mặc định       
          '/home': (context) => const Home(),
          '/signup': (context) => const SignUpView(),
          '/speechcheck':(context) => const PronunciationCheckView(sampleText: '',),
          '/hearingcheck':(context) =>  const HearingCheckView(),
          QuestionsScreen.routeName:(context) =>const QuestionsScreen(),
        },
      ),
    );
  }
}
