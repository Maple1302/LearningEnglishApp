import 'package:flutter/material.dart';

import 'package:maple/models/topicmodel.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';

import 'package:maple/views/topics/topic_widget.dart';
import 'package:provider/provider.dart';

class TopicListScreenUser extends StatefulWidget {
  final List<TopicModel> topics;
  final String description;
  const TopicListScreenUser(
      {super.key, required this.topics, required this.description});

  @override
  State<TopicListScreenUser> createState() => _TopicListScreenUserState();
}

class _TopicListScreenUserState extends State<TopicListScreenUser> {
  @override
  Widget build(BuildContext context) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    
    String completedTopic = authViewModel.user!.completedLessons.split(";")[1];
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.description),
      ),
      body: ListView.builder(
        itemCount: widget.topics.length,
        itemBuilder: (context, index) {
          return TopicWidget(
            topic: widget.topics[index], title: "Cửa ${index+1}: ${widget.topics[index].description}", enable: index <= int.parse(completedTopic) - 1,
          );
        },
      ),
    );
  }
}
