import 'package:json_annotation/json_annotation.dart';

part 'user_state.g.dart';

@JsonSerializable(explicitToJson: true)
class UserState {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'money_dollars')
  final int moneyDollars;

  @JsonKey(name: 'current_space_id')
  final String currentSpaceId;

  @JsonKey(name: 'owned_properties')
  final List<String> ownedProperties;

  final int position;

  UserState({
    required this.userId,
    required this.moneyDollars,
    required this.position,
    required this.currentSpaceId,
    required this.ownedProperties
  });

  factory UserState.fromJson(Map<String, dynamic> json) =>
      _$UserStateFromJson(json);

  Map<String, dynamic> toJson() => _$UserStateToJson(this);
}
