import 'package:flutter/material.dart';




class ManagerLessonScreen extends StatelessWidget {
  const ManagerLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Lesson'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle menu press
          },
        ),
      ),
      body: Container(
        color: Colors.grey[300],
        child: const Column(
          children: [
            StatisticsCard(
              title: 'Level 1',
              subtitle: 'Section: 4\nTitle',
              icon: Icons.person,
            ),
            StatisticsCard(
              title: 'Level 2',
              subtitle: 'Section: 6\nTitle',
              icon: Icons.person,
            ),
            StatisticsCard(
              title: 'Other',
              subtitle: 'Revenue: 15k \$\nTitle',
              icon: Icons.person,
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const StatisticsCard({super.key, 
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
         color: Colors.white,
         shadowColor: Colors.grey,
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(icon),
          ),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}