import 'package:flutter/material.dart';
import 'package:maple/views/lessons/levels.dart';
class Lessons extends StatelessWidget {
  const Lessons({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Levels(),
    );
  }
}


