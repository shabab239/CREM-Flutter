import 'package:flutter/material.dart';
import 'package:crem_flutter/util/AlertUtil.dart';
import 'package:crem_flutter/util/ApiResponse.dart';
import 'TaskService.dart';
import 'model/Task.dart';

class TaskList extends StatefulWidget {
  final Status status;

  TaskList({required this.status});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final _taskService = TaskService();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    try {
      ApiResponse response = await _taskService.getAllTasksByStatus(widget.status);
      if (response.successful) {
        setState(() {
          tasks = List<Task>.from(
              response.data['tasks'].map((x) => Task.fromJson(x)));
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void updateTaskStatus(Task task, Status newStatus) async {
    try {
      ApiResponse response =
      await _taskService.changeTaskStatus(task.id!, newStatus);
      if (response.successful) {
        AlertUtil.success(context, response);
        loadTasks();
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void viewTaskDetails(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Task Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${task.description ?? 'N/A'}"),
            Text("Start Date: ${task.startDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}"),
            Text("End Date: ${task.endDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}"),
            Text("Status: ${task.status.toString().split('.').last}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.status.toString().split('.').last} Tasks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  Task task = tasks[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        task.description ?? "Task",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                          "Start: ${task.startDate?.toLocal().toString().split(' ')[0] ?? 'N/A'} | End: ${task.endDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility),
                            color: Colors.blue,
                            onPressed: () => viewTaskDetails(task),
                          ),
                          PopupMenuButton<Status>(
                            onSelected: (Status newStatus) {
                              updateTaskStatus(task, newStatus);
                            },
                            itemBuilder: (context) => Status.values
                                .where((status) => status != task.status)
                                .map((status) {
                              return PopupMenuItem<Status>(
                                value: status,
                                child: Text(status.toString().split('.').last),
                              );
                            }).toList(),
                            icon: Icon(Icons.edit, color: Colors.orange),
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
