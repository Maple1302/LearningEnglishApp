import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioHelper {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static FlutterTts flutterTts = FlutterTts();
  static void playSound(String type) async {
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
      case 'bounus':
        source = 'sounds/game-bonus.mp3';
        break;
      case 'success':
        source = 'sounds/success-effect.mp3';
        break;
      // Thêm các trường hợp khác cần xử lý
      default:
        // Xử lý mặc định nếu không có trường hợp nào khớp
        break;
    }
    await _audioPlayer.play(AssetSource(source));
  }

  static Future<void> speak(String text,{double speed = 0.5}) async {
    await flutterTts.setSpeechRate(speed);
    await flutterTts.setLanguage('en-US'); // Đặt ngôn ngữ là tiếng Anh (Mỹ)
    await flutterTts.setPitch(1.0); // Đặt pitch mặc định (1.0)
    await flutterTts.speak(text);

    // Phát âm thanh từ văn bản
  }

 

  static void disposeTts() {
    flutterTts.stop();
  }

  static void disposeAudio() {
    _audioPlayer.stop();
  }
}
