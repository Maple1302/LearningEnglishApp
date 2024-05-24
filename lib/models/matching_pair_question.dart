// matching_pair_question.g.dart

import 'package:json_annotation/json_annotation.dart';

part 'matching_pair_question.g.dart';

@JsonSerializable()
class MatchingPairQuestion {
   final String typeOfQuestion;
  final List<Map<String, String>> items;
  final String type;

  MatchingPairQuestion({
    required this.typeOfQuestion,
    required this.items, required this.type});

  factory MatchingPairQuestion.fromJson(Map<String, dynamic> json) => _$MatchingPairQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$MatchingPairQuestionToJson(this);
}
