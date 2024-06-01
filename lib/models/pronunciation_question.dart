// pronunciation_question.g.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:maple/utils/constants.dart';

part 'pronunciation_question.g.dart';

@JsonSerializable(explicitToJson: true)
class PronunciationQuestion {
   final String typeOfQuestion;
  final String sampleText;
  final String mean;

  PronunciationQuestion({ this.typeOfQuestion = pronunciationQuestion,required this.sampleText, required this.mean});

  factory PronunciationQuestion.fromJson(Map<String, dynamic> json) => _$PronunciationQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$PronunciationQuestionToJson(this);
}
