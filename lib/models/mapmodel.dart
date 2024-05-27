import 'package:json_annotation/json_annotation.dart';
import 'package:maple/models/sectionmodel.dart';
part 'mapmodel.g.dart';

@JsonSerializable(explicitToJson: true)
class MapModel {
  final String id;
  final String description;
  final List <SectionModel> sections;

  MapModel(
      {required this.id, required this.description, required this.sections});
  factory MapModel.fromJson(Map<String, dynamic> json) =>
      _$MapModelFromJson(json);
  Map<String, dynamic> toJson() => _$MapModelToJson(this);
}
