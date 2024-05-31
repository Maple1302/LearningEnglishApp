import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Text(
              'Statistics',
              style: TextStyle(fontSize: 40),
            ),
            Spacer(),
            StatisticsCard(
                title: 'User',
                subtitle: 'Online: 15k/45k',
                iconFath: 'images/user-manager.png',
                progress: ProgressIndicatorCustom(progress: 70)),
            StatisticsCard(
                title: 'Learning Progress',
                subtitle: 'Level average : 3/5',
                iconFath: 'images/learning-manager.png',
                progress: ProgressIndicatorCustom(
                  progress: 80,
                )),
            StatisticsCard(
                title: 'Other',
                subtitle: 'Revenue: 15k \$',
                iconFath: 'images/cost-manager.png',
                progress: ProgressIndicatorCustom(progress: 30)),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class ProgressIndicatorCustom extends StatelessWidget {
  final double progress;
  final double size;
  final String displayText;
  const ProgressIndicatorCustom(
      {super.key, required this.progress, this.size = 5,this.displayText = ''});

  @override
  Widget build(BuildContext context) {
   
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FAProgressBar(
        currentValue: progress,
        progressColor: Colors.green,
        size: size,
        displayText: displayText,
        //  backgroundColor: Colors.transparent, // Xóa nền của thanh tiến trình
        borderRadius: BorderRadius.circular(6),
        // Làm tròn góc của progress bar bên trong
      ),
    );
  }
}

class StatisticsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconFath;
  final Widget progress;
  

  const StatisticsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconFath,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        shadowColor: Colors.grey,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(iconFath),
                radius: 30,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 0.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 0.0),
                      child:
                          Text(subtitle, style: const TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: progress,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
