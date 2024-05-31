import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maple/models/mapmodel.dart';
import 'package:maple/viewmodels/map_viewmodel.dart';
import 'package:maple/views/maps/map_list_screen.dart';

import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
   

   @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('maps'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Maps').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No maps available'));
          }

          final maps = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return MapModel.fromJson(data);
          }).toList();

          return ListView.builder(
            itemCount: maps.length,
            itemBuilder: (context, index) {
              final map = maps[index];
               return ListTile(
                title: Text(map.description),
                subtitle: const Text('Sections: '),
                
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => viewModel.deleteMap(map.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMapScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
