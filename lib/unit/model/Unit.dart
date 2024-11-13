
import '../../floor/model/Floor.dart';

class Unit {
  int? id;
  String name;
  int? size;
  double? price;
  UnitType? type;
  UnitStatus? status;
  Floor? floor;
  String? image;

  Unit({
    this.id,
    required this.name,
    this.size,
    this.price,
    this.type,
    this.status,
    this.floor,
    this.image,
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
      image: json['image'],
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
      'floor': floor?.toJson(),
      'image': image,
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
