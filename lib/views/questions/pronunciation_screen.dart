import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:maple/UI/custom_buttons.dart';
import 'package:maple/helper/audio_helper.dart';
import 'package:maple/utils/constants.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class PronunciationScreen extends StatefulWidget {
  final String sampleText;
  final String mean;
  final Function(bool, int) onAnswer;
  const PronunciationScreen(
      {super.key,
      required this.sampleText,
      required this.mean,
      required this.onAnswer});

  @override
  State<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _userText = "";
  bool standards = false;
  int score = 3;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void didUpdateWidget(PronunciationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      // Reset lại dữ liệu khi widget thay đổi
      _initializeData();
    }
  }

  void _initializeData() {
    _speech = stt.SpeechToText();
    _isListening = false;
    _userText = "";
    standards = false;
    AudioHelper.speak(widget.sampleText);
    score = 3;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    IconButton(
                      icon: const Icon(Icons.volume_up,
                          size: 40, color: Colors.blue),
                      onPressed: () {
                        if (!_isListening) {
                          AudioHelper.speak(widget.sampleText);
                        }
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              widget.onAnswer(false, score);
            },
            child: const Text(
              'GIỜ CHƯA NÓI ĐƯỢC',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          ButtonCheck(
            enable: _userText != "",
            onPressed: _evaluatePronunciation,
          ),
        ],
      ),
    );
  }

  Widget _highlightedText() {
    List<String> sampleWords = widget.sampleText.split(' ');
    List<String> userWords = _userText.toLowerCase().split(' ');
    int countRatio = 0;
    return RichText(
      text: TextSpan(
        children: sampleWords.map((word) {
          bool matched = userWords.contains(_normalizeText(word));
          if (matched) {
            countRatio++;
          }
          standards = countRatio / sampleWords.length > 0.7;
          if (countRatio / sampleWords.length == 1) {
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
          if (mounted) {
            setState(() {
              _isListening = false;
            });
          }
        }
      },
      onError: (error) {
        if (mounted) {
          _showResultDialog('Bạn chưa phát âm phải không?', false);
          AudioHelper.playSound('error');
        }
      },
    );

    if (available) {
      if (mounted) {
        setState(() {
          _isListening = true;
        });
      }

      _speech.listen(
        listenFor: const Duration(seconds: 15),
        onResult: (result) {
          if (mounted) {
            setState(() {
              _userText = result.recognizedWords.trim();
            });
          }
        },
      );
    } else {
      if (mounted) {
        _showResultDialog('Vui lòng cho phép ghi âm', false);
        AudioHelper.playSound('fail');
      }
    }
  }

  void _evaluatePronunciation() {
    if (standards) {
      AudioHelper.playSound('correct');
      _showResultDialog("Rất giỏi! Dịch Nghĩa:\n${widget.mean}", true);
    } else {
      AudioHelper.playSound('incorrect');
      _showResultDialog('Có vẻ không đúng, thử lại lần nữa nhé', false);
    }
  }

  String _normalizeText(String text) {
    return text.toLowerCase().replaceAll(RegExp(r"[^\w\s\']"), '');
  }

  void _showResultDialog(String message, bool check) {
    if (mounted) {
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
                      color: check ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      check ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 15.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: check ? Colors.green : Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              check
                  ? ButtonCheck(
                      type: check ? typeButtonCheck : typeButtonCheckDialog,
                      onPressed: () {
                        widget.onAnswer(check, score);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      text: 'Tiếp tục',
                    )
                  : const SizedBox(height: 0),
            ],
          ),
        ),
      ));
    }
  }

  @override
  void dispose() {
    _speech.stop();
    AudioHelper.disposeAudio();
    AudioHelper.disposeTts();
    super.dispose();
  }
}
