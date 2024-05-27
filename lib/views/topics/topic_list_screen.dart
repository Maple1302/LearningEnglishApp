import 'package:flutter/material.dart';
import 'package:maple/models/lessonmodel.dart';
import 'package:maple/models/questionmodel.dart';
import 'package:maple/models/sectionmodel.dart';
import 'package:maple/models/topicmodel.dart';
import 'package:maple/viewmodels/topic_viewmodel.dart';
import 'package:maple/views/lessons/lesson_list_screen.dart';
import 'package:provider/provider.dart';

class TopicListScreen extends StatelessWidget {
  final SectionModel section;

  const TopicListScreen({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics in ${section.description}'),
      ),
      body: ListView.builder(
        itemCount: section.topics.length,
        itemBuilder: (context, index) {
          final topic = section.topics[index];
          return ListTile(
            title: Text(topic.description),
            subtitle: Text('Lessons: ${topic.lessons.length}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonListScreen(topic: topic),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddTopicScreen extends StatelessWidget {
  final TextEditingController _descriptionController = TextEditingController();

  AddTopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TopicViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Topic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
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
                  translationQuestions: [], answersCardQuestions: [],
                );

                final lesson = LessonModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  description: '',
                  question: question,
                );

                final topic = TopicModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  description: _descriptionController.text,
                  lessons: [lesson],
                );

                viewModel.addTopic(topic);
                Navigator.pop(context);
              },
              child: const Text('Add Topic'),
            ),
          ],
        ),
      ),
    );
  }
}