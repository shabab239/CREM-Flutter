import 'dart:convert';
import 'package:dio/dio.dart';
import '../auth/AuthInterceptor.dart';
import '../util/APIUrls.dart';
import '../util/ApiResponse.dart';
import 'model/Task.dart';

class TaskService {
  final Dio _dio;

  TaskService() : _dio = Dio() {
    _dio.interceptors.add(AuthInterceptor());
  }

  final String apiUrl = APIUrls.task;

  Future<ApiResponse> getAllTasks() async {
    final response = await _dio.get('$apiUrl/');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> getTaskById(int id) async {
    final response = await _dio.get('$apiUrl/$id');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> saveTask(Task task) async {
    final response = await _dio.post(
      '$apiUrl/save',
      data: jsonEncode(task.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> updateTask(Task task) async {
    final response = await _dio.put(
      '$apiUrl/update',
      data: jsonEncode(task.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> markTaskAsCompleted(int id) async {
    final response = await _dio.post(
      '$apiUrl/markAsCompleted',
      queryParameters: {'id': id},
    );
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> deleteTaskById(int id) async {
    final response = await _dio.delete('$apiUrl/$id');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> getAllTasksByStatus(Status status) async {
    final response = await _dio.post(
      '$apiUrl/getAllByStatus',
      queryParameters: {'status': status},
    );
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> changeTaskStatus(int id, Status status) async {
    final response = await _dio.post(
      '$apiUrl/changeStatus',
      queryParameters: {'id': id, 'status': status},
    );
    return ApiResponse.fromJson(response.data);
  }


}
