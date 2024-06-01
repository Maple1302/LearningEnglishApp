import 'package:flutter/material.dart';
import 'package:maple/models/lessonmodel.dart';
import 'package:maple/models/mapmodel.dart';
import 'package:maple/models/questionmodel.dart';
import 'package:maple/models/topicmodel.dart';
import 'package:maple/repositories/map_repository.dart';
import 'package:maple/utils/constants.dart';

class MapViewModel extends ChangeNotifier {
  final MapRepository _repository = MapRepository();
  List<MapModel> _maps = [];

  List<MapModel> get maps => _maps;
  // Lấy danh sách maps và cập nhật trạng thái
  Future<List<MapModel>> fetchMaps() async {
    try {
      final newMaps = await _repository.fetchMaps();
      if (newMaps != _maps) {
        // Check if maps have changed
        _maps = newMaps;
        notifyListeners();
      }
      return _maps;
    } catch (e) {
      // Xử lý lỗi ở đây, ví dụ
      return []; // Hoặc trả về một danh sách rỗng nếu có lỗi
    } finally {
      notifyListeners();
    }
  }
Future<MapModel?> getMapById(String mapId) async {
    try {
      final map = await _repository.getMapById(mapId);
      return map;
    } catch (e) {
      throw Exception('Failed to fetch map: $e');
    }
  }
  Future<void> addMap(MapModel map) async {
    await _repository.addMap(map);
    await fetchMaps();
  }

  String generateId() {
    if (maps.isEmpty) {
      return "1";
    }
    int maxId = maps.isNotEmpty
        ? maps.map((map) => int.parse(map.id)).reduce((a, b) => a > b ? a : b)
        : 0;
    return (maxId + 1).toString();
  }

  Future<void> updateMap(MapModel map) async {
    await _repository.updateMap(map);
    await fetchMaps();
  }

  Future<void> deleteMap(String id) async {
    await _repository.deleteMap(id);
    await fetchMaps();
  }



  String newIdQuestion(
    String mapId,
    String topicId,
    String lessonId,
  ) {
    MapModel? map = _maps.firstWhere((map) => map.id == mapId);

    // Tìm topic theo id trong map đã tìm
    TopicModel? topic = map.topics.firstWhere((topic) => topic.id == topicId);

    // Tìm lesson theo id trong topic đã tìm
    LessonModel? lesson =
        topic.lessons.firstWhere((lesson) => lesson.id == lessonId);

    // Tìm id lớn nhất trong danh sách các câu hỏi hiện có
    int maxId = lesson.question.isNotEmpty
        ? lesson.question
            .map((question) => int.parse(question.id))
            .reduce((a, b) => a > b ? a : b)
        : 0;

    return (maxId + 1).toString();
  }

  Future<void> addListQuestion(String mapId, String topicId, String lessonId,
      QuestionModel newListQuestion) async {
    MapModel? map = _maps.firstWhere((map) => map.id == mapId);
    TopicModel? topic = map.topics.firstWhere((topic) => topic.id == topicId);
    LessonModel? lesson =
        topic.lessons.firstWhere((lesson) => lesson.id == lessonId);
    
    lesson.question.add(newListQuestion);
    await _repository.updateLesson(mapId, topicId, lesson);
    await fetchMaps();
  }

  Future<void> addQuestion(String mapId, String topicId, String lessonId,
      dynamic updateQuestion, int index, String questionId) async {
    MapModel? map = _maps.firstWhere((map) => map.id == mapId);
    TopicModel? topic = map.topics.firstWhere((topic) => topic.id == topicId);
    LessonModel? lesson =
        topic.lessons.firstWhere((lesson) => lesson.id == lessonId);
    QuestionModel questionModel =
        lesson.question.firstWhere((question) => question.id == questionId);
    //    int maxQuestionId = listQuestionModel.isNotEmpty
    //       ? listQuestionModel.map((q) => int.parse(q.id)).reduce((a, b) => a > b ? a : b)
    //     : 0;
    //  String updateQuestionId = (maxQuestionId + 1).toString();

    //  dynamic updatedQuestions;
    //  String typeOfQuestion = updateQuestion.typeOfQuestion;
    switch (updateQuestion.typeOfQuestion) {
      case completeConversationQuestion:
        questionModel.completeConversationQuestions.add(updateQuestion);
        break;
      case transerlationReadQueston:
        questionModel.translationQuestions.add(updateQuestion);
        break;
      case transerlationListenQueston:
        questionModel.translationQuestions.add(updateQuestion);
        break;
      case matchingPairWordQuestion:
        questionModel.matchingPairQuestions.add(updateQuestion);

        break;
      case matchingPairSoundQuestion:
        questionModel.matchingPairQuestions.add(updateQuestion);

        break;
      case listenQuestion:
        questionModel.listeningQuestions.add(updateQuestion);

        break;
      case imageSelectionQuestions:
        questionModel.imageSelectionQuestions.add(updateQuestion);

        break;
      case pronunciationQuestion:
        questionModel.pronunciationQuestions.add(updateQuestion);

        break;
      case completeMissingSentenceQuestion:
        questionModel.completeMissingSentenceQuestions.add(updateQuestion);

        break;
      case cardMutilChoiceQuestion:
        questionModel.answersCardQuestions.add(updateQuestion);
        break;
      default:
        break;
    }
    await _repository.updateQuestion(mapId, topicId, lessonId, questionModel);
    await fetchMaps();
  }

  Future<void> updateQuestion(String mapId, String topicId, String lessonId,
      dynamic updateQuestion, int index, String questionId) async {
    MapModel? map = _maps.firstWhere((map) => map.id == mapId);
    TopicModel? topic = map.topics.firstWhere((topic) => topic.id == topicId);
    LessonModel? lesson =
        topic.lessons.firstWhere((lesson) => lesson.id == lessonId);
    QuestionModel questionModel =
        lesson.question.firstWhere((question) => question.id == questionId);
 
    switch (updateQuestion.typeOfQuestion) {
      case completeConversationQuestion:
        questionModel.completeConversationQuestions[index] = updateQuestion;
        break;
      case transerlationReadQueston:
        questionModel.translationQuestions[index] = updateQuestion;
        break;
      case transerlationListenQueston:
        questionModel.translationQuestions[index] = updateQuestion;
        break;
      case matchingPairWordQuestion:
        questionModel.matchingPairQuestions[index] = updateQuestion;

        break;
      case matchingPairSoundQuestion:
        questionModel.matchingPairQuestions[index] = updateQuestion;

        break;
      case listenQuestion:
        questionModel.listeningQuestions[index] = updateQuestion;

        break;
      case imageSelectionQuestions:
        questionModel.imageSelectionQuestions[index] = updateQuestion;

        break;
      case pronunciationQuestion:
        questionModel.pronunciationQuestions[index] = updateQuestion;

        break;
      case completeMissingSentenceQuestion:
        questionModel.completeMissingSentenceQuestions[index] = updateQuestion;

        break;
      case cardMutilChoiceQuestion:
        questionModel.answersCardQuestions[index] = updateQuestion;
        break;
      default:
        break;
    }
    await _repository.updateQuestion(mapId, topicId, lessonId, questionModel);
    await fetchMaps();
  }

  Future<void> updateListQuestion(String mapId, String topicId, String lessonId,
      QuestionModel updatedQuestion) async {
    MapModel? map = _maps.firstWhere((map) => map.id == mapId);
    TopicModel? topic = map.topics.firstWhere((topic) => topic.id == topicId);
    LessonModel? lesson =
        topic.lessons.firstWhere((lesson) => lesson.id == lessonId);
    int questionIndex = lesson.question
        .indexWhere((question) => question.id == updatedQuestion.id);
    if (questionIndex != -1) {
      lesson.question[questionIndex] = updatedQuestion;
      await _repository.updateLesson(mapId, topicId, lesson);
      await fetchMaps();
    }
  }

  Future<void> deleteListQuestion(
      String mapId, String topicId, String lessonId, String questionId) async {
    MapModel? map = _maps.firstWhere((map) => map.id == mapId);
    TopicModel? topic = map.topics.firstWhere((topic) => topic.id == topicId);
    LessonModel? lesson =
        topic.lessons.firstWhere((lesson) => lesson.id == lessonId);
    lesson.question.removeWhere((question) => question.id == questionId);
    await _repository.updateLesson(mapId, topicId, lesson);
    await fetchMaps();
  }

  Future<void> deleteQuestion(String mapId, String topicId, String lessonId,
      String questionId, dynamic question, int index) async {
    MapModel? map = _maps.firstWhere((map) => map.id == mapId);
    TopicModel? topic = map.topics.firstWhere((topic) => topic.id == topicId);
    LessonModel? lesson =
        topic.lessons.firstWhere((lesson) => lesson.id == lessonId);

    QuestionModel listQuestion =
        lesson.question.firstWhere((question) => question.id == questionId);
    switch (question.typeOfQuestion) {
      case completeConversationQuestion:
        listQuestion.completeConversationQuestions.removeAt(index);
        // updatedQuestions =List.from(listQuestion.completeConversationQuestions)
        //       ..add(updateQuestion);
        break;
      case transerlationReadQueston || transerlationListenQueston:
        listQuestion.translationQuestions.removeAt(index);
        break;

      case matchingPairWordQuestion || matchingPairSoundQuestion:
        listQuestion.matchingPairQuestions.removeAt(index);

        break;
      case listenQuestion:
        listQuestion.listeningQuestions.removeAt(index);

        break;
      case imageSelectionQuestions:
        listQuestion.imageSelectionQuestions.removeAt(index);

        break;
      case pronunciationQuestion:
        listQuestion.pronunciationQuestions.removeAt(index);

        break;
      case completeMissingSentenceQuestion:
        listQuestion.completeMissingSentenceQuestions.removeAt(index);

        break;
      case cardMutilChoiceQuestion:
        listQuestion.answersCardQuestions.removeAt(index);
        break;
      default:
        break;
    }
    await _repository.updateQuestion(mapId, topicId, lessonId, listQuestion);
    await fetchMaps();
  }

  String newLessonId(String mapId, String topicId) {
    MapModel? map = _maps.firstWhere((map) => map.id == mapId);
    TopicModel? topic = map.topics.firstWhere((topic) => topic.id == topicId);
    int maxLessonId = topic.lessons.isNotEmpty
        ? topic.lessons
            .map((lesson) => int.parse(lesson.id))
            .reduce((a, b) => a > b ? a : b)
        : 0;
    String newLessonId = (maxLessonId + 1).toString();
    return newLessonId;
  }

  Future<void> addLesson(
      String mapId, String topicId, LessonModel newLesson) async {
    await _repository.addLesson(mapId, topicId, newLesson);
    await fetchMaps();
  }

  Future<void> updateLesson(String mapId, String topicId, updatedLesson) async {
    await _repository.updateLesson(mapId, topicId, updatedLesson);
    await fetchMaps();
  }

  Future<void> deleteLesson(
      String mapId, String topicId, String lessonId) async {
    await _repository.deleteLesson(mapId, topicId, lessonId);
    await fetchMaps();
  }

  String newIdTopic(
    String mapId,
  ) {
    MapModel? map = _maps.firstWhere((map) => map.id == mapId);

    int maxTopicId = map.topics.isNotEmpty
        ? map.topics
            .map((topic) => int.parse(topic.id))
            .reduce((a, b) => a > b ? a : b)
        : 0;
    String newTopicId = (maxTopicId + 1).toString();
    return newTopicId;
  }

  Future<void> addTopic(String mapId, TopicModel newTopic) async {
    await _repository.addTopic(mapId, newTopic);
    await fetchMaps();
  }

  Future<void> updateTopic(String mapId, TopicModel updatedTopic) async {
    await _repository.updateTopic(mapId, updatedTopic);
    await fetchMaps();
  }

  Future<void> deleteTopic(String mapId, String topicId) async {
    await _repository.deleteTopic(
      mapId,
      topicId,
    );
    await fetchMaps();
  }
}
