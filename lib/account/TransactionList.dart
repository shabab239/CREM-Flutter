import 'package:crem_flutter/account/TransactionService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../util/AlertUtil.dart';
import 'model/Transaction.dart';

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  DateTimeRange? _selectedDateRange;
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  List<Transaction> transactions = [];

  final _transactionService = TransactionService(); // Assuming ApiService is properly set up

  @override
  void initState() {
    super.initState();
    _fetchTransactionData(); // Fetch initial data on page load
  }

  // Fetch total income, total expense, and transactions within selected date range
  Future<void> _fetchTransactionData() async {
    try {
      // Get total income
      final incomeResponse = await _transactionService.getTotalIncome();
      if (incomeResponse.successful) {
        setState(() {
          totalIncome = incomeResponse.data['totalIncome'] ?? 0.0;
        });
      } else {
        // Show failure message using AlertUtil
        AlertUtil.error(context, incomeResponse);
      }

      // Get total expense
      final expenseResponse = await _transactionService.getTotalExpense();
      if (expenseResponse.successful) {
        setState(() {
          totalExpense = expenseResponse.data['totalExpense'] ?? 0.0;
        });
      } else {
        // Show failure message using AlertUtil
        AlertUtil.error(context, expenseResponse);
      }

      // If date range is selected, fetch transactions for the range
      if (_selectedDateRange != null) {
        final transactionsResponse = await _transactionService.getTransactionsByDateRange(
          _selectedDateRange!.start,
          _selectedDateRange!.end,
        );
        if (transactionsResponse.successful) {
          setState(() {
            transactions = (transactionsResponse.data['transactions'] as List)
                .map((item) => Transaction.fromJson(item))
                .toList();
          });
        } else {
          // Show failure message using AlertUtil
          AlertUtil.error(context, transactionsResponse);
        }
      }
    } catch (error) {
      // Handle unexpected errors
      AlertUtil.exception(context, error);
    }
  }

  // Show date range picker and fetch data for the selected range
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
      _fetchTransactionData(); // Fetch data based on selected range
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transactions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Picker Button
            ElevatedButton(
              onPressed: _selectDateRange,
              child: Text(
                _selectedDateRange == null
                    ? 'Select Date Range'
                    : 'From: ${DateFormat.yMd().format(_selectedDateRange!.start)} - To: ${DateFormat.yMd().format(_selectedDateRange!.end)}',
              ),
            ),

            // Income vs Expense Display
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Total Income: \$${totalIncome.toStringAsFixed(2)}', style: TextStyle(color: Colors.green),),
                    Text('Total Expense: \$${totalExpense.toStringAsFixed(2)}', style: TextStyle(color: Colors.red),),
                  ],
                ),
              ),
            ),
            // Transaction List
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];

                  // Get the account name and transaction type as readable strings
                  final accountName = transaction.account?.name ?? 'No Account';
                  final transactionType = transaction.type == TransactionType.INCOME ? 'Income' : 'Expense';

                  // Define colors for income and expense
                  final transactionColor = transaction.type == TransactionType.INCOME
                      ? Colors.green
                      : Colors.red;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(transaction.particular ?? 'No Particular'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${DateFormat.yMd().format(transaction.date!)}'),
                          Text('Account: $accountName'),
                          Text(
                            'Type: $transactionType',
                            style: TextStyle(color: transactionColor),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '\$${transaction.amount!.toStringAsFixed(2)}',
                        style: TextStyle(color: transactionColor),
                      ),
                    ),
                  );
                },
              ),
            ),


          ],
        ),
      ),
    );
  }
}
