import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'subject_model.g.dart';

enum SubjectType {
  kyrgyz,
  russian,
  english,
  math,
  physics,
  chemistry,
  biology,
  history,
  geography
}

@JsonSerializable()
class SubjectModel {
  final String id;
  final String name;
  final String nameKy;
  final String nameRu;
  final String nameEn;
  final SubjectType type;

  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color color;

  const SubjectModel({
    required this.id,
    required this.name,
    required this.nameKy,
    required this.nameRu,
    required this.nameEn,
    required this.type,
    required this.color,
  });

  // Конвертеры для Color
  static Color _colorFromJson(int colorValue) => Color(colorValue);
  static int _colorToJson(Color color) => color.value;

  factory SubjectModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectModelToJson(this);

  static List<SubjectModel> get defaultSubjects => [
    const SubjectModel(
      id: '1',
      name: 'Кыргызский язык',
      nameKy: 'Кыргыз тили',
      nameRu: 'Кыргызский язык',
      nameEn: 'Kyrgyz Language',
      type: SubjectType.kyrgyz,
      color: Color(0xFF4CAF50), // Зеленый
    ),
    const SubjectModel(
      id: '2',
      name: 'Русский язык',
      nameKy: 'Орус тили',
      nameRu: 'Русский язык',
      nameEn: 'Russian Language',
      type: SubjectType.russian,
      color: Color(0xFF2196F3), // Синий
    ),
    const SubjectModel(
      id: '3',
      name: 'Английский язык',
      nameKy: 'Англис тили',
      nameRu: 'Английский язык',
      nameEn: 'English Language',
      type: SubjectType.english,
      color: Color(0xFFFF9800), // Оранжевый
    ),
    const SubjectModel(
      id: '4',
      name: 'Математика',
      nameKy: 'Математика',
      nameRu: 'Математика',
      nameEn: 'Mathematics',
      type: SubjectType.math,
      color: Color(0xFF9C27B0), // Фиолетовый
    ),
  ];
}
