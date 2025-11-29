// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameState _$GameStateFromJson(Map<String, dynamic> json) => GameState(
  userId: json['user_id'] as String,
  moneyDollars: (json['money_dollars'] as num).toInt(),
  position: (json['position'] as num).toInt(),
  currentSpaceId: json['current_space_id'] as String,
  boardSpaces: (json['board_spaces'] as List<dynamic>)
      .map((e) => BoardSpaceData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GameStateToJson(GameState instance) => <String, dynamic>{
  'user_id': instance.userId,
  'money_dollars': instance.moneyDollars,
  'position': instance.position,
  'current_space_id': instance.currentSpaceId,
  'board_spaces': instance.boardSpaces.map((e) => e.toJson()).toList(),
};
