import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crem_flutter/util/APIUrls.dart';
import 'package:intl/intl.dart';
import '../auth/AuthInterceptor.dart';
import '../util/ApiResponse.dart';
import 'model/Transaction.dart';

class TransactionService {
  final Dio _dio;

  TransactionService() : _dio = Dio() {
    _dio.interceptors.add(AuthInterceptor());
  }

  final String apiUrl = APIUrls.transaction;

  // Get all transactions
  Future<ApiResponse> getAllTransactions() async {
    try {
      final response = await _dio.get('$apiUrl/');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Save a transaction
  Future<ApiResponse> saveTransaction(Transaction transaction) async {
    try {
      final response = await _dio.post(
        '$apiUrl/save',
        data: jsonEncode(transaction.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Get a transaction by ID
  Future<ApiResponse> getTransactionById(int id) async {
    try {
      final response = await _dio.get('$apiUrl/$id');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Update a transaction
  Future<ApiResponse> updateTransaction(Transaction transaction) async {
    try {
      final response = await _dio.put(
        '$apiUrl/update',
        data: jsonEncode(transaction.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Delete a transaction by ID
  Future<ApiResponse> deleteTransactionById(int id) async {
    try {
      final response = await _dio.delete('$apiUrl/$id');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Get total income
  Future<ApiResponse> getTotalIncome() async {
    try {
      final response = await _dio.get('$apiUrl/total-income');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Get total expense
  Future<ApiResponse> getTotalExpense() async {
    try {
      final response = await _dio.get('$apiUrl/total-expense');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  Future<ApiResponse> getTransactionsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      // Format the DateTime objects to dd-MM-yyyy format
      String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
      String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);

      final response = await _dio.get(
        '$apiUrl/transactions-by-date-range',
        queryParameters: {'startDate': formattedStartDate, 'endDate': formattedEndDate},
      );

      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }


  // Get transactions by account ID
  Future<ApiResponse> getTransactionsByAccount(int accountId) async {
    try {
      final response = await _dio.get('$apiUrl/transactions-by-account', queryParameters: {'accountId': accountId});
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }
}
