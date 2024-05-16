import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class PronunciationCheckView extends StatefulWidget {
  final String sampleText;
  const PronunciationCheckView({super.key, required this.sampleText});

  @override
  // ignore: library_private_types_in_public_api
  _PronunciationCheckViewState createState() => _PronunciationCheckViewState();
}

class _PronunciationCheckViewState extends State<PronunciationCheckView> {
  late stt.SpeechToText _speech;
   bool _isListening = false;
  String _userText = "";
  bool standards = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Đọc câu này",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.volume_up, size: 30),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _highlightedText(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                    onPressed: _isListening ? null : _startListening,
                    icon: _isListening
                        ? const SpinKitWave(color: Colors.white, size: 20.0)
                        : const Icon(Icons.mic),
                    label: Text(_isListening ? 'ĐANG NGHE...' : 'NHẤN ĐỂ NÓI'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Chức năng khi không thể nói
                },
                child: const Text(
                  'GIỜ CHƯA NÓI ĐƯỢC',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _evaluatePronunciation,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'KIỂM TRA',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _highlightedText() {
    List<String> sampleWords = widget.sampleText.split(' ');
    List<String> userWords = _userText.toLowerCase().split(' ');
    int countRatio = 0;
    return RichText(
      text: TextSpan(
        children: sampleWords.map((word) {
          bool matched = userWords.contains(_normalizeText(word));
          if(matched){countRatio++;}
          standards = countRatio / sampleWords.length > 0.7;
          if(countRatio / sampleWords.length == 1){
            _speech.stop();
            _isListening = false;
          }
         
          return TextSpan(
            text: '$word ',
            style: TextStyle(
              fontSize: 18,
              color: matched ? Colors.green : Colors.black,
            ),
          );
        }).toList(),
      ),
    );
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
           _evaluatePronunciation();
          setState(() {
            _isListening = false;
           
          });
        }
      },
      onError: (error) {
        _showResultDialog('Bạn chưa phát âm phải không? ', false);
        AudioHelper.playSound('error');
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
      });

      _speech.listen(
        listenFor: const Duration(seconds: 15),
        onResult: (result) {
          setState(() {
            _userText = result.recognizedWords.trim();
          });
        },
      );
    } else {
      _showResultDialog('Vui lòng cho phép ghi âm', false);
      AudioHelper.playSound('fail');
    }
  }

  void _evaluatePronunciation() {
    if (standards) {AudioHelper.playSound('correct');
      _showResultDialog(
          "Rất giỏi! Dịch Nghĩa:\n" "Xin chào, Bạn tên gì?", true);
      
    } else {AudioHelper.playSound('incorrect');
      _showResultDialog('Có vẻ không đúng, thử lại lần nữa nhé', false);
      
    }
  }

  String _normalizeText(String text) {
    return text.toLowerCase().replaceAll(RegExp(r"[^\w\s\']"), '');
  }

  void _showResultDialog(String message, bool check) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      duration:
          check ? const Duration(seconds: 100) : const Duration(seconds: 2),
      content: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            check ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: const Text('Tiếp tục'),
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ],
        ),
      ),
    ));
  }
}
