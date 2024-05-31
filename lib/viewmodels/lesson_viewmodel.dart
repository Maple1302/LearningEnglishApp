import 'package:flutter/material.dart';
import 'package:maple/models/lessonmodel.dart';
import 'package:maple/repositories/lesson_repository.dart';

class LessonViewModel extends ChangeNotifier {
  final LessonRepository _repository = LessonRepository();
  List<LessonModel> _lessons = [];

  List<LessonModel> get lessons => _lessons;

  Future<void> fetchLessons() async {
    _lessons = await _repository.fetchLessons();
    notifyListeners();
  }

  Future<void> addLesson(LessonModel lesson) async {
    await _repository.addLesson(lesson);
    await fetchLessons();
  }

  Future<void> updateLesson(String id, LessonModel lesson) async {
    await _repository.updateLesson(id, lesson);
    await fetchLessons();
  }

  Future<void> deleteLesson(String id) async {
    await _repository.deleteLesson(id);
    await fetchLessons();
  }
  String generateId(){
    if(lessons.isEmpty){
      return "1";
    }
    return (lessons.length + 1).toString();
  }
}
