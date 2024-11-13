import '../../stage/model/ConstructionStage.dart';
import 'Worker.dart';

class WorkerAttendance {
  int? id;
  DateTime? date;
  AttendanceStatus? status;
  ConstructionStage? stage;
  Worker? worker;

  WorkerAttendance({
    this.id,
    this.date,
    this.status,
    this.stage,
    this.worker,
  });

  factory WorkerAttendance.fromJson(Map<String, dynamic> json) {
    return WorkerAttendance(
      id: json['id'],
      date: DateTime.parse(json['date']),
      status: AttendanceStatus.values.firstWhere(
          (e) => e.toString() == 'AttendanceStatus.' + json['status']),
      stage: ConstructionStage.fromJson(json['stage']),
      worker: Worker.fromJson(json['worker']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'status': status.toString().split('.').last,
      'stage': stage?.toJson(),
      'worker': worker?.toJson(),
    };
  }
}

enum AttendanceStatus { PRESENT, ABSENT, ON_LEAVE }
