import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:maple/models/topicmodel.dart';
import 'package:maple/views/lessons/lessons.dart';

class TopicWidget extends StatefulWidget {
  final TopicModel topic;
  final String title;
  final String subtitle;
  final bool isCurrentTopic;
  final bool isCureentTopicUnlockFull;
  final int mapId;
  final int topicId;
  final bool isMapUnlocked;
  final bool isCurrentMap;

  const TopicWidget(
      {super.key,
      required this.topic,
      required this.title,
      required this.isCurrentTopic,
      required this.subtitle,
      required this.mapId,
      required this.topicId,
      required this.isCureentTopicUnlockFull,
      required this.isMapUnlocked,
      required this.isCurrentMap});

  @override
  State<TopicWidget> createState() => _TopicWidgetState();
}

class _TopicWidgetState extends State<TopicWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: (widget.isCureentTopicUnlockFull || widget.isCurrentTopic || widget.isMapUnlocked)
              ? HexColor(widget.topic.color)
              : Colors.grey,
          child: ListTile(
            titleTextStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: (widget.isCureentTopicUnlockFull || widget.isCurrentTopic || widget.isMapUnlocked)
                  ? Colors.white
                  : Colors.black,
            ),
            subtitleTextStyle: TextStyle(
                fontSize: 18,
                color:
                    (widget.isCureentTopicUnlockFull || widget.isCurrentTopic || widget.isMapUnlocked)
                        ? Colors.white
                        : Colors.black),
            title: Text(
              widget.title,
              style: TextStyle(
                  color:
                      (widget.isCureentTopicUnlockFull || widget.isCurrentTopic || widget.isMapUnlocked)
                          ? Colors.white
                          : Colors.black),
            ),
            subtitle: Text(
              widget.subtitle,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Lessons(
            mapId: widget.mapId,
            topicId: widget.topicId,
            listLesson: widget.topic.lessons,
            isCurrentTopic: widget.isCurrentTopic,
            isCureentTopicUnlockFull: widget.isCureentTopicUnlockFull,
            isMapUnlocked: widget.isMapUnlocked,
            isCurrentMap: widget.isCurrentMap),
      ],
    );
  }
}
