// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameState _$GameStateFromJson(Map<String, dynamic> json) => GameState(
  gameId: json['game_id'] as String,
  playerStates: (json['player_states'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, UserState.fromJson(e as Map<String, dynamic>)),
  ),
  gameBoard: (json['game_board'] as List<dynamic>)
      .map((e) => BoardSpaceData.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentTurn: (json['current_turn'] as num).toInt(),
  currentTurnUid: json['current_turn_uid'] as String,
);

Map<String, dynamic> _$GameStateToJson(GameState instance) => <String, dynamic>{
  'game_id': instance.gameId,
  'player_states': instance.playerStates.map((k, e) => MapEntry(k, e.toJson())),
  'game_board': instance.gameBoard.map((e) => e.toJson()).toList(),
  'current_turn': instance.currentTurn,
  'current_turn_uid': instance.currentTurnUid,
};
