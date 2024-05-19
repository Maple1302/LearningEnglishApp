import 'package:flutter/material.dart';
import 'package:maple/UI/custom_messagebox.dart';
import 'package:maple/UI/custom_buttons.dart';
import 'package:maple/helper/audio_helper.dart';
import 'package:maple/utils/constants.dart';

class CompleteConversation extends StatefulWidget {
  final Map<String, String> question;
  final List<String> items;
  final Map<String, String> correctAnswer;

  const CompleteConversation(
      {super.key,
      required this.question,
      required this.items,
      required this.correctAnswer});

  @override
  State<CompleteConversation> createState() => _CompleteConversationState();
}

class _CompleteConversationState extends State<CompleteConversation> {
  int selectedIndex = -1;
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
            children: [
              const Text(
                'Hoàn thành hội thoại',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: MessageQuestion(question: widget.question['text']!)),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: MessageBoxAwsome(
                  child: SizedBox(
                      width: 100,
                      height: 30,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text("_______________"),
                      )),
                ),
              ),
              const Spacer(),
              ListView.builder(
                shrinkWrap:
                    true, // Đảm bảo ListView chỉ chiếm không gian cần thiết
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ButtonItems(
                      checked: selectedIndex == index,
                      onPressed: () {
                        // Hành động cho từng nút
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Text(widget.items[index],
                          style: const TextStyle(fontSize: 18)),
                    ),
                  );
                },
              ),
              const Spacer(),
              ButtonCheck(
                enable: selectedIndex != -1,
                onPressed: () {
                  if (widget.items[selectedIndex] ==
                      widget.correctAnswer['text']) {
                    AudioHelper.playSound("correct");
                    showResultDialog("Chính xác!", true);
                  } else {
                    AudioHelper.playSound("incorrect");
                    showResultDialog("Không chính xác!", false);
                  }
                },
              ),
            ],
          ),
        ));
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
             Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      !check ? "Trả lời đúng": "Dịch nghĩa:",
                      style: TextStyle(
                          color: check ? Colors.green : Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ))
                ,
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  !check ? widget.correctAnswer['text']! : "${widget.question['mean']!}"+"\n"+"${widget.correctAnswer['mean']!}",
                  style: TextStyle(
                    color: check ? Colors.green : Colors.red,
                    fontSize: 16,
                  ),
                )),
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
