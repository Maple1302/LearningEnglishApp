// translation_screen.g.dart
import 'package:json_annotation/json_annotation.dart';

part 'translation_question.g.dart';

@JsonSerializable()
class TranslationScreen {
  final String typeOfQuestion;
  final String question;
  final String mean;
  final List<String> answers;
  final String type;

  TranslationScreen({
    required this.typeOfQuestion,
    required this.question,
    required this.mean,
    required this.answers,
    required this.type,
  });

  factory TranslationScreen.fromJson(Map<String, dynamic> json) =>
      _$TranslationScreenFromJson(json);

  Map<String, dynamic> toJson() => _$TranslationScreenToJson(this);
}
