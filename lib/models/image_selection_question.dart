// image_selection_question.g.dart

import 'package:json_annotation/json_annotation.dart';

part 'image_selection_question.g.dart';

@JsonSerializable(explicitToJson: true)
class ImageSelectionQuestion {
   final String typeOfQuestion;
  final String expectedWord;
  final String correctAnswer;
  final List<Map<String,String>> items;

  ImageSelectionQuestion({
    required this.typeOfQuestion,
    required this.expectedWord,
    required this.correctAnswer,
    required this.items
  });

  factory ImageSelectionQuestion.fromJson(Map<String, dynamic> json) => _$ImageSelectionQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$ImageSelectionQuestionToJson(this);
}
