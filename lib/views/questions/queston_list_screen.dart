import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maple/models/answers_card_question.dart';
import 'package:maple/models/complete_conversation_question.dart';
import 'package:maple/models/complete_missing_sentence_question.dart';
import 'package:maple/models/image_selection_question.dart';
import 'package:maple/models/lessonmodel.dart';
import 'package:maple/models/listening_question.dart';
import 'package:maple/models/matching_pair_question.dart';
import 'package:maple/models/pronunciation_question.dart';
import 'package:maple/models/questionmodel.dart';
import 'package:maple/models/translation_question.dart';
import 'package:maple/utils/constants.dart';
import 'package:maple/viewmodels/map_viewmodel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

class QuestionListScreen extends StatefulWidget {
  final String topicId;
  final String mapId;
  final LessonModel lesson;
  const QuestionListScreen(
      {super.key,
      required this.topicId,
      required this.mapId,
      required this.lesson});

  @override
  State<QuestionListScreen> createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.lesson.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget.lesson);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          QuestionModel newListQuestion = QuestionModel(
              id: viewModel.newIdQuestion(
                  widget.mapId, widget.topicId, widget.lesson.id),
              answersCardQuestions: [],
              completeConversationQuestions: [],
              completeMissingSentenceQuestions: [],
              imageSelectionQuestions: [],
              listeningQuestions: [],
              matchingPairQuestions: [],
              pronunciationQuestions: [],
              translationQuestions: []);
          _showAddConfirmationDialog(context, newListQuestion);
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: widget.lesson.question.length,
        itemBuilder: (context, index) {
          final question = widget.lesson.question[index];

          return Card(
            color: HexColor(widget.lesson.color),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    " Bộ câu hỏi ${question.id} của bài học ${widget.lesson.title}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    " Số lượng câu hỏi: ${question.length}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    final updatedQuestion = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListQuestionInLessson(
                          question: question,
                          mapId: widget.mapId,
                          topicId: widget.topicId,
                          lessonId: widget.lesson.id,
                        ),
                      ),
                    );

                    if (updatedQuestion != null) {
                      setState(() {
                        widget.lesson.question[index] = updatedQuestion;
                      });
                    }
                  },
                ),
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, index, question);
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

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, int index, QuestionModel question) async {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Người dùng phải nhấn vào một nút để đóng hộp thoại
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn xóa bộ câu hỏi này không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xóa'),
              onPressed: () {
                viewModel.deleteListQuestion(widget.mapId, widget.topicId,
                    widget.lesson.id, question.id);
                setState(() {
                  widget.lesson.question.remove(question);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddConfirmationDialog(
      BuildContext context, QuestionModel newListQuestion) async {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Người dùng phải nhấn vào một nút để đóng hộp thoại
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận thêm'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn muốn thêm bộ câu hỏi mới khônng ? '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Thêm'),
              onPressed: () {
                viewModel.addListQuestion(widget.mapId, widget.topicId,
                    widget.lesson.id, newListQuestion);
                setState(() {
                  widget.lesson.question.add(newListQuestion);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ListQuestionInLessson extends StatefulWidget {
  final QuestionModel question;
  final String mapId;
  final String topicId;
  final String lessonId;

  const ListQuestionInLessson({
    super.key,
    required this.question,
    required this.mapId,
    required this.topicId,
    required this.lessonId,
  });

  @override
  State<ListQuestionInLessson> createState() => _ListQuestionInLesssonState();
}

class _ListQuestionInLesssonState extends State<ListQuestionInLessson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Phân loại câu hỏi"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget.question);
          },
        ),
      ),
      body: Column(
        children: [
          tileByType(
            "Answer Card Question",
            widget.question.answersCardQuestions,
            widget.mapId,
            widget.topicId,
            widget.lessonId,
            widget.question.id,
            cardMutilChoiceQuestion,
          ),
          tileByType(
              "Complete Conversation Question",
              widget.question.completeConversationQuestions,
              widget.mapId,
              widget.topicId,
              widget.lessonId,
              widget.question.id,
              completeConversationQuestion),
          tileByType(
              "Complete Missing Sentence Question",
              widget.question.completeMissingSentenceQuestions,
              widget.mapId,
              widget.topicId,
              widget.lessonId,
              widget.question.id,
              completeMissingSentenceQuestion),
          tileByType(
              "Image Selection Question",
              widget.question.imageSelectionQuestions,
              widget.mapId,
              widget.topicId,
              widget.lessonId,
              widget.question.id,
              imageSelectionQuestions),
          tileByType(
              "Listening Question",
              widget.question.listeningQuestions,
              widget.mapId,
              widget.topicId,
              widget.lessonId,
              widget.question.id,
              listenQuestion),
          tileByType(
              "Matching Pair Question",
              widget.question.matchingPairQuestions,
              widget.mapId,
              widget.topicId,
              widget.lessonId,
              widget.question.id,
              matchingPairSoundQuestion),
          tileByType(
              "Pronunciation Question",
              widget.question.pronunciationQuestions,
              widget.mapId,
              widget.topicId,
              widget.lessonId,
              widget.question.id,
              pronunciationQuestion),
          tileByType(
              "Translation Question",
              widget.question.translationQuestions,
              widget.mapId,
              widget.topicId,
              widget.lessonId,
              widget.question.id,
              transerlationReadQueston),
        ],
      ),
    );
  }

  Widget tileByType(
      String title,
      dynamic listQuestionByType,
      String mapId,
      String topicId,
      String lessonId,
      String questionId,
      String typeOfQuestion) {
    return Card(
      color: Colors.blue,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          " Số lượng câu hỏi: ${listQuestionByType.length}",
        ),
        onTap: () async {
          final updateList = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListQuestionByType(
                listQuestionByType: listQuestionByType,
                title: title,
                mapId: mapId,
                topicId: topicId,
                lessonId: lessonId,
                questionId: questionId,
                typeOfQuestion: typeOfQuestion,
              ),
            ),
          );
          if (updateList != null) {
            setState(() {
              // Cập nhật lại danh sách câu hỏi từ updateList
              listQuestionByType = updateList;
            });
          }
        },
      ),
    );
  }
}

class ListQuestionByType extends StatefulWidget {
  final dynamic listQuestionByType;
  final String title;
  final String mapId;
  final String topicId;
  final String lessonId;
  final String questionId;
  final String typeOfQuestion;

  const ListQuestionByType(
      {super.key,
      required this.listQuestionByType,
      required this.title,
      required this.mapId,
      required this.topicId,
      required this.lessonId,
      required this.questionId,
      required this.typeOfQuestion});

  @override
  State<ListQuestionByType> createState() => _ListQuestionByTypeState();
}

class _ListQuestionByTypeState extends State<ListQuestionByType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget.listQuestionByType);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog<void>(
            context: context,
            barrierDismissible:
                false, // Người dùng phải nhấn vào một nút để đóng hộp thoại
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Xác nhận thêm'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Bạn muốn thêm câu hỏi mới?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Hủy'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Thêm'),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditQuestionByType(
                            title: widget.title,
                            mapId: widget.mapId,
                            topicId: widget.topicId,
                            lessonId: widget.lessonId,
                            type: widget.title,
                            add: true,
                            questionId: widget.questionId,
                            typeOfQuestion: widget.typeOfQuestion,
                          ),
                        ),
                      );

                      if (result != null) {
                        switch (result[2]) {
                          case completeConversationQuestion:
                            final updatedQuestion =
                                result[0] as CompleteConversationQuestion;
                            setState(() {
                              widget.listQuestionByType.add(updatedQuestion);
                            });
                            break;
                          case cardMutilChoiceQuestion:
                            final updatedQuestion =
                                result[0] as AnswersCardQuestion;
                            setState(() {
                              widget.listQuestionByType.add(updatedQuestion);
                            });
                            break;
                          case completeMissingSentenceQuestion:
                            final updatedQuestion =
                                result[0] as CompleteConversationQuestion;
                            setState(() {
                              widget.listQuestionByType.add(updatedQuestion);
                            });
                            break;
                          case pronunciationQuestion:
                            final updatedQuestion =
                                result[0] as PronunciationQuestion;
                            setState(() {
                              widget.listQuestionByType.add(updatedQuestion);
                            });
                            break;
                          case matchingPairSoundQuestion ||
                                matchingPairWordQuestion:
                            final updatedQuestion =
                                result[0] as MatchingPairQuestion;
                            setState(() {
                              widget.listQuestionByType.add(updatedQuestion);
                            });
                            break;
                          case listenQuestion:
                            final updatedQuestion =
                                result[0] as ListeningQuestion;
                            setState(() {
                              widget.listQuestionByType.add(updatedQuestion);
                            });
                            break;
                          case transerlationListenQueston ||
                                transerlationReadQueston:
                            final updatedQuestion =
                                result[0] as TranslationQuestion;
                            setState(() {
                              widget.listQuestionByType.add(updatedQuestion);
                            });
                            break;
                          case imageSelectionQuestions:
                            final updatedQuestion =
                                result[0] as ImageSelectionQuestion;
                            setState(() {
                              widget.listQuestionByType.add(updatedQuestion);
                            });
                            break;
                          default:
                        }
                      }

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: widget.listQuestionByType.length,
        itemBuilder: (context, index) {
          final question = widget.listQuestionByType[index];
          return Card(
            elevation: 3,
            shadowColor: Colors.grey,
            child: ListTile(
              title: Text(" Câu hỏi số ${index + 1}"),
              //  subtitle: Text(" Nội dụng câu hỏi: ${question.question}"),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditQuestionByType(
                      question: question,
                      title: widget.title,
                      mapId: widget.mapId,
                      topicId: widget.topicId,
                      lessonId: widget.lessonId,
                      type: widget.title,
                      index: index,
                      add: false,
                      questionId: widget.questionId,
                      typeOfQuestion: '',
                    ),
                  ),
                );

                if (result != null) {
                  switch (result[2]) {
                    case completeConversationQuestion:
                      final updatedQuestion =
                          result[0] as CompleteConversationQuestion;
                      final updatedIndex = result[1] as int;
                      setState(() {
                        widget.listQuestionByType[updatedIndex] =
                            updatedQuestion;
                      });
                      break;
                    case cardMutilChoiceQuestion:
                      final updatedQuestion = result[0] as AnswersCardQuestion;
                      final updatedIndex = result[1] as int;
                      setState(() {
                        widget.listQuestionByType[updatedIndex] =
                            updatedQuestion;
                      });
                      break;
                    case completeMissingSentenceQuestion:
                      final updatedQuestion =
                          result[0] as CompleteMissingSentenceQuestion;
                      final updatedIndex = result[1] as int;
                      setState(() {
                        widget.listQuestionByType[updatedIndex] =
                            updatedQuestion;
                      });
                      break;
                    case pronunciationQuestion:
                      final updatedQuestion =
                          result[0] as PronunciationQuestion;
                      final updatedIndex = result[1] as int;
                      setState(() {
                        widget.listQuestionByType[updatedIndex] =
                            updatedQuestion;
                      });
                      break;
                    case matchingPairSoundQuestion || matchingPairWordQuestion:
                      final updatedQuestion = result[0] as MatchingPairQuestion;
                      final updatedIndex = result[1] as int;
                      setState(() {
                        widget.listQuestionByType[updatedIndex] =
                            updatedQuestion;
                      });
                      break;
                    case listenQuestion:
                      final updatedQuestion = result[0] as ListeningQuestion;
                      final updatedIndex = result[1] as int;
                      setState(() {
                        widget.listQuestionByType[updatedIndex] =
                            updatedQuestion;
                      });
                      break;
                    case transerlationListenQueston || transerlationReadQueston:
                      final updatedQuestion = result[0] as TranslationQuestion;
                      final updatedIndex = result[1] as int;
                      setState(() {
                        widget.listQuestionByType[updatedIndex] =
                            updatedQuestion;
                      });
                      break;
                    case imageSelectionQuestions:
                      final updatedQuestion =
                          result[0] as ImageSelectionQuestion;
                      final updatedIndex = result[1] as int;
                      setState(() {
                        widget.listQuestionByType[updatedIndex] =
                            updatedQuestion;
                      });
                      break;
                    default:
                  }
                }
              },
              trailing: IconButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context, index, question);
                },
                icon: const Icon(Icons.delete_forever),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, int index, dynamic question) async {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Người dùng phải nhấn vào một nút để đóng hộp thoại
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn xóa câu hỏi này không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xóa'),
              onPressed: () {
                setState(() {
                  widget.listQuestionByType.removeAt(index);
                });
                viewModel.deleteQuestion(
                  widget.mapId,
                  widget.topicId,
                  widget.lessonId,
                  widget.questionId,
                  question,
                  index,
                );

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class EditQuestionByType extends StatefulWidget {
  final bool add;
  final String mapId;
  final String topicId;
  final String lessonId;
  final dynamic question; // câu hỏi để cần cập nhật
  final String title;
  final String type;
  final String typeOfQuestion;
  final int index;

  ///vị trí câu hỏi cần update trong list
  final String questionId;
  const EditQuestionByType(
      {super.key,
      this.question,
      required this.title,
      required this.mapId,
      required this.topicId,
      required this.lessonId,
      required this.type,
      this.index = 0,
      required this.add,
      required this.questionId,
      required this.typeOfQuestion});

  @override
  State<EditQuestionByType> createState() => _EditQuestionByTypeState();
}

class _EditQuestionByTypeState extends State<EditQuestionByType> {
  final List<TextEditingController> textEditList =
      List.generate(10, (index) => TextEditingController());
  final List<dynamic> images = [null, null, null, null];
  final picker = ImagePicker();
  bool isLoading = false;
  String selectedValue = '';
  List<String> optionType = [];
  List<String> optionTypeCodeOfMatchingQuestion = [
    matchingPairSoundQuestion,
    matchingPairWordQuestion
  ];
  Random random = Random();
  List<String> optionTypeCodeOfTranselationQuestion = [
    transerlationReadQueston,
    transerlationReadQueston
  ];
  String typesection = '';
  Future<void> getImage(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        images[index] = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImageToFirebase(File image) async {
    final fileName = image.path.split('/').last;
    final storageRef = FirebaseStorage.instance.ref().child('images/$fileName');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _showImageSourceActionSheet(
      BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Chọn từ thư viện'),
                onTap: () {
                  _pickImageFromGallery(index);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.cloud),
                title: const Text('Chọn từ Firebase Storage'),
                onTap: () {
                  _pickImageFromFirebase(index);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        images[index] = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromFirebase(int index) async {
    List<String> imageUrls = await _fetchImageUrlsFromFirebase();

    showModalBottomSheet(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext bc) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  images[index] = imageUrls[i] as File?;
                });
                Navigator.of(context).pop();
              },
              child: Image.network(imageUrls[i]),
            );
          },
        );
      },
    );
  }

  Future<List<String>> _fetchImageUrlsFromFirebase() async {
    ListResult result = await FirebaseStorage.instance.ref().listAll();
    List<String> urls = [];
    for (var ref in result.items) {
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  @override
  void initState() {
    super.initState();
    typesection =
        widget.add ? widget.typeOfQuestion : widget.question.typeOfQuestion;
    if (widget.add == false) {
      if (typesection == imageSelectionQuestions) {
        textEditList[4].text =
            widget.question.expectedWord + ';' + widget.question.correctAnswer;
        for (int i = 0; i < images.length; i++) {
          textEditList[i].text = widget.question.items[i]['mean'] +
              ';' +
              widget.question.items[i]['text'];
          images[i] = images[i] ?? widget.question.items[i]['image'];
        }
      }
      if (typesection == matchingPairSoundQuestion ||
          typesection == matchingPairWordQuestion) {
        for (int i = 0; i < widget.question.items.length; i += 2) {
          textEditList[0].text += widget.question.items[i]['text'] + ';';
          textEditList[1].text += widget.question.items[i]['mean'] + ';';
        }
        textEditList[0].text =
            textEditList[0].text.substring(0, textEditList[0].text.length - 1);
        textEditList[1].text =
            textEditList[1].text.substring(0, textEditList[1].text.length - 1);
        optionType = ['Nghe từ ghép cặp', 'Đọc từ ghép cặp'];
        selectedValue =
            optionType[optionTypeCodeOfMatchingQuestion.indexOf(typesection)];
      }
      if (typesection == transerlationReadQueston ||
          typesection == transerlationReadQueston) {
        textEditList[0].text = widget.question.question;
        textEditList[1].text = widget.question.mean;
        textEditList[2].text = widget.question.answers.join(";");
        optionType = ['Nghe câu ghép từ', 'Dịch câu ghép từ'];
        selectedValue = optionType[
            optionTypeCodeOfTranselationQuestion.indexOf(typesection)];
      }
    }
    if (typesection == matchingPairSoundQuestion ||
        typesection == matchingPairWordQuestion) {
      optionType = ['Nghe từ ghép cặp', 'Đọc từ ghép cặp'];
      selectedValue =
          optionType[optionTypeCodeOfMatchingQuestion.indexOf(typesection)];
    }
    if (typesection == transerlationReadQueston ||
        typesection == transerlationReadQueston) {
      optionType = ['Nghe câu ghép từ', 'Dịch câu ghép từ'];
      selectedValue =
          optionType[optionTypeCodeOfTranselationQuestion.indexOf(typesection)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context, listen: false);

    switch (typesection) {
      case completeConversationQuestion:
        if (widget.add == false) {
          textEditList[0].text = widget.question.question['text'];
          textEditList[1].text = widget.question.question['mean'];
          textEditList[2].text = widget.question.correctAnswer['text'];
          textEditList[3].text = widget.question.correctAnswer['mean'];
          textEditList[4].text = widget.question.items.join(';');
        }
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Câu hỏi ${widget.index + 1} ${widget.title}'),
                    TextField(
                      controller: textEditList[0],
                      decoration: const InputDecoration(
                        labelText: 'Câu hỏi',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: textEditList[1],
                      decoration: const InputDecoration(
                        labelText: 'Nghĩa của câu hỏi(Tiếng việt)',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: textEditList[2],
                      decoration: const InputDecoration(
                        labelText: 'Đáp án đúng',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: textEditList[3],
                      decoration: const InputDecoration(
                          labelText: 'Nghĩa của đáp án đúng(Tiếng việt)'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: textEditList[4],
                      decoration: const InputDecoration(
                          labelText: 'Nhập các đáp án cách nhau bởi dấu ;'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Map<String, String> question1 = {
                          'text': textEditList[0].text,
                          'mean': textEditList[1].text
                        };

                        Map<String, String> correctAnswer = {
                          'text': textEditList[2].text,
                          'mean': textEditList[3].text
                        };
                        List<String> items = textEditList[4].text.split(';');
                        final updateQuestion = CompleteConversationQuestion(
                            typeOfQuestion: typesection,
                            question: question1,
                            correctAnswer: correctAnswer,
                            items: items);
                        widget.add
                            ? viewModel.addQuestion(
                                widget.mapId,
                                widget.topicId,
                                widget.lessonId,
                                updateQuestion,
                                widget.index,
                                widget.questionId)
                            : viewModel.updateQuestion(
                                widget.mapId,
                                widget.topicId,
                                widget.lessonId,
                                updateQuestion,
                                widget.index,
                                widget.questionId);
                        List<dynamic> backData = [
                          updateQuestion,
                          widget.index,
                          typesection
                        ];
                        Navigator.pop(context, backData);
                      },
                      child:
                          Text(widget.add ? ' Thêm câu hỏi' : 'Lưu thay đổi'),
                    ),
                  ],
                )),
          ),
        );
      case transerlationReadQueston || transerlationListenQueston:
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text("Dạng ghép từ thành đáp án đúng"),
                  Text('Câu hỏi ${widget.title} ${widget.index + 1} '),
                  TextField(
                    controller: textEditList[0],
                    decoration: const InputDecoration(labelText: 'Câu hỏi'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: textEditList[1],
                    decoration:
                        const InputDecoration(labelText: 'Nghĩa của câu hỏi'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: textEditList[2],
                    decoration: const InputDecoration(
                        labelText:
                            'Nhập các từ để ghép thành đáp án(ví dụ: bạn;ăn;cơm;gì?)'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButton<String>(
                    hint: const Text('Lựa chọn kiểu câu hỏi'),
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: optionType
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      List<String> items = textEditList[2].text.split(';');
                      final newQuestion = TranslationQuestion(
                          answers: items,
                          typeOfQuestion: optionTypeCodeOfTranselationQuestion[
                              optionType.indexOf(selectedValue)],
                          question: textEditList[0].text,
                          mean: textEditList[1].text);
                      widget.add
                          ? viewModel.addQuestion(
                              widget.mapId,
                              widget.topicId,
                              widget.lessonId,
                              newQuestion,
                              widget.index,
                              widget.questionId)
                          : viewModel.updateQuestion(
                              widget.mapId,
                              widget.topicId,
                              widget.lessonId,
                              newQuestion,
                              widget.index,
                              widget.questionId);
                      List<dynamic> backData = [
                        newQuestion,
                        widget.index,
                        typesection
                      ];
                      Navigator.pop(context, backData);
                    },
                    child: Text(widget.add ? "Thêm câu hỏi" : "Lưu thay đổi"),
                  ),
                ],
              )),
        );
      case matchingPairSoundQuestion || matchingPairWordQuestion:
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: !isLoading
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text("Dạng ghép cặp phù hợp"),
                        Text('Câu hỏi ${widget.title} ${widget.index + 1}'),
                        TextField(
                          controller: textEditList[0],
                          decoration: const InputDecoration(
                              labelText:
                                  'Nhập các lựa chọn(ví dụ: car;cat...)'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: textEditList[1],
                          decoration: const InputDecoration(
                              labelText:
                                  'Nhập nghĩa tiếng việt(ví dụ: ô tô;mèo...)'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButton<String>(
                          hint: const Text('Lựa chọn kiểu câu hỏi'),
                          value: selectedValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                            });
                          },
                          items: optionType
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            List<String> listSplitEnglish =
                                textEditList[0].text.split(';');
                            List<String> listSplitVienamese =
                                textEditList[1].text.split(';');
                            List<Map<String, String>> itemsLeft = [];
                            List<Map<String, String>> itemsRight = [];
                            List<Map<String, String>> items = [];
                            for (int i = 0; i < listSplitEnglish.length; i++) {
                              itemsLeft.add({
                                'text': listSplitEnglish[i],
                                'mean': listSplitVienamese[i]
                              });
                              itemsRight.add({
                                'mean': listSplitEnglish[i],
                                'text': listSplitVienamese[i]
                              });
                            }
                            itemsLeft.shuffle(random);
                            itemsRight.shuffle(random);
                            for (int i = 0; i < listSplitEnglish.length; i++) {
                              items.add({
                                'text': itemsLeft[i]['text']!,
                                'mean': itemsLeft[i]['mean']!
                              });
                              items.add({
                                'mean': itemsRight[i]['mean']!,
                                'text': itemsRight[i]['text']!
                              });
                            }

                            final newQuestion = MatchingPairQuestion(
                              typeOfQuestion: optionTypeCodeOfMatchingQuestion[
                                  optionType.indexOf(selectedValue)],
                              items: items,
                            );
                            widget.add
                                ? viewModel.addQuestion(
                                    widget.mapId,
                                    widget.topicId,
                                    widget.lessonId,
                                    newQuestion,
                                    widget.index,
                                    widget.questionId)
                                : viewModel.updateQuestion(
                                    widget.mapId,
                                    widget.topicId,
                                    widget.lessonId,
                                    newQuestion,
                                    widget.index,
                                    widget.questionId);
                            List<dynamic> backData = [
                              newQuestion,
                              widget.index,
                              typesection
                            ];
                            Navigator.pop(context, backData);
                          },
                          child: Text(
                              widget.add ? "Thêm câu hỏi" : "Lưu thay đổi"),
                        ),
                      ],
                    ))
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        );
      case listenQuestion:
        if (widget.add == false) {
          textEditList[0].text = widget.question.correctAnswer;
          textEditList[1].text = widget.question.items.join(";");
        }
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text("Dạng nghe chọn đáp án đúng"),
                    Text('Câu hỏi ${widget.index + 1} '),
                    TextField(
                      controller: textEditList[0],
                      decoration:
                          const InputDecoration(labelText: 'Đáp án đúng'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: textEditList[1],
                      decoration: const InputDecoration(
                          labelText: 'Nhập các lựa chọn cách nhau bởi ";"'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        List<String> items = textEditList[1].text.split(';');
                        final newQuestion = ListeningQuestion(
                            typeOfQuestion: typesection,
                            correctAnswer: textEditList[0].text,
                            items: items);
                        widget.add
                            ? viewModel.addQuestion(
                                widget.mapId,
                                widget.topicId,
                                widget.lessonId,
                                newQuestion,
                                widget.index,
                                widget.questionId)
                            : viewModel.updateQuestion(
                                widget.mapId,
                                widget.topicId,
                                widget.lessonId,
                                newQuestion,
                                widget.index,
                                widget.questionId);
                        List<dynamic> backData = [
                          newQuestion,
                          widget.index,
                          typesection
                        ];
                        Navigator.pop(context, backData);
                      },
                      child: Text(widget.add ? "Thêm câu hỏi" : 'Lưu thay đổi'),
                    ),
                  ],
                )),
          ),
        );
      case imageSelectionQuestions:
        return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: !isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text("Dạng nhìn hình chọn đáp án đúng"),
                          Text('Câu hỏi ${widget.title} ${widget.index + 1} '),
                          Column(
                            children: List.generate(4, (index) {
                              return Column(
                                children: [
                                  TextField(
                                    controller: textEditList[index],
                                    decoration: InputDecoration(
                                        labelText:
                                            'Lựa chọn ${index + 1}(Ví dụ: car ; ô tô)'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            }),
                          ),
                          TextField(
                            controller: textEditList[4],
                            decoration: const InputDecoration(
                                labelText: 'Đáp án (Ví dụ: car ; ô tô)'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (index) {
                              return GestureDetector(
                                onTap: () =>
                                    _showImageSourceActionSheet(context, index),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: images[index] != null
                                        ? (images[index] is File
                                            ? Image.file(
                                                images[index]!,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                images[index] as String,
                                                fit: BoxFit.cover,
                                              ))
                                        : Center(
                                            child: Text(
                                              'Hình minh họa đáp án ${index + 1}',
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              bool enable = true;
                              final List<Map<String, String>> items = [];

                              // Check if all images are non-null
                              for (int i = 0; i < images.length; i++) {
                                if (images[i] == null) {
                                  enable = false;
                                  break;
                                }
                              }

                              if (enable) {
                                List<String> imageUrl = [];

                                // Upload files and keep URLs unchanged
                                for (int i = 0; i < images.length; i++) {
                                  if (images[i] is File) {
                                    String uploadedUrl =
                                        await uploadImageToFirebase(
                                            images[i] as File);
                                    imageUrl.add(uploadedUrl);
                                  } else if (images[i] is String) {
                                    imageUrl.add(images[i] as String);
                                  } else {
                                    // Handle unexpected type
                                    enable = false;
                                    break;
                                  }
                                }

                                if (enable) {
                                  // Construct items with the URLs and text/mean values
                                  for (int i = 0; i < images.length; i++) {
                                    items.add({
                                      'image': imageUrl[i],
                                      'text':
                                          textEditList[i].text.split(';')[0],
                                      'mean':
                                          textEditList[i].text.split(';')[1],
                                    });
                                  }

                                  // Create the updated question object
                                  final updateQuestion = ImageSelectionQuestion(
                                    typeOfQuestion: typesection,
                                    expectedWord:
                                        textEditList[4].text.split(";")[0],
                                    correctAnswer:
                                        textEditList[4].text.split(";")[1],
                                    items: items,
                                  );

                                  // Update the question in the view model
                                  widget.add
                                      ? viewModel.addQuestion(
                                          widget.mapId,
                                          widget.topicId,
                                          widget.lessonId,
                                          updateQuestion,
                                          widget.index,
                                          widget.questionId,
                                        )
                                      : viewModel.updateQuestion(
                                          widget.mapId,
                                          widget.topicId,
                                          widget.lessonId,
                                          updateQuestion,
                                          widget.index,
                                          widget.questionId,
                                        );

                                  // Prepare data to send back
                                  List<dynamic> backData = [
                                    updateQuestion,
                                    widget.index,
                                    typesection,
                                  ];
                                  setState(() {
                                    isLoading = false;
                                  });

                                  // Navigate back with updated data
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context, backData);
                                }
                              }
                            },
                            child: Text(
                                widget.add ? "Thêm câu hỏi" : 'Lưu thay đổi'),
                          ),
                        ],
                      ))
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ));
      case pronunciationQuestion:
        if (!widget.add) {
          textEditList[0].text = widget.question.sampleText;
          textEditList[1].text = widget.question.mean;
        }

        return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: !isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text("Dạng phát âm"),
                          Text('Câu hỏi ${widget.title} ${widget.index + 1} '),
                          TextField(
                            controller: textEditList[0],
                            decoration:
                                const InputDecoration(labelText: 'Câu hỏi'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: textEditList[1],
                            decoration: const InputDecoration(
                                labelText: 'Nghĩa của câu hỏi'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final newQuestion = PronunciationQuestion(
                                typeOfQuestion: typesection,
                                sampleText: textEditList[0].text,
                                mean: textEditList[1].text,
                              );
                              widget.add
                                  ? viewModel.addQuestion(
                                      widget.mapId,
                                      widget.topicId,
                                      widget.lessonId,
                                      newQuestion,
                                      widget.index,
                                      widget.questionId)
                                  : viewModel.updateQuestion(
                                      widget.mapId,
                                      widget.topicId,
                                      widget.lessonId,
                                      newQuestion,
                                      widget.index,
                                      widget.questionId);
                              List<dynamic> backData = [
                                newQuestion,
                                widget.index,
                                typesection
                              ];
                              Navigator.pop(context, backData);
                            },
                            child: Text(
                                widget.add ? "Thêm câu hỏi" : 'Lưu thay đổi'),
                          ),
                        ],
                      ))
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ));
      case completeMissingSentenceQuestion:
        if (!widget.add) {
          textEditList[2].text = widget.question.expectedSentence;
          textEditList[0].text = widget.question.missingSentence;
          textEditList[1].text = widget.question.correctanswers;
        }

        return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: !isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text("Dạng hoàn thành câu"),
                          Text('Câu hỏi ${widget.title} ${widget.index + 1} '),
                          TextField(
                            controller: textEditList[0],
                            decoration: const InputDecoration(
                                labelText: 'Nhập câu(thiếu)'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: textEditList[1],
                            decoration: const InputDecoration(
                                labelText: 'Nhập phần còn thiếu'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: textEditList[2],
                            decoration: const InputDecoration(
                                labelText: 'Nghĩa của toàn bộ câu'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final newQuestion =
                                  CompleteMissingSentenceQuestion(
                                      typeOfQuestion: typesection,
                                      expectedSentence: textEditList[2].text,
                                      missingSentence: textEditList[0].text,
                                      correctanswers: textEditList[1].text);
                              widget.add
                                  ? viewModel.addQuestion(
                                      widget.mapId,
                                      widget.topicId,
                                      widget.lessonId,
                                      newQuestion,
                                      widget.index,
                                      widget.questionId)
                                  : viewModel.updateQuestion(
                                      widget.mapId,
                                      widget.topicId,
                                      widget.lessonId,
                                      newQuestion,
                                      widget.index,
                                      widget.questionId);
                              List<dynamic> backData = [
                                newQuestion,
                                widget.index,
                                typesection
                              ];
                              Navigator.pop(context, backData);
                            },
                            child: Text(
                                widget.add ? "Thêm câu hỏi" : 'Lưu thay đổi'),
                          ),
                        ],
                      ))
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ));
      case cardMutilChoiceQuestion:
        if (!widget.add) {
          textEditList[0].text = widget.question.question;
          textEditList[1].text = widget.question.correctAnswer;
          textEditList[2].text = widget.question.answers.join(';');
        }

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: !isLoading
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text("Dạng chọn đáp án phù hợp"),
                        Text('Câu hỏi ${widget.title} ${widget.index + 1} '),
                        TextField(
                          controller: textEditList[0],
                          decoration:
                              const InputDecoration(labelText: 'Câu hỏi'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: textEditList[1],
                          decoration:
                              const InputDecoration(labelText: 'Đáp án đúng'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: textEditList[2],
                          decoration: const InputDecoration(
                              labelText:
                                  'Nhập các lựa chọn cách nhau bởi dấu ";" '),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            List<String> items =
                                textEditList[2].text.split(';');
                            final newQuestion = AnswersCardQuestion(
                                typeOfQuestion: typesection,
                                question: textEditList[0].text,
                                correctAnswer: textEditList[1].text,
                                answers: items);
                            widget.add
                                ? viewModel.addQuestion(
                                    widget.mapId,
                                    widget.topicId,
                                    widget.lessonId,
                                    newQuestion,
                                    widget.index,
                                    widget.questionId)
                                : viewModel.updateQuestion(
                                    widget.mapId,
                                    widget.topicId,
                                    widget.lessonId,
                                    newQuestion,
                                    widget.index,
                                    widget.questionId);
                            List<dynamic> backData = [
                              newQuestion,
                              widget.index,
                              typesection
                            ];
                            Navigator.pop(context, backData);
                          },
                          child: Text(
                              widget.add ? "Thêm câu hỏi" : 'Lưu thay đổi'),
                        ),
                      ],
                    ))
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        );
      default:
        return const Scaffold(
            body: Center(
          child: Text("Không có câu hỏi nào loại này "),
        ));
    }
  }
}
