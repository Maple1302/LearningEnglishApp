import 'package:flutter/material.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
import 'package:maple/views/admin/user_profile.dart';
import 'package:maple/views/auth/login_view.dart';
import 'package:maple/views/maps/map_list_screen.dart';

import 'package:provider/provider.dart';


class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MapListScreen(),
     const ProfileScreen(),
    
    
    // QuestionListScreen(lesson: LessonModel(id: '', description: 'description', question: QuestionModel(id: '', completeConversationQuestions: completeConversationQuestions, completeMissingSentenceQuestions: completeMissingSentenceQuestions, imageSelectionQuestions: imageSelectionQuestions, listeningQuestions: listeningQuestions, matchingPairQuestions: matchingPairQuestions, pronunciationQuestions: pronunciationQuestions, translationScreens: translationScreens)),),
  ];
  static BottomNavigationBarItem getBottomNavItem(String imageIcon) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(5),
        child: Image.asset(
          imageIcon,
          height: 30,
        ),
      ), // Biểu tượng ngôi nhà
      label: '', // Nhãn trống
      activeIcon: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            border: Border.all(color: Colors.blue, width: 3),
            borderRadius: BorderRadius.circular(10)),
        child: Image.asset(
          imageIcon,
          height: 30,
        ),
      ),
    );
  }

  final List<BottomNavigationBarItem> bottomnavigationBarItems = [
    getBottomNavItem('images/house.png'),
    getBottomNavItem('images/woman.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.user;
    PageController pageController = PageController();

    void onItemTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
      pageController.animateToPage(index,
          duration: const Duration(microseconds: 1), curve: Curves.ease);
    }

    return user != null
        ? Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: bottomnavigationBarItems,
              currentIndex: _currentIndex,
              selectedItemColor: Colors.blue,
              onTap: onItemTapped,
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              children: _pages,
            ),
          )
        : const LoginView();
  }
  Widget itemAppBar(String image, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(image, height: 25),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.user;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (user != null) ...[
            Text('Username: ${user.username ?? "N/A"}'),
            Text('Email: ${user.email ?? "N/A"}'),
            Text('Completed Lessons: ${user.completedLessons}'),
            Text('Progress: ${user.progress}'),
          ],
          ElevatedButton(
            onPressed: () {
              authViewModel.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text("Đăng xuất"),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.user;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (user != null) ...[
            Text('Username: ${user.username ?? "N/A"}'),
            Text('Email: ${user.email ?? "N/A"}'),
            Text('Completed Lessons: ${user.completedLessons}'),
            Text('Progress: ${user.progress}'),
            Text('Streak: ${user.streak}'),
            Text('Language: ${user.language}'),
            Text('Heart: ${user.heart}'),
            Text('Gem: ${user.gem}'),
            Text('SignInMethod: ${user.signInMethod}'),
          ],
        ],
      ),
    );
  }
}
