import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class TranslationScreen extends StatefulWidget {
  final String question;
  final List<String> correctAnswer;
  final List<String> answers;
  @override
  const TranslationScreen(
      {super.key,
      required this.question,
      required this.correctAnswer,
      required this.answers});
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  @override
  // ignore: library_private_types_in_public_api
  _TranslationScreenState createState() =>
      // ignore: no_logic_in_create_state
      _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  List<String> selectedAnswers = [];
  List<bool> visibility = List.generate(12, (index) => true);
  final AudioPlayer _audioPlayer = AudioPlayer();

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dịch câu này',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.volume_up,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.question,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              SizedBox(
                height:
                    155, // Đặt chiều cao để có đủ không gian cho các dòng kẻ
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    selectedAnswers.length,
                    (index) => ElevatedButton(
                      onPressed: () {
                        setState(() {
                          int optionIndex =
                              widget.answers.indexOf(selectedAnswers[index]);

                          visibility[optionIndex] = true;
                          selectedAnswers.removeAt(index);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        elevation: 4,
                        side: const BorderSide(
                            color: Colors.grey,width: 2),
                            
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                         
                        ),
                      ),
                      child: Text(selectedAnswers[index]),
                    ),
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
                      replacement: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          widget.answers[index],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      visible: visibility[index],
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedAnswers.add(widget.answers[index]);

                            visibility[index] = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          elevation: 4,
                          side: const BorderSide(color: Colors.grey,width: 3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(widget.answers[index]),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    color: selectedAnswers.isNotEmpty? Colors.green.withOpacity(0.5):Colors.grey,width:selectedAnswers.isNotEmpty ? 3:0),
              
             shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Góc bo tròn của nút
              ),
              shadowColor: Colors.green, 
                elevation: 6,
               
                backgroundColor: selectedAnswers.isNotEmpty ? Colors.green:Colors.grey,
                minimumSize: const Size(double.infinity, 50),
              ),
                onPressed: selectedAnswers.isNotEmpty 
                    ? () {
                        if (compareLists(
                            selectedAnswers, widget.correctAnswer)) {
                          // Hiển thị thông báo đáp án đúng
                          playSound("correct");
                          showResultDialog("Chính xác!", true);
                        } else {
                          // Hiển thị thông báo đáp án sai
                          playSound("incorrect");
                          showResultDialog("Không chính xác!", false);
                        }
                      }
                    : null,
                child:  Center(
                    child: Text(
                  'Kiểm tra'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selectedAnswers.isNotEmpty ? Colors.white:Colors.black26 ,
                  ),
                )),
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
  void playSound(String type) async {
    String source = "";
    switch (type) {
      case 'correct':
        source = 'sounds/correct_answer.mp3';
        break;
      case 'incorrect':
        source = 'sounds/fail.mp3';
        break;
      case 'error':
        source = 'sounds/error.mp3';
        break;
      case 'fail':
        source = 'sounds/fail.mp3';
        break;
      // Thêm các trường hợp khác cần xử lý
      default:
        // Xử lý mặc định nếu không có trường hợp nào khớp
        break;
    }
    await _audioPlayer.play(AssetSource(source));
  }

  void showResultDialog(String message, bool check) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      duration:
           const Duration(seconds: 100) ,
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
            !check?
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Trả lời đúng",
                  style: TextStyle(
                      color: check ? Colors.green : Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )):const SizedBox(),
             !check? Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  convertListToString(widget.correctAnswer),
                  style: TextStyle(
                    color: check ? Colors.green : Colors.red,
                    fontSize: 16,
                  ),
                )): const SizedBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
              
             shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Góc bo tròn của nút
              ),
              shadowColor: Colors.grey, 
                elevation: 6,
                foregroundColor: Colors.white,
                backgroundColor:check? Colors.green: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child:  Text('Tiếp tục'.toUpperCase()),
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
}