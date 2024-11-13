import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerAttendanceActivity extends StatefulWidget {
  @override
  _WorkerAttendanceActivityState createState() => _WorkerAttendanceActivityState();
}

class _WorkerAttendanceActivityState extends State<WorkerAttendanceActivity> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> workers = [];
  final int totalWorkers = 5;

  @override
  void initState() {
    super.initState();
    _generateWorkers();
    _loadAttendance(selectedDate);
  }

  void _generateWorkers() {
    workers = List.generate(totalWorkers, (index) {
      return {
        'id': index + 1,
        'name': 'Worker ${String.fromCharCode(65 + index)}',
        'cell': '012345678${index + 1}',
        'gender': index % 2 == 0 ? 'Male' : 'Female',
        'status': 'ABSENT', // Default status
      };
    });
  }

  Future<void> _saveAttendance(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _getDateKey(date);
    String data = jsonEncode(workers);
    await prefs.setString(key, data);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Attendance saved for ${_formatDate(date)}')),
    );
  }

  Future<void> _loadAttendance(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _getDateKey(date);
    String? data = prefs.getString(key);

    if (data != null) {
      List<dynamic> loadedWorkers = jsonDecode(data);
      setState(() {
        workers = loadedWorkers.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    } else {
      _generateWorkers(); // Reset workers if no data found
    }
  }

  String _getDateKey(DateTime date) {
    return 'attendance_${date.year}_${date.month}_${date.day}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _updateAttendance(int id, String status) {
    setState(() {
      workers = workers.map((worker) {
        if (worker['id'] == id) {
          worker['status'] = status;
        }
        return worker;
      }).toList();
    });
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
      _loadAttendance(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Attendance'),
      ),
      body: Column(
        children: [
          // Date Picker
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Date: ${_formatDate(selectedDate)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text('Select Date'),
                ),
              ],
            ),
          ),
          // Worker Attendance List
          Expanded(
            child: ListView.builder(
              itemCount: workers.length,
              itemBuilder: (context, index) {
                final worker = workers[index];
                return ListTile(
                  title: Text(worker['name']),
                  subtitle: Text('Cell: ${worker['cell']} | Gender: ${worker['gender']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _updateAttendance(worker['id'], 'PRESENT'),
                        icon: const Icon(Icons.check),
                        color: worker['status'] == 'PRESENT' ? Colors.green : Colors.grey,
                      ),
                      IconButton(
                        onPressed: () => _updateAttendance(worker['id'], 'ABSENT'),
                        icon: const Icon(Icons.close),
                        color: worker['status'] == 'ABSENT' ? Colors.red : Colors.grey,
                      ),
                      IconButton(
                        onPressed: () => _updateAttendance(worker['id'], 'ON_LEAVE'),
                        icon: const Icon(Icons.airline_seat_flat),
                        color: worker['status'] == 'ON_LEAVE' ? Colors.blue : Colors.grey,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Save Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _saveAttendance(selectedDate),
              child: const Text('Save Attendance'),
            ),
          ),
        ],
      ),
    );
  }
}
