import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maple/models/lessonmodel.dart';

class LessonRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLesson(LessonModel lesson) async {
    await _firestore.collection('Lessons').doc(lesson.id).set(lesson.toJson());
  }

  Future<List<LessonModel>> fetchLessons() async {
    QuerySnapshot snapshot = await _firestore.collection('Lessons').get();
    return snapshot.docs.map((doc) => LessonModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> updateLesson(String id, LessonModel lesson) async {
    await _firestore.collection('Lessons').doc(id).update(lesson.toJson());
  }

  Future<void> deleteLesson(String id) async {
    await _firestore.collection('Lessons').doc(id).delete();
  }
}
