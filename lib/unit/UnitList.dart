import 'package:flutter/material.dart';
import 'package:crem_flutter/project/ProjectService.dart';
import 'package:crem_flutter/util/AlertUtil.dart';
import 'package:crem_flutter/util/ApiResponse.dart';
import 'UnitViewer.dart';
import 'model/Unit.dart';
import 'UnitForm.dart';

class UnitList extends StatefulWidget {
  @override
  _UnitListState createState() => _UnitListState();
}

class _UnitListState extends State<UnitList> with WidgetsBindingObserver {
  final _projectService = ProjectService();
  List<Unit> units = [];

  @override
  void initState() {
    super.initState();
    loadUnits();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      loadUnits();
    }
  }

  void loadUnits() async {
    try {
      ApiResponse response = await _projectService.getAllUnits();
      if (response.successful) {
        setState(() {
          units = List<Unit>.from(
              response.data['units'].map((x) => Unit.fromJson(x)));
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void deleteUnit(int? id) async {
    if (id == null) {
      AlertUtil.exception(context, "ID not found");
      return;
    }
    try {
      ApiResponse response = await _projectService.deleteUnitById(id);
      if (response.successful) {
        loadUnits();
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
        title: Text("Units List"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UnitForm()));
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
                itemCount: units.length,
                itemBuilder: (context, index) {
                  Unit unit = units[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(unit.name ?? 'Unit'),
                      subtitle: Text(
                          'Size: ${unit.size ?? "N/A"} | Price: \$${unit.price ?? 0.0} | Status: ${unit.status?.toString().split('.').last ?? "Unknown"} | Floor: ${unit.floor?.name?.toString() ?? "N/A"}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility),
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UnitViewer(
                                    unit: unit,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.orange,
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UnitForm(unitId: unit.id),
                                ),
                              );
                              loadUnits();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              deleteUnit(unit.id);
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
