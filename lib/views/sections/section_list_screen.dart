import 'package:flutter/material.dart';
import 'package:maple/models/lessonmodel.dart';
import 'package:maple/models/mapmodel.dart';
import 'package:maple/models/questionmodel.dart';
import 'package:maple/models/sectionmodel.dart';
import 'package:maple/models/topicmodel.dart';
import 'package:maple/viewmodels/section_viewmodel.dart';
import 'package:maple/views/topics/topic_list_screen.dart';
import 'package:provider/provider.dart';

class SectionListScreen extends StatelessWidget {
  final MapModel map;

  const SectionListScreen({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sections in ${map.description}'),
      ),
      body: ListView.builder(
        itemCount: map.sections.length,
        itemBuilder: (context, index) {
          final section = map.sections[index];
          return ListTile(
            title: Text(section.description),
            subtitle: Text('Topics: ${section.topics.length}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicListScreen(section: section),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddSectionScreen extends StatelessWidget {
  final TextEditingController _descriptionController = TextEditingController();

  AddSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SectionViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Section'),
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
                  completeConversationQuestions: [],
                  completeMissingSentenceQuestions: [],
                  imageSelectionQuestions: [],
                  listeningQuestions: [],
                  matchingPairQuestions: [],
                  pronunciationQuestions: [],
                  translationQuestions: [],
                  id: '', answersCardQuestions: [],
                );

                final lesson = LessonModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  question: question,
                  description: '',
                );

                final topic = TopicModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  description: 'Sample Topic',
                  lessons: [lesson],
                );

                final section = SectionModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  description: _descriptionController.text,
                  topics: [topic],
                );

                viewModel.addSection(section);
                Navigator.pop(context);
              },
              child: const Text('Add Section'),
            ),
          ],
        ),
      ),
    );
  }
}
