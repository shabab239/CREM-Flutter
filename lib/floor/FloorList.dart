import 'package:crem_flutter/project/ProjectService.dart';
import 'package:flutter/material.dart';

import '../util/AlertUtil.dart';
import '../util/ApiResponse.dart';
import 'FloorForm.dart';
import 'model/Floor.dart';

class FloorList extends StatefulWidget {
  @override
  _FloorListState createState() => _FloorListState();
}

class _FloorListState extends State<FloorList> {
  final _projectService = ProjectService();
  List<Floor> floors = [];

  @override
  void initState() {
    super.initState();
    loadFloors();
  }

  void loadFloors() async {
    try {
      ApiResponse response = await _projectService.getAllFloors();
      if (response.successful) {
        setState(() {
          floors = List<Floor>.from(
              response.data['floors'].map((x) => Floor.fromJson(x)));
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void deleteFloor(int? id) async {
    if (id == null) {
      AlertUtil.exception(context, "ID not found");
      return;
    }
    try {
      ApiResponse response = await _projectService.deleteFloorById(id);
      if (response.successful) {
        loadFloors();
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
        title: Text("Floors List"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FloorForm()));
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
                itemCount: floors.length,
                itemBuilder: (context, index) {
                  Floor floor = floors[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                          floor.name?.toString().split('.').last ?? 'Floor'),
                      subtitle:
                          Text('Building: ${floor.building?.name ?? "N/A"}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility),
                            color: Colors.blue,
                            onPressed: () {
                              // Navigate to floor details page (optional)
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
                                        FloorForm(floorId: floor.id)),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              deleteFloor(floor.id);
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
