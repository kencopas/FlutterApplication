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
  VisualProperties visualProperties;

  @JsonKey(name: 'purchase_price')
  final int? purchasePrice;

  @JsonKey(name: 'rent_prices')
  final List<int>? rentPrices;

  @JsonKey(name: 'mortgage_value')
  final int? mortgageValue;

  @JsonKey(name: 'owned_by')
  final String? ownedBy;

  final int? hotels;
  final String? action;

  BoardSpaceData({
    required this.name,
    required this.spaceType,
    required this.spaceId,
    required this.spaceIndex,
    required this.visualProperties,
    this.purchasePrice,
    this.rentPrices,
    this.mortgageValue,
    this.hotels,
    this.ownedBy,
    this.action,
  });

  factory BoardSpaceData.fromJson(Map<String, dynamic> json) =>
      _$BoardSpaceDataFromJson(json);

  BoardSpaceData copy() {
    return BoardSpaceData.fromJson(toJson());
  }

  Map<String, dynamic> toJson() => _$BoardSpaceDataToJson(this);

  /// True for the 4 Monopoly corner tiles.
  bool get isCorner =>
      spaceIndex == 0 ||
      spaceIndex == 10 ||
      spaceIndex == 20 ||
      spaceIndex == 30;
}
