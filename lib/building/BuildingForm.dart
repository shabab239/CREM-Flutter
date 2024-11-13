import 'package:flutter/material.dart';

import '../project/ProjectService.dart';
import '../project/model/Project.dart';
import '../util/AlertUtil.dart';
import '../util/ApiResponse.dart';
import 'model/Building.dart';

class BuildingForm extends StatefulWidget {
  final int? buildingId;

  BuildingForm({super.key, this.buildingId});

  @override
  _BuildingFormState createState() => _BuildingFormState();
}

class _BuildingFormState extends State<BuildingForm> {
  Map<String, String> errors = {};
  Building building = Building();
  List<Project> projects = [];

  final _projectService = ProjectService();

  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadProjects();
    if (widget.buildingId != null) {
      _loadBuilding(widget.buildingId!);
    }
  }

  void _loadProjects() async {
    try {
      ApiResponse response = await _projectService.getAllProjects();
      if (response.successful) {
        setState(() {
          List<dynamic> projectList = response.data['projects'] ?? [];
          projects =
          List<Project>.from(projectList.map((x) => Project.fromJson(x)));
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void _loadBuilding(int buildingId) async {
    try {
      ApiResponse response = await _projectService.getBuildingById(buildingId);
      if (response.successful) {
        setState(() {
          dynamic buildingData = response.data['building'];
          if (buildingData != null) {
            building = Building.fromJson(buildingData);
            _nameController.text = building.name ?? '';
          }
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void _saveBuilding() async {
    building.name = _nameController.text;

    try {
      var response = building.id != null
          ? await _projectService.updateBuilding(building)
          : await _projectService.saveBuilding(building);
      if (response.successful) {
        AlertUtil.success(context, response);
        Navigator.pop(context);
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
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Building Form')),
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
                          labelText: 'Building Name',
                          errorText:
                          errors['name'] == '' ? null : errors['name'],
                        ),
                        onChanged: (value) {
                          setState(() {
                            building.name = value;
                            errors['name'] = '';
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: building.type?.toString().split('.').last,
                        decoration: InputDecoration(
                          labelText: 'Building Type',
                          errorText:
                          errors['type'] == '' ? null : errors['type'],
                        ),
                        items: BuildingType.values.map((type) {
                          return DropdownMenuItem<String>(
                            value: type.toString().split('.').last,
                            child: Text(type.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            building.type = BuildingType.values.firstWhere(
                                    (type) =>
                                type.toString().split('.').last == value,
                                orElse: () => BuildingType.RESIDENTIAL);
                            errors['type'] = ''; // Clear any existing error
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: building.project?.id,
                        decoration: InputDecoration(
                          labelText: 'Associated Project',
                          errorText: errors['project'] == ''
                              ? null
                              : errors['project'],
                        ),
                        items: projects.map((project) {
                          return DropdownMenuItem<int>(
                            value: project.id,
                            child: Text(project.name ?? 'Project'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            building.project = projects.firstWhere(
                                    (project) => project.id == value,
                                orElse: () => Project());
                            errors['project'] = ''; // Clear any existing error
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _saveBuilding,
                  child: Text(building.id != null
                      ? 'Update Building'
                      : 'Create Building'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
