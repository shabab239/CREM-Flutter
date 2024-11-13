

class Worker {
  final int? id;
  final String name;
  final double salary;
  final String? cell;
  final String? gender;
  final String? address;
  final String? avatar;
  final DateTime? joiningDate;
  final String? bloodGroup;
  final int companyId;

  Worker({
    this.id,
    required this.name,
    required this.salary,
    this.cell,
    this.gender,
    this.address,
    this.avatar,
    this.joiningDate,
    this.bloodGroup,
    required this.companyId,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'],
      name: json['name'],
      salary: json['salary'],
      cell: json['cell'],
      gender: json['gender'],
      address: json['address'],
      avatar: json['avatar'],
      joiningDate: json['joiningDate'] != null
          ? DateTime.parse(json['joiningDate'])
          : null,
      bloodGroup: json['bloodGroup'],
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'salary': salary,
      'cell': cell,
      'gender': gender,
      'address': address,
      'avatar': avatar,
      'joiningDate': joiningDate?.toIso8601String(),
      'bloodGroup': bloodGroup,
      'companyId': companyId,
    };
  }
}
