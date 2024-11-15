import 'package:crem_flutter/project/ProjectForm.dart';
import 'package:flutter/material.dart';

import '../util/AlertUtil.dart';
import '../util/ApiResponse.dart';
import 'ProjectService.dart';
import 'model/Project.dart';

class ProjectList extends StatefulWidget {
  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  final _projectService = ProjectService();
  List<Project> projects = [];

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  void loadProjects() async {
    try {
      ApiResponse response = await _projectService.getAllProjects();
      if (response.successful) {
        setState(() {
          projects = List<Project>.from(
              response.data['projects'].map((x) => Project.fromJson(x)));
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void deleteProject(int? id) async {
    if (id == null) {
      AlertUtil.exception(context, "ID not found");
      return;
    }
    try {
      ApiResponse response = await _projectService.deleteProjectById(id);
      if (response.successful) {
        loadProjects();
        AlertUtil.success(context, response);
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projects List"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProjectForm()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  Project project = projects[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(project.name ?? 'Project'),
                      subtitle: Text(
                          '${project.location} | Budget: \$${project.budget}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility),
                            color: Colors.blue,
                            onPressed: () {
                              // Navigate to project details page
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.orange,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProjectForm(projectId: project.id)),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              deleteProject(project.id);
                            },
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
