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

  final _projectService = ProjectService();
  final _userService = UserService();

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
      var response = await _projectService.saveProject(project);
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
                        initialValue: project.name,
                        decoration: InputDecoration(
                          labelText: 'Project Name',
                          errorText:
                              errors['name'] == '' ? null : errors['name'],
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
                        initialValue: project.location,
                        decoration: InputDecoration(
                          labelText: 'Project Location',
                          errorText: errors['location'] == ''
                              ? null
                              : errors['location'],
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
                          errorText:
                              errors['status'] == '' ? null : errors['status'],
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
                        controller: TextEditingController(
                          text: project.startDate != null
                              ? project.startDate.toString().split(' ')[0]
                              : '',
                        ),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Start Date',
                          errorText: errors['startDate'] == ''
                              ? null
                              : errors['startDate'],
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
                      SizedBox(height: 12),
                      TextFormField(
                        controller: TextEditingController(
                          text: project.endDate != null
                              ? project.endDate.toString().split(' ')[0]
                              : '',
                        ),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'End Date',
                          errorText: errors['endDate'] == ''
                              ? null
                              : errors['endDate'],
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
                      SizedBox(height: 12),
                      TextFormField(
                        initialValue: project.budget?.toString() ?? '',
                        decoration: InputDecoration(
                          labelText: 'Budget',
                          errorText:
                              errors['budget'] == '' ? null : errors['budget'],
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
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
                          labelText: 'Project Manager',
                          errorText: errors['manager'] == ''
                              ? null
                              : errors['manager'],
                        ),
                        items: users.map((user) {
                          return DropdownMenuItem<int>(
                            value: user.id,
                            child: Text(user.name ?? 'User'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            project.manager?.id = value!;
                            errors['manager'] = '';
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      MultiSelectDialogField<User>(
                        items: users
                            .map((user) => MultiSelectItem<User>(
                                user, user.name ?? 'User'))
                            .toList(),
                        title: Text('Select Team Members'),
                        buttonText: Text('Team Members'),
                        selectedItemsTextStyle: TextStyle(color: Colors.blue),
                        initialValue: project.teamMembers ?? [],
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: errors['teamMembers'] == null
                                ? Colors.grey
                                : Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onConfirm: (values) {
                          setState(() {
                            project.teamMembers = List<User>.from(values);
                            errors['teamMembers'] = '';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                'Additional Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    initialValue: project.description,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Project Description',
                      errorText: errors['description'] == ''
                          ? null
                          : errors['description'],
                    ),
                    onChanged: (value) {
                      setState(() {
                        project.description = value;
                        errors['description'] = '';
                      });
                    },
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProject,
                  child: Text(
                      project.id != null ? 'Update Project' : 'Create Project'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
