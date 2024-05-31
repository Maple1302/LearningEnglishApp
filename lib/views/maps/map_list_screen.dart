import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maple/models/mapmodel.dart';
import 'package:maple/viewmodels/map_viewmodel.dart';
import 'package:maple/views/admin/static_view.dart';
import 'package:maple/views/topics/topic_list_screen.dart';
import 'package:provider/provider.dart';

class MapListScreen extends StatefulWidget {
  const MapListScreen({super.key});

  @override
  State<MapListScreen> createState() => _MapListScreenState();
}

class _MapListScreenState extends State<MapListScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Khóa học Tiếng Anh"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMapScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<MapModel>>(
        future: viewModel.fetchMaps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No maps available'));
          }
          return Consumer<MapViewModel>(
            builder: (context, viewModel, child) {
              final maps = viewModel.maps;
              return ListView.builder(
                itemCount: maps.length,
                itemBuilder: (context, index) {
                  final map = maps[index];
                  return StatisticsCard(
                    title: map.description,
                    progress: const ProgressIndicatorCustom(
                      progress: 70,
                      size: 20,
                      displayText: '%',
                    ),
                    map: map,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class StatisticsCard extends StatelessWidget {
  final String title;
  final MapModel map;
  final Widget progress;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.map,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopicListScreen(mapModel: map),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.white,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 0.0),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: progress,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditMapScreen(map: map),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever),
                            onPressed: () {
                              viewModel.deleteMap(map.id);
                            },
                          ),
                        ],
                      ),
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


class EditMapScreen extends StatefulWidget {
  final MapModel map;

  const EditMapScreen({super.key, required this.map});

  @override
  State<EditMapScreen> createState() => _EditMapScreenState();
}

class _EditMapScreenState extends State<EditMapScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.map.description;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa Phần'),
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
                final updatedMap = MapModel(
                  id: widget.map.id,
                  description: _descriptionController.text,
                  topics: widget.map.topics,
                );

                viewModel.updateMap(updatedMap);
                Navigator.pop(context);
              },
              child: const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddMapScreen extends StatelessWidget {
  final TextEditingController _descriptionController = TextEditingController();

  AddMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Phần mới'),
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
                final map = MapModel(
                  id: viewModel.generateId(),
                  description: _descriptionController.text,
                  topics: [],
                );

                viewModel.addMap(map);
                Navigator.pop(context);
              },
              child: const Text('Add Map'),
            ),
          ],
        ),
      ),
    );
  }

  String genId() {
    // Lấy thời gian hiện tại
    DateTime now = DateTime.now();

    // Tạo một chuỗi ID từ các phần của thời gian hiện tại
    String id = now.year.toString() +
        now.month.toString().padLeft(2, '0') +
        now.day.toString().padLeft(2, '0') +
        now.hour.toString().padLeft(2, '0') +
        now.minute.toString().padLeft(2, '0') +
        now.second.toString().padLeft(2, '0') +
        now.millisecond.toString().padLeft(3, '0') +
        now.microsecond.toString().padLeft(3, '0');

    // Thêm một số ngẫu nhiên để đảm bảo ID là duy nhất hơn
    Random random = Random();
    int randomNum = random.nextInt(100000); // Số ngẫu nhiên từ 0 đến 99999
    id += randomNum.toString().padLeft(5, '0');

    return id;
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
