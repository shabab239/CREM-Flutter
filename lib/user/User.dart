import '../auth/Company.dart';

class User {
  int? id;
  String? name;
  String? cell;
  String? email;
  String? gender;
  String? address;
  String? avatar;
  DateTime? dateOfBirth;
  DateTime? joiningDate;
  String? bloodGroup;
  String? status;
  Role? role;
  Company? company;

  User({
    this.id,
    this.name,
    this.cell,
    this.email,
    this.gender,
    this.address,
    this.avatar,
    this.dateOfBirth,
    this.joiningDate,
    this.bloodGroup,
    this.status,
    this.role,
    this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      cell: json['cell'],
      email: json['email'],
      gender: json['gender'],
      address: json['address'],
      avatar: json['avatar'],
      dateOfBirth: json['dateOfBirth'] == null ? null : DateTime.parse(json['dateOfBirth']),
      joiningDate: json['joiningDate'] == null ? null : DateTime.parse(json['joiningDate']),
      bloodGroup: json['bloodGroup'],
      status: json['status'],
      role: _parseRole(json['role']),
      company: Company.fromJson(json['company']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cell': cell,
      'email': email,
      'gender': gender,
      'address': address,
      'avatar': avatar,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'joiningDate': joiningDate?.toIso8601String(),
      'bloodGroup': bloodGroup,
      'status': status,
      'role': role?.index,
      'company': company?.toJson(),
    };
  }
}

Role _parseRole(String role) {
  return Role.values.firstWhere(
        (e) => e.toString().split('.').last == role, // Compare the string part of the enum name
    orElse: () => Role.EMPLOYEE, // Default role if the string doesn't match any enum value
  );
}

enum Role {
  ADMIN,
  MANAGER,
  EMPLOYEE,
  CUSTOMER,
  OWNER,
}
