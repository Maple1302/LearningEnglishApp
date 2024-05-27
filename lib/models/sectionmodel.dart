import 'package:json_annotation/json_annotation.dart';
import 'package:maple/models/topicmodel.dart';
part 'sectionmodel.g.dart';

@JsonSerializable(explicitToJson: true)
class SectionModel {
  final String id;
  final String description;
  final List<TopicModel> topics;

  SectionModel(
      {required this.id, required this.description, required this.topics});
  factory SectionModel.fromJson(Map<String, dynamic> json) =>
      _$SectionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SectionModelToJson(this);
}
