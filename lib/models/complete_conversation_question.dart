// complete_conversation_question.g.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:maple/utils/constants.dart';

part 'complete_conversation_question.g.dart';

@JsonSerializable(explicitToJson: true)
class CompleteConversationQuestion {
   final String typeOfQuestion;
  final Map<String, String> question;
  final Map<String, String> correctAnswer;
  final List<String> items;

  CompleteConversationQuestion({
     this.typeOfQuestion = completeConversationQuestion,
    required this.question,
    required this.correctAnswer,
    required this.items,
  });

  factory CompleteConversationQuestion.fromJson(Map<String, dynamic> json) => _$CompleteConversationQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteConversationQuestionToJson(this);
}
