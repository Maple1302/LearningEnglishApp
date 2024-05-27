import 'package:json_annotation/json_annotation.dart';
import 'package:maple/models/questionmodel.dart';
part 'lessonmodel.g.dart';

@JsonSerializable(explicitToJson: true)
class LessonModel {
  final String id;
  final String description;
  final QuestionModel question;

  LessonModel(
      {required this.id, required this.description, required this.question});
  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);
  Map<String, dynamic> toJson() => _$LessonModelToJson(this);
}
