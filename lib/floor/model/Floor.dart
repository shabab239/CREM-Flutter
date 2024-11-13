import '../../building/model/Building.dart';

class Floor {
  int? id;
  FloorName? name;
  Building? building;

  Floor({
    this.id,
    this.name,
    this.building,
  });

  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      id: json['id'],
      name: json['name'] != null
          ? FloorName.values
          .firstWhere((e) => e.toString() == 'FloorName.${json['name']}')
          : null,
      building: Building.fromJson(json['building']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name?.toString().split('.').last,
      'building': building?.toJson(),
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