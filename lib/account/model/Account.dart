

import '../../auth/Company.dart';
import '../../auth/User.dart';
import '../../raw-material/model/Supplier.dart';
import '../../worker/model/Worker.dart';
import 'Transaction.dart';

class Account {
  final int? id;
  final String name;
  final double balance;
  final User? user;
  final Supplier? supplier;
  final Worker? worker;
  final Company? company;
  final List<Transaction>? transactions;
  final int companyId;

  Account({
    this.id,
    required this.name,
    required this.balance,
    this.user,
    this.supplier,
    this.worker,
    this.company,
    this.transactions,
    required this.companyId,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      balance: json['balance']?.toDouble() ?? 0.0,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      supplier:
      json['supplier'] != null ? Supplier.fromJson(json['supplier']) : null,
      worker: json['worker'] != null ? Worker.fromJson(json['worker']) : null,
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
      transactions: json['transactions'] != null
          ? (json['transactions'] as List)
          .map((e) => Transaction.fromJson(e))
          .toList()
          : [],
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'user': user?.toJson(),
      'supplier': supplier?.toJson(),
      'worker': worker?.toJson(),
      'company': company?.toJson(),
      'transactions': transactions?.map((e) => e.toJson()).toList(),
      'companyId': companyId,
    };
  }
}
