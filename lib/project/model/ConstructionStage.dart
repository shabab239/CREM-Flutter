

import '../../raw-material/model/RawMaterial.dart';
import '../../worker/model/Worker.dart';
import 'Building.dart';
import 'Floor.dart';
import 'Unit.dart';

class ConstructionStage {
  final int? id;
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;
  final StageStatus? status;
  final Building? building;
  final Floor? floor;
  final Unit? unit;
  final List<RawMaterial>? rawMaterials;
  final List<Worker>? workers;
  final int companyId;

  ConstructionStage({
    this.id,
    required this.name,
    this.startDate,
    this.endDate,
    this.status,
    this.building,
    this.floor,
    this.unit,
    this.rawMaterials,
    this.workers,
    required this.companyId,
  });

  factory ConstructionStage.fromJson(Map<String, dynamic> json) {
    return ConstructionStage(
      id: json['id'],
      name: json['name'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
      status: json['status'] != null
          ? StageStatus.values
          .firstWhere((e) => e.toString() == 'StageStatus.${json['status']}')
          : null,
      building:
      json['building'] != null ? Building.fromJson(json['building']) : null,
      floor: json['floor'] != null ? Floor.fromJson(json['floor']) : null,
      unit: json['unit'] != null ? Unit.fromJson(json['unit']) : null,
      rawMaterials: json['rawMaterials'] != null
          ? (json['rawMaterials'] as List)
          .map((item) => RawMaterial.fromJson(item))
          .toList()
          : null,
      workers: json['workers'] != null
          ? (json['workers'] as List)
          .map((item) => Worker.fromJson(item))
          .toList()
          : null,
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status?.toString().split('.').last,
      'building': building?.toJson(),
      'floor': floor?.toJson(),
      'unit': unit?.toJson(),
      'rawMaterials': rawMaterials?.map((item) => item.toJson()).toList(),
      'workers': workers?.map((item) => item.toJson()).toList(),
      'companyId': companyId,
    };
  }
}

enum StageStatus {
  NOT_STARTED,
  IN_PROGRESS,
  COMPLETED,
}
