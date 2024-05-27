import 'package:flutter/material.dart';
import 'package:maple/models/mapmodel.dart';
import 'package:maple/repositories/map_repository.dart';

class MapViewModel extends ChangeNotifier {
  final MapRepository _repository = MapRepository();
  List<MapModel> _maps = [];

  List<MapModel> get maps => _maps;


  // Lấy danh sách maps và cập nhật trạng thái
  Future<List<MapModel>> fetchMaps() async {
    

    try {
      final newMaps = await _repository.fetchMaps();
      if (newMaps != _maps) {
        // Check if maps have changed
        _maps = newMaps;
        notifyListeners();
      }
      return _maps;
    } catch (e) {
      // Xử lý lỗi ở đây, ví dụ
      return []; // Hoặc trả về một danh sách rỗng nếu có lỗi
    } finally {
    
      notifyListeners();
    }
  }

  Future<void> addMap(MapModel map) async {
    await _repository.addMap(map);
    await fetchMaps();
  }

  Future<void> updateMap(MapModel map) async {
    await _repository.updateMap(map);
    await fetchMaps();
  }

  Future<void> deleteMap(String id) async {
    await _repository.deleteMap(id);
    await fetchMaps();
  }
}
