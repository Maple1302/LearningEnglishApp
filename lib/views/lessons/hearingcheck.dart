import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HearingCheckView extends StatefulWidget {
  const HearingCheckView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HearingCheckViewState createState() => _HearingCheckViewState();
}

class _HearingCheckViewState extends State<HearingCheckView> {
  final TextEditingController _textEditingController = TextEditingController();
  String expectedWord = 'banana'; // Từ mà bạn muốn người dùng nhập
  FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiểm tra nghe'),
      ),
      body: Padding(
        padding:const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _speak(expectedWord); // Phát âm thanh của từ mẫu
              },
              child:const Text('Phát từ mẫu'),
            ),
           const SizedBox(height: 20.0),
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Nhập từ bạn nghe thấy',
              ),
            ),
           const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String userInput = _textEditingController.text.toLowerCase();
                if (userInput == expectedWord) {
                  _showDialog('Chính xác!', 'Bạn đã nhập đúng từ.');
                } else {
                  _showDialog('Sai rồi!', 'Bạn đã nhập sai từ.');
                }
              },
              child:const Text('Kiểm tra'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('en-US'); // Đặt ngôn ngữ là tiếng Anh (Mỹ)
    await flutterTts.setPitch(1.0); // Đặt pitch mặc định (1.0)
    await flutterTts.speak(text); // Phát âm thanh từ văn bản
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:const Text('Đóng'),
            ),
          ],
        );
      },  
    );
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop(); // Dừng phát âm thanh khi thoát trang
  }
}
