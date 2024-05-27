import 'package:flutter/material.dart';
import 'package:maple/models/questionmodel.dart';
import 'package:maple/repositories/question_respository.dart';

class QuestionViewModel extends ChangeNotifier {
  final QuestionRepository _repository = QuestionRepository();
  List<QuestionModel> _questions = [];

  List<QuestionModel> get questions => _questions;

  Future<void> fetchQuestions() async {
    _questions = await _repository.fetchQuestions();
    notifyListeners();
  }

  Future<void> addQuestion(QuestionModel question) async {
    
    await _repository.addQuestion(question);
    await fetchQuestions();
  }

  Future<void> updateQuestion( QuestionModel question) async {
    await _repository.updateQuestion( question);
    await fetchQuestions();
  }

  Future<void> deleteQuestion(String id) async {
    await _repository.deleteQuestion(id);
    await fetchQuestions();
  }

 
}
