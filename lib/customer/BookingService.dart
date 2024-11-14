import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crem_flutter/util/APIUrls.dart';
import '../auth/AuthInterceptor.dart';
import '../util/ApiResponse.dart';
import 'model/Booking.dart'; // Define Booking model

class BookingService {
  final Dio _dio;

  BookingService() : _dio = Dio() {
    _dio.interceptors.add(AuthInterceptor());
  }

  final String apiUrl = APIUrls.booking;

  Future<ApiResponse> getAllBookings() async {
    try {
      final response = await _dio.get('$apiUrl/');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  Future<ApiResponse> saveBooking(Booking booking) async {
    try {
      final response = await _dio.post(
        '$apiUrl/save',
        data: jsonEncode(booking.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  Future<ApiResponse> updateBooking(Booking booking) async {
    try {
      final response = await _dio.put(
        '$apiUrl/update',
        data: jsonEncode(booking.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  Future<ApiResponse> getBookingById(int id) async {
    try {
      final response = await _dio.get('$apiUrl/$id');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  Future<ApiResponse> deleteBookingById(int id) async {
    try {
      final response = await _dio.delete('$apiUrl/$id');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  Future<ApiResponse> getBookingByUnitId(int unitId) async {
    try {
      final response = await _dio.get('$apiUrl/unit/$unitId');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  Future<ApiResponse> getBookingsByCustomerId(int customerId) async {
    try {
      final response = await _dio.get('$apiUrl/customer/$customerId');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }
}
