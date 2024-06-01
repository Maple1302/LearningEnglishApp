import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:maple/models/topicmodel.dart';
import 'package:maple/views/lessons/lessons.dart';

class TopicWidget extends StatefulWidget {
  final TopicModel topic;
  final String title;
  final bool enable;

  const TopicWidget({super.key, required this.topic, required this.title, required this.enable});

  @override
  State<TopicWidget> createState() => _TopicWidgetState();
}

class _TopicWidgetState extends State<TopicWidget> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: widget.enable ? HexColor(widget.topic.color) : Colors.grey,
          child: ListTile(title: Text(widget.title,style: TextStyle(color:widget.enable ? Colors.white:Colors.black),))),
        const SizedBox(height: 10),
        Lessons(listLesson: widget.topic.lessons, enable: widget.enable,),
      ],
    );
  }
}
