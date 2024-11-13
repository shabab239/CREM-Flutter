
import 'RawMaterial.dart';
import 'Supplier.dart';

class RawMaterialOrder {
  final int? id;
  final double quantity;
  final double unitPrice;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final double totalPrice;
  final RawMaterialOrderStatus status;
  final String? groupTransactionId;
  final RawMaterial rawMaterial;
  final Supplier supplier;
  final int companyId;

  RawMaterialOrder({
    this.id,
    required this.quantity,
    required this.unitPrice,
    required this.orderDate,
    this.deliveryDate,
    required this.totalPrice,
    required this.status,
    this.groupTransactionId,
    required this.rawMaterial,
    required this.supplier,
    required this.companyId,
  });

  factory RawMaterialOrder.fromJson(Map<String, dynamic> json) {
    return RawMaterialOrder(
      id: json['id'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'],
      orderDate: DateTime.parse(json['orderDate']),
      deliveryDate: json['deliveryDate'] != null ? DateTime.parse(json['deliveryDate']) : null,
      totalPrice: json['totalPrice'],
      status: RawMaterialOrderStatus.values.byName(json['status']),
      groupTransactionId: json['groupTransactionId'],
      rawMaterial: RawMaterial.fromJson(json['rawMaterial']),
      supplier: Supplier.fromJson(json['supplier']),
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'totalPrice': totalPrice,
      'status': status.name,
      'groupTransactionId': groupTransactionId,
      'rawMaterial': rawMaterial.toJson(),
      'supplier': supplier.toJson(),
      'companyId': companyId,
    };
  }
}

enum RawMaterialOrderStatus { PENDING, DELIVERED, CANCELLED }
