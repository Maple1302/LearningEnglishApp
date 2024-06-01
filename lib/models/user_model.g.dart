// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      role: json['role'] as String? ?? "user",
      dateCreate: json['dateCreate'] as String,
      urlAvatar: json['urlAvatar'] as String,
      signInMethod: json['signInMethod'] as String,
      completedLessons: json['completedLessons'] as String,
      progress: json['progress'] as String,
      username: json['username'] as String?,
      streak: json['streak'] as String,
      language: json['language'] as String,
      heart: json['heart'] as String,
      gem: json['gem'] as String,
      kN: json['kN'] as String,
      lastCompletionDate: json['lastCompletionDate'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'role': instance.role,
      'email': instance.email,
      'urlAvatar': instance.urlAvatar,
      'dateCreate': instance.dateCreate,
      'signInMethod': instance.signInMethod,
      'completedLessons': instance.completedLessons,
      'progress': instance.progress,
      'username': instance.username,
      'streak': instance.streak,
      'language': instance.language,
      'heart': instance.heart,
      'gem': instance.gem,
      'kN': instance.kN,
      'lastCompletionDate': instance.lastCompletionDate,
    };
