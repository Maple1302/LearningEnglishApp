import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:maple/helper/audio_helper.dart';
import 'package:maple/utils/constants.dart';

class MessageBoxAwsome extends StatelessWidget {
  final Widget child;
  const MessageBoxAwsome({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: buttonItemUncheckedBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: buttonItemCheckedSideColor, width: 3),
      ),
      child: child,
    );
  }
}

class MessageQuestion extends StatelessWidget {
  final String question;
  const MessageQuestion({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: HexColor("#f7f7f7"),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: HexColor("#e8e8e8"), width: 3),
      ),
      child: SizedBox(
        width: 200,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Đảm bảo các icon và text được căn chỉnh đúng
          children: [
            IconButton(
              onPressed: () {
              AudioHelper.speak(question);
              },
              icon: Icon(
                Icons.volume_up,
                color: HexColor("#14b2fa"),
                size: 30,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              // Sử dụng Expanded để Text có thể bọc xuống và không bị cắt ngang
              child: Text(
                question,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
