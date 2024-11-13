import 'package:crem_flutter/project/ProjectService.dart';
import 'package:flutter/material.dart';

import '../util/AlertUtil.dart';
import '../util/ApiResponse.dart';
import 'BuildingForm.dart';
import 'model/Building.dart';

class BuildingList extends StatefulWidget {
  @override
  _BuildingListState createState() => _BuildingListState();
}

class _BuildingListState extends State<BuildingList> {
  final _projectService = ProjectService();
  List<Building> buildings = [];

  @override
  void initState() {
    super.initState();
    loadBuildings();
  }

  void loadBuildings() async {
    try {
      ApiResponse response = await _projectService.getAllBuildings();
      if (response.successful) {
        setState(() {
          buildings = List<Building>.from(
              response.data['buildings'].map((x) => Building.fromJson(x)));
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void deleteBuilding(int? id) async {
    if (id == null) {
      AlertUtil.exception(context, "ID not found");
      return;
    }
    try {
      ApiResponse response = await _projectService.deleteBuildingById(id);
      if (response.successful) {
        loadBuildings();
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
        title: Text("Buildings List"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BuildingForm()));
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
                itemCount: buildings.length,
                itemBuilder: (context, index) {
                  Building building = buildings[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(building.name ?? 'Building'),
                      subtitle: Text(
                          '${building.type?.toString().split('.').last ?? "Unknown"} | Project: ${building.project?.name ?? "N/A"}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility),
                            color: Colors.blue,
                            onPressed: () {
                              // Navigate to building details page
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
                                        BuildingForm(buildingId: building.id)),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              deleteBuilding(building.id);
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
