/*
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../util/api_response.dart';
import '../../util/urls.dart';
import './project.model.dart';
import './building/building.model.dart';
import './floor/floor.model.dart';
import './unit/unit.model.dart';

class ProjectService {
  final String apiUrl = API_URLS.project;

  // Helper method for handling API response
  Future<ApiResponse> _handleResponse(http.Response response) async {
    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch data: ${response.reasonPhrase}');
    }
  }

  // Project APIs
  Future<ApiResponse> getAllProjects() async {
    final response = await http.get(Uri.parse('$apiUrl/'));
    return _handleResponse(response);
  }

  Future<ApiResponse> saveProject(Project project) async {
    final response = await http.post(
      Uri.parse('$apiUrl/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(project.toJson()),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> updateProject(Project project) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(project.toJson()),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> getProjectById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    return _handleResponse(response);
  }

  Future<ApiResponse> deleteProjectById(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    return _handleResponse(response);
  }

  // Building APIs
  Future<ApiResponse> getAllBuildings() async {
    final response = await http.get(Uri.parse('$apiUrl/buildings'));
    return _handleResponse(response);
  }

  Future<ApiResponse> saveBuilding(Building building) async {
    final response = await http.post(
      Uri.parse('$apiUrl/building/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(building.toJson()),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> updateBuilding(Building building) async {
    final response = await http.put(
      Uri.parse('$apiUrl/building/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(building.toJson()),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> getBuildingById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/building/$id'));
    return _handleResponse(response);
  }

  Future<ApiResponse> deleteBuildingById(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/building/$id'));
    return _handleResponse(response);
  }

  // Floor APIs
  Future<ApiResponse> getAllFloors() async {
    final response = await http.get(Uri.parse('$apiUrl/floors'));
    return _handleResponse(response);
  }

  Future<ApiResponse> saveFloor(Floor floor) async {
    final response = await http.post(
      Uri.parse('$apiUrl/floor/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(floor.toJson()),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> updateFloor(Floor floor) async {
    final response = await http.put(
      Uri.parse('$apiUrl/floor/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(floor.toJson()),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> getFloorById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/floor/$id'));
    return _handleResponse(response);
  }

  Future<ApiResponse> deleteFloorById(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/floor/$id'));
    return _handleResponse(response);
  }

  // Unit APIs
  Future<ApiResponse> getAllUnits() async {
    final response = await http.get(Uri.parse('$apiUrl/units'));
    return _handleResponse(response);
  }

  Future<ApiResponse> saveUnit(Unit unit) async {
    final response = await http.post(
      Uri.parse('$apiUrl/unit/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(unit.toJson()),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> updateUnit(Unit unit) async {
    final response = await http.put(
      Uri.parse('$apiUrl/unit/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(unit.toJson()),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> getUnitById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/unit/$id'));
    return _handleResponse(response);
  }

  Future<ApiResponse> deleteUnitById(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/unit/$id'));
    return _handleResponse(response);
  }
}
*/
