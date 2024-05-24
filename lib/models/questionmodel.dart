// translation_screen.g.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:maple/models/complete_conversation_question.dart';
import 'package:maple/models/complete_missing_sentence_question.dart';
import 'package:maple/models/image_selection_question.dart';
import 'package:maple/models/listening_question.dart';
import 'package:maple/models/matching_pair_question.dart';
import 'package:maple/models/pronunciation_question.dart';
import 'package:maple/models/translation_question.dart';

part 'questionmodel.g.dart';

@JsonSerializable()
class QuestionModel {
  final List<CompleteConversationQuestion> completeConversationQuestions;
  final List<CompleteMissingSentenceQuestion> completeMissingSentenceQuestions;
  final List<ImageSelectionQuestion> imageSelectionQuestions;
  final List<ListeningQuestion> listeningQuestions;
  final List<MatchingPairQuestion> matchingPairQuestions;
  final List<PronunciationQuestion> pronunciationQuestions;
  final List<TranslationScreen> translationScreens;

  QuestionModel(
      {required this.completeConversationQuestions,
      required this.completeMissingSentenceQuestions,
      required this.imageSelectionQuestions,
      required this.listeningQuestions,
      required this.matchingPairQuestions,
      required this.pronunciationQuestions,
      required this.translationScreens});

}
