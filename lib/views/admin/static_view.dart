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
                progress: ProgressIndicator(progress: 0.7)),
            StatisticsCard(
                title: 'Learning Progress',
                subtitle: 'Level average : 3/5',
                iconFath: 'images/learning-manager.png',
                progress: ProgressIndicator(progress: 0.6)),
            StatisticsCard(
                title: 'Other',
                subtitle: 'Revenue: 15k \$',
                iconFath: 'images/cost-manager.png',
                progress: ProgressIndicator(progress: 0.5)),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  final double progress;

  const ProgressIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
    //  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
    
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(color: Colors.white, width: 0.5), // Viền trắng
        borderRadius: BorderRadius.circular(10),
        
      ),
      child: FAProgressBar(
        currentValue: 70,
        progressColor: Colors.blue,
        size: 5,
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                      child: Text(subtitle, style: const TextStyle(fontSize: 16)),
                    ),
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
