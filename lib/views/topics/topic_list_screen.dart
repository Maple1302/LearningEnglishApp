import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:maple/models/mapmodel.dart';
import 'package:maple/models/topicmodel.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget.mapModel);
          },
        ),
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
            topic: topic,
            mapId: widget.mapModel.id,
            index:index,
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
  final TopicModel topic;
  final String mapId;
  final int index;
  final Function onDelete;
  final Function onEdit;
  

  const StatisticsCard({
    super.key,
    required this.topic,
    required this.mapId,
    required this.onDelete,
    required this.onEdit,
    required this.index,
  });

  @override
  State<StatisticsCard> createState() => _StatisticsCardState();
}

class _StatisticsCardState extends State<StatisticsCard> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TopicViewModel>(context, listen: false);
     final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    bool isUser = authViewModel.isUser();
    return GestureDetector(
      onTap: () async {
     final result =   await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonListScreen(topic: widget.topic, mapId: widget.mapId),
          ),
        );
        if(result != null){
            
              widget.onEdit(result as TopicModel);
            
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: HexColor(widget.topic.color),
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
                          "Cửa ${widget.index + 1}: ${widget.topic.description}",
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                        Visibility(
                        visible: isUser,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: ProgressIndicatorCustom(
                            progress: 70,
                            size: 20,
                            displayText: '%',
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !isUser,
                        child:  Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _confirmDelete(context, viewModel, widget.topic,"Cửa ${widget.index + 1}: ${widget.topic.description}");
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
                      ),),
                     
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

  void _confirmDelete(BuildContext context, TopicViewModel viewModel, TopicModel topic,String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content:  Text('Bạn có chắc chắn muốn xóa $content này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                viewModel.deleteTopic(topic.id);
                widget.onDelete(topic);
                Navigator.pop(context); // Close the confirmation dialog
                _showSuccessDialog(context, 'Xóa $content thành công');
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the success dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
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
                  id: viewModel.newIdTopic(map.id),
                  description: _descriptionController.text,
                  lessons: [],
                  color: getRandomColor(),
                );

                viewModel.addTopic(map.id, topic);
                List<dynamic> backData = [topic];
                Navigator.pop(context, backData);
                _showSuccessDialog(context, 'Thêm ${topic.description} thành công');
              },
                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
              child: const Text('Thêm Topic',style: TextStyle(color: Colors.white),),
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

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the success dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
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


class EditTopicScreen extends StatefulWidget {
  final TopicModel topic;
  final String map;

  const EditTopicScreen({super.key, required this.topic, required this.map});

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
                _showSuccessDialog(context, 'Cập nhật ${widget.topic.description} thành công');
              },
                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
              child: const Text('Lưu thay đổi',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the success dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

