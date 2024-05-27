import 'dart:math';

import 'package:flutter/material.dart';

import 'package:maple/views/questions/questions_screen.dart';

class Levels extends StatefulWidget {
  const Levels({super.key});

  @override
  State<Levels> createState() => _LevelsState();
}

class _LevelsState extends State<Levels> {
  int countLeft = 0;
  int countRight = 0;
  int count = 3;
  List<Widget> listLesson = [];

  @override
  void initState() {
    super.initState();
    listLesson = customListLesson(getListLesson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: topic(listLesson));
  }

  static Widget columnLesson(List<Widget> list) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list,
    );
  }

  Widget topic(List<Widget> lessons) {
    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        return lessons[index];
      },
    );
  }

  Widget lesson(String image, Color color, String title, String process) {
    return (image == '' || title == '')
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
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.yellow),
                          value: double.parse(process) / 5,
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
                           WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Navigator.pushReplacementNamed(
                                          context,QuestionScreen.routeName);
                                    });
                          },
                          child: CircleAvatar(
                            backgroundColor: color,
                            radius: 35,
                            //backgroundImage: AssetImage('images/easter-egg_colorful.png'),
                            child: Image.asset(
                              image,
                              height: 50,
                            ),
                          )),
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
                        process,
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

  List<Widget> getListLesson() {
    List<Widget> listLesson = [];
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(
      lesson('images/face-man.png', Colors.green, 'con người'.toUpperCase(),
          3.toString()),
    );
    listLesson.add(lesson('images/treasure.png', Colors.purple,
        'du lịch'.toUpperCase(), 4.toString()));
    listLesson.add(lesson('images/restaurant.png', Colors.grey,
        'nhà hàng'.toUpperCase(), 1.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));
    listLesson.add(lesson('images/easter-egg_colorful.png', Colors.blue,
        'sự vật'.toUpperCase(), 2.toString()));

    return listLesson;
  }

  static List<Widget> customListLesson(List<Widget> lessons) {
    int countLeft = 0;
    int countRight = 0;
    int process = -1;
    int count = 3;
    List<Widget> customList = [];
    for (int index = 0; index < lessons.length; index++) {
      List<Widget> listLeft = [];
      List<Widget> listRight = [];
      if (index == 0 || index % 4 == 0) {
        customList.add(lessons[index]);
      } else {
        if (countLeft <= count && process == -1) {
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
            process = 1;
            continue;
          }
          customList.add(columnLesson(listLeft));
        }
        if (countRight <= count && process == 1) {
          for (int i = 0; i < countRight + 1; i++) {
            listRight.add(Container());
          }
          listRight.add(lessons[index]);
          countRight++;

          if (countRight == count) {
            countRight = 0;
            listRight.removeAt(0);
            listRight.removeAt(0);
            process = -1;
          }
          customList.add(columnLesson(listRight));
        }
      }
    }

    return customList;
  }
}
