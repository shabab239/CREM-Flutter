import 'dart:io';
import 'package:flutter/material.dart';
import 'package:crem_flutter/util/AlertUtil.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:crem_flutter/account/TransactionService.dart';
import 'package:path_provider/path_provider.dart';

import '../util/ApiResponse.dart';
import 'model/Account.dart';
import 'model/Transaction.dart';

class AccountDetails extends StatefulWidget {
  final int accountId;

  AccountDetails({required this.accountId});

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  late Account account = Account();
  List<Transaction> transactions = [];
  bool isLoading = true;

  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    loadAccountDetails();
  }

  Future<void> loadAccountDetails() async {
    try {
      ApiResponse response = await _transactionService.getTransactionsByAccount(widget.accountId);
      if (response.successful) {
        setState(() {
          account = Account.fromJson(response.data['account']);
          transactions = List<Transaction>.from(
              response.data['transactions'].map((x) => Transaction.fromJson(x))
          );
          isLoading = false;
        });
      } else {
        AlertUtil.error(context, response);
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      AlertUtil.exception(context, error);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _downloadPDF() async {
    final pdf = pw.Document();
    final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Account Details - $formattedDate',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Account ID: ${account.id ?? "N/A"}'),
              pw.Text('Account Name: ${account.name ?? "N/A"}'),
              pw.Text('Account Balance: \$${account.balance ?? 0.0}'),
              pw.SizedBox(height: 20),
              pw.Text('Transactions:',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                context: context,
                headers: ['Date', 'Amount', 'Type', 'Particular'],
                data: transactions
                    .map((transaction) => [
                  DateFormat('yyyy-MM-dd').format(transaction.date!),
                  '\$${transaction.amount}',
                  transaction.type.toString().split('.').last,
                  transaction.particular ?? 'N/A'
                ])
                    .toList(),
              ),
            ],
          );
        },
      ),
    );

    final output = await getExternalStorageDirectory();
    final filePath = '${output!.path}/account_report_${account.id}.pdf';
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Report saved to $filePath")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Details Card
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account ID: ${account.id}',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Account Name: ${account.name ?? "N/A"}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Account Balance: \$${account.balance ?? 0.0}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Transactions Card
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction Details:',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        if (transactions.isNotEmpty)
                          Column(
                            children: transactions.map((transaction) =>
                                ListTile(
                                  title: Text('${transaction.type.toString().split('.').last}: \$${transaction.amount}'),
                                  subtitle: Text('Date: ${DateFormat('yyyy-MM-dd').format(transaction.date!)}'),
                                )).toList(),
                          )
                        else
                          Text('No transactions yet.',
                              style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
              // Download PDF Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: _downloadPDF,
                  child: Text('Download PDF'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
