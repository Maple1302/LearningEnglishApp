// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sectionmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionModel _$SectionModelFromJson(Map<String, dynamic> json) => SectionModel(
      id: json['id'] as String,
      description: json['description'] as String,
      topics: (json['topics'] as List<dynamic>)
          .map((e) => TopicModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SectionModelToJson(SectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'topics': instance.topics.map((e) => e.toJson()).toList(),
    };
