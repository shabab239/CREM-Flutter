
import '../../floor/model/Floor.dart';
import '../../project/model/Project.dart';

class Building {
  int? id;
  String? name;
  BuildingType? type;
  Project? project;
  List<Floor>? floors;

  Building({
    this.id,
    this.name,
    this.type,
    this.project,
    this.floors,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      name: json['name'],
      type: json['type'] != null
          ? BuildingType.values
          .firstWhere((e) => e.toString() == 'BuildingType.${json['type']}')
          : null,
      project: json['project'] == null ? null : Project.fromJson(json['project']),
      floors: json['floors'] != null
          ? (json['floors'] as List)
          .map((e) => Floor.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type?.toString().split('.').last,
      'project': project?.toJson(),
      'floors': floors?.map((e) => e.toJson()).toList(),
    };
  }
}

enum BuildingType {
  RESIDENTIAL,
  COMMERCIAL,
  MIXED_USE,
}
