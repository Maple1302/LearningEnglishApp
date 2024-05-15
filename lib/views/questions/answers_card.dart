import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Answer Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Card Answer Example'),
        ),
        body: Center(
          child: CardAnswer(
            question: 'What is the capital of France?',
            answers: ['Paris', 'London', 'Berlin', 'Madrid'],
          ),
        ),
      ),
    );
  }
}

class CardAnswer extends StatelessWidget {
  final String question;
  final List<String> answers;

  CardAnswer({required this.question, required this.answers});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Độ nâng của card
      margin: EdgeInsets.all(16), // Khoảng cách xung quanh card
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16), // Khoảng cách giữa câu hỏi và đáp án

            // Tạo danh sách các đáp án
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: answers.map((answer) {
                return ElevatedButton(
                  onPressed: () {
                    // Xử lý khi người dùng chọn đáp án
                    print('Selected answer: $answer');
                  },
                  child: Text(answer),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
  
}
