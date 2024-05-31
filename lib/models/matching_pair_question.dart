// matching_pair_question.g.dart

import 'package:json_annotation/json_annotation.dart';

part 'matching_pair_question.g.dart';

@JsonSerializable(explicitToJson: true)
class MatchingPairQuestion {
   final String typeOfQuestion;
  final List<Map<String, String>> items;



  MatchingPairQuestion({
    required this.typeOfQuestion,
    required this.items,
    });

  factory MatchingPairQuestion.fromJson(Map<String, dynamic> json) => _$MatchingPairQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$MatchingPairQuestionToJson(this);
}
