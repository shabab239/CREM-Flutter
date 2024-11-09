class Company {
  final int id;
  final String name;
  final String contact;
  final String address;

  Company({
    required this.id,
    required this.name,
    required this.contact,
    required this.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      contact: json['contact'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'address': address,
    };
  }
}
