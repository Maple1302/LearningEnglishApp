import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:maple/UI/custom_buttons.dart';
import 'package:maple/helper/audio_helper.dart';
import 'package:maple/utils/constants.dart';
import 'package:maple/views/questions/answers_card.dart';
import 'package:maple/views/questions/background_decoration.dart';
import 'package:maple/views/questions/complete_conversation_screen.dart';
import 'package:maple/views/questions/complete_mising_sentence_screen.dart';
import 'package:maple/views/questions/listening_screen.dart';
import 'package:maple/views/questions/matching_pair_screen.dart';
import 'package:maple/views/questions/pronunciation_screen.dart';
import 'package:maple/views/questions/result_screen.dart';
import 'package:maple/views/questions/select_card_screen.dart';
import 'package:maple/views/questions/transerlation_screen.dart';

class QuestionScreen extends StatefulWidget {
  static const String routeName = "/questionScreen";
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final List<Map<String, Object>> questions = [
    {
      'type': matchingPairWordQuestion,
      'items': [
        {'mean': 'em bé', 'text': 'baby'},
        {'text': 'em bé', 'mean': 'baby'},
        {'mean': 'kem', 'text': 'ice cream'},
        {'text': 'màu vàng', 'mean': 'yellow'},
        {'mean': 'sô-cô-la', 'text': 'socola'},
        {'text': 'sô-cô-la', 'mean': 'socola'},
        {'mean': 'màu vàng', 'text': 'yellow'},
        {'text': 'kem', 'mean': 'ice cream'},
      ],
    },
    {
      'type': pronunciationQuestion,
      'sampleText': "Hello, What's your name?",
      'mean': 'Xin chào, Bạn tên gì?',
    },
    

    {
      'type': completeConversationQuestion,
      'question': {
        'text': 'what can i do?',
        'mean': 'Đây là bạn trai của con có phải không Lisa?'
      },
      'correctAnswer': {
        'text': 'Yes, He is Tommy',
        'mean': 'Vâng, Anh ấy là Tommy'
      },
      'items': [
        'Yes, He is Tommy',
        'Yes, that\'s my younger brother.',
      ],
    },
    {
      'type': transerlationListenQueston,
      'answers': [
        'Hello',
        "What's",
        'your',
        'have',
        'am',
        'name?',
      ],
      'question': "Hello, What's your name?",
      'mean': "Xin chào, tên bạn là gì?",
    },
    
   
    {
      'type': transerlationReadQueston,
      'answers': [
        'Hello',
        "What's",
        'your',
        'have',
        'am',
        'name?',
      ],
      'question': "Hello, What's your name?",
      'mean': "Xin chào, tên bạn là gì?",
    },
   

    {
      'type': matchingPairSoundQuestion,
      'items': [
        {'mean': 'em bé', 'text': 'baby'},
        {'text': 'em bé', 'mean': 'baby'},
        {'mean': 'kem', 'text': 'ice cream'},
        {'text': 'màu vàng', 'mean': 'yellow'},
        {'mean': 'sô-cô-la', 'text': 'socola'},
        {'text': 'sô-cô-la', 'mean': 'socola'},
        {'mean': 'màu vàng', 'text': 'yellow'},
        {'text': 'kem', 'mean': 'ice cream'},
      ],
    },
    {
      'type': listenQuestion,
      'items': ['Flow', 'Flew'],
      'correctAnswer': 'Flow',
    },
    {
      'type': imageSelectionQuestions,
      'expectedWord': 'ice cream',
      'correctAnswer': 'kem',
      'items': [
        {'image': 'images/restaurant.png', 'text': 'kem', 'mean': 'ice cream'},
        {'image': 'images/crown.png', 'text': 'em bé', 'mean': 'baby'},
        {
          'image': 'images/easter-egg_colorful.png',
          'text': 'màu vàng',
          'mean': 'yellow'
        },
        {'image': 'images/gem.png', 'text': 'sô-cô-la', 'mean': 'socola'},
      ],
    },

    {
      'type': completeMissingSentenceQuestion,
      'expectedSentence': 'Vâng, tôi muốn hai chiếc Pizza',
      'missingSentence': 'Yes,I would like to ',
      'correctanswers': 'pizzas',
    },
    {
      'type': cardMutilChoiceQuestion,
      'question': "Hi Peter",
      'correctAnswer': "hello",
      'answers': ["hi", "hello", "good", "too much"]
    },
    // Thêm các câu hỏi khác tương tự
  ];
  int currentQuestionIndex = 0;
  int countIcorrectQuestion = 0;
  int score = 0;
  int consecutiveCorrect = 0;
  int _elapsedTime = 0; // Thời gian đã trôi qua (giây)
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime++;
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    _timer?.cancel();
    setState(() {
      _elapsedTime = 0;
    });
  }

  String convertToMinute(int time) {
    int minutes = time ~/ 60;
    int seconds = time % 60;
    String minute = minutes < 10 ? "0$minutes" : minutes.toString();
    String sencond = seconds < 10 ? "0$seconds" : seconds.toString();
    return "$minute:$sencond";
  }

  void nextQuestion(bool isCorrect, int s) {
    if (isCorrect) {
      setState(() {
        score += s;
        countIcorrectQuestion++;
        consecutiveCorrect++;

        // Kiểm tra chuỗi câu trả lời đúng và hiển thị thông báo
        if (consecutiveCorrect == 3 ||
            consecutiveCorrect == 5 ||
            consecutiveCorrect == 10 ||
            consecutiveCorrect == 20) {
          String message = '';
          String iconSource = '';
          Color color = Colors.green;
          if (consecutiveCorrect == 3) {
            score += 1;
            message = "Điểm thưởng +1";
            
            iconSource = "images/streak_3.png";
          } else if (consecutiveCorrect == 5) {
            score += 4;
            message = "Điểm thưởng +4";
            iconSource = "images/streak_5.png";
             color = Colors.blue;
          } else if (consecutiveCorrect == 10) {
            score += 8;
            message = "Điểm thưởng +8";
            iconSource = "images/streak_10.png";
            color = Colors.yellow;
          } else if (consecutiveCorrect == 20) {
            score += 15;
            message = "Điểm thưởng +15";
            iconSource = "images/streak_20.png";
            color= Colors.orange;
          }
          showDialog(
              context: context,
              builder: (BuildContext context) {
                Future.delayed(const Duration(milliseconds: 1300), () {
                  Navigator.of(context)
                      .pop(true); // Đóng hộp thoại sau 0.5 giây
                });
                AudioHelper.playSound('bonus'); // Phát âm thanh 'bonus'
                return AlertDialog(
                  backgroundColor: color,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            iconSource,
                            height:200,
                            width: 200,
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            "Streak $consecutiveCorrect",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        message,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              });
        }
      });
    } else {
      setState(() {
        consecutiveCorrect = 0; // Reset chuỗi đúng liên tục nếu trả lời sai
      });
    }
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        // Hết câu hỏi, chuyển tới màn hình kết quả
        stopTimer();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              finalTime: convertToMinute(_elapsedTime),
              score: score,
              rateCompleted:
                  ((countIcorrectQuestion / questions.length) * 100).ceil(),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    Widget questionWidget = Container();
    switch (question['type']) {
      case completeConversationQuestion:
        questionWidget = CompleteConversationScreen(
          question: question['question'] as Map<String, String>,
          items: question['items'] as List<String>,
          correctAnswer: question['correctAnswer'] as Map<String, String>,
          onAnswer: nextQuestion,
        );
        break;
      case transerlationReadQueston:
        questionWidget = TranslationScreen(
          answers: question['answers'] as List<String>,
          question: question['question'] as String,
          mean: question['mean'] as String,
          type: transerlateRead,
          onAnswer: nextQuestion,
        );

        break;
      case transerlationListenQueston:
        questionWidget = TranslationScreen(
          answers: question['answers'] as List<String>,
          question: question['question'] as String,
          mean: question['mean'] as String,
          type: transerlateListen,
          onAnswer: nextQuestion,
        );

        break;
      case matchingPairWordQuestion:
        questionWidget = MatchingPairScreen(
          items: question['items'] as List<Map<String, String>>,
          type: matchingword,
          onAnswer: nextQuestion,
        );
        break;
      case matchingPairSoundQuestion:
        questionWidget = questionWidget = MatchingPairScreen(
          items: question['items'] as List<Map<String, String>>,
          type: matchingsound,
          onAnswer: nextQuestion,
        );
        break;
      case listenQuestion:
        questionWidget = ListenScreen(
          items: question['items'] as List<String>,
          correctAnswer: question['correctAnswer'] as String,
          onAnswer: nextQuestion,
        );
        break;
      case imageSelectionQuestions:
        questionWidget = ImageSelectionScreen(
          expectedWord: question['expectedWord'] as String,
          correctAnswer: question['correctAnswer'] as String,
          items: question['items'] as List<Map<String, String>>,
          onAnswer: nextQuestion,
        );
        break;
      case pronunciationQuestion:
        questionWidget = PronunciationScreen(
          sampleText: question['sampleText'] as String,
          mean: question['mean'] as String,
          onAnswer: nextQuestion,
        );
        break;
      case completeMissingSentenceQuestion:
        questionWidget = CompletedMissingSentenceScreen(
          expectedSentence: question['expectedSentence'] as String,
          missingSentence: question['missingSentence'] as String,
          correctanswers: question['correctanswers'] as String,
          onAnswer: nextQuestion,
        );

        break;
      case cardMutilChoiceQuestion:
        questionWidget = CardAnswerScreen(
          question: question['question'] as String,
          correctAnswer: question['correctAnswer'] as String,
          answers: question['answers'] as List<String>,
          onAnswer: nextQuestion,
        );
        break;
      default:
        questionWidget = Container();
        break;
    }

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
                Visibility(
                  visible: false,
                  child: Text(
                    convertToMinute(_elapsedTime),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (currentQuestionIndex >= 1) {
                        showAlertDialog(
                            "Nếu bạn thoát sẽ mất toàn bộ điểm đã kiếm được trong bài học này");
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacementNamed(context, '/home');
                        });
                      }
                    },
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
                      currentValue:
                          (currentQuestionIndex / questions.length) * 100,
                      displayText: '%',
                      size: 25,
                  //  changeColorValue:  ((currentQuestionIndex / questions.length) * 100).ceil(),
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
      body: BackgroundDecoration(
        child: Center(
            child: Card(
          elevation: 4,
          margin: const EdgeInsets.only(top: 10, bottom: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: questionWidget,
        )),
      ),
    );
  }
  
  void showAlertDialog(
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 100),
      content: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.red, // Nền màu đỏ
                    shape: BoxShape.circle, // Hình tròn
                  ),
                  padding:
                      const EdgeInsets.all(5.0), // Khoảng đệm xung quanh icon
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    weight: 10,
                    opticalSize: 10, // Màu của tích X là màu trắng
                    size: 15.0, // Kích thước của icon
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ButtonCheck(
                onPressed: () {
                  if (mounted) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }
                },
                text: 'tiếp tục học',
                type: typeButtonCheck),
            TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Future.delayed(const Duration(milliseconds: 250), () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacementNamed(context, '/home');
                    });
                  });
                },
                child: const Text(
                  "Thoát",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ))
          ],
        ),
      ),
    ));
  }
}
