import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crem_flutter/util/APIUrls.dart';
import '../auth/AuthInterceptor.dart';
import '../util/ApiResponse.dart';
import 'model/BookingPayment.dart';

class PaymentService {
  final Dio _dio;

  PaymentService() : _dio = Dio() {
    _dio.interceptors.add(AuthInterceptor());
  }

  final String apiUrl = APIUrls.payment;

  Future<ApiResponse> getAllPayments() async {
    try {
      final response = await _dio.get('$apiUrl/');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  Future<ApiResponse> savePayment(BookingPayment bookingPayment) async {
    try {
      final response = await _dio.post(
        '$apiUrl/save',
        data: jsonEncode(bookingPayment.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  Future<ApiResponse> getPaymentById(int id) async {
    try {
      final response = await _dio.get('$apiUrl/$id');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  Future<ApiResponse> deletePaymentById(int id) async {
    try {
      final response = await _dio.delete('$apiUrl/$id');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  Future<ApiResponse> getPaymentsByCustomerId(int customerId) async {
    try {
      final response = await _dio.get('$apiUrl/customer/$customerId');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }
}
