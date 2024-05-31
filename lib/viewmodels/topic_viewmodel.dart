import 'package:flutter/material.dart';
import 'package:maple/models/topicmodel.dart';
import 'package:maple/repositories/topic_repository.dart';

class TopicViewModel extends ChangeNotifier {
  final TopicRepository _repository = TopicRepository();
  List<TopicModel> _topics = [];

  List<TopicModel> get topics => _topics;

  Future<void> fetchTopics() async {
    _topics = await _repository.fetchTopics();
    notifyListeners();
  }

  Future<void> addTopic(TopicModel topic) async {
    await _repository.addTopic(topic);
    await fetchTopics();
  }

String generateId(){
    if(topics.isEmpty){
      return "1";
    }
    return (topics.length + 1).toString();
  }
  Future<void> updateTopic(String id, TopicModel topic) async {
    await _repository.updateTopic(id, topic);
    await fetchTopics();
  }

  Future<void> deleteTopic(String id) async {
    await _repository.deleteTopic(id);
    await fetchTopics();
  }
}
