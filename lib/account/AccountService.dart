import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crem_flutter/util/APIUrls.dart';
import '../auth/AuthInterceptor.dart';
import '../util/ApiResponse.dart';
import 'model/Account.dart';

class AccountService {
  final Dio _dio;

  AccountService() : _dio = Dio() {
    _dio.interceptors.add(AuthInterceptor());
  }

  final String apiUrl = APIUrls.account;

  // Get an account by ID
  Future<ApiResponse> getAccountById(int id) async {
    try {
      final response = await _dio.get('$apiUrl/$id');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Get all accounts
  Future<ApiResponse> getAllAccounts() async {
    try {
      final response = await _dio.get('$apiUrl/');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Save an account
  Future<ApiResponse> saveAccount(Account account) async {
    try {
      final response = await _dio.post(
        '$apiUrl/save',
        data: jsonEncode(account.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Update an account
  Future<ApiResponse> updateAccount(Account account) async {
    try {
      final response = await _dio.put(
        '$apiUrl/update',
        data: jsonEncode(account.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Delete an account by ID
  Future<ApiResponse> deleteAccountById(int id) async {
    try {
      final response = await _dio.delete('$apiUrl/$id');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Get all accounts by company ID
  Future<ApiResponse> getAllAccountsByCompanyId(int companyId) async {
    try {
      final response = await _dio.get('$apiUrl/company/$companyId');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Get account by ID and company ID
  Future<ApiResponse> getAccountByIdAndCompanyId(int id, int companyId) async {
    try {
      final response = await _dio.get('$apiUrl/company/$companyId/account/$id');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Get the total account balance
  Future<ApiResponse> getTotalAccountBalance() async {
    try {
      final response = await _dio.get('$apiUrl/total-account-balance');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Get balance by account type
  Future<ApiResponse> getBalanceByAccountType(String accountType) async {
    try {
      final response = await _dio.get('$apiUrl/balance-by-account-type', queryParameters: {'accountType': accountType});
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }

  // Get account summary by account ID
  Future<ApiResponse> getAccountSummary(int accountId) async {
    try {
      final response = await _dio.get('$apiUrl/account-summary', queryParameters: {'accountId': accountId});
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return ApiResponse(successful: false, message: e.toString());
    }
  }
}
