import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:maple/models/topicmodel.dart';
import 'package:maple/views/questions/questions_screen.dart';

class Lessons extends StatefulWidget {
  final TopicModel topicModel;
  const Lessons({
    super.key,
    required this.topicModel,
  });

  @override
  State<Lessons> createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  List<Widget> listLesson = [];

  @override
  void initState() {
    super.initState();
    listLesson = customListLesson(getListLesson(widget.topicModel));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: Container(),
            backgroundColor: HexColor(widget.topicModel.color),
            centerTitle: true,
            title: Text(widget.topicModel.description,
                style: const TextStyle(fontSize: 20, color: Colors.white))),
        body: Column(children: listLesson));
  }

  static Widget columnLesson(List<Widget> list) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list,
    );
  }

  Widget lesson(String imageUrl, Color color, String title, String progress) {
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
                          value: double.parse(progress) / 5,
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
                          padding: MaterialStateProperty.all(EdgeInsets.zero), // Xác định padding
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushReplacementNamed(
                                context, QuestionScreen.routeName);
                          });
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

  List<Widget> getListLesson(TopicModel topic) {
    List<Widget> listLesson = [];
    for (int i = 0; i < topic.lessons.length; i++) {
      listLesson.add(lesson(
        topic.lessons[i].images,
        HexColor(topic.lessons[i].color),
        topic.lessons[i].title,
        4.toString(),
      ));
    }

    return listLesson;
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
