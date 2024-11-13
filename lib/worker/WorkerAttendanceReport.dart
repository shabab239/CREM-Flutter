import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

class WorkerAttendanceReport extends StatefulWidget {
  @override
  _WorkerAttendanceReportState createState() => _WorkerAttendanceReportState();
}

class _WorkerAttendanceReportState extends State<WorkerAttendanceReport> {
  DateTime? selectedDate;
  List<Map<String, dynamic>> workers = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadAttendance(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _getDateKey(date);
    String? data = prefs.getString(key);

    if (data != null) {
      List<dynamic> loadedWorkers = jsonDecode(data);
      setState(() {
        workers =
            loadedWorkers.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No attendance data available for this date.")),
      );
    }
  }

  String _getDateKey(DateTime date) {
    return 'attendance_${date.year}_${date.month}_${date.day}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  Future<void> _downloadPDF() async {
    if (selectedDate == null || workers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Select a date and ensure data is available.")),
      );
      return;
    }

    final pdf = pw.Document();
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final date = selectedDate != null
        ? dateFormatter.format(selectedDate!)
        : 'No Date Selected';

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Worker Attendance Report - $date',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                headers: ['Name', 'Status'],
                data: workers
                    .map((entry) => [entry['name'], entry['status']])
                    .toList(),
              ),
            ],
          );
        },
      ),
    );

    final output = await getExternalStorageDirectory();
    final filePath =
        '${output!.path}/attendance_report_${DateFormat('yyyyMMdd').format(selectedDate!)}.pdf';
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
        title: Text("Worker Attendance Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? "Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}"
                      : "Select a Date",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: Text("Pick Date"),
                ),
              ],
            ),
            SizedBox(height: 20),
            workers.isNotEmpty
                ? Expanded(
                    child: ListView(
                      children: [
                        DataTable(
                          columns: const [
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("Status")),
                          ],
                          rows: workers
                              .map(
                                (entry) => DataRow(
                                  cells: [
                                    DataCell(Text(entry['name'])),
                                    DataCell(Text(entry['status'])),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      "No data available. Please select a date.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _downloadPDF,
              icon: Icon(Icons.download),
              label: Text("Download Report"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
