
import '../../project/model/ConstructionStage.dart';
import 'RawMaterial.dart';

class RawMaterialUsage {
  final int? id;
  final double quantity;
  final DateTime? entryDate;
  final RawMaterial rawMaterial;
  final ConstructionStage stage;
  final int companyId;

  RawMaterialUsage({
    this.id,
    required this.quantity,
    this.entryDate,
    required this.rawMaterial,
    required this.stage,
    required this.companyId,
  });

  factory RawMaterialUsage.fromJson(Map<String, dynamic> json) {
    return RawMaterialUsage(
      id: json['id'],
      quantity: json['quantity'],
      entryDate: json['entryDate'] != null ? DateTime.parse(json['entryDate']) : null,
      rawMaterial: RawMaterial.fromJson(json['rawMaterial']),
      stage: ConstructionStage.fromJson(json['stage']),
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'entryDate': entryDate?.toIso8601String(),
      'rawMaterial': rawMaterial.toJson(),
      'stage': stage.toJson(),
      'companyId': companyId,
    };
  }
}
