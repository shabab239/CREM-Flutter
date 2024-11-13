
import 'Floor.dart';
import 'Project.dart';

class Building {
  final int? id;
  final String? name;
  final BuildingType? type;
  final Project project;
  final List<Floor>? floors;
  final int companyId;

  Building({
    this.id,
    this.name,
    this.type,
    required this.project,
    this.floors,
    required this.companyId,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      name: json['name'],
      type: json['type'] != null
          ? BuildingType.values
          .firstWhere((e) => e.toString() == 'BuildingType.${json['type']}')
          : null,
      project: Project.fromJson(json['project']),
      floors: json['floors'] != null
          ? (json['floors'] as List)
          .map((e) => Floor.fromJson(e))
          .toList()
          : [],
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type?.toString().split('.').last,
      'project': project.toJson(),
      'floors': floors?.map((e) => e.toJson()).toList(),
      'companyId': companyId,
    };
  }
}

enum BuildingType {
  RESIDENTIAL,
  COMMERCIAL,
  MIXED_USE,
}
