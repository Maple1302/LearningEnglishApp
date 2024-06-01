// listening_question.g.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:maple/utils/constants.dart';

part 'listening_question.g.dart';

@JsonSerializable(explicitToJson: true)
class ListeningQuestion {
   final String typeOfQuestion;
  final String correctAnswer;
  final List<String> items;

  ListeningQuestion({
     this.typeOfQuestion = listenQuestion,
    required this.correctAnswer,
    required this.items,
  });

  factory ListeningQuestion.fromJson(Map<String, dynamic> json) => _$ListeningQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$ListeningQuestionToJson(this);
}
