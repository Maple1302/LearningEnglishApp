import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maple/models/answers_card_question.dart';
import 'package:maple/models/lessonmodel.dart';
import 'package:maple/models/questionmodel.dart';
import 'package:maple/models/topicmodel.dart';
import 'package:maple/utils/constants.dart';
import 'package:maple/viewmodels/map_viewmodel.dart';
import 'package:maple/views/questions/queston_list_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

class LessonListScreen extends StatefulWidget {
  final TopicModel topic;
  final String mapId;
  const LessonListScreen({super.key, required this.topic, required this.mapId});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  late List<LessonModel> lessons;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons in ${widget.topic.description}'),
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
          return ListTile(
            title: Text(lesson.title),
            subtitle: Text(lesson.description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionListScreen(
                    lesson: lesson,
                    mapId: widget.mapId,
                    topicId: widget.topic.id,
                  ),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditLessonScreen(
                          lesson: lesson,
                          mapId: widget.mapId,
                          topicId: widget.topic.id,
                        ),
                      ),
                    ).then((updatedLesson) {
                      if (updatedLesson != null) {
                        setState(() {
                          viewModel.updateLesson(widget.topic.id, widget.topic.id, updatedLesson);
                          lessons[index] = updatedLesson;
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() {
                      viewModel.deleteLesson(widget.mapId, widget.topic.id, lesson.id);
                      lessons.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
              ],
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

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.lesson.title;
    _descriptionController.text = widget.lesson.description;
    _imageUrl = widget.lesson.images;
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
    final fileName = image.path.split('/').last;
    final storageRef = FirebaseStorage.instance.ref().child('images/$fileName');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa Lesson'),
      ),
      body: Padding(
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
              child: const Text('Chọn ảnh từ thư viện'),
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
                // ignore: use_build_context_synchronously
                Navigator.pop(context, updatedLesson);
              },
              child: const Text('Lưu thay đổi'),
            ),
          ],
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
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        //print('No image selected.');
      }
    });
  }

  Future<String> uploadImageToFirebase(File image) async {
    final fileName = image.path.split('/').last;
    final storageRef = FirebaseStorage.instance.ref().child('images/$fileName');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Lesson'),
      ),
      body: Padding(
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
              child: const Text('Chọn ảnh từ thư viện'),
            ),
            const SizedBox(height: 20),
            if (_image != null)
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(60), // Điều chỉnh bán kính nếu cần
                child: Image.file(
                  _image!,
                  width: 80, // Điều chỉnh chiều rộng nếu cần
                  height: 80, // Điều chỉnh chiều cao nếu cần
                  fit: BoxFit.cover, // Điều chỉnh fit nếu cần
                ),
              ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () async {
                if (_image != null) {
                  String lessonId= viewModel.newLessonId(widget.mapId, widget.topic.id,);
                 List<QuestionModel> newQuestion = [QuestionModel(id: '', answersCardQuestions: [AnswersCardQuestion(typeOfQuestion: cardMutilChoiceQuestion, question: 'question', correctAnswer: 'correctAnswer', answers: [])], completeConversationQuestions: [], completeMissingSentenceQuestions: [], imageSelectionQuestions: [], listeningQuestions: [], matchingPairQuestions: [], pronunciationQuestions: [], translationQuestions: [])];
              
                  final imageUrl = await uploadImageToFirebase(_image!);
                  LessonModel newLesson = LessonModel(
                    id: lessonId,
                    title: widget._titleController.text,
                    description: widget._descriptionController.text,
                    question:newQuestion ,
                    images: imageUrl, // Lưu URL hình ảnh
                    color: widget.topic.color,
                  );

                  viewModel.addLesson(widget.mapId, widget.topic.id, newLesson);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context, newLesson);
                }
              },
              child: const Text('Thêm Lesson'),
            ),
          ],
        ),
      ),
    );
  }
}
