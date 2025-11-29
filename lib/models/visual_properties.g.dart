// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visual_properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisualProperties _$VisualPropertiesFromJson(Map<String, dynamic> json) =>
    VisualProperties(
      color: json['color'] as String?,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      occupiedBy: json['occupied_by'] as String?,
    );

Map<String, dynamic> _$VisualPropertiesToJson(VisualProperties instance) =>
    <String, dynamic>{
      'color': instance.color,
      'icon': instance.icon,
      'description': instance.description,
      'occupied_by': instance.occupiedBy,
    };
