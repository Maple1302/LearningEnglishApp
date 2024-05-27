import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maple/models/sectionmodel.dart';

class SectionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSection(SectionModel section) async {
    await _firestore.collection('Sections').doc(section.id).set(section.toJson());
  }

  Future<List<SectionModel>> fetchSections() async {
    QuerySnapshot snapshot = await _firestore.collection('Sections').get();
    return snapshot.docs.map((doc) => SectionModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> updateSection(String id, SectionModel section) async {
    await _firestore.collection('Sections').doc(id).update(section.toJson());
  }

  Future<void> deleteSection(String id) async {
    await _firestore.collection('Sections').doc(id).delete();
  }
}
