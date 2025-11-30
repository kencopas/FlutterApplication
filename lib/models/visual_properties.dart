import 'package:json_annotation/json_annotation.dart';

part 'visual_properties.g.dart';

@JsonSerializable()
class VisualProperties {
  final String? color;
  final String? icon;
  final String? description;

  @JsonKey(name: 'occupied_by')
  final String? occupiedBy;

  VisualProperties({this.color, this.icon, this.description, this.occupiedBy});

  factory VisualProperties.fromJson(Map<String, dynamic> json) =>
      _$VisualPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$VisualPropertiesToJson(this);
}
