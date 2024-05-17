import 'package:flutter/material.dart';
import 'package:maple/helper/audio_helper.dart';

class MatchingPairScreen extends StatefulWidget {
  final List<Map<String, String>> items;

  const MatchingPairScreen({
    super.key,
    required this.items,
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
                      maintainState: true,
                      maintainAnimation: true,
                      maintainSize: true,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (index % 2 == 0) {
                              answerSelectedLeft = widget.items[index]['mean']!;
                              selectedIndexLeft = index;
                              AudioHelper.speak(widget.items[index]['mean']!);
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
                                print( visibility[selectedIndexRight]);
                                selectedIndexLeft = -1;
                                selectedIndexRight = -1;
                                count +=2;

                                if (count == widget.items.length) {
                                  showResultDialog("Tuyệt vời!", true);
                                } else {
                                  showResultDialog("Chính xác!", true);
                                }
                                AudioHelper.playSound("correct");
                              } else {
                                showResultDialog("Không chính xác!", false);
                                AudioHelper.playSound("incorrect");
                              }
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 6,
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                width: 3,
                                color: (index == selectedIndexRight ||
                                        index == selectedIndexLeft)
                                    ? Colors.blue
                                    : Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            shadowColor: Colors.blue),
                        child: Text(capitalize(widget.items[index]['text']!),
                            style: const TextStyle(fontSize: 16)),
                      ));
                },
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
                      '',
                      style: TextStyle(
                        color: check ? Colors.green : Colors.red,
                        fontSize: 16,
                      ),
                    ))
                : const SizedBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Góc bo tròn của nút
                ),
                shadowColor: Colors.grey,
                elevation: 6,
                foregroundColor: Colors.white,
                backgroundColor: check ? Colors.green : Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: Text('Tiếp tục'.toUpperCase()),
            )
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
