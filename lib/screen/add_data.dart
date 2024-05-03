import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ChangeData extends StatelessWidget {
  const ChangeData({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddDataScreen(),
    );
  }
}

class AddDataScreen extends StatelessWidget {
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data to Firestore'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            addData();
          },
          child: Text('Add Data'),
        ),
      ),
    );
  }

  Future<void> addData() async {
    // Example data
    String customDocumentId = 'your_custom_id';
    Map<String, dynamic> data = {
      'completedLessons': 'John Doe',
      'progress': 30,
      'email': 'john.doe@example.com',
      'username':'Jonny Deep'
    };
    await FirebaseFirestore.instance.collection('Users').doc(customDocumentId).set(data);
    // Add the data to Firestore
    return users
        .add(data)
        .then((value) => print("Data added successfully"))
        .catchError((error) => print("Failed to add data: $error"));
  }
}
