import 'package:flutter/material.dart';
import 'package:maple/screen/levels.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}
class HomePage extends StatelessWidget {
  
  const HomePage({super.key});
  
  @override
  
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Page'),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(''),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings Page'),
    );
  }
}
class _HomeState extends State<Home> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
   const Levels(),
  ];

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    print(authViewModel.currentUser?.uid);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                'images/flag_america.png',
                height: 35,
              ),
              itemAppBar('images/fire.png', authViewModel.currentUser?.email ?? ""),
              itemAppBar('images/gem.png', ' 1142'),
              itemAppBar('images/heart.png', ' 4')
            ],
          ),
        ),
      body:_pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex ,
        
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        items: [
          navBarItem(image:'images/house.png', activeImage:'images/house.png'),
          navBarItem(image:'images/mouth.png', activeImage:'images/mouth.png'),
          navBarItem(image:'images/dumbbell.png', activeImage:'images/dumbbell.png'),
          navBarItem(image:'images/treasure.png', activeImage:'images/treasure.png'),
          navBarItem(image:'images/woman.png', activeImage:'images/woman.png'),
        ],
        onTap: (value) {
          setState(() {
            _currentIndex = value;
            
          });
        },
        
      ),
    );
  }
  BottomNavigationBarItem navBarItem({required String image, required String activeImage}){
    return BottomNavigationBarItem(
      icon: Image.asset(image,height: 30),
      activeIcon: Image.asset(activeImage,height: 30),
      label: ''
      );
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
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
