

import 'auth/User.dart';

class Task {
  final int? id;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final Status status;
  final List<User> employees;
  final int companyId;

  Task({
    this.id,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.employees,
    required this.companyId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: Status.values.firstWhere((e) => e.toString() == 'Status.' + json['status']),
      employees: List<User>.from(json['employees'].map((employee) => User.fromJson(employee))),
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'employees': employees.map((e) => e.toJson()).toList(),
      'companyId': companyId,
    };
  }
}

enum Status {
  PENDING,
  IN_PROGRESS,
  COMPLETED
}
