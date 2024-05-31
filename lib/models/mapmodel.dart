import 'package:json_annotation/json_annotation.dart';

import 'package:maple/models/topicmodel.dart';
part 'mapmodel.g.dart';

@JsonSerializable(explicitToJson: true)
class MapModel {
  final String id;
  final String description;
  final List <TopicModel> topics;

  MapModel(
      {required this.id, required this.description, required this.topics});
  factory MapModel.fromJson(Map<String, dynamic> json) =>
      _$MapModelFromJson(json);
  Map<String, dynamic> toJson() => _$MapModelToJson(this);
}
