import '../../auth/Company.dart';
import '../../raw-material/model/Supplier.dart';
import '../../user/User.dart';
import '../../worker/model/Worker.dart';
import 'Transaction.dart';

class Account {
  int? id;
  String? name;
  double? balance;
  User? user;
  Supplier? supplier;
  Worker? worker;
  Company? company;
  List<Transaction>? transactions;

  Account({
    this.id,
    this.name,
    this.balance,
    this.user,
    this.supplier,
    this.worker,
    this.company,
    this.transactions,
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
      company:
          json['company'] != null ? Company.fromJson(json['company']) : null,
      transactions: json['transactions'] != null
          ? (json['transactions'] as List)
              .map((e) => Transaction.fromJson(e))
              .toList()
          : [],
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
    };
  }
}
