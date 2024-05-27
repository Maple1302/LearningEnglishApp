import 'package:flutter/material.dart';
import 'package:maple/models/complete_conversation_question.dart';
import 'package:maple/models/complete_missing_sentence_question.dart';
import 'package:maple/models/image_selection_question.dart';
import 'package:maple/models/lessonmodel.dart';
import 'package:maple/models/listening_question.dart';
import 'package:maple/models/matching_pair_question.dart';
import 'package:maple/models/pronunciation_question.dart';
import 'package:maple/models/questionmodel.dart';
import 'package:maple/models/translation_question.dart';
import 'package:maple/utils/constants.dart';
import 'package:maple/viewmodels/question_viewmodel.dart';
import 'package:maple/views/questions/edit_question_screen.dart';
import 'package:provider/provider.dart';


class QuestionListScreen extends StatelessWidget {
  final LessonModel lesson;

  const QuestionListScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final QuestionModel questions = lesson.question; // Single instance of QuestionModel

    // Extract each type of question from the single QuestionModel instance
    final List<CompleteConversationQuestion> questions1 = questions.completeConversationQuestions;
    final List<CompleteMissingSentenceQuestion> questions2 = questions.completeMissingSentenceQuestions;
    final List<ImageSelectionQuestion> questions3 = questions.imageSelectionQuestions;
    final List<ListeningQuestion> questions4 = questions.listeningQuestions;
    final List<MatchingPairQuestion> questions5 = questions.matchingPairQuestions;
    final List<PronunciationQuestion> questions6 = questions.pronunciationQuestions;
    final List<TranslationQuestion> questions7 = questions.translationQuestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions in Lesson'),
      ),
      body: ListView(
        children: [
          _buildQuestionSection(context, 'Complete Conversation Questions', questions1),
          _buildQuestionSection(context, 'Complete Missing Sentence Questions', questions2),
          _buildQuestionSection(context, 'Image Selection Questions', questions3),
          _buildQuestionSection(context, 'Listening Questions', questions4),
          _buildQuestionSection(context, 'Matching Pair Questions', questions5),
          _buildQuestionSection(context, 'Pronunciation Questions', questions6),
          _buildQuestionSection(context, 'Translation Questions', questions7),
        ],
      ),
    );
  }

  Widget _buildQuestionSection(BuildContext context, String title, List<dynamic> questions) {
    return ExpansionTile(
      title: Text(title),
      children: questions.asMap().entries.map((entry) {
        int index = entry.key;
        var question = entry.value;
        return ListTile(
          title: Text('$title ${index + 1}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditQuestionScreen(question: question),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
// Extension method to flatMap lists in Dart

class AddQuestionScreen extends StatelessWidget {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  AddQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuestionViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Question'),
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
                  id: '',
                  completeConversationQuestions: [
                    CompleteConversationQuestion(
                      typeOfQuestion: '', question: <String,String>{}, correctAnswer: <String,String>{}, items: [])
                  ],
                  completeMissingSentenceQuestions: [
                    CompleteMissingSentenceQuestion(
                        typeOfQuestion: '',
                        expectedSentence: 'expectedSentence',
                        missingSentence: 'missingSentence',
                        correctanswers: 'correctanswers')
                  ],
                  imageSelectionQuestions: [
                    ImageSelectionQuestion(
                        typeOfQuestion: '',
                        expectedWord: '',
                        correctAnswer: 'correctAnswer',
                        items:[])
                  ],
                  listeningQuestions: [
                    ListeningQuestion(
                        typeOfQuestion: '',
                        correctAnswer: 'correctAnswer',
                        items: [])
                  ],
                  matchingPairQuestions: [
                    MatchingPairQuestion(
                        typeOfQuestion: '', items: [], )
                  ],
                  pronunciationQuestions: [
                    PronunciationQuestion(
                        typeOfQuestion: '',
                        sampleText: 'sampleText',
                        mean: 'mean')
                  ],
                  translationQuestions: [
                    TranslationQuestion(
                      typeOfQuestion: transerlateListen,
                      question: _questionController.text,
                      mean: _answerController.text,
                      answers: [],
                    
                    ),
                  ], answersCardQuestions: [],
                );
                viewModel.addQuestion(question);
                Navigator.pop(context);
              },
              child: const Text('Add Question'),
            ),
          ],
        ),
      ),
    );
  }
}
