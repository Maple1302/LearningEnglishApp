import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maple/models/lessonmodel.dart';
import 'package:maple/models/topicmodel.dart';
import 'package:maple/viewmodels/map_viewmodel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:maple/views/questions/queston_list_screen.dart';
import 'package:provider/provider.dart';

class LessonListScreen extends StatefulWidget {
  final TopicModel topic;
  final String mapId;
  const LessonListScreen({super.key, required this.topic, required this.mapId});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  List<LessonModel> lessons = [];

  @override
  void initState() {
    super.initState();
    lessons = widget.topic.lessons.toList();
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đồng ý'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int index, LessonModel lesson) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chăc muôn xóa ${lesson.description}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  Provider.of<MapViewModel>(context, listen: false)
                      .deleteLesson(widget.mapId, widget.topic.id, lesson.id);
                  lessons.removeAt(index);
                });
                Navigator.of(context).pop(); // Close the dialog
                _showSuccessDialog('Xóa ${lesson.description} thành công');
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget.topic);
          },
        ),
        centerTitle: true,
        title: Text(widget.topic.description),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newLesson = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddLessonScreen(topic: widget.topic, mapId: widget.mapId),
            ),
          );

          if (newLesson != null) {
            setState(() {
              lessons.add(newLesson);
              viewModel.addLesson(widget.mapId, widget.topic.id, newLesson);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return Card(
            color: HexColor(lesson.color),
            child: ListTile(
              title: Text(lesson.title,style: const TextStyle(color: Colors.white),),
              subtitle: Text(lesson.description,style: const TextStyle(color: Colors.white),),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionListScreen(
                      lesson: lesson,
                      mapId: widget.mapId,
                      topicId: widget.topic.id,
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    lessons[index] = result as LessonModel;
                  });
                }
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      final updatedLesson = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditLessonScreen(
                            lesson: lesson,
                            mapId: widget.mapId,
                            topicId: widget.topic.id,
                          ),
                        ),
                      );

                      if (updatedLesson != null) {
                        setState(() {
                          viewModel.updateLesson(
                              widget.mapId, widget.topic.id, updatedLesson);
                          lessons[index] = updatedLesson;
                          //_showSuccessDialog('Cập nhập bài học thành');
                        });
                      }
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(index, lesson);
                    },
                    icon: const Icon(Icons.delete_forever),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditLessonScreen extends StatefulWidget {
  final LessonModel lesson;
  final String mapId;
  final String topicId;

  const EditLessonScreen({
    required this.lesson,
    required this.mapId,
    required this.topicId,
    super.key,
  });

  @override
  State<EditLessonScreen> createState() => _EditLessonScreenState();
}

class _EditLessonScreenState extends State<EditLessonScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  String? _imageUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.lesson.title;
    _descriptionController.text = widget.lesson.description;
    _imageUrl = widget.lesson.images;
    isLoading = false;
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String?> uploadImageToFirebase(File image) async {
    try {
      final fileName = image.path.split('/').last;
      final storageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa bài học'),
      ),
      body: !isLoading
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Tiêu đề'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Mô tả'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: getImage,
                    child: const Text('Chọn ảnh từ bộ sưu tập'),
                  ),
                  const SizedBox(height: 20),
                  if (_image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.file(
                        _image!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (_image == null && _imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        _imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      String? imageUrl = _imageUrl;
                      if (_image != null) {
                        imageUrl = await uploadImageToFirebase(_image!);
                      }

                      LessonModel updatedLesson = LessonModel(
                        id: widget.lesson.id,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        question: widget.lesson.question,
                        images: imageUrl ?? widget.lesson.images,
                        color: widget.lesson.color,
                      );

                      viewModel.updateLesson(
                          widget.mapId, widget.topicId, updatedLesson);
                      setState(() {
                        isLoading = false;
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, updatedLesson);
                      _showSuccessDialog(
                          'Cập nhật bài học ${updatedLesson.description} thành công');
                    },
                    child: const Text('Lưu thay đổi'),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
    );
  }
}

class AddLessonScreen extends StatefulWidget {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final String mapId;
  final TopicModel topic;

  AddLessonScreen({super.key, required this.topic, required this.mapId});

  @override
  State<AddLessonScreen> createState() => _AddLessonScreenState();
}

class _AddLessonScreenState extends State<AddLessonScreen> {
  bool isLoading = false;
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String?> uploadImageToFirebase(File image) async {
    try {
      final fileName = image.path.split('/').last;
      final storageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      // Handle errors during image upload
      return null;
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đồng ý'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Bài học'),
      ),
      body: !isLoading
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: widget._titleController,
                    decoration: const InputDecoration(labelText: 'Tiêu đề'),
                  ),
                  TextField(
                    controller: widget._descriptionController,
                    decoration: const InputDecoration(labelText: 'Mô tả'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: getImage,
                    child: const Text('Chọn ảnh từ bộ sưu tập'),
                  ),
                  const SizedBox(height: 20),
                  if (_image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.file(
                        _image!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () async {
                      if (_image != null) {
                        setState(() {
                          isLoading = true;
                        });
                        final imageUrl = await uploadImageToFirebase(_image!);
                        if (imageUrl != null) {
                          String lessonId = viewModel.newLessonId(
                              widget.mapId, widget.topic.id);
                         // String questionId  = viewModel.newIdQuestion(widget.mapId, widget.topic.id, lessonId);
                         
                          LessonModel newLesson = LessonModel(
                            id: lessonId,
                            title: widget._titleController.text,
                            description: widget._descriptionController.text,
                            question: [],
                            images: imageUrl,
                            color: widget.topic.color,
                          );

                          viewModel.addLesson(
                              widget.mapId, widget.topic.id, newLesson);
                          setState(() {
                            isLoading = false;
                          });
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context, newLesson);
                          _showSuccessDialog(
                              'Thêm bài học ${newLesson.description} thành công');
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Lỗi khi tải lên file')),
                          );
                        }
                      }
                    },
                    child: const Text('Thêm bài học mới'),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
    );
  }
}
