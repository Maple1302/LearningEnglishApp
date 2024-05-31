// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topicmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicModel _$TopicModelFromJson(Map<String, dynamic> json) => TopicModel(
      id: json['id'] as String,
      description: json['description'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      color: json['color'] as String,
    );

Map<String, dynamic> _$TopicModelToJson(TopicModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'lessons': instance.lessons.map((e) => e.toJson()).toList(),
      'color': instance.color,
    };
