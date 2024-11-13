

import 'RawMaterial.dart';

class RawMaterialStock {
  final int? id;
  final double quantity;
  final DateTime lastUpdated;
  final RawMaterial rawMaterial;
  final int companyId;

  RawMaterialStock({
    this.id,
    required this.quantity,
    required this.lastUpdated,
    required this.rawMaterial,
    required this.companyId,
  });

  factory RawMaterialStock.fromJson(Map<String, dynamic> json) {
    return RawMaterialStock(
      id: json['id'],
      quantity: json['quantity'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      rawMaterial: RawMaterial.fromJson(json['rawMaterial']),
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'lastUpdated': lastUpdated.toIso8601String(),
      'rawMaterial': rawMaterial.toJson(),
      'companyId': companyId,
    };
  }
}
