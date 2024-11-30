import 'package:flutter/material.dart';
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
import 'layout/MainLayout.dart';

class HomeActivity extends StatefulWidget {
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  User? user;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      title: 'Dashboard',
      child: user != null
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 24),
            if (user?.role == Role.ADMIN || user?.role == Role.MANAGER)
              _buildAdminDashboard()
            else if (user?.role == Role.EMPLOYEE)
              _buildEmployeeDashboard()
            else if (user?.role == Role.CUSTOMER)
                _buildCustomerDashboard(),
          ],
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: Text(
                        user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back,",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            user?.name ?? 'User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user?.role?.toString().split('.').last ?? 'Unknown Role',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color ?? Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: Colors.blue.shade800),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }

  Widget _buildAdminDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Project Management'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          childAspectRatio: 1.3,
          children: [
            _buildMenuItem(
              title: 'Projects',
              icon: Icons.business,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProjectList()),
              ),
            ),
            _buildMenuItem(
              title: 'Buildings',
              icon: Icons.apartment,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BuildingList()),
              ),
            ),
            _buildMenuItem(
              title: 'Floors',
              icon: Icons.layers,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FloorList()),
              ),
            ),
            _buildMenuItem(
              title: 'Units',
              icon: Icons.home_work,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UnitList()),
              ),
            ),
          ],
        ),
        _buildSectionTitle('Administration'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          childAspectRatio: 1.3,
          children: [
            _buildMenuItem(
              title: 'Users',
              icon: Icons.people,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserList()),
              ),
            ),
            _buildMenuItem(
              title: 'Accounts',
              icon: Icons.account_balance,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountList()),
              ),
            ),
            _buildMenuItem(
              title: 'Transactions',
              icon: Icons.receipt_long,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransactionList()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmployeeDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Tasks'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          childAspectRatio: 1.3,
          children: [
            _buildMenuItem(
              title: 'Pending Tasks',
              icon: Icons.pending_actions,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskList(status: Status.PENDING),
                ),
              ),
            ),
            _buildMenuItem(
              title: 'In Progress',
              icon: Icons.work,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskList(status: Status.IN_PROGRESS),
                ),
              ),
            ),
            _buildMenuItem(
              title: 'Completed',
              icon: Icons.task_alt,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskList(status: Status.COMPLETED),
                ),
              ),
            ),
          ],
        ),
        _buildSectionTitle('Worker Management'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          childAspectRatio: 1.3,
          children: [
            _buildMenuItem(
              title: 'Take Attendance',
              icon: Icons.how_to_reg,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkerAttendanceActivity(),
                ),
              ),
            ),
            _buildMenuItem(
              title: 'View Report',
              icon: Icons.assessment,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkerAttendanceReport(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomerDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Property Browse'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          childAspectRatio: 1.3,
          children: [
            _buildMenuItem(
              title: 'Available Units',
              icon: Icons.home,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UnitBrowse(unitStatus: UnitStatus.AVAILABLE),
                ),
              ),
            ),
            _buildMenuItem(
              title: 'My Bookings',
              icon: Icons.bookmark,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UnitBrowse(unitStatus: UnitStatus.RESERVED),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}