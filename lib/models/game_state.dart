import 'package:json_annotation/json_annotation.dart';
import './board_space_data.dart';
import './user_state.dart';

part 'game_state.g.dart';

@JsonSerializable(explicitToJson: true)
class GameState {
  @JsonKey(name: 'game_id')
  final String gameId;

  @JsonKey(name: 'player_states')
  final Map<String, UserState> playerStates;

  @JsonKey(name: 'game_board')
  final List<BoardSpaceData> gameBoard;

  GameState({
    required this.gameId,
    required this.playerStates,
    required this.gameBoard
  });

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateToJson(this);
}
