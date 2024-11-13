import 'package:crem_flutter/project/ProjectService.dart';
import 'package:flutter/material.dart';
import '../../building/model/Building.dart';
import '../util/AlertUtil.dart';
import '../util/ApiResponse.dart';
import 'model/Floor.dart';

class FloorForm extends StatefulWidget {
  final int? floorId;

  FloorForm({super.key, this.floorId});

  @override
  _FloorFormState createState() => _FloorFormState();
}

class _FloorFormState extends State<FloorForm> {
  Map<String, String> errors = {};
  Floor floor = Floor(building: Building());
  List<Building> buildings = [];

  final _projectService = ProjectService();

  // We now use a controller to handle the selected floor name from the enum
  FloorName? _selectedFloorName;

  @override
  void initState() {
    super.initState();
    _loadBuildings();
    if (widget.floorId != null) {
      _loadFloor(widget.floorId!);
    }
  }

  void _loadBuildings() async {
    try {
      ApiResponse response = await _projectService.getAllBuildings();
      if (response.successful) {
        setState(() {
          List<dynamic> buildingList = response.data['buildings'] ?? [];
          buildings = List<Building>.from(
              buildingList.map((x) => Building.fromJson(x)));
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void _loadFloor(int floorId) async {
    try {
      ApiResponse response = await _projectService.getFloorById(floorId);
      if (response.successful) {
        setState(() {
          dynamic floorData = response.data['floor'];
          if (floorData != null) {
            floor = Floor.fromJson(floorData);
            _selectedFloorName = floor.name;  // Set the selected floor name
          }
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void _saveFloor() async {
    // Update the floor's name based on the selected value from the dropdown
    floor.name = _selectedFloorName ?? FloorName.BASEMENT;

    try {
      var response = floor.id != null
          ? await _projectService.updateFloor(floor)
          : await _projectService.saveFloor(floor);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Floor Form')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Floor Information',
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
                      // Dropdown for Floor Name
                      DropdownButtonFormField<FloorName>(
                        value: _selectedFloorName,
                        decoration: InputDecoration(
                          labelText: 'Floor Name',
                          errorText:
                          errors['name'] == '' ? null : errors['name'],
                        ),
                        items: FloorName.values.map((floorName) {
                          return DropdownMenuItem<FloorName>(
                            value: floorName,
                            child: Text(floorName.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFloorName = value;
                            errors['name'] = ''; // Clear any existing error
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      // Dropdown for Associated Building
                      DropdownButtonFormField<int>(
                        value: floor.building?.id,
                        decoration: InputDecoration(
                          labelText: 'Associated Building',
                          errorText:
                          errors['building'] == '' ? null : errors['building'],
                        ),
                        items: buildings.map((building) {
                          return DropdownMenuItem<int>(
                            value: building.id,
                            child: Text(building.name ?? 'Building'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            floor.building = buildings.firstWhere(
                                    (building) => building.id == value,
                                orElse: () => Building());
                            errors['building'] = ''; // Clear any existing error
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _saveFloor,
                  child: Text(floor.id != null
                      ? 'Update Floor'
                      : 'Create Floor'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
