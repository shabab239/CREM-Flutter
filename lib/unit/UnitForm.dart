import 'package:crem_flutter/project/ProjectService.dart';
import 'package:flutter/material.dart';
import '../../floor/model/Floor.dart';
import '../util/AlertUtil.dart';
import '../util/ApiResponse.dart';
import 'model/Unit.dart';

class UnitForm extends StatefulWidget {
  final int? unitId;

  UnitForm({super.key, this.unitId});

  @override
  _UnitFormState createState() => _UnitFormState();
}

class _UnitFormState extends State<UnitForm> {
  Map<String, String> errors = {};
  Unit unit = Unit(name: '', floor: Floor());
  List<Floor> floors = [];
  final _projectService = ProjectService();

  // Controllers for inputs
  TextEditingController _nameController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  UnitType? _selectedUnitType;
  UnitStatus? _selectedUnitStatus;
  Floor? _selectedFloor;

  @override
  void initState() {
    super.initState();
    _loadFloors();
    if (widget.unitId != null) {
      _loadUnit(widget.unitId!);
    }
  }

  void _loadFloors() async {
    try {
      ApiResponse response = await _projectService.getAllFloors();
      if (response.successful) {
        setState(() {
          List<dynamic> floorList = response.data['floors'] ?? [];
          floors = List<Floor>.from(floorList.map((x) => Floor.fromJson(x)));
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void _loadUnit(int unitId) async {
    try {
      ApiResponse response = await _projectService.getUnitById(unitId);
      if (response.successful) {
        setState(() {
          dynamic unitData = response.data['unit'];
          if (unitData != null) {
            unit = Unit.fromJson(unitData);
            _nameController.text = unit.name;
            _sizeController.text = unit.size?.toString() ?? '';
            _priceController.text = unit.price?.toString() ?? '';
            _selectedUnitType = unit.type;
            _selectedUnitStatus = unit.status;
            _selectedFloor = unit.floor;
          }
        });
      } else {
        AlertUtil.error(context, response);
      }
    } catch (error) {
      AlertUtil.exception(context, error);
    }
  }

  void _saveUnit() async {
    unit.name = _nameController.text;
    unit.size = int.tryParse(_sizeController.text);
    unit.price = double.tryParse(_priceController.text);
    unit.type = _selectedUnitType;
    unit.status = _selectedUnitStatus;
    unit.floor = _selectedFloor ?? Floor();

    try {
      var response = unit.id != null
          ? await _projectService.updateUnit(unit)
          : await _projectService.saveUnit(unit);
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
    _sizeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unit Form')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unit Information',
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
                      // Unit Name Input
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Unit Name',
                          errorText: errors['name'] == '' ? null : errors['name'],
                        ),
                        onChanged: (value) {
                          setState(() {
                            unit.name = value;
                            errors['name'] = ''; // Clear any existing error
                          });
                        },
                      ),
                      SizedBox(height: 12),

                      // Unit Size Input
                      TextFormField(
                        controller: _sizeController,
                        decoration: InputDecoration(
                          labelText: 'Size (sq ft)',
                          errorText: errors['size'] == '' ? null : errors['size'],
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            unit.size = int.tryParse(value);
                            errors['size'] = ''; // Clear any existing error
                          });
                        },
                      ),
                      SizedBox(height: 12),

                      // Unit Price Input
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          errorText: errors['price'] == '' ? null : errors['price'],
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          setState(() {
                            unit.price = double.tryParse(value);
                            errors['price'] = ''; // Clear any existing error
                          });
                        },
                      ),
                      SizedBox(height: 12),

                      // Unit Type Dropdown
                      DropdownButtonFormField<UnitType>(
                        value: _selectedUnitType,
                        decoration: InputDecoration(
                          labelText: 'Unit Type',
                          errorText:
                          errors['type'] == '' ? null : errors['type'],
                        ),
                        items: UnitType.values.map((unitType) {
                          return DropdownMenuItem<UnitType>(
                            value: unitType,
                            child: Text(unitType.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedUnitType = value;
                            errors['type'] = ''; // Clear any existing error
                          });
                        },
                      ),
                      SizedBox(height: 12),

                      // Unit Status Dropdown
                      DropdownButtonFormField<UnitStatus>(
                        value: _selectedUnitStatus,
                        decoration: InputDecoration(
                          labelText: 'Unit Status',
                          errorText:
                          errors['status'] == '' ? null : errors['status'],
                        ),
                        items: UnitStatus.values.map((unitStatus) {
                          return DropdownMenuItem<UnitStatus>(
                            value: unitStatus,
                            child: Text(unitStatus.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedUnitStatus = value;
                            errors['status'] = ''; // Clear any existing error
                          });
                        },
                      ),
                      SizedBox(height: 12),

                      // Floor Dropdown
                      DropdownButtonFormField<int>(
                        value: _selectedFloor?.id,
                        decoration: InputDecoration(
                          labelText: 'Associated Floor',
                          errorText:
                          errors['floor'] == '' ? null : errors['floor'],
                        ),
                        items: floors.map((floor) {
                          return DropdownMenuItem<int>(
                            value: floor.id,
                            child: Text(floor.name?.toString() ?? 'Floor'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFloor = floors.firstWhere(
                                    (floor) => floor.id == value,
                                orElse: () => Floor());
                            errors['floor'] = ''; // Clear any existing error
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _saveUnit,
                  child: Text(unit.id != null ? 'Update Unit' : 'Create Unit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
