import 'package:flutter/material.dart';

import 'package:maple/models/topicmodel.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';

import 'package:maple/views/topics/topic_widget.dart';
import 'package:provider/provider.dart';

class TopicListScreenUser extends StatefulWidget {
  final List<TopicModel> topics;
  final String description;
  final int mapId;
 final bool isMapUnlocked ;
 final bool isCurrentMap;
  const TopicListScreenUser(
      {super.key,
      required this.topics,
      required this.description,
      required this.mapId, required this.isMapUnlocked, required this.isCurrentMap});

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
        title: Text(widget.description),
      ),
      body: ListView.builder(
        itemCount: widget.topics.length,
        itemBuilder: (context, index) {
          return TopicWidget(
            mapId: widget.mapId,
            topicId: index,
            topic: widget.topics[index],
            title: "Cửa ${index + 1}",
            subtitle: widget.topics[index].description,
            isCureentTopicUnlockFull:index < int.parse(completedTopic),
            isCurrentTopic: index == int.parse(completedTopic),
            isMapUnlocked : widget.isMapUnlocked, isCurrentMap:widget.isCurrentMap
          );
        },
      ),
    );
  }
}
