import 'package:crem_flutter/account/AccountList.dart';
import 'package:crem_flutter/account/TransactionList.dart';
import 'package:crem_flutter/building/BuildingForm.dart';
import 'package:crem_flutter/building/BuildingList.dart';
import 'package:crem_flutter/floor/FloorForm.dart';
import 'package:crem_flutter/floor/FloorList.dart';
import 'package:crem_flutter/project/ProjectForm.dart';
import 'package:crem_flutter/project/ProjectList.dart';
import 'package:crem_flutter/task/TaskList.dart';
import 'package:crem_flutter/task/model/Task.dart';
import 'package:crem_flutter/customer/UnitBrowse.dart';
import 'package:crem_flutter/unit/UnitForm.dart';
import 'package:crem_flutter/unit/UnitList.dart';
import 'package:crem_flutter/unit/model/Unit.dart';
import 'package:crem_flutter/user/UserList.dart';
import 'package:crem_flutter/worker/WorkerAttendanceActivity.dart';
import 'package:crem_flutter/worker/WorkerAttendanceReport.dart';
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
                  if (user?.role == Role.ADMIN || user?.role == Role.MANAGER) ...[
                    _buildAdminManagerSections(),
                  ],
                  if (user?.role == Role.EMPLOYEE) ...[
                    _buildEmployeeSections(),
                  ],
                  if (user?.role == Role.CUSTOMER) ...[
                    _buildCustomerSections(),
                  ],
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
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12.0),
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

  Widget _buildAdminManagerSections() {
    return Column(
      children: [
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
              },
            ),
            _buildButton(
              icon: Icons.add_box,
              label: "Add Project",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectForm()),
                );
              },
            ),
          ],
        ),
        _buildSection(
          title: "Buildings",
          items: [
            _buildButton(
              icon: Icons.apartment,
              label: "Buildings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BuildingList()),
                );
              },
            ),
            _buildButton(
              icon: Icons.add_box,
              label: "Add Building",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BuildingForm()),
                );
              },
            ),
          ],
        ),
        _buildSection(
          title: "Floors",
          items: [
            _buildButton(
              icon: Icons.layers,
              label: "Floors",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FloorList()),
                );
              },
            ),
            _buildButton(
              icon: Icons.add_box,
              label: "Add Floor",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FloorForm()),
                );
              },
            ),
          ],
        ),
        _buildSection(
          title: "Units",
          items: [
            _buildButton(
              icon: Icons.home_work,
              label: "Units",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UnitList()),
                );
              },
            ),
            _buildButton(
              icon: Icons.add_box,
              label: "Add Unit",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UnitForm()),
                );
              },
            ),
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
              },
            ),
            _buildButton(
              icon: Icons.add_box,
              label: "Add User",
              onTap: () {
                // Add functionality for adding users when implemented
              },
            ),
          ],
        ),
        _buildSection(
          title: "Accounts",
          items: [
            _buildButton(
              icon: Icons.account_balance,
              label: "All A/C",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountList()),
                );
              },
            ),
            _buildButton(
              icon: Icons.money,
              label: "Transactions",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TransactionList()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildEmployeeSections() {
    return Column(
      children: [
        _buildSection(
          title: "Tasks",
          items: [
            _buildButton(
              icon: Icons.pending_actions,
              label: "Pending",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskList(status: Status.PENDING)),
                );
              },
            ),
            _buildButton(
              icon: Icons.pending_actions,
              label: "In Progress",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskList(status: Status.IN_PROGRESS)),
                );
              },
            ),
            _buildButton(
              icon: Icons.task_rounded,
              label: "Completed",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskList(status: Status.COMPLETED)),
                );
              },
            ),
          ],
        ),
        _buildSection(
          title: "Worker Attendance",
          items: [
            _buildButton(
              icon: Icons.checklist,
              label: "Take",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkerAttendanceActivity()),
                );
              },
            ),
            _buildButton(
              icon: Icons.document_scanner_sharp,
              label: "View",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkerAttendanceReport()),
                );
              },
            ),
          ],
        ),
        _buildSection(
          title: "Buildings",
          items: [
            _buildButton(
              icon: Icons.apartment,
              label: "Buildings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BuildingList()),
                );
              },
            ),
          ],
        ),
        _buildSection(
          title: "Floors",
          items: [
            _buildButton(
              icon: Icons.layers,
              label: "Floors",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FloorList()),
                );
              },
            ),
          ],
        ),
        _buildSection(
          title: "Units",
          items: [
            _buildButton(
              icon: Icons.home_work,
              label: "Units",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UnitList()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomerSections() {
    return Column(
      children: [
        _buildSection(
          title: "Units",
          items: [
            _buildButton(
              icon: Icons.home,
              label: "Available",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnitBrowse(unitStatus: UnitStatus.AVAILABLE), // Pass the status here
                  ),
                );
              },
            ),
            _buildButton(
              icon: Icons.book,
              label: "Booked",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnitBrowse(unitStatus: UnitStatus.RESERVED), // Pass the status here
                  ),
                );
              },
            ),
          ],
        ),
      ],
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

