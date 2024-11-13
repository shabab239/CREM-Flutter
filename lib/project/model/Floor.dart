
import 'Building.dart';
import 'Unit.dart';

class Floor {
  final int? id;
  final FloorName? name;
  final Building building;
  final List<Unit>? units;
  final int companyId;

  Floor({
    this.id,
    this.name,
    required this.building,
    this.units,
    required this.companyId,
  });

  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      id: json['id'],
      name: json['name'] != null
          ? FloorName.values
          .firstWhere((e) => e.toString() == 'FloorName.${json['name']}')
          : null,
      building: Building.fromJson(json['building']),
      units: json['units'] != null
          ? (json['units'] as List).map((e) => Unit.fromJson(e)).toList()
          : [],
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name?.toString().split('.').last,
      'building': building.toJson(),
      'units': units?.map((e) => e.toJson()).toList(),
      'companyId': companyId,
    };
  }
}

enum FloorName {
  BASEMENT,
  GROUND,
  FIRST,
  SECOND,
  THIRD,
  FOURTH,
  FIFTH,
  SIXTH,
  SEVENTH,
  EIGHTH,
  NINTH,
  TENTH,
  ELEVENTH,
  TWELVETH,
  THIRTEENTH,
  FOURTEENTH,
  FIFTEENTH,
}
