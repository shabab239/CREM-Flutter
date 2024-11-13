

class Task {
  int? id;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  Status? status;

  Task({
    this.id,
    this.description,
    this.startDate,
    this.endDate,
    this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: Status.values.firstWhere((e) => e.toString() == 'Status.' + json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }
}

enum Status {
  PENDING,
  IN_PROGRESS,
  COMPLETED
}
