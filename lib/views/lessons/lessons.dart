import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:maple/models/lessonmodel.dart';
import 'package:maple/models/questionmodel.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
import 'package:maple/views/questions/questions_screen.dart';
import 'package:provider/provider.dart';

class Lessons extends StatefulWidget {
  final List<LessonModel> listLesson;
  final bool isCurrentTopic;
  final bool isCureentTopicUnlockFull;
  final int mapId;
  final int topicId;
  final bool isMapUnlocked;
  final bool isCurrentMap;
  const Lessons({
    super.key,
    required this.listLesson,
    required this.isCurrentTopic,
    required this.mapId,
    required this.topicId,
    required this.isCureentTopicUnlockFull,
    required this.isMapUnlocked,
    required this.isCurrentMap,
  });

  @override
  State<Lessons> createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  List<Widget> listLesson = [];
  List<String> completedLesson = [];

  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    completedLesson = authViewModel.user!.completedLessons.split(";");
  }

  @override
  Widget build(BuildContext context) {
    listLesson =
        customListLesson(getListLesson(widget.listLesson, completedLesson));

    return Column(children: listLesson);
  }

  static Widget columnLesson(List<Widget> list) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list,
    );
  }

  Widget lesson(int lessonId, String imageUrl, Color color, String title,
      String progress, QuestionModel questionModel, int length, bool enable) {
    return (imageUrl == '' || title == '')
        ? Container()
        : Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Transform.rotate(
                        angle: 3 * pi / 4,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation(color),
                          value: double.parse(progress) / length,
                          strokeWidth: 60,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 42,
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.zero), // Xác định padding
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          if (enable) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuestionScreen(
                                        questionModel: questionModel,
                                        lessonState: [
                                          widget.mapId.toString(),
                                          widget.topicId.toString(),
                                          lessonId.toString(),
                                          progress
                                        ],
                                      ) //TopicListScreen(mapModel: map),
                                  ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: color,
                          radius: 35,
                          child: imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(35),
                                  child: Image.network(
                                    imageUrl,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                  ),
                                )
                              : const Icon(Icons.image),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image.asset(
                        'images/crown.png',
                        height: 30,
                      ),
                      Text(
                        progress,
                        style: const TextStyle(color: Colors.deepOrangeAccent),
                      )
                    ],
                  ),
                ],
              ),
              Text(title)
            ],
          );
  }

  List<Widget> getListLesson(
      List<LessonModel> listLesson, List<String> lessonCompleted) {
    List<Widget> listLessonWidget = [];
int lessonC = int.parse(lessonCompleted[2]); // lesson count
int questionC = int.parse(lessonCompleted[3]); // question count

if (widget.isCurrentMap) {
  for (int i = 0; i < listLesson.length; i++) {
    bool isLessonUnlocked = lessonC >= i; // lock full
    bool isCurrentLesson = lessonC == i; // current lesson
    bool isEnabled = widget.isCurrentTopic || widget.isCureentTopicUnlockFull; // topic enable
    Color lessonColor = isLessonUnlocked ? HexColor(listLesson[i].color) : Colors.grey;
    String questionCount = isLessonUnlocked
        ? (isCurrentLesson ? lessonCompleted[3] : listLesson[i].question.length.toString())
        : "0";
    QuestionModel currentQuestion = isLessonUnlocked
        ? (isCurrentLesson ? listLesson[i].question[questionC] : listLesson[i].question.last)
        : listLesson[i].question[0];
    
    if (widget.isCureentTopicUnlockFull) {
      currentQuestion = widget.listLesson[i].question.last;
      questionCount = widget.listLesson[i].question.length.toString();
      lessonColor = HexColor(listLesson[i].color);
      isEnabled = true;
    }

    listLessonWidget.add(
      lesson(
        i,
        listLesson[i].images, // image
        isEnabled ? lessonColor : Colors.grey, // color
        listLesson[i].title, // title
        isEnabled ? questionCount : "0", // question count
        isEnabled ? currentQuestion : listLesson[i].question[0], // current question
        listLesson[i].question.length, // total questions
        isEnabled // is question completed
      )
    );
  }
} else {
  for (int i = 0; i < listLesson.length; i++) {
    listLessonWidget.add(
      lesson(
        i,
        listLesson[i].images, // image
        HexColor(listLesson[i].color), // color
        listLesson[i].title, // title
        listLesson[i].question.length.toString(), // question count
        listLesson[i].question.last, // current question
        listLesson[i].question.length, // total questions
        true // is question completed
      )
    );
  }
}

return listLessonWidget;

  }

  static List<Widget> customListLesson(List<Widget> lessons) {
    int countLeft = 0;
    int countRight = 0;
    int progress = -1;
    int count = 3;
    List<Widget> customList = [];
    for (int index = 0; index < lessons.length; index++) {
      List<Widget> listLeft = [];
      List<Widget> listRight = [];
      if (index == 0 || index % 4 == 0) {
        customList.add(lessons[index]);
      } else {
        if (countLeft <= count && progress == -1) {
          listLeft.add(lessons[index]);
          countLeft++;
          for (int i = 0; i < countLeft; i++) {
            listLeft.add(Container());
          }
          if (countLeft == count) {
            countLeft = 0;
            listLeft.removeAt(count);
            listLeft.removeAt(count - 1);

            customList.add(columnLesson(listLeft));
            progress = 1;
            continue;
          }
          customList.add(columnLesson(listLeft));
        }
        if (countRight <= count && progress == 1) {
          for (int i = 0; i < countRight + 1; i++) {
            listRight.add(Container());
          }
          listRight.add(lessons[index]);
          countRight++;

          if (countRight == count) {
            countRight = 0;
            listRight.removeAt(0);
            listRight.removeAt(0);
            progress = -1;
          }
          customList.add(columnLesson(listRight));
        }
      }
    }

    return customList;
  }
}
