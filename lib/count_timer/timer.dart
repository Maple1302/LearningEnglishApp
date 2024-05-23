import 'dart:async';

import 'package:flutter/material.dart';

class IncrementalTimer extends StatefulWidget {
  @override
  State<IncrementalTimer> createState() => _IncrementalTimerState();
}

class _IncrementalTimerState extends State<IncrementalTimer> {
  int _elapsedTime = 0; // Thời gian đã trôi qua (giây)
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _showElapsedTime();
  }

  void resetTimer() {
    _timer?.cancel();
    setState(() {
      _elapsedTime = 0;
    });
  }

  String _showElapsedTime() {
    return convertToMinute(_elapsedTime);
    // Bạn có thể sử dụng biến elapsedTime cho các mục đích khác
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            convertToMinute(_elapsedTime),
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String convertToMinute(int time) {
    int minutes = time ~/ 60;
    int seconds = time % 60;
    String minute = minutes < 10 ? "0$minutes" : minutes.toString();
    String sencond = seconds < 10 ? "0$seconds" : seconds.toString();
    return "$minute:$sencond";
  }
}
