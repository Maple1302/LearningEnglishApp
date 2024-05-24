import 'package:flutter/material.dart';
import 'package:maple/UI/custom_buttons.dart';
import 'package:maple/UI/custom_messagebox.dart';
import 'package:maple/helper/audio_helper.dart';
import 'package:maple/utils/constants.dart';

class TranslationScreen extends StatefulWidget {
  final String question;
  final String mean;
  final List<String> answers;
  final String type; //type[listen,transelation]
  final Function(bool,int) onAnswer;
  @override
  const TranslationScreen(
      {super.key,
      required this.question,
      required this.mean,
      required this.answers,
      required this.type,
      required this.onAnswer});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  List<String> selectedAnswers = [];
  List<bool> visibility = [];
 int score = 3;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void didUpdateWidget(TranslationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question || oldWidget.type != widget.type) {
      // Reset lại dữ liệu khi type thay đổi
      _initializeData();
    }
  }

  void _initializeData() {
    selectedAnswers = [];
    visibility = List.generate(widget.answers.length, (index) => true);
    AudioHelper.speak(widget.question);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            widget.type == transerlateListen
                ? 'Nhấn vào những gì bạn nghe'
                : 'Dịch câu này',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.type == transerlateListen)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[300]!, width: 3),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.volume_up,
                            size: 60, color: Colors.blue),
                        onPressed: () {
                          AudioHelper.speak(widget.question);
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      SizedBox(
                        height: 80,
                        child: VerticalDivider(
                          color: Colors.grey[300]!,
                          thickness: 3,
                        ),
                      ),
                      IconButton(
                        icon: Image.asset('images/turtle-icon.png',
                            width: 60, height: 60, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            AudioHelper.speak(widget.question, speed: 0.1);
                          });
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ],
                  ),
                )
              else
                Expanded(child: MessageQuestion(question: widget.question)),
            ],
          ),
          const SizedBox(height: 20),
          const VerticalDivider(
            width: 20,
            thickness: 1,
            indent: 20,
            endIndent: 0,
            color: Colors.grey,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: SizedBox(
              height: (widget.answers.length / 4).ceil() * 50,
              child: Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    selectedAnswers.length,
                    (index) => FittedBox(
                      child: ButtonItems(
                        onPressed: () {
                          setState(() {
                            int optionIndex =
                                widget.answers.indexOf(selectedAnswers[index]);
                            visibility[optionIndex] = true;
                            selectedAnswers.removeAt(index);
                          });
                        },
                        child: Text(selectedAnswers[index]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(widget.answers.length, (index) {
                    return Visibility(
                      replacement: FittedBox(
                        child: ButtomItemReplace(
                          child: Text(
                            widget.answers[index],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      visible: visibility[index],
                      child: FittedBox(
                        child: ButtonItems(
                          onPressed: () {
                            setState(() {
                              selectedAnswers.add(widget.answers[index]);
                              visibility[index] = false;
                              AudioHelper.speak(widget.answers[index]);
                            });
                          },
                          child: Text(widget.answers[index]),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          ButtonCheck(
            enable: selectedAnswers.isNotEmpty,
            onPressed: selectedAnswers.isNotEmpty
                ? () {
                    if (normalizeText(convertListToString(selectedAnswers)) ==
                        normalizeText(widget.question)) {
                      AudioHelper.playSound("correct");
                      showResultDialog("Chính xác!", true);
                    } else {
                      AudioHelper.playSound("incorrect");
                      showResultDialog("Không chính xác!", false);
                    }
                  }
                : () {},
          ),
        ],
      ),
    );
  }

  void showResultDialog(String message, bool check) {
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
                  decoration: BoxDecoration(
                    color: check ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    check ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 15.0,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: check ? Colors.green : Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                !check ? "Trả lời đúng" : "Dịch nghĩa:",
                style: TextStyle(
                  color: check ? Colors.green : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                !check ? widget.question : widget.mean,
                style: TextStyle(
                  color: check ? Colors.green : Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ButtonCheck(
              type: check ? typeButtonCheck : typeButtonCheckDialog,
              onPressed: () {
                widget.onAnswer(check,score);

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              text: "Tiếp tục",
            ),
          ],
        ),
      ),
    ));
  }

  String convertListToString(List<String> text) {
    String result = '';
    for (var element in text) {
      result += '$element ';
    }

    if (result.isNotEmpty) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }

  String normalizeText(String text) {
    return text.toLowerCase().replaceAll(RegExp(r"[^\w\s\']"), '');
  }

  @override
  void dispose() {
    super.dispose();
    AudioHelper.disposeAudio();
    AudioHelper.disposeTts();
  }
}
