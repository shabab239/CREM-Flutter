import 'package:crem_flutter/project/ProjectList.dart';
import 'package:crem_flutter/project/ProjectService.dart';
import 'package:crem_flutter/util/AlertUtil.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../user/User.dart';
import '../user/UserService.dart';
import '../util/ApiResponse.dart';
import 'model/Project.dart';

class ProjectForm extends StatefulWidget {
  var projectId;

  ProjectForm({super.key, this.projectId});

  @override
  _ProjectFormState createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  Map<String, String> errors = {};
  Project project = Project();
  List<User> users = [];
  List<User> selectedTeamMembers = [];

  final _projectService = ProjectService();
  final _userService = UserService();

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _budgetController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
    if (widget.projectId != null) {
      _loadProject(widget.projectId);
    }
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

  void _loadProject(int projectId) async {
    try {
      ApiResponse response = await _projectService.getProjectById(projectId);
      if (response.successful) {
        setState(() {
          dynamic project = response.data['project'];
          if (project != null) {
            this.project = Project.fromJson(project);

            _nameController.text = project['name'] ?? '';
            _locationController.text = project['location'] ?? '';
            _startDateController.text = project['startDate']?.toString().split(' ')[0] ?? '';
            _endDateController.text = project['endDate']?.toString().split(' ')[0] ?? '';
            _budgetController.text = project['budget']?.toString() ?? '';
            _descriptionController.text = project['description'] ?? '';

            selectedTeamMembers = (project['teamMembers'] as List)
                .map((teamMember) => User.fromJson(teamMember))
                .toList();
          }
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
      project.teamMembers = selectedTeamMembers;

      var response;
      if (widget.projectId != null) {
        response = await _projectService.updateProject(project);
      } else {
        response = await _projectService.saveProject(project);
      }
      if (response.successful) {
        AlertUtil.success(context, response);
        Navigator.pop(context);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Project Name',
                          errorText: errors['name'] == '' ? null : errors['name'],
                        ),
                        onChanged: (value) {
                          setState(() {
                            project.name = value;
                            errors['name'] = '';
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Project Location',
                          errorText: errors['location'] == '' ? null : errors['location'],
                        ),
                        onChanged: (value) {
                          setState(() {
                            project.location = value;
                            errors['location'] = '';
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: project.status?.toString().split('.').last,
                        decoration: InputDecoration(
                          labelText: 'Project Status',
                          errorText: errors['status'] == '' ? null : errors['status'],
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
                                    (status) =>
                                status.toString().split('.').last == value,
                                orElse: () => ProjectStatus.PLANNING);
                            errors['status'] = '';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                'Project Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _startDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Start Date',
                          errorText: errors['startDate'] == '' ? null : errors['startDate'],
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
                              _startDateController.text = pickedDate.toString().split(' ')[0];
                              errors['startDate'] = '';
                            });
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _endDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'End Date',
                          errorText: errors['endDate'] == '' ? null : errors['endDate'],
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
                              _endDateController.text = pickedDate.toString().split(' ')[0];
                              errors['endDate'] = '';
                            });
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _budgetController,
                        decoration: InputDecoration(
                          labelText: 'Budget',
                          errorText: errors['budget'] == '' ? null : errors['budget'],
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              project.budget = double.tryParse(value);
                            } else {
                              project.budget = null;
                            }
                            errors['budget'] = '';
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: project.manager?.id,
                        decoration: InputDecoration(
                          labelText: 'Manager',
                          errorText: errors['manager'] == '' ? null : errors['manager'],
                        ),
                        items: users.map((user) {
                          return DropdownMenuItem<int>(
                            value: user.id,
                            child: Text(user.name ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            project.manager = users.firstWhere(
                                    (user) => user.id == value,
                                orElse: () => User());
                            errors['manager'] = '';
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      MultiSelectDialogField(
                        items: users.map((user) => MultiSelectItem<User>(user, user.name!)).toList(),
                        initialValue: selectedTeamMembers,
                        title: Text("Select"),
                        buttonText: Text("Select Team Members"),
                        selectedColor: Colors.blue,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                        onConfirm: (values) {
                          setState(() {
                            selectedTeamMembers = values;
                          });
                        },
                      )

                    ],
                  ),
                ),
              ),
              Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          errorText: errors['description'] == '' ? null : errors['description'],
                        ),
                        onChanged: (value) {
                          setState(() {
                            project.description = value;
                            errors['description'] = '';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _saveProject,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
