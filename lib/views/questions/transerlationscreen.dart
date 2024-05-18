import 'package:flutter/material.dart';
import 'package:maple/UI/custom_buttons.dart';
import 'package:maple/UI/custom_messagebox.dart';
import 'package:maple/helper/audio_helper.dart';
import 'package:maple/utils/constants.dart';

class TranslationScreen extends StatefulWidget {
  final String question;
  final List<String> correctAnswer;
  final List<String> answers;
  final String type; //type[listen,transelation]
  @override
  const TranslationScreen(
      {super.key,
      required this.question,
      required this.correctAnswer,
      required this.answers,
      required this.type});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  List<String> selectedAnswers = [];
  List<bool> visibility = List.generate(100, (index) => true);

  @override
  void initState() {
    super.initState();
    AudioHelper.speak(widget.question);
  }

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.type == transerlateListen
                    ? 'Nhấn vào những gì bạn nghe'
                    : 'Dịch câu này',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.type == transerlateListen
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Colors.grey[300]!, width: 3),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.volume_up,
                                    size: 60,
                                    color:
                                        Colors.blue), // Icon volume up màu đen
                                onPressed: () {
                                  // Thêm hành động khi nút được nhấn

                                  AudioHelper.speak(widget.question);
                                },
                                splashColor:
                                    Colors.transparent, // Bỏ hiệu ứng splash
                                highlightColor:
                                    Colors.transparent, // Bỏ hiệu ứng highlight
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
                                    width: 60,
                                    height: 60,
                                    color:
                                        Colors.blue), // Icon volume up màu đen
                                onPressed: () {
                                  // Thêm hành động khi nút được nhấn
                                  setState(() {
                                    AudioHelper.speak(widget.question,
                                        speed: 0.1);
                                  });
                                },
                                splashColor:
                                    Colors.transparent, // Bỏ hiệu ứng splash
                                highlightColor:
                                    Colors.transparent, // Bỏ hiệu ứng highlight
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: MessageQuestion(question: widget.question)),
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
              const Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              SizedBox(
                height:
                    155, // Đặt chiều cao để có đủ không gian cho các dòng kẻ
                child: Align(
                  alignment: Alignment.topLeft, // Căn trái
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                        selectedAnswers.length,
                        (index) => FittedBox(
                              child: ButtonItems(
                                onPressed: () {
                                  setState(() {
                                    int optionIndex = widget.answers
                                        .indexOf(selectedAnswers[index]);

                                    visibility[optionIndex] = true;
                                    selectedAnswers.removeAt(index);
                                  });
                                },
                                child: Text(selectedAnswers[index]),
                              ),
                            )),
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              const SizedBox(height: 20),
              Center(
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
                              });
                            },
                            child: Text(widget.answers[index]),
                          ),
                        ));
                  }).toList(),
                ),
              ),
              const Spacer(),
              ButtonCheck(
                enable: selectedAnswers.isNotEmpty,
                onPressed: selectedAnswers.isNotEmpty
                    ? () {
                        if (compareLists(
                            selectedAnswers, widget.correctAnswer)) {
                          // Hiển thị thông báo đáp án đúng
                          AudioHelper.playSound("correct");
                          showResultDialog("Chính xác!", true);
                        } else {
                          // Hiển thị thông báo đáp án sai
                          AudioHelper.playSound("incorrect");
                          showResultDialog("Không chính xác!", false);
                        }
                      }
                    : () {},
              ),
            ],
          ),
        ));
  }

  bool compareLists(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) {
      return false; // Không cùng kích thước, không giống nhau
    }

    for (int i = 0; i < list1.length; i++) {
      if (list1[i].compareTo(list2[i]) != 0) {
        return false; // Phần tử tại vị trí i không giống nhau
      }
    }

    return true; // Cả hai danh sách giống nhau
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
                    color: check ? Colors.green : Colors.red, // Nền màu đỏ
                    shape: BoxShape.circle, // Hình tròn
                  ),
                  padding:
                      const EdgeInsets.all(5.0), // Khoảng đệm xung quanh icon
                  child: Icon(
                    check ? Icons.check : Icons.close,
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
                    style: TextStyle(
                        color: check ? Colors.green : Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            !check
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Trả lời đúng",
                      style: TextStyle(
                          color: check ? Colors.green : Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ))
                : const SizedBox(),
            !check
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      convertListToString(widget.correctAnswer),
                      style: TextStyle(
                        color: check ? Colors.green : Colors.red,
                        fontSize: 16,
                      ),
                    ))
                : const SizedBox(),
            const SizedBox(height: 20),
            ButtonCheck(
              type: check ? typeButtonCheck : typeButtonCheckDialog,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              text: "Tiếp tục",
            )
          ],
        ),
      ),
    ));
  }

  String convertListToString(List<String> text) {
    String result = ''; // Chuỗi kết quả
    for (var element in text) {
      result += element + ' '; // Nối phần tử và thêm dấu cách sau mỗi phần tử
    }

    // Loại bỏ dấu cách cuối cùng nếu có
    if (result.isNotEmpty) {
      result = result.substring(
          0, result.length - 1); // Cắt bỏ ký tự cuối cùng (dấu cách)
    }
    return result;
  }

  @override
  void dispose() {
    super.dispose();
    AudioHelper.disposeAudio();
    AudioHelper.disposeTts();
  }
}
