
import 'Floor.dart';

class Unit {
  final int? id;
  final String name;
  final int? size;
  final double? price;
  final UnitType? type;
  final UnitStatus? status;
  final Floor floor;
  final int companyId;

  Unit({
    this.id,
    required this.name,
    this.size,
    this.price,
    this.type,
    this.status,
    required this.floor,
    required this.companyId,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      name: json['name'],
      size: json['size'],
      price: (json['price'] != null) ? json['price'].toDouble() : null,
      type: json['type'] != null
          ? UnitType.values
          .firstWhere((e) => e.toString() == 'UnitType.${json['type']}')
          : null,
      status: json['status'] != null
          ? UnitStatus.values
          .firstWhere((e) => e.toString() == 'UnitStatus.${json['status']}')
          : null,
      floor: Floor.fromJson(json['floor']),
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'price': price,
      'type': type?.toString().split('.').last,
      'status': status?.toString().split('.').last,
      'floor': floor.toJson(),
      'companyId': companyId,
    };
  }
}

enum UnitType {
  APARTMENT,
  OFFICE,
  SHOP,
  OTHER,
}

enum UnitStatus {
  AVAILABLE,
  SOLD,
  RESERVED,
}
