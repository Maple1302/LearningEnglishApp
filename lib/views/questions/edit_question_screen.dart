import 'package:flutter/material.dart';
import 'package:maple/utils/constants.dart';

class EditQuestionScreen extends StatelessWidget {
  final dynamic question;

  const EditQuestionScreen({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    Map<String,String> text = <String,String>{};
    if(question.typeOfQuestion == completeConversationQuestion){
     text =  question.question;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Question details go here: $text'),
      ),
    );
  }
}
