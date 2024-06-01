import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';
@JsonSerializable(explicitToJson: true)
class UserModel {
  final String uid;
  final String role;
  final String? email;
  final String urlAvatar;
  final String dateCreate;
  final String signInMethod;
  final String completedLessons;
  final String progress; 
  final String? username;
  final String streak;
  final String language;
  final String heart;
  final String gem;
  final String kN;
  final String lastCompletionDate;

  UserModel({
    required this.uid,
    this.email,
    required this.role,
    required this.dateCreate,
    required this.urlAvatar ,
    required this.signInMethod, 
    required this.completedLessons,
    required this.progress,
    required this.username,
    required this.streak,
    required this.language,
    required this.heart,
    required this.gem,
    required this.kN,
    required this.lastCompletionDate
  });
factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}


