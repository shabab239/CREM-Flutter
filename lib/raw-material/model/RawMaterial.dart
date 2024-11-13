

class RawMaterial {
  final int? id;
  final String name;
  final int companyId;

  RawMaterial({
    this.id,
    required this.name,
    required this.companyId,
  });

  factory RawMaterial.fromJson(Map<String, dynamic> json) {
    return RawMaterial(
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
