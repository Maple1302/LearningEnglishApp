import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maple/models/lessonmodel.dart';
import 'package:maple/models/mapmodel.dart';
import 'package:maple/models/questionmodel.dart';
import 'package:maple/models/topicmodel.dart';

class MapRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath =
      'Maps'; // Đường dẫn đến collection trên Firebase

  // Lấy danh sách maps
  Future<List<MapModel>> fetchMaps() async {
    try {
      final snapshot = await _firestore.collection(_collectionPath).get();
      return snapshot.docs.map((doc) => MapModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch maps: $e');
    }
  }

  Future<MapModel?> getMapById(String mapId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection(_collectionPath).doc(mapId).get();
      if (documentSnapshot.exists) {
        return MapModel.fromJson(
            documentSnapshot.data() as Map<String, dynamic>);
      } else {
        print("Roong");
        return null;
      }
    } catch (e) {
      print("Roong");
    return null;
    }
  }

  Future<void> addTopic(String mapId, TopicModel newTopic) async {
    try {
      MapModel? mapModel = await getMapById(mapId);
      if (mapModel != null) {
        List<TopicModel> updatedtopics = [...mapModel.topics, newTopic];

        await updateMaptopics(mapId, updatedtopics);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateMaptopics(String mapId, List<TopicModel> newtopics) async {
    try {
      await _firestore.collection(_collectionPath).doc(mapId).update({
        'topics': newtopics.map((topic) => topic.toJson()).toList(),
      });
      
    } catch (e) {
      return;
    }
  }

  Future<void> deleteTopic(String mapId, String topicId) async {
    try {
      MapModel? mapModel = await getMapById(mapId);
      if (mapModel != null) {
        List<TopicModel> updatedtopics =
            mapModel.topics.where((topic) => topic.id != topicId).toList();

        await updateMaptopics(mapId, updatedtopics);
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> addQuestion(String mapId, String topicId, String lessonId, QuestionModel newQuestion) async {
    try {
      MapModel? mapModel = await getMapById(mapId);
      if (mapModel != null) {
        List<TopicModel> updatedtopics = mapModel.topics.map((topic) {
          if (topic.id == topicId) {
            List<LessonModel> updatedLessons = topic.lessons.map((lesson) {
              if (lesson.id == lessonId) {
                return LessonModel(
                  id: lesson.id,
                  title: lesson.title,
                  description: lesson.description,
                  question: [...lesson.question, newQuestion],
                  images: lesson.images,
                  color: lesson.color,
                );
              }
              return lesson;
            }).toList();
            return TopicModel(id: topic.id, description: topic.description, lessons: updatedLessons,color: topic.color);
          }
          return topic;
        }).toList();

        await updateMaptopics(mapId, updatedtopics);
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> updateTopic(String mapId, TopicModel updatedTopic) async {
    try {
      MapModel? mapModel = await getMapById(mapId);
      if (mapModel != null) {
        List<TopicModel> updatedtopics = mapModel.topics.map((topic) {
          if (topic.id == updatedTopic.id) {
            return updatedTopic;
          }
          return topic;
        }).toList();

        await updateMaptopics(mapId, updatedtopics);
      }
    } catch (e) {
      print("Lỗi khi cập nhật topic: $e");
    }
  }
  Future<void> updateQuestion(String mapId, String topicId, String lessonId,
      QuestionModel updatedQuestion) async {
    try {
      MapModel? mapModel = await getMapById(mapId);
      if (mapModel != null) {
        List<TopicModel> updatedtopics = mapModel.topics.map((topic) {
          if (topic.id == topicId) {
            List<LessonModel> updatedLessons = topic.lessons.map((lesson) {
              if (lesson.id == lessonId) {
                List<QuestionModel> updatedQuestions =
                    lesson.question.map((question) {
                  if (question.id == updatedQuestion.id) {
                    return updatedQuestion;
                  }
                  return question;
                }).toList();
                return LessonModel(
                  id: lesson.id,
                  title: lesson.title,
                  description: lesson.description,
                  question: updatedQuestions,
                  images: lesson.images,
                  color: lesson.color,
                );
              }
              return lesson;
            }).toList();
            return TopicModel(
                id: topic.id,
                lessons: updatedLessons,
                description: topic.description,
                color: topic.color);
          }
          return topic;
        }).toList();

        await updateMaptopics(mapId, updatedtopics);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteQuestion(
      String mapId, String topicId, String lessonId, String questionId) async {
    try {
      MapModel? mapModel = await getMapById(mapId);
      if (mapModel != null) {
        List<TopicModel> updatedtopics = mapModel.topics.map((topic) {
          if (topic.id == topicId) {
            List<LessonModel> updatedLessons = topic.lessons.map((lesson) {
              if (lesson.id == lessonId) {
                List<QuestionModel> updatedQuestions = lesson.question
                    .where((question) => question.id != questionId)
                    .toList();
                return LessonModel(
                  id: lesson.id,
                  title: lesson.title,
                  description: lesson.description,
                  question: updatedQuestions,
                  images: lesson.images,
                  color: lesson.color,
                );
              }
              return lesson;
            }).toList();
            return TopicModel(
                id: topic.id,
                lessons: updatedLessons,
                description: topic.description,
                color: topic.color);
          }
          return topic;
        }).toList();

        await updateMaptopics(mapId, updatedtopics);
      }
    } catch (e) {
     print(e);
    }
  }

  Future<void> addLesson(
      String mapId, String topicId, LessonModel newLesson) async {
    try {
      MapModel? mapModel = await getMapById(mapId);
      if (mapModel != null) {
        List<TopicModel> updatedtopics = mapModel.topics.map((topic) {
          if (topic.id == topicId) {
            return TopicModel(
                id: topic.id,
                lessons: [...topic.lessons, newLesson],
                description: topic.description,
                color: topic.color);
          }
          return topic;
        }).toList();

        await updateMaptopics(mapId, updatedtopics);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateLesson(
      String mapId, String topicId, LessonModel updatedLesson) async {
    try {
      MapModel? mapModel = await getMapById(mapId);
      if (mapModel != null) {
        List<TopicModel> updatedtopics = mapModel.topics.map((topic) {
          if (topic.id == topicId) {
            List<LessonModel> updatedLessons = topic.lessons.map((lesson) {
              if (lesson.id == updatedLesson.id) {
                return updatedLesson;
              }
              return lesson;
            }).toList();
            return TopicModel(
                id: topic.id,
                lessons: updatedLessons,
                description: topic.description,
                color: topic.color);
          }
          return topic;
        }).toList();

        await updateMaptopics(mapId, updatedtopics);
      }
    } catch (e) {
     print(e);
    }
  }

  Future<void> deleteLesson(
      String mapId, String topicId, String lessonId) async {
    try {
      MapModel? mapModel = await getMapById(mapId);
      if (mapModel != null) {
        List<TopicModel> updatedtopics = mapModel.topics.map((topic) {
          if (topic.id == topicId) {
            List<LessonModel> updatedLessons =
                topic.lessons.where((lesson) => lesson.id != lessonId).toList();
            return TopicModel(
                id: topic.id,
                lessons: updatedLessons,
                description: topic.id,
                color: topic.color);
          }
          return topic;
        }).toList();

        await updateMaptopics(mapId, updatedtopics);
      }
    } catch (e) {
      print("Lỗi khi xóa lesson: $e");
    }
  }

  // Thêm map mới
  Future<void> addMap(MapModel map) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(map.id)
          .set(map.toJson());
    } catch (e) {
      throw Exception('Failed to add map: $e');
    }
  }

  // Cập nhật map
  Future<void> updateMap(MapModel map) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(map.id)
          .update(map.toJson());
    } catch (e) {
      throw Exception('Failed to update map: $e');
    }
  }

  // Xóa map
  Future<void> deleteMap(String mapId) async {
    try {
      await _firestore.collection(_collectionPath).doc(mapId).delete();
    } catch (e) {
      throw Exception('Failed to delete map: $e');
    }
  }
}
