// translation_screen.g.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:maple/models/answers_card_question.dart';
import 'package:maple/models/complete_conversation_question.dart';
import 'package:maple/models/complete_missing_sentence_question.dart';
import 'package:maple/models/image_selection_question.dart';
import 'package:maple/models/listening_question.dart';
import 'package:maple/models/matching_pair_question.dart';
import 'package:maple/models/pronunciation_question.dart';
import 'package:maple/models/translation_question.dart';

part 'questionmodel.g.dart';

@JsonSerializable(explicitToJson: true)
class QuestionModel {
  final String id;
  final List<AnswersCardQuestion> answersCardQuestions;
  final List<CompleteConversationQuestion> completeConversationQuestions;
  final List<CompleteMissingSentenceQuestion> completeMissingSentenceQuestions;
  final List<ImageSelectionQuestion> imageSelectionQuestions;
  final List<ListeningQuestion> listeningQuestions;
  final List<MatchingPairQuestion> matchingPairQuestions;
  final List<PronunciationQuestion> pronunciationQuestions;
  final List<TranslationQuestion> translationQuestions;

  QuestionModel({
    required this.id,
    required this.answersCardQuestions,
    required this.completeConversationQuestions,
    required this.completeMissingSentenceQuestions,
    required this.imageSelectionQuestions,
    required this.listeningQuestions,
    required this.matchingPairQuestions,
    required this.pronunciationQuestions,
    required this.translationQuestions,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);

  int get length =>
      completeConversationQuestions.length +
      completeMissingSentenceQuestions.length +
      imageSelectionQuestions.length +
      listeningQuestions.length +
      matchingPairQuestions.length +
      pronunciationQuestions.length +
      translationQuestions.length;
}
