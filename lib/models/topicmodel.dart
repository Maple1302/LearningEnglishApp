import 'package:json_annotation/json_annotation.dart';
import 'package:maple/models/lessonmodel.dart';
part 'topicmodel.g.dart';

@JsonSerializable(explicitToJson: true)
class TopicModel {
  final String id;
  final String description;
  final List<LessonModel> lessons;

  TopicModel(
      {required this.id, required this.description, required this.lessons});
  factory TopicModel.fromJson(Map<String, dynamic> json) =>
      _$TopicModelFromJson(json);
  Map<String, dynamic> toJson() => _$TopicModelToJson(this);
}
