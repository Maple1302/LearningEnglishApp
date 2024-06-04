import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:intl/intl.dart';
import 'package:maple/UI/custom_buttons.dart';
import 'package:maple/helper/audio_helper.dart';
import 'package:maple/models/user_model.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
import 'package:maple/viewmodels/map_viewmodel.dart';
import 'package:maple/views/home/home.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatelessWidget {
  final int score, rateCompleted;
  final String finalTime;
  final List<String> lessonState;
  static const String routeName = "/resultScreen";

  const ResultScreen({
    super.key,
    required this.score,
    required this.rateCompleted,
    required this.finalTime,
    required this.lessonState,
  });

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.user;
    final mapViewModel = Provider.of<MapViewModel>(context, listen: false);
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
                  fontWeight: FontWeight.bold,
                ),
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
                  if (user != null) {
                    int newGem = int.parse(user.gem) + 10;
                    int newKN = int.parse(user.kN) + score;
                    int streak = int.parse(user.streak);
                    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
                    DateTime date1 = dateFormat.parse(user.lastCompletionDate);
                    DateTime date2 = dateFormat
                        .parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
                    if (areDatesOneDayApart(date1, date2)) {
                      streak++;
                    } else {
                      streak = 1;
                    }
                    int indexOfMap = int.parse(lessonState[0]);
                    int indexOfTopic = int.parse(lessonState[1]);
                    int indexOfLesson = int.parse(lessonState[2]);
                    int indexOfQuestion = int.parse(lessonState[3]);

                    int? lengthOfMap = mapViewModel.maps.length;
                    int? lengthOfTopic =
                        mapViewModel.maps[indexOfMap].topics.length;
                    int? lengthOfLesson = mapViewModel
                        .maps[indexOfMap].topics[indexOfTopic].lessons.length;
                    int? lengthOfQuestion = mapViewModel
                        .maps[indexOfMap]
                        .topics[indexOfTopic]
                        .lessons[indexOfLesson]
                        .question
                        .length;

                    List<String> currentLessonState =
                        user.completedLessons.split(";");
                    String updatedState = user.completedLessons;
                    if (indexOfMap == int.parse(currentLessonState[0]) &&
                        indexOfTopic == int.parse(currentLessonState[1]) &&
                        indexOfLesson == int.parse(currentLessonState[2]) &&
                        indexOfQuestion == int.parse(currentLessonState[3])) {
                      indexOfQuestion++;
                      if (indexOfQuestion == lengthOfQuestion) {
                        indexOfQuestion = 0;
                        indexOfLesson++;
                        if (indexOfLesson == lengthOfLesson) {
                          indexOfLesson = 0;
                          indexOfTopic++;
                          if (indexOfTopic == lengthOfTopic) {
                            indexOfTopic = 0;
                            indexOfMap++;
                            if (indexOfMap == lengthOfMap) {
                              indexOfMap = 100;
                            }
                          }
                        }
                      }
                      updatedState = [
                        indexOfMap.toString(),
                        indexOfTopic.toString(),
                        indexOfLesson.toString(),
                        indexOfQuestion.toString(),
                      ].join(";");
                    }

                    UserModel updatedUser = UserModel(
                      uid: user.uid,
                      role: user.role,
                      email: user.email,
                      dateCreate: user.dateCreate,
                      urlAvatar: user.urlAvatar,
                      signInMethod: user.signInMethod,
                      completedLessons: updatedState,
                      progress: user.progress,
                      username: user.username,
                      streak: streak.toString(),
                      language: user.language,
                      heart: user.heart,
                      gem: newGem.toString(),
                      kN: newKN.toString(),
                      lastCompletionDate:
                          DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    );
                    authViewModel.updateUser(updatedUser);
                  }
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                    (Route<dynamic> route) => false,
                  );
                },
                text: 'Tiếp tục',
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool areDatesOneDayApart(DateTime date1, DateTime date2) {
    Duration difference = date1.difference(date2).abs();
    return difference.inDays == 1 && difference.inHours < 24;
  }
  bool areDatesEqual(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
         date1.month == date2.month &&
         date1.day == date2.day;
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
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
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
                      const SizedBox(width: 5),
                      Text(
                        value,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: color),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
