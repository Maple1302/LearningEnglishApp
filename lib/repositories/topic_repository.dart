import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maple/models/topicmodel.dart';

class TopicRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTopic(TopicModel topic) async {
    await _firestore.collection('Topics').doc(topic.id).set(topic.toJson());
  }

  Future<List<TopicModel>> fetchTopics() async {
    QuerySnapshot snapshot = await _firestore.collection('Topics').get();
    return snapshot.docs.map((doc) => TopicModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> updateTopic(String id, TopicModel topic) async {
    await _firestore.collection('Topics').doc(id).update(topic.toJson());
  }

  Future<void> deleteTopic(String id) async {
    await _firestore.collection('Topics').doc(id).delete();
  }
}
