import 'package:crem_flutter/customer/BookingService.dart';
import 'package:crem_flutter/auth/AuthService.dart';
import 'package:crem_flutter/customer/BookingView.dart';
import 'package:crem_flutter/project/ProjectService.dart';
import 'package:crem_flutter/util/AlertUtil.dart';
import 'package:crem_flutter/util/ApiResponse.dart';
import 'package:flutter/material.dart';

import 'model/Booking.dart';
import '../unit/UnitViewer.dart';
import '../unit/model/Unit.dart';
import '../user/User.dart';

class UnitBrowse extends StatefulWidget {
  final UnitStatus? unitStatus;

  UnitBrowse({this.unitStatus});

  @override
  _UnitBrowseState createState() => _UnitBrowseState();
}

class _UnitBrowseState extends State<UnitBrowse> {
  final _projectService = ProjectService();
  final _bookingService = BookingService();
  List<Unit> units = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadUnits();
  }

  void loadUnits() async {
    try {
      ApiResponse response;
      if (widget.unitStatus == UnitStatus.AVAILABLE) {
        response = await _projectService.getAllUnits();
      } else {
        User? user =  await AuthService.getStoredUser();
        if (user == null) {
          return;
        }
        response = await _bookingService.getBookingsByCustomerId( //todo change later
            user.id!
        );
      }
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

  void _bookUnit(Unit unit) async {
    try {
      Booking booking = Booking();
      booking.bookingDate = DateTime.now();
      booking.unit = unit;
      booking.customer = await AuthService.getStoredUser();
      ApiResponse response = await _bookingService.saveBooking(booking);

      if (response.successful) {
        setState(() {
          AlertUtil.success(context, response);
          loadUnits();
        });
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
        title: Text("Browse Units"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: UnitSearchDelegate(units));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Units',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16),
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
                        'Size: ${unit.size ?? "N/A"} | Price: \$${unit.price ?? 0.0} | '
                            'Status: ${unit.status?.toString().split('.').last ?? "Unknown"} | '
                            'Floor: ${unit.floor?.name != null ? unit.floor!.name.toString().split('.').last : "N/A"}',
                      ),
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
                                  builder: (context) => UnitViewer(unit: unit),
                                ),
                              );
                            },
                          ),
                          // Conditionally display either Book Now or View Booking button
                          if (unit.status == UnitStatus.AVAILABLE)
                            TextButton(
                              onPressed: () {
                                _bookUnit(unit);
                              },
                              child: Text('Book Now'),
                            )
                          else
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingView(unitId: unit.id!,),
                                  ),
                                );
                              },
                              child: Text('View Booking'),
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


class UnitSearchDelegate extends SearchDelegate {
  final List<Unit> units;

  UnitSearchDelegate(this.units);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Unit> results = units
        .where((unit) =>
            unit.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        Unit unit = results[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(unit.name ?? 'Unit'),
            subtitle: Text(
                'Size: ${unit.size ?? "N/A"} | Price: \$${unit.price ?? 0.0} | Status: ${unit.status?.toString().split('.').last ?? "Unknown"}'),
            trailing: IconButton(
              icon: Icon(Icons.visibility),
              color: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnitViewer(unit: unit),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Unit> suggestions = units
        .where((unit) =>
            unit.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        Unit unit = suggestions[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(unit.name ?? 'Unit'),
            subtitle: Text(
                'Size: ${unit.size ?? "N/A"} | Price: \$${unit.price ?? 0.0} | Status: ${unit.status?.toString().split('.').last ?? "Unknown"}'),
            trailing: IconButton(
              icon: Icon(Icons.visibility),
              color: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnitViewer(unit: unit),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
