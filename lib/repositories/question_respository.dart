import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maple/models/questionmodel.dart'; // Import model của bạn

class QuestionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'Questions'; // Đường dẫn collection trên Firebase

  // Lấy danh sách câu hỏi
  Future<List<QuestionModel>> fetchQuestions() async {
    try {
      final snapshot = await _firestore.collection(_collectionPath).get();
      return snapshot.docs.map((doc) => QuestionModel.fromJson(doc.data())).toList();
    } catch (e) {
      // Xử lý lỗi (ví dụ: in ra log, hiển thị thông báo lỗi)
      throw Exception('Failed to fetch questions: $e');
    }
  }

  // Thêm câu hỏi mới
  Future<void> addQuestion(QuestionModel question) async {
    try {
      await _firestore.collection(_collectionPath).doc(question.id).set(question.toJson());
    } catch (e) {
      throw Exception('Failed to add question: $e');
    }
  }

  // Cập nhật câu hỏi
  Future<void> updateQuestion(QuestionModel question) async {
    try {
      await _firestore.collection(_collectionPath).doc(question.id).update(question.toJson());
    } catch (e) {
      throw Exception('Failed to update question: $e');
    }
  }

  // Xóa câu hỏi
  Future<void> deleteQuestion(String questionId) async {
    try {
      await _firestore.collection(_collectionPath).doc(questionId).delete();
    } catch (e) {
      throw Exception('Failed to delete question: $e');
    }
  }
}
