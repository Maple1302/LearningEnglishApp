import 'package:flutter/material.dart';
import 'package:maple/UI/custom_buttons.dart';
import 'package:maple/helper/audio_helper.dart';
import 'package:maple/utils/constants.dart';

class ImageSelectionScreen extends StatefulWidget {
   final String expectedWord; 
    final String correctAnswer;

  const ImageSelectionScreen({super.key, required this.expectedWord, required this.correctAnswer, required this.items,});
  final List<Map<String, String>> items;


  @override
  State<ImageSelectionScreen> createState() => _ImageSelectionScreenState();
}

class _ImageSelectionScreenState extends State<ImageSelectionScreen> {

  
  String? answerSelected = '';
 
  
  int selectedIndex = -1; // -1 means no item is selected
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
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Chọn hình ảnh đúng',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      AudioHelper.speak(widget.expectedWord); // Phát âm thanh của từ mẫu
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.blue,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Icon(
                      Icons.volume_up,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Text(
                  "ice cream",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 1,
                ),
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return ButtonItems(
                    onPressed: () {
                      setState(() {
                        answerSelected = widget.items[index]['mean'];
                        selectedIndex = index;
                        AudioHelper.speak(widget.items[index]['mean']!);
                      });
                    },
                    checked: selectedIndex == index,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(widget.items[index]['image']!,
                            height: 80, fit: BoxFit.cover),
                        const SizedBox(height: 8),
                        Text(capitalize(widget.items[index]['text']!),
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ButtonCheck(
                onPressed: () {
                  if (answerSelected == widget.expectedWord) {
                    showResultDialog("Chính xác!", true);
                    AudioHelper.playSound("correct");
                  } else {
                    showResultDialog("Không chính xác!", false);
                    AudioHelper.playSound("incorrect");
                  }
                },
               text:'Kiểm tra' ,
             enable: answerSelected!.isNotEmpty,
              ),
            ),
          ],
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
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              text: 'tiếp tục',
              type:check ? typeButtonCheck : typeButtonCheckDialog
            )
          ],
        ),
      ),
    ));
  }

  @override
  void dispose(){
    super.dispose();
    AudioHelper.disposeAudio();
    AudioHelper.disposeTts();
  }
  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }

    return input.split(' ').map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
