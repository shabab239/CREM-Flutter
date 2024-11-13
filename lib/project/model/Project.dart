import '../../user/User.dart';
import 'Building.dart';

class Project {
   int? id;
  String? name;
   String? location;
   DateTime? startDate;
   DateTime? endDate;
   double? budget;
   String? description;
   ProjectStatus? status;
   User? manager;
   List<User>? teamMembers;
   List<Building>? buildings;

  Project({
    this.id,
    this.name,
    this.location,
    this.startDate,
    this.endDate,
    this.budget,
    this.description,
    this.status,
    this.manager,
    this.teamMembers,
    this.buildings,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int?,
      name: json['name'] as String?,
      location: json['location'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
      budget: (json['budget'] as num?)?.toDouble(),
      description: json['description'] as String?,
      status: ProjectStatus.values.firstWhere(
          (e) => e.toString() == 'ProjectStatus.${json['status']}',
          orElse: null),
      manager: json['manager'] != null
          ? User.fromJson(json['manager'] as Map<String, dynamic>)
          : null,
      teamMembers: json['teamMembers'] != null
          ? (json['teamMembers'] as List)
              .map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      buildings: json['buildings'] != null
          ? (json['buildings'] as List)
              .map((e) => Building.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'budget': budget,
      'description': description,
      'status': status?.toString().split('.').last,
      'manager': manager?.toJson(),
      'teamMembers': teamMembers?.map((e) => e.toJson()).toList(),
      'buildings': buildings?.map((e) => e.toJson()).toList(),
    };
  }
}

enum ProjectStatus {
  PLANNING,
  IN_PROGRESS,
  COMPLETED,
}
