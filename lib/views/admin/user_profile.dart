import 'package:flutter/material.dart';
import 'package:maple/models/user_model.dart';
import 'package:maple/utils/constants.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    UserModel? user = authViewModel.user;
    return user != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue[100],
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Avatar and basic info
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.green,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.brown,
                            child: ClipOval(
                              child: Image.network(
                                user.urlAvatar,
                                width:
                                    90, // Ensure the image fits within the circle
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return const Icon(Icons.person);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.username!,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(user.email!),
                        Text('Đã tham gia ${user.dateCreate}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/flag_america.png', width: 24),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Stats
                   Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const StatCard(
                              icon: 'images/fire.png',
                              value: '1',
                              label: 'Ngày streak',
                            ),
                            StatCard(
                              icon: 'images/score_icon.png',
                              value:  user.kN,
                              label: 'Tổng KN',
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StatCard(
                              icon: 'images/trophy.png',
                              value: 'Lam Ngọc',
                              label: 'Giải đấu hiện tại',
                            ),
                            StatCard(
                              icon: 'images/medal.png',
                              value: '4',
                              label: 'Số lần đạt top 3',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Additional achievements or other sections can go here
                ],
              ),
            ),
          )
        : Container();
  }
}

class StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;

  const StatCard(
      {super.key,
      required this.icon,
      required this.value,
      required this.label,
      this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      width: 140,height: 140,
      decoration: BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.circular(15),border:Border.all(color: Colors.grey,width: 2)),
        child: Column(
      children: [
        Image.asset(
          icon,
          width: 40,
          height: 40,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    ));
  }
}
