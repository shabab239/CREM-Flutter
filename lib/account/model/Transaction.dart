
import 'Account.dart';


class Transaction {
  final int? id;
  final DateTime date;
  final double amount;
  final TransactionType type;
  final String groupTransactionId;
  final String particular;
  final Account account;
  final int companyId;

  Transaction({
    this.id,
    required this.date,
    required this.amount,
    required this.type,
    required this.groupTransactionId,
    required this.particular,
    required this.account,
    required this.companyId,
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
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'type': type.toString().split('.').last,
      'groupTransactionId': groupTransactionId,
      'particular': particular,
      'account': account.toJson(),
      'companyId': companyId,
    };
  }
}

// Enum for Transaction Type
enum TransactionType { INCOME, EXPENSE }
