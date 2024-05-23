import 'package:flutter/material.dart';

import 'package:maple/UI/custom_buttons.dart';
import 'package:maple/helper/audio_helper.dart';
import 'package:maple/utils/constants.dart';

class MatchingPairScreen extends StatefulWidget {
  final List<Map<String, String>> items;
  final String type;
  final Function(bool,int) onAnswer;

  const MatchingPairScreen({
    super.key,
    required this.items,
    required this.type,
    required this.onAnswer,
  });

  @override
  State<MatchingPairScreen> createState() => _MatchingPairScreenState();
}

class _MatchingPairScreenState extends State<MatchingPairScreen> {
  String answerSelectedLeft = '';
  String answerSelectedRight = '';
  List<bool> visibility = List.generate(20, (index) => true);
  int count = 0;
  int selectedIndexLeft = -1; // -1 means no item is selected
  int selectedIndexRight = -1; // -1 means no item is selected
  bool enableButton = false;
  int selectAnswer = -1;
  int score = 3;


  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void didUpdateWidget(MatchingPairScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      // Reset lại dữ liệu khi type thay đổi
      _initializeData();
    }
  }

  void _initializeData() {
    answerSelectedLeft = '';
    answerSelectedRight = '';
    visibility = List.generate(widget.items.length, (index) => true);
    count = 0;
    selectedIndexLeft = -1; // -1 means no item is selected
    selectedIndexRight = -1; // -1 means no item is selected
    enableButton = false;
    selectAnswer = -1;
    
  }

  @override
  Widget build(BuildContext context) {
    return 
         Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Nhấn vào cặp từ tương ứng',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 40.0,
                  mainAxisSpacing: 40.0,
                  childAspectRatio: 2,
                ),
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return Visibility(
                      visible: visibility[index],
                      replacement:  ButtonItems(
                        onPressed: () {
                          
                        },
                        enable: false,
                        checked: false,
                        child: (widget.type == matchingsound && index % 2 == 0)
                            ?  Center(
                                child: Icon(Icons.volume_up,
                                    size: 40, color: buttonCheckDisableSideColor),
                              )
                            : Text(capitalize(widget.items[index]['text']!),
                                style:  TextStyle(fontSize: 16,color: buttonCheckDisableSideColor)),
                      ),
                      child: ButtonItems(
                        onPressed: () {
                          setState(() {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            AudioHelper.disposeAudio();
                            AudioHelper.disposeTts();
                            if (index % 2 == 0) {
                              answerSelectedLeft = widget.items[index]['mean']!;
                              selectedIndexLeft = index;
                              selectAnswer = index;
                              AudioHelper.speak(widget.items[index]['text']!);
                            } else {
                              answerSelectedRight =
                                  widget.items[index]['text']!;
                              selectedIndexRight = index;
                            }
                            if (selectedIndexLeft != -1 &&
                                selectedIndexRight != -1) {
                              if (answerSelectedLeft == answerSelectedRight) {
                                visibility[selectedIndexRight] = false;
                                visibility[selectedIndexLeft] = false;

                                count += 2;
                                if (count == widget.items.length) {
                                  showResultDialog("Tuyệt vời!", true);

                                  enableButton = true;
                                } else {
                                  showResultDialog("Chính xác!", true);
                                }
                                selectedIndexLeft = -1;
                                selectedIndexRight = -1;

                                AudioHelper.playSound("correct");
                              } else {
                                score = score > 0 ? score -1 : 0;
                                showResultDialog("Không chính xác!", false);
                                AudioHelper.playSound("incorrect");
                                selectedIndexLeft = -1;
                                selectedIndexRight = -1;
                              }
                            }
                          });
                        },
                        checked: (index == selectedIndexLeft ||
                            index == selectedIndexRight),
                        child: (widget.type == matchingsound && index % 2 == 0)
                            ? const Center(
                                child: Icon(Icons.volume_up,
                                    size: 40, color: Colors.blue),
                              )
                            : Text(capitalize(widget.items[index]['text']!),
                                style: const TextStyle(fontSize: 16)),
                      ));
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16),
                child: ButtonCheck(
                  enable: enableButton,
                  onPressed: () {},
                )),
          ],
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
                      selectAnswer != -1
                          ? capitalize(widget.items[selectAnswer]['mean']!)
                          : '',
                      style: TextStyle(
                        color: check ? Colors.green : Colors.red,
                        fontSize: 16,
                      ),
                    ))
                : const SizedBox(),
            const SizedBox(height: 20),
            ButtonCheck(
              text: "Tiếp tục",
              onPressed: () {
                if (message == "Tuyệt vời!") {
                    widget.onAnswer(check,score);
                }
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              type: !check ? typeButtonCheckDialog : typeButtonCheck,
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
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
