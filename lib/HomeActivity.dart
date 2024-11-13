import 'package:crem_flutter/project/ProjectForm.dart';
import 'package:crem_flutter/project/ProjectList.dart';
import 'package:crem_flutter/user/UserList.dart';
import 'package:flutter/material.dart';

import 'auth/AuthService.dart';
import 'user/User.dart';
import 'layout/MainLayout.dart'; // Import the MainLayout

class HomeActivity extends StatefulWidget {
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  User? user;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    user = await AuthService.getStoredUser();
    if (user == null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Home',
      child: user != null
          ? Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildHeader(),
                        _buildSection(
                          title: "Projects",
                          items: [
                            _buildButton(
                                icon: Icons.business,
                                label: "Projects",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ProjectList()),
                                  );
                                }),
                            _buildButton(
                                icon: Icons.add_box,
                                label: "Add Project",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ProjectForm()),
                                  );
                                }),
                          ],
                        ),
                        _buildSection(
                          title: "Buildings",
                          items: [
                            _buildButton(
                                icon: Icons.apartment,
                                label: "Buildings",
                                onTap: () {}),
                            _buildButton(
                                icon: Icons.add_box,
                                label: "Add Building",
                                onTap: () {}),
                          ],
                        ),
                        _buildSection(
                          title: "Floors",
                          items: [
                            _buildButton(
                                icon: Icons.layers,
                                label: "Floors",
                                onTap: () {}),
                            _buildButton(
                                icon: Icons.add_box,
                                label: "Add Floor",
                                onTap: () {}),
                          ],
                        ),
                        _buildSection(
                          title: "Units",
                          items: [
                            _buildButton(
                                icon: Icons.home_work,
                                label: "Units",
                                onTap: () {}),
                            _buildButton(
                                icon: Icons.add_box,
                                label: "Add Unit",
                                onTap: () {}),
                          ],
                        ),
                        _buildSection(
                          title: "Users",
                          items: [
                            _buildButton(
                                icon: Icons.supervised_user_circle,
                                label: "Users",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => UserList()),
                                  );
                                }),
                            _buildButton(
                                icon: Icons.add_box,
                                label: "Add User",
                                onTap: () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12.0), // Matches Card shape
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Welcome, ${user?.name ?? 'Guest'}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "${user?.role?.toString().split('.').last ?? 'Unknown Role'}",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
