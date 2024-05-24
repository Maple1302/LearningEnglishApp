import 'package:json_annotation/json_annotation.dart';

part 'answers_card_question.g.dart';

@JsonSerializable()
class AnswersCardQuestion {
  final String typeOfQuestion;
  final String question;
  final String correctAnswer;
  final List<String> answers;

  AnswersCardQuestion({
    required this.typeOfQuestion,
    required this.question,
    required this.correctAnswer,
    required this.answers,
  });

  factory AnswersCardQuestion.fromJson(Map<String, dynamic> json) =>
      _$AnswersCardQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$AnswersCardQuestionToJson(this);
}
