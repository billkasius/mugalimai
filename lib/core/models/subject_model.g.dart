// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubjectModel _$SubjectModelFromJson(Map<String, dynamic> json) => SubjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameKy: json['nameKy'] as String,
      nameRu: json['nameRu'] as String,
      nameEn: json['nameEn'] as String,
      type: $enumDecode(_$SubjectTypeEnumMap, json['type']),
      color: SubjectModel._colorFromJson((json['color'] as num).toInt()),
    );

Map<String, dynamic> _$SubjectModelToJson(SubjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameKy': instance.nameKy,
      'nameRu': instance.nameRu,
      'nameEn': instance.nameEn,
      'type': _$SubjectTypeEnumMap[instance.type]!,
      'color': SubjectModel._colorToJson(instance.color),
    };

const _$SubjectTypeEnumMap = {
  SubjectType.kyrgyz: 'kyrgyz',
  SubjectType.russian: 'russian',
  SubjectType.english: 'english',
  SubjectType.math: 'math',
  SubjectType.physics: 'physics',
  SubjectType.chemistry: 'chemistry',
  SubjectType.biology: 'biology',
  SubjectType.history: 'history',
  SubjectType.geography: 'geography',
};
