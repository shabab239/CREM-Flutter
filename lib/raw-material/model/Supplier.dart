

class Supplier {
  final int? id;
  final String name;
  final int companyId;

  Supplier({
    this.id,
    required this.name,
    required this.companyId,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      name: json['name'],
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'companyId': companyId,
    };
  }
}
