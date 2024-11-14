import 'package:flutter/material.dart';
import 'package:crem_flutter/util/AlertUtil.dart';
import 'package:crem_flutter/util/ApiResponse.dart';
import 'AccountDetails.dart';
import 'AccountService.dart';
import 'model/Account.dart';

class AccountList extends StatefulWidget {
  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> with WidgetsBindingObserver {
  final _accountService = AccountService();
  List<Account> accounts = [];

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadAccounts();
    }
  }

  // Load all accounts
  void loadAccounts() async {
    try {
      ApiResponse response = await _accountService.getAllAccounts();
      if (response.successful) {
        setState(() {
          accounts = List<Account>.from(response.data['accounts'].map((x) => Account.fromJson(x)));
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  // Delete account by ID
  void deleteAccount(int? id) async {
    if (id == null) {
      AlertUtil.exception(context, "ID not found");
      return;
    }
    try {
      ApiResponse response = await _accountService.deleteAccountById(id);
      if (response.successful) {
        loadAccounts();
        AlertUtil.success(context, response);
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accounts List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  Account account = accounts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(account.name ?? 'Account'),
                      subtitle: Text(
                        'Balance: \$${account.balance} | Company: ${account.company?.name ?? "N/A"}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility),
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccountDetails(
                                    accountId: account.id!,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
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
