// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserState _$UserStateFromJson(Map<String, dynamic> json) => UserState(
  userId: json['user_id'] as String,
  moneyDollars: (json['money_dollars'] as num).toInt(),
  position: (json['position'] as num).toInt(),
  currentSpaceId: json['current_space_id'] as String,
  ownedProperties: (json['owned_properties'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UserStateToJson(UserState instance) => <String, dynamic>{
  'user_id': instance.userId,
  'money_dollars': instance.moneyDollars,
  'current_space_id': instance.currentSpaceId,
  'owned_properties': instance.ownedProperties,
  'position': instance.position,
};
