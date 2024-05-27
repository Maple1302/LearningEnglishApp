import 'package:flutter/material.dart';
import 'package:maple/models/sectionmodel.dart';
import 'package:maple/repositories/section_repository.dart';

class SectionViewModel extends ChangeNotifier {
  final SectionRepository _repository = SectionRepository();
  List<SectionModel> _sections = [];

  List<SectionModel> get sections => _sections;

  Future<void> fetchSections() async {
    _sections = await _repository.fetchSections();
    notifyListeners();
  }

  Future<void> addSection(SectionModel section) async {
    await _repository.addSection(section);
    await fetchSections();
  }

  Future<void> updateSection(String id, SectionModel section) async {
    await _repository.updateSection(id, section);
    await fetchSections();
  }

  Future<void> deleteSection(String id) async {
    await _repository.deleteSection(id);
    await fetchSections();
  }
}
