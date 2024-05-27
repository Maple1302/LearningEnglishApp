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

class AddLessonScreen extends StatelessWidget {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  AddLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LessonViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Lesson'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final question = QuestionModel(
                  id:'',
                  completeConversationQuestions: [],
                  completeMissingSentenceQuestions: [],
                  imageSelectionQuestions: [],
                  listeningQuestions: [],
                  matchingPairQuestions: [],
                  pronunciationQuestions: [],
                  translationQuestions: [
                    TranslationQuestion(
                      typeOfQuestion: transerlateListen,
                      question: _questionController.text,
                      mean: _answerController.text,
                      answers: [],
                    
                    ),
                  ], answersCardQuestions: [],
                );

                final lesson = LessonModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  description: '',
                  question: question,
                );

                viewModel.addLesson(lesson);
                Navigator.pop(context);
              },
              child: const Text('Add Lesson'),
            ),
          ],
        ),
      ),
    );
  }
}