import 'package:flutter/material.dart';

import '../util/APIUrls.dart';
import '../util/AlertUtil.dart';
import '../util/ApiResponse.dart';
import 'User.dart';
import 'UserService.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final _userService = UserService();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    try {
      ApiResponse response = await _userService.getAll();
      if (response.successful) {
        setState(() {
          users = List<User>.from(
              response.data['users'].map((x) => User.fromJson(x)));
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void deleteUser(int? id) async {
    if (id == null) {
      AlertUtil.exception(context, "ID not found");
      return;
    }
    try {
      ApiResponse response = await _userService.deleteById(id);
      if (response.successful) {
        loadUsers();
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
        title: Text("Users List"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/user-form');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: users.isEmpty
            ? Center(child: Text('No users found'))
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  User user = users[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: user.avatar != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(APIUrls.avatar + user.avatar!),
                            )
                          : CircleAvatar(child: Icon(Icons.person)),
                      title: Text(user.name ?? 'User'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (user.email != null) Text("Email: ${user.email}"),
                          if (user.cell != null) Text("Cell: ${user.cell}"),
                          if (user.role != null)
                            Text(
                                "Role: ${user.role.toString().split('.').last}"),
                          if (user.status != null)
                            Text("Status: ${user.status}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility, color: Colors.blue),
                            onPressed: () {
                              // Navigate to user details page
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/user-form',
                                arguments: user.id,
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deleteUser(user.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
