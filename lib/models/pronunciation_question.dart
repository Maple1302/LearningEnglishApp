// pronunciation_question.g.dart

import 'package:json_annotation/json_annotation.dart';

part 'pronunciation_question.g.dart';

@JsonSerializable(explicitToJson: true)
class PronunciationQuestion {
   final String typeOfQuestion;
  final String sampleText;
  final String mean;

  PronunciationQuestion({required this.typeOfQuestion,required this.sampleText, required this.mean});

  factory PronunciationQuestion.fromJson(Map<String, dynamic> json) => _$PronunciationQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$PronunciationQuestionToJson(this);
}
