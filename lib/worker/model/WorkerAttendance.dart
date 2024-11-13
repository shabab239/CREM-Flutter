

import '../../stage/model/ConstructionStage.dart';
import 'Worker.dart';

class WorkerAttendance {
  final int? id;
  final DateTime date;
  final AttendanceStatus status;
  final ConstructionStage stage;
  final Worker worker;
  final int companyId;

  WorkerAttendance({
    this.id,
    required this.date,
    required this.status,
    required this.stage,
    required this.worker,
    required this.companyId,
  });

  factory WorkerAttendance.fromJson(Map<String, dynamic> json) {
    return WorkerAttendance(
      id: json['id'],
      date: DateTime.parse(json['date']),
      status: AttendanceStatus.values.firstWhere((e) => e.toString() == 'AttendanceStatus.' + json['status']),
      stage: ConstructionStage.fromJson(json['stage']),
      worker: Worker.fromJson(json['worker']),
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'status': status.toString().split('.').last,
      'stage': stage.toJson(),
      'worker': worker.toJson(),
      'companyId': companyId,
    };
  }
}

enum AttendanceStatus {
  PRESENT,
  ABSENT,
  ON_LEAVE
}
