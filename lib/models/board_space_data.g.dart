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
      purchasePrice: (json['purchase_price'] as num?)?.toInt(),
      rentPrices: (json['rent_prices'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      mortgageValue: (json['mortgage_value'] as num?)?.toInt(),
      hotels: (json['hotels'] as num?)?.toInt(),
      ownedBy: json['owned_by'] as String?,
      action: json['action'] as String?,
    );

Map<String, dynamic> _$BoardSpaceDataToJson(BoardSpaceData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'space_type': instance.spaceType,
      'space_id': instance.spaceId,
      'space_index': instance.spaceIndex,
      'visual_properties': instance.visualProperties.toJson(),
      'purchase_price': instance.purchasePrice,
      'rent_prices': instance.rentPrices,
      'mortgage_value': instance.mortgageValue,
      'owned_by': instance.ownedBy,
      'hotels': instance.hotels,
      'action': instance.action,
    };
