import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:maple/UI/custom_buttons.dart';
import 'package:maple/helper/audio_helper.dart';

class ResultScreen extends StatelessWidget {
  final int score, rateCompleted;
  final String finalTime;
  static const String routeName = "/resultScreen";

  const ResultScreen(
      {super.key,
      required this.score,
      required this.rateCompleted,
      required this.finalTime});

  @override
  Widget build(BuildContext context) {
    AudioHelper.playSound("success");
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated image section
              const Spacer(),
              Image.asset('images/faster_icon.png', height: 150),
              const SizedBox(height: 20),
              // Text Section
              const Text(
                'Siêu nhanh!',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Bạn hoàn thành trong chưa tới 2 phút!',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Stats section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildStatCard('TỔNG ĐIỂM', '$score', HexColor("#ffc800"),
                      'images/score_icon.png', true),
                  const SizedBox(width: 10),
                  buildStatCard('TỐC ĐỘ', finalTime, Colors.blue,
                      'images/clock_icon.png', false),
                  const SizedBox(width: 10),
                  buildStatCard('TUYỆT VỜI', '$rateCompleted%', Colors.green,
                      'images/target_icon.png', false),
                ],
              ),
              const Spacer(),
              // Continue button
              ButtonCheck(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(context, '/');
                  });
                },
                text: 'Tiếp tục',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatCard(String title, String value, Color color,
      String iconSource, bool original) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                color: color,
                height: 80,
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Column(children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                ])),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        iconSource,
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                        color: !original ? color : null,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        value,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: color),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
