import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firestore Example'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Questions').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var users = snapshot.data?.docs;
            return ListView.builder(
              itemCount: users?.length,
              itemBuilder: (context, index) {
                var user = users![index];
                return ListTile(
                  // ignore: prefer_interpolation_to_compose_strings
                  title: Text("${index+1}." + user['content']),
                  subtitle: Text(user['correctAnswer']),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
