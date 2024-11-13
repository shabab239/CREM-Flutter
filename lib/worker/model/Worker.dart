

class Worker {
  int? id;
  String? name;
  double? salary;
  String? cell;
  String? gender;
  String? address;
  String? avatar;
  DateTime? joiningDate;
  String? bloodGroup;

  Worker({
    this.id,
    this.name,
    this.salary,
    this.cell,
    this.gender,
    this.address,
    this.avatar,
    this.joiningDate,
    this.bloodGroup,
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
    };
  }
}
