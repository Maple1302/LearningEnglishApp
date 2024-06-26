// complete_missing_sentence_question.g.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:maple/utils/constants.dart';

part 'complete_missing_sentence_question.g.dart';

@JsonSerializable(explicitToJson: true)
class CompleteMissingSentenceQuestion {
   final String typeOfQuestion;
  final String expectedSentence;
  final String missingSentence;
  final String correctanswers;

  CompleteMissingSentenceQuestion({
     this.typeOfQuestion = completeMissingSentenceQuestion,
    required this.expectedSentence,
    required this.missingSentence,
    required this.correctanswers,
  });

  factory CompleteMissingSentenceQuestion.fromJson(Map<String, dynamic> json) => _$CompleteMissingSentenceQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteMissingSentenceQuestionToJson(this);
}
