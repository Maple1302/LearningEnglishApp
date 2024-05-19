import 'package:flutter/material.dart';
import 'package:maple/UI/custom_buttons.dart';
import 'package:maple/helper/audio_helper.dart';
import 'package:maple/utils/constants.dart';


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
  String selectedAnswer='';

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
                    ButtonItems(
                      onPressed: () {
                        setState(() {
                          selectedAnswer = answer; // Lưu đáp án được chọn
                        });
                      },
                     checked: answer == selectedAnswer,
                      child: Text(
                        answer,
                        style: const TextStyle(
                            fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),

            const Spacer(),

            // Nút kiểm tra đáp án
            ButtonCheck(
             enable: selectedAnswer.isNotEmpty,
              onPressed: () {
                      if (selectedAnswer == widget.correctAnswer) {
                        // Hiển thị thông báo đáp án đúng
                       AudioHelper.playSound("correct");
                    showResultDialog("Chính xác!", true);
                      } else {
                        // Hiển thị thông báo đáp án sai
                         AudioHelper.playSound("incorrect");
                    showResultDialog("Không chính xác!", false);
                      }
                    }
                  
             
            ),
          ],
        ),
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
                      widget.correctAnswer,
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
              text: "tiếp tục",
            )
          ],
        ),
      ),
    ));
  }

}
