import 'package:json_annotation/json_annotation.dart';
import './board_space_data.dart';

part 'game_state.g.dart';

@JsonSerializable(explicitToJson: true)
class GameState {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'money_dollars')
  final int moneyDollars;

  final int position;

  @JsonKey(name: 'current_space_id')
  final String currentSpaceId;

  @JsonKey(name: 'board_spaces')
  final List<BoardSpaceData> boardSpaces;

  GameState({
    required this.userId,
    required this.moneyDollars,
    required this.position,
    required this.currentSpaceId,
    required this.boardSpaces,
  });

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateToJson(this);
}
