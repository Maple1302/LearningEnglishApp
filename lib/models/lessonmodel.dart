import 'package:json_annotation/json_annotation.dart';
import 'package:maple/models/questionmodel.dart';
part 'lessonmodel.g.dart';

@JsonSerializable(explicitToJson: true)
class LessonModel {
  final String id;
  final String title;
  final String description;
  final List<QuestionModel> question;
  final String images;
  final String color;

  LessonModel(
      {required this.id, required this.title, required this.description, required this.question,required this.images,required this.color});
  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);
  Map<String, dynamic> toJson() => _$LessonModelToJson(this);
}
