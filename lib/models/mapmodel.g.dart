// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapModel _$MapModelFromJson(Map<String, dynamic> json) => MapModel(
      id: json['id'] as String,
      description: json['description'] as String,
      topics: (json['topics'] as List<dynamic>)
          .map((e) => TopicModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MapModelToJson(MapModel instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'topics': instance.topics.map((e) => e.toJson()).toList(),
    };
