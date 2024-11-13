import 'package:crem_flutter/project/ProjectList.dart';
import 'package:crem_flutter/project/ProjectService.dart';
import 'package:crem_flutter/util/AlertUtil.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../auth/User.dart';
import '../auth/UserService.dart';
import '../util/ApiResponse.dart';
import 'model/Project.dart';

class ProjectForm extends StatefulWidget {
  @override
  _ProjectFormState createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  Map<String, String> errors = {};
  Project project = Project();
  List<User> users = [];

  final _projectService = ProjectService();
  final _userService = UserService();

  @override
  void initState() {
    super.initState();

    _loadUsers();
  }

  void _loadUsers() async {
    try {
      ApiResponse response = await _userService.getAll();
      if (response.successful) {
        setState(() {
          List<dynamic> usersList = response.data['users'] ?? [];
          users = List<User>.from(usersList.map((x) => User.fromJson(x)));
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void _saveProject() async {
    try {
      var response = await _projectService.saveProject(project);
      if (response.successful) {
        AlertUtil.success(context, response);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProjectList()),
        );
      } else {
        setState(() {
          errors = response.errors ?? {};
        });
        if (errors.isEmpty) {
          AlertUtil.error(context, response);
        }
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Project Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                initialValue: project.name,
                decoration: InputDecoration(
                  labelText: 'Project Name',
                  errorText: errors['name'],
                ),
                onSaved: (value) => project.name = value!,
                onChanged: (value) {
                  setState(() {
                    errors['name'] = '';
                  });
                },
              ),
              TextFormField(
                initialValue: project.location,
                decoration: InputDecoration(
                  labelText: 'Project Location',
                  errorText: errors['location'],
                ),
                onSaved: (value) => project.location = value!,
                onChanged: (value) {
                  setState(() {
                    errors['location'] = '';
                  });
                },
              ),
              TextFormField(
                controller: TextEditingController(
                  text: project.startDate != null ? project.startDate.toString().split(' ')[0] : '',
                ),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  errorText: errors['startDate'],
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: project.startDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      project.startDate = pickedDate;
                      errors['startDate'] = '';
                    });
                  }
                },
              ),
              TextFormField(
                controller: TextEditingController(
                  text: project.endDate != null ? project.endDate.toString().split(' ')[0] : '',
                ),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'End Date',
                  errorText: errors['endDate'],
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: project.endDate ?? DateTime.now(),
                    firstDate: project.startDate ?? DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      project.endDate = pickedDate;
                      errors['endDate'] = '';
                    });
                  }
                },
              ),
              TextFormField(
                initialValue: project.budget?.toString() ?? '',
                decoration: InputDecoration(
                  labelText: 'Budget',
                  errorText: errors['budget'],
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    project.budget = double.tryParse(value);
                  } else {
                    project.budget = null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    errors['budget'] = '';
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: project.status?.toString().split('.').last,
                decoration: InputDecoration(
                  labelText: 'Project Status',
                  errorText: errors['status'],
                ),
                items: ProjectStatus.values.map((status) {
                  return DropdownMenuItem<String>(
                    value: status.toString().split('.').last,
                    child: Text(status.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    project.status = ProjectStatus.values.firstWhere(
                            (status) => status.toString().split('.').last == value,
                        orElse: () => ProjectStatus.PLANNING
                    );
                  });
                },
              ),
              DropdownButtonFormField<int>(
                value: project.manager?.id,
                decoration: InputDecoration(
                  labelText: 'Project Manager',
                  errorText: errors['manager'],
                ),
                items: users.map((user) {
                  return DropdownMenuItem<int>(
                    value: user.id,
                    child: Text(user.name ?? 'User'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => project.manager?.id = value!),
              ),
              MultiSelectDialogField<User>(
                items: users.map((user) => MultiSelectItem<User>(user, user.name ?? 'User')).toList(),
                title: Text('Team Members'),
                selectedItemsTextStyle: TextStyle(color: Colors.blue),
                initialValue: project.teamMembers ?? [],
                onConfirm: (values) {
                  setState(() {
                    project.teamMembers = List<User>.from(values);
                  });
                },
              ),
              TextFormField(
                initialValue: project.description,
                decoration: InputDecoration(
                  labelText: 'Project Description',
                  errorText: errors['description'],
                ),
                onSaved: (value) => project.description = value!,
                onChanged: (value) {
                  setState(() {
                    errors['description'] = '';
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProject,
                child: Text(project.id != null ? 'Update Project' : 'Create Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
