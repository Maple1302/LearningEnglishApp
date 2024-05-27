import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maple/models/mapmodel.dart';

class MapRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'Maps'; // Đường dẫn đến collection trên Firebase

  // Lấy danh sách maps
  Future<List<MapModel>> fetchMaps() async {
    try {
      final snapshot = await _firestore.collection(_collectionPath).get();
      return snapshot.docs.map((doc) => MapModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch maps: $e');
    }
  }

  // Thêm map mới
  Future<void> addMap(MapModel map) async {
    try {
      await _firestore.collection(_collectionPath).add(map.toJson());
    } catch (e) {
      throw Exception('Failed to add map: $e');
    }
  }

  // Cập nhật map
  Future<void> updateMap(MapModel map) async {
    try {
      await _firestore.collection(_collectionPath).doc(map.id).update(map.toJson());
    } catch (e) {
      throw Exception('Failed to update map: $e');
    }
  }

  // Xóa map
  Future<void> deleteMap(String mapId) async {
    try {
      await _firestore.collection(_collectionPath).doc(mapId).delete();
    } catch (e) {
      throw Exception('Failed to delete map: $e');
    }
  }
}
