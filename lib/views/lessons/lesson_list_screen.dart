import 'package:flutter/material.dart';
import 'package:maple/models/lessonmodel.dart';
import 'package:maple/models/questionmodel.dart';
import 'package:maple/models/topicmodel.dart';
import 'package:maple/models/translation_question.dart';
import 'package:maple/utils/constants.dart';
import 'package:maple/viewmodels/lesson_viewmodel.dart';
import 'package:maple/views/questions/queston_list_screen.dart';
import 'package:provider/provider.dart';

class LessonListScreen extends StatelessWidget {
  final TopicModel topic;

  const LessonListScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons in ${topic.description}'),
      ),
      body: ListView.builder(
        itemCount: topic.lessons.length,
        itemBuilder: (context, index) {
          final lesson = topic.lessons[index];
          return ListTile(
            title: Text('Lesson ${index + 1}'),
            subtitle: Text('Questions: ${lesson.question}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionListScreen(lesson: lesson),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


