import 'package:flutter/material.dart';
import 'package:maple/models/answers_card_question.dart';
import 'package:maple/models/complete_conversation_question.dart';
import 'package:maple/models/complete_missing_sentence_question.dart';
import 'package:maple/models/image_selection_question.dart';
import 'package:maple/models/lessonmodel.dart';
import 'package:maple/models/listening_question.dart';
import 'package:maple/models/mapmodel.dart';
import 'package:maple/models/matching_pair_question.dart';
import 'package:maple/models/pronunciation_question.dart';
import 'package:maple/models/questionmodel.dart';
import 'package:maple/models/sectionmodel.dart';
import 'package:maple/models/topicmodel.dart';
import 'package:maple/models/translation_question.dart';
import 'package:maple/utils/constants.dart';
import 'package:maple/viewmodels/map_viewmodel.dart';
import 'package:maple/views/sections/section_list_screen.dart';
import 'package:provider/provider.dart';

class MapListScreen extends StatefulWidget {
  const MapListScreen({super.key});

  @override
  State<MapListScreen> createState() => _MapListScreenState();
}

class _MapListScreenState extends State<MapListScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);

    return Scaffold(
      body: FutureBuilder<List<MapModel>>(
        future: viewModel.fetchMaps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No maps available'));
          }
          return Consumer<MapViewModel>(
            builder: (context, viewModel, child) {
              final maps = viewModel.maps;
              return ListView.builder(
                itemCount: maps.length,
                itemBuilder: (context, index) {
                  final map = maps[index];
                  return ListTile(
                    title: Text(map.description),
                    subtitle: Text('Sections: ${map.sections.length}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SectionListScreen(map: map),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => viewModel.deleteMap(map.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMapScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddMapScreen extends StatelessWidget {
  final TextEditingController _descriptionController = TextEditingController();

  AddMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Map'),
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
                  completeConversationQuestions: [
                    CompleteConversationQuestion(
                      typeOfQuestion: completeConversationQuestion,
                      question: {
                        'text': "This is your boyfriend, isn't it?",
                        'mean': 'Đây là bạn trai của con có phải không Lisa?'
                      },
                      correctAnswer: {
                        'text': 'Yes, He is Tommy',
                        'mean': 'Vâng, Anh ấy là Tommy'
                      },
                      items: [
                        'Yes, He is Tommy',
                        'Yes, that\'s my younger brother.',
                      ],
                    )
                  ],
                  completeMissingSentenceQuestions: [
                    CompleteMissingSentenceQuestion(
                        typeOfQuestion: completeMissingSentenceQuestion,
                        expectedSentence: 'Vâng, tôi muốn hai chiếc Pizza',
                        missingSentence: 'Yes,I would like to ',
                        correctanswers: 'pizzas')
                  ],
                  imageSelectionQuestions: [
                    ImageSelectionQuestion(
                      typeOfQuestion: imageSelectionQuestions,
                      expectedWord: 'ice cream',
                      correctAnswer: 'kem',
                      items: [
                        {
                          'image': 'images/restaurant.png',
                          'text': 'kem',
                          'mean': 'ice cream'
                        },
                        {
                          'image': 'images/crown.png',
                          'text': 'em bé',
                          'mean': 'baby'
                        },
                        {
                          'image': 'images/easter-egg_colorful.png',
                          'text': 'màu vàng',
                          'mean': 'yellow'
                        },
                        {
                          'image': 'images/gem.png',
                          'text': 'sô-cô-la',
                          'mean': 'socola'
                        },
                      ],
                    )
                  ],
                  listeningQuestions: [
                    ListeningQuestion(
                      typeOfQuestion: listenQuestion,
                      items: ['Flow', 'Flew'],
                      correctAnswer: 'Flow',
                    )
                  ],
                  matchingPairQuestions: [
                    MatchingPairQuestion(
                      typeOfQuestion: matchingPairSoundQuestion,
                      items: [
                        {'mean': 'em bé', 'text': 'baby'},
                        {'text': 'em bé', 'mean': 'baby'},
                        {'mean': 'kem', 'text': 'ice cream'},
                        {'text': 'màu vàng', 'mean': 'yellow'},
                        {'mean': 'sô-cô-la', 'text': 'socola'},
                        {'text': 'sô-cô-la', 'mean': 'socola'},
                        {'mean': 'màu vàng', 'text': 'yellow'},
                        {'text': 'kem', 'mean': 'ice cream'},
                      ],
                    ),
                    MatchingPairQuestion(
                      typeOfQuestion: matchingPairWordQuestion,
                      items: [
                        {'mean': 'em bé', 'text': 'baby'},
                        {'text': 'em bé', 'mean': 'baby'},
                        {'mean': 'kem', 'text': 'ice cream'},
                        {'text': 'màu vàng', 'mean': 'yellow'},
                        {'mean': 'sô-cô-la', 'text': 'socola'},
                        {'text': 'sô-cô-la', 'mean': 'socola'},
                        {'mean': 'màu vàng', 'text': 'yellow'},
                        {'text': 'kem', 'mean': 'ice cream'},
                      ],
                    )
                  ],
                  pronunciationQuestions: [
                    PronunciationQuestion(
                      typeOfQuestion: pronunciationQuestion,
                      sampleText: "Hello, What's your name?",
                      mean: 'Xin chào, Bạn tên gì?',
                    )
                  ],
                  translationQuestions: [
                    TranslationQuestion(
                      typeOfQuestion: transerlateListen,
                      question: "Hello, What's your name?",
                      mean: "Xin chào, tên bạn là gì?",
                      answers: [
                        'Hello',
                        "What's",
                        'your',
                        'have',
                        'am',
                        'name?',
                      ],
                    ),
                    TranslationQuestion(
                      typeOfQuestion: transerlateRead,
                      question: "Hello, What's your name?",
                      mean: "Xin chào, tên bạn là gì?",
                      answers: [
                        'Hello',
                        "What's",
                        'your',
                        'have',
                        'am',
                        'name?',
                      ],
                    )
                  ],
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  answersCardQuestions: [
                    AnswersCardQuestion(
                        typeOfQuestion: cardMutilChoiceQuestion,
                        question: "Hi Peter",
                        correctAnswer: "hello",
                        answers: ["hi", "hello", "good", "too much"])
                  ],
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
                  description: 'Sample Section',
                  topics: [topic],
                );

                final map = MapModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  description: _descriptionController.text,
                  sections: [section],
                );

                viewModel.addMap(map);
                Navigator.pop(context);
              },
              child: const Text('Add Map'),
            ),
          ],
        ),
      ),
    );
  }
}
