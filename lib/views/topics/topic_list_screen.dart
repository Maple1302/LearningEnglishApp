import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:maple/models/mapmodel.dart';
import 'package:maple/models/topicmodel.dart';
import 'package:maple/viewmodels/map_viewmodel.dart';
import 'package:maple/viewmodels/topic_viewmodel.dart';
import 'package:maple/views/admin/static_view.dart';
import 'package:maple/views/lessons/lesson_list_screen.dart';

import 'package:provider/provider.dart';

class TopicListScreen extends StatefulWidget {
  final MapModel mapModel;
  const TopicListScreen({super.key, required this.mapModel});

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  List<TopicModel> topics = [];

  @override
  void initState() {
    super.initState();
    topics = widget.mapModel.topics.toList();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: const Text(""),
        centerTitle: true,
        title: Text(widget.mapModel.description),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTopic = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTopicScreen(
                      map: widget.mapModel,
                    )),
          );

          if (newTopic != null) {
            setState(() {
              topics.add(newTopic[0] as TopicModel);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return StatisticsCard(
            title: topic.description,
            progress: const ProgressIndicatorCustom(
              progress: 70,
              size: 20,
              displayText: '%',
            ),
            topic: topic,
            color: HexColor(topic.color),
            mapId: widget.mapModel.id,
            onDelete: (TopicModel topic) {
              setState(() {
                viewModel.deleteTopic(widget.mapModel.id, topic.id);
                topics.remove(topic);
              });
            },
            onEdit: (TopicModel updatedTopic) {
              setState(() {
                topics[index] = updatedTopic;
              });
            },
          );
        },
      ),
    );
  }
}

class StatisticsCard extends StatefulWidget {
  final String title;
  final TopicModel topic;
  final Widget progress;
  final Color color;
  final String mapId;
  final Function onDelete;
  final Function onEdit;
  const StatisticsCard({super.key, required this.title, required this.topic, required this.progress, required this.color, required this.mapId, required this.onDelete, required this.onEdit});

  @override
  State<StatisticsCard> createState() => _StatisticsCardState();
}

class _StatisticsCardState extends State<StatisticsCard> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TopicViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonListScreen(topic: widget.topic, mapId: widget.mapId),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: widget.color,
          shadowColor: Colors.grey,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: widget.progress,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              viewModel.deleteTopic(widget.topic.id);
                              widget.onDelete(widget.topic);
                            },
                            icon: const Icon(Icons.delete_forever),
                           
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () async {
                              final updatedTopic = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTopicScreen(topic: widget.topic, map: widget.mapId),
                                ),
                              );

                              if (updatedTopic != null) {
                                widget.onEdit(updatedTopic);
                              }
                            },
                            icon: const Icon(Icons.edit),
                           
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddTopicScreen extends StatelessWidget {
  final TextEditingController _descriptionController = TextEditingController();
  final MapModel map;
  AddTopicScreen({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Topic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final topic = TopicModel(
                  id: '',
                  description: _descriptionController.text,
                  lessons: [],
                  color: getRandomColor(),
                );

                viewModel.addTopic(map.id, topic);
                List<dynamic> backData = [topic];
                Navigator.pop(context, backData);
              },
              child: const Text('Thêm Topic'),
            ),
          ],
        ),
      ),
    );
  }

  String getRandomColor() {
    final List<String> colorHexCodes = [
      '#57cc02', // xanh lá cây
      '#cc3c3d', // đỏ
      '#cc6ca7', // hồng
      '#168dc5', // xanh
      '#ffc605', //vàng
    ];

    final Random random = Random();
    String hexCode = colorHexCodes[random.nextInt(colorHexCodes.length)];

    return hexCode;
  }
}

class EditTopicScreen extends StatefulWidget {
  final TopicModel topic;
  final String map;
  EditTopicScreen({super.key, required this.topic, required this.map});

  @override
  State<EditTopicScreen> createState() => _EditTopicScreenState();
}

class _EditTopicScreenState extends State<EditTopicScreen> {
  late TextEditingController _descriptionController;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.topic.description);
    _selectedColor = widget.topic.color;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa Topic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedTopic = TopicModel(
                  id: widget.topic.id,
                  description: _descriptionController.text,
                  lessons: widget.topic.lessons,
                  color: _selectedColor,
                );

                viewModel.updateTopic(widget.map, updatedTopic);
                Navigator.pop(context, updatedTopic);
              },
              child: const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}
