import 'package:json_annotation/json_annotation.dart';
import './visual_properties.dart';

part 'board_space_data.g.dart';

/// Model representing one Monopoly board space.
@JsonSerializable(explicitToJson: true)
class BoardSpaceData {
  final String name;

  @JsonKey(name: 'space_type')
  final String spaceType;

  @JsonKey(name: 'space_id')
  final String spaceId;

  @JsonKey(name: 'space_index')
  final int spaceIndex;

  @JsonKey(name: 'visual_properties')
  final VisualProperties visualProperties;

  BoardSpaceData({
    required this.name,
    required this.spaceType,
    required this.spaceId,
    required this.spaceIndex,
    required this.visualProperties,
  });

  factory BoardSpaceData.fromJson(Map<String, dynamic> json) =>
      _$BoardSpaceDataFromJson(json);

  Map<String, dynamic> toJson() => _$BoardSpaceDataToJson(this);

  /// True for the 4 Monopoly corner tiles.
  bool get isCorner =>
      spaceIndex == 0 ||
      spaceIndex == 10 ||
      spaceIndex == 20 ||
      spaceIndex == 30;
}
