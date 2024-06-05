import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maple/models/mapmodel.dart';
import 'package:maple/models/user_model.dart';
import 'package:maple/viewmodels/auth_viewmodel.dart';
import 'package:maple/viewmodels/map_viewmodel.dart';
import 'package:maple/views/admin/static_view.dart';
import 'package:maple/views/topics/topic_list_screen.dart';
import 'package:maple/views/topics/topic_list_screen_user.dart';
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
        backgroundColor: Colors.blueAccent,
        title: Consumer<AuthViewModel>(
          builder: (context, authViewModel, child) {
            bool isAdmin = authViewModel.isAdmin();
            UserModel? user = authViewModel.user;
            return user != null && !isAdmin
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        'images/flag_america.png',
                        height: 35,
                      ),
                      itemAppBar('images/fire.png', user.streak),
                      itemAppBar('images/gem.png', user.gem),
                      itemAppBar('images/heart.png', user.heart)
                    ],
                  )
                : const Text("Khóa học tiếng Anh");
          },
        ),
        centerTitle: true,
      ),
      floatingActionButton: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          bool isAdmin = authViewModel.isAdmin();
          return isAdmin
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddMapScreen()),
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : Container();
        },
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

          return Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              String completedMap =
                  authViewModel.user?.completedLessons.split(";")[0] ?? "0";
              return Consumer<MapViewModel>(
                builder: (context, viewModel, child) {
                  final maps = viewModel.maps;
                  return ListView.builder(
                    itemCount: maps.length,
                    itemBuilder: (context, index) {
                      final map = maps[index];
                      bool isMapUnlocked = index < int.parse(completedMap);
                      bool isCurrentMap = index == int.parse(completedMap);
                      double progressOfMap = 0;

                      if (isMapUnlocked) {
                        progressOfMap = 100;
                      }
                      if (isCurrentMap) {
                        progressOfMap = int.parse(authViewModel
                                .user!.completedLessons
                                .split(";")[1]) /
                            map.topics.length *
                            100;
                      }

                      return StatisticsCard(
                        title: map.description,
                        map: map,
                        index: index,
                        onEdit: (MapModel result) {
                          setState(() {
                            maps[index] = result;
                          });
                        },
                        isMapUnlocked: isMapUnlocked,
                        isCurrentMap: isCurrentMap,
                        progress: progressOfMap,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget itemAppBar(String image, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(image, height: 25),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class StatisticsCard extends StatelessWidget {
  final String title;
  final MapModel map;
  final int index;
  final Function onEdit;
  final bool isMapUnlocked;
  final bool isCurrentMap;
  final double progress;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.map,
    required this.index,
    required this.onEdit,
    required this.isMapUnlocked,
    required this.progress,
    required this.isCurrentMap,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    bool isUser = authViewModel.isUser();
    return GestureDetector(
      onTap: () async {
        if (isMapUnlocked || isCurrentMap) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => isUser
                  ? TopicListScreenUser(
                      mapId: index,
                      topics: map.topics,
                      description: "Phần ${index + 1}: $title",
                      isMapUnlocked:isMapUnlocked ,isCurrentMap:isCurrentMap
                    )
                  : TopicListScreen(mapModel: map),
            ),
          );
          if (result != null) {
            onEdit(result);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: isMapUnlocked || isCurrentMap ? Colors.white : Colors.grey,
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
                          "Phần ${index + 1}: $title",
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isUser,
                        child: isMapUnlocked || isCurrentMap
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: ProgressIndicatorCustom(
                                  progress: progress,
                                  size: 20,
                                  displayText: '%',
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child:
                                    Text("Hoàn thành phần $index để mở khóa")),
                      ),
                      Visibility(
                        visible: !isUser,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditMapScreen(map: map),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_forever),
                              onPressed: () {
                                _confirmDelete(context, viewModel, map);
                              },
                            ),
                          ],
                        ),
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

  void _confirmDelete(
      BuildContext context, MapViewModel viewModel, MapModel map) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: Text(
              'Bạn có chắc chắn muốn xóa "Phần ${index + 1}: $title" này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                viewModel.deleteMap(map.id);
                Navigator.pop(context); // Close the confirmation dialog
                _showDeleteSuccessDialog(context, "Phần ${index + 1}: $title");
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteSuccessDialog(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content: Text('Xóa $content thành công'),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Thành công'),
                      content: Text(
                          'Chỉnh sửa ${widget.map.description} thành công'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                            Navigator.pop(context); // Close the EditMapScreen
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Thành công'),
                      content: Text('Thêm ${map.description} mới thành công'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                            Navigator.pop(context); // Close the AddMapScreen
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Thêm phần học mới'),
            ),
          ],
        ),
      ),
    );
  }

  // Other methods remain the same...
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
