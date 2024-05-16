import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:maple/views/questions/image_card_check.dart';
import 'package:maple/views/questions/speech_check.dart';
import 'package:maple/views/questions/background_decoration.dart';
import 'package:maple/views/questions/messagebubble.dart';
import 'package:maple/views/questions/transerlationscreen.dart';
import 'package:maple/views/questions/translation_view.dart';

class QuestionsScreen extends StatelessWidget {
 final List<Map<String, String>> items = [
    {'image': 'images/restaurant.png', 'text': 'kem', 'mean': 'ice cream'},
    {'image': 'images/crown.png', 'text': 'em bé', 'mean': 'baby'},
    {
      'image': 'images/easter-egg_colorful.png',
      'text': 'màu vàng',
      'mean': 'yellow'
    },
    {'image': 'images/gem.png', 'text': 'sô-cô-la', 'mean': 'socola'},
  ];
   QuestionsScreen({super.key});
  static String routeName = "/questionScreen";
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Loại bỏ bóng mờ của AppBar
        bottom: PreferredSize(
          preferredSize: const Size.square(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white, width: 3), // Viền trắng
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FAProgressBar(
                      currentValue: 80,
                      displayText: '%',
                      backgroundColor:
                          Colors.transparent, // Xóa nền của thanh tiến trình
                      borderRadius: BorderRadius.circular(
                          6), // Làm tròn góc của progress bar bên trong
                    ),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 30,
                    )),
                const Padding(
                  padding: EdgeInsets.all(0.5),
                  child: Text(
                    '1',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body:   BackgroundDecoration(
        child: Center(
            child:ImageSelectionScreen(expectedWord: 'ice cream', correctAnswer: 'kem', items:items ,)/*PronunciationCheckView( sampleText: "Hello, What's your name?",),TranselateView(expectedSentence: 'Vâng, tôi muốn hai chiếc Pizza', missingSentence: 'Yes,I would like to ', correctanswers: 'pizzas',)
             ImageSelectionScreen(expectedWord: 'ice cream', correctAnswer: 'kem', items: items,)CardAnswer(
                question: "hodhfishfisdjofsoidfois jofojsdofjsoi",
                correctAnswer: "hello",
                answers: [
              "hi",
              "hello",
              "good",
              "too much"
            ])*/  /* */
            ),
      ),
    );
  }
}

class CardAnswer extends StatefulWidget {
  final String question;
  final String correctAnswer;
  final List<String> answers;

  const CardAnswer(
      {super.key,
      required this.question,
      required this.correctAnswer,
      required this.answers});

  @override
  // ignore: library_private_types_in_public_api
  _CardAnswerState createState() => _CardAnswerState();
}

class _CardAnswerState extends State<CardAnswer> {
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 10, bottom: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Chọn bản dịch đúng",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border:
                              Border.all(color: Colors.grey[300]!, width: 2),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.volume_up,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Center(
                              child: Text(
                                widget.question,
                                style: const TextStyle(fontSize: 18),
                              ),
                            )),
                          ],
                        )),
                  ),
                )
              ],
            ),
            const Spacer(),
            // Danh sách các đáp án
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.answers.map((answer) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedAnswer = answer; // Lưu đáp án được chọn
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor: selectedAnswer == answer
                              ? MaterialStateProperty.all<Color>(
                                  Colors.blue) // Thay đổi màu nền khi được chọn
                              : null, // Màu nền của nút
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Bán kính bo góc
                            ),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal:
                                    24), // Khoảng cách giữa nội dung và viền
                          ),
                          elevation: MaterialStateProperty.all(4)),
                      child: Text(
                        answer,
                        style: TextStyle(
                          color: selectedAnswer == answer
                              ? Colors.white
                              : Colors.black,
                              fontSize: 16
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),

            const Spacer(),

            // Nút kiểm tra đáp án
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: selectedAnswer != null
                    ? MaterialStateProperty.all<Color>(Colors.green)
                    : null, // Màu nền của nút
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0), // Bán kính bo góc
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 24), // Khoảng cách giữa nội dung và viền
                ),
              ),
              onPressed: selectedAnswer != null
                  ? () {
                      if (selectedAnswer == widget.correctAnswer) {
                        // Hiển thị thông báo đáp án đúng
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Correct Answer'),
                            content: const Text(
                                'Congratulations! Your answer is correct.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Đóng hộp thoại
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Hiển thị thông báo đáp án sai
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Incorrect Answer'),
                            content:
                                const Text('Sorry! Your answer is incorrect.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Đóng hộp thoại
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  : null,
              child: Center(
                  child: Text(
                'Kiểm tra',
                style: TextStyle(
                  fontSize: 16,
                  color: selectedAnswer != null ? Colors.white : Colors.black,
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
