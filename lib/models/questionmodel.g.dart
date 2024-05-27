// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      id: json['id'] as String,
      answersCardQuestions: (json['answersCardQuestions'] as List<dynamic>)
          .map((e) => AnswersCardQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      completeConversationQuestions: (json['completeConversationQuestions']
              as List<dynamic>)
          .map((e) =>
              CompleteConversationQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      completeMissingSentenceQuestions:
          (json['completeMissingSentenceQuestions'] as List<dynamic>)
              .map((e) => CompleteMissingSentenceQuestion.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
      imageSelectionQuestions: (json['imageSelectionQuestions']
              as List<dynamic>)
          .map(
              (e) => ImageSelectionQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      listeningQuestions: (json['listeningQuestions'] as List<dynamic>)
          .map((e) => ListeningQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      matchingPairQuestions: (json['matchingPairQuestions'] as List<dynamic>)
          .map((e) => MatchingPairQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      pronunciationQuestions: (json['pronunciationQuestions'] as List<dynamic>)
          .map((e) => PronunciationQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      translationQuestions: (json['translationQuestions'] as List<dynamic>)
          .map((e) => TranslationQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'answersCardQuestions':
          instance.answersCardQuestions.map((e) => e.toJson()).toList(),
      'completeConversationQuestions': instance.completeConversationQuestions
          .map((e) => e.toJson())
          .toList(),
      'completeMissingSentenceQuestions': instance
          .completeMissingSentenceQuestions
          .map((e) => e.toJson())
          .toList(),
      'imageSelectionQuestions':
          instance.imageSelectionQuestions.map((e) => e.toJson()).toList(),
      'listeningQuestions':
          instance.listeningQuestions.map((e) => e.toJson()).toList(),
      'matchingPairQuestions':
          instance.matchingPairQuestions.map((e) => e.toJson()).toList(),
      'pronunciationQuestions':
          instance.pronunciationQuestions.map((e) => e.toJson()).toList(),
      'translationQuestions':
          instance.translationQuestions.map((e) => e.toJson()).toList(),
    };
