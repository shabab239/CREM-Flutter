
import 'Account.dart';


class Transaction {
  int? id;
  DateTime? date;
  double? amount;
  TransactionType? type;
  String? groupTransactionId;
  String? particular;
  Account? account;

  Transaction({
    this.id,
    this.date,
    this.amount,
    this.type,
    this.groupTransactionId,
    this.particular,
    this.account,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      date: DateTime.parse(json['date']),
      amount: json['amount'].toDouble(),
      type: TransactionType.values
          .firstWhere((e) => e.toString() == 'TransactionType.' + json['type']),
      groupTransactionId: json['groupTransactionId'],
      particular: json['particular'],
      account: Account.fromJson(json['account']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'amount': amount,
      'type': type.toString().split('.').last,
      'groupTransactionId': groupTransactionId,
      'particular': particular,
      'account': account?.toJson(),
    };
  }
}

// Enum for Transaction Type
enum TransactionType { INCOME, EXPENSE }
