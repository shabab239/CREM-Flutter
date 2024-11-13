import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:crem_flutter/util/APIUrls.dart';
import '../auth/AuthInterceptor.dart';
import '../util/ApiResponse.dart';
import 'User.dart';

class UserService {
  final Dio _dio;

  UserService() : _dio = Dio() {
    _dio.interceptors.add(AuthInterceptor());
  }

  final String apiUrl = APIUrls.user;

  Future<ApiResponse> getAll() async {
    final response = await _dio.get('$apiUrl/');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> getAllCustomers() async {
    final response = await _dio.get('$apiUrl/customers');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> getById(int id) async {
    final response = await _dio.get('$apiUrl/$id');
    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> save(User user, {File? avatarFile}) async {
    final formData = FormData.fromMap({
      'user': jsonEncode(user.toJson()),
      if (avatarFile != null) 'avatar': await MultipartFile.fromFile(avatarFile.path),
    });

    final response = await _dio.post(
      '$apiUrl/save',
      data: formData,
    );

    return ApiResponse.fromJson(response.data);
  }

  Future<ApiResponse> update(User user, {File? avatarFile}) async {
    final formData = FormData.fromMap({
      'user': jsonEncode(user.toJson()),
      if (avatarFile != null) 'avatar': await MultipartFile.fromFile(avatarFile.path),
    });

    final response = await _dio.put(
      '$apiUrl/update',
      data: formData,
    );

    return ApiResponse.fromJson(response.data);
  }

  // Delete user by ID
  Future<ApiResponse> deleteById(int id) async {
    final response = await _dio.delete('$apiUrl/$id');
    return ApiResponse.fromJson(response.data);
  }
}
