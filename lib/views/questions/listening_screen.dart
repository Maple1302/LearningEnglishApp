import 'package:flutter/material.dart';
import 'package:maple/UI/custom_buttons.dart';
import 'package:maple/helper/audio_helper.dart';
import 'package:maple/utils/constants.dart';

class ListenScreen extends StatefulWidget {
  final String correctAnswer;
  final List<String> items;
   final Function(bool,int) onAnswer;

  const ListenScreen(
      {super.key, required this.items, required this.correctAnswer, required this.onAnswer});

  @override
  State<ListenScreen> createState() => _ListenScreenState();
}

class _ListenScreenState extends State<ListenScreen> {
  int selectedIndex = -1;
  int score =3;
   @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void didUpdateWidget(ListenScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.correctAnswer != widget.correctAnswer) {
      // Reset lại dữ liệu khi type thay đổi
      _initializeData();
    }
  }

  void _initializeData() {
     selectedIndex = -1;
    AudioHelper.speak(widget.correctAnswer);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bạn nghe được gì',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[300]!, width: 3),
                ),
                child: IconButton(
                  icon: const Icon(Icons.volume_up,
                      size: 60, color: Colors.blue), // Icon volume up màu đen
                  onPressed: () {
                    // Thêm hành động khi nút được nhấn

                    AudioHelper.speak(widget.correctAnswer);
                  },
                  splashColor: Colors.transparent, // Bỏ hiệu ứng splash
                  highlightColor: Colors.transparent, // Bỏ hiệu ứng highlight
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
                          AudioHelper.speak(widget.items[index]);
                        });
                      },
                      child: Text(widget.items[index],
                          style: const TextStyle(
                            fontSize: 18,
                            
                          )),
                    ),
                  );
                },
              ),
              const Spacer(),
              ButtonCheck(
                enable: selectedIndex != -1 ,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  if (widget.items[selectedIndex] == widget.correctAnswer) {
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
             
              onPressed: () {
                 widget.onAnswer(check,score);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              text: 'Tiếp tục',
              type: !check ? typeButtonCheckDialog:typeButtonCheck ,
            )
          ],
        ),
      ),
    ));
  }
}
