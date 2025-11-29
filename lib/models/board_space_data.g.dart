// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_space_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardSpaceData _$BoardSpaceDataFromJson(Map<String, dynamic> json) =>
    BoardSpaceData(
      name: json['name'] as String,
      spaceType: json['space_type'] as String,
      spaceId: json['space_id'] as String,
      spaceIndex: (json['space_index'] as num).toInt(),
      visualProperties: VisualProperties.fromJson(
        json['visual_properties'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$BoardSpaceDataToJson(BoardSpaceData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'space_type': instance.spaceType,
      'space_id': instance.spaceId,
      'space_index': instance.spaceIndex,
      'visual_properties': instance.visualProperties.toJson(),
    };
