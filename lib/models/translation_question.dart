// translation_screen.g.dart
import 'package:json_annotation/json_annotation.dart';

part 'translation_question.g.dart';

@JsonSerializable(explicitToJson: true)
class TranslationQuestion {
  final String typeOfQuestion;
  final String question;
  final String mean;
  final List<String> answers;

  TranslationQuestion({
    required this.typeOfQuestion,
    required this.question,
    required this.mean,
    required this.answers,
  });

  factory TranslationQuestion.fromJson(Map<String, dynamic> json) =>
      _$TranslationQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$TranslationQuestionToJson(this);
}
