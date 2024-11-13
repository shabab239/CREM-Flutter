import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crem_flutter/util/APIUrls.dart';
import '../auth/AuthInterceptor.dart';
import '../util/ApiResponse.dart';
import '../building/model/Building.dart';
import '../floor/model/Floor.dart';
import 'model/Project.dart';
import '../unit/model/Unit.dart';

class ProjectService {
  final Dio _dio;

  ProjectService() : _dio = Dio() {
    _dio.interceptors.add(AuthInterceptor());
  }

  final String apiUrl = APIUrls.project;

  // Project APIs
  Future<ApiResponse> getAllProjects() async {
    final response = await _dio.get('$apiUrl/');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> saveProject(Project project) async {
    final response = await _dio.post(
      '$apiUrl/save',
      data: jsonEncode(project.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> updateProject(Project project) async {
    final response = await _dio.put(
      '$apiUrl/update',
      data: jsonEncode(project.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> getProjectById(int id) async {
    final response = await _dio.get('$apiUrl/$id');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> deleteProjectById(int id) async {
    final response = await _dio.delete('$apiUrl/$id');
    return ApiResponse.fromJson(response.data);
  }

  // Building APIs
  Future<ApiResponse> getAllBuildings() async {
    final response = await _dio.get('$apiUrl/buildings');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> saveBuilding(Building building) async {
    final response = await _dio.post(
      '$apiUrl/building/save',
      data: jsonEncode(building.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> updateBuilding(Building building) async {
    final response = await _dio.put(
      '$apiUrl/building/update',
      data: jsonEncode(building.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> getBuildingById(int id) async {
    final response = await _dio.get('$apiUrl/building/$id');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> deleteBuildingById(int id) async {
    final response = await _dio.delete('$apiUrl/building/$id');
    return ApiResponse.fromJson(response.data);
  }

  // Floor APIs
  Future<ApiResponse> getAllFloors() async {
    final response = await _dio.get('$apiUrl/floors');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> saveFloor(Floor floor) async {
    final response = await _dio.post(
      '$apiUrl/floor/save',
      data: jsonEncode(floor.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> updateFloor(Floor floor) async {
    final response = await _dio.put(
      '$apiUrl/floor/update',
      data: jsonEncode(floor.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> getFloorById(int id) async {
    final response = await _dio.get('$apiUrl/floor/$id');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> deleteFloorById(int id) async {
    final response = await _dio.delete('$apiUrl/floor/$id');
    return ApiResponse.fromJson(response.data);
  }

  // Unit APIs
  Future<ApiResponse> getAllUnits() async {
    final response = await _dio.get('$apiUrl/units');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> saveUnit(Unit unit) async {
    final response = await _dio.post(
      '$apiUrl/unit/save',
      data: jsonEncode(unit.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> updateUnit(Unit unit) async {
    final response = await _dio.put(
      '$apiUrl/unit/update',
      data: jsonEncode(unit.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> updateUnitImage(MultipartFile image, int unitId) async {
    final formData = FormData.fromMap({
      'image': image,
      'unitId': unitId,
    });
    final response = await _dio.put(
      '$apiUrl/unit/updateImage',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data', // Set correct content type for multipart data
        },
      ),
    );
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> getUnitById(int id) async {
    final response = await _dio.get('$apiUrl/unit/$id');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> deleteUnitById(int id) async {
    final response = await _dio.delete('$apiUrl/unit/$id');
    return ApiResponse.fromJson(response.data);
  }
}
