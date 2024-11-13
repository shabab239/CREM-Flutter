import 'package:crem_flutter/auth/AuthService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? jwt = await AuthService.getAuthToken();
    if (jwt != null) {
      options.headers['Authorization'] = 'Bearer $jwt';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await AuthService.logout();
      final context = navigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Session expired. Please log in again.')),
        );
      }
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
    } else {
      super.onError(err, handler);
    }
  }
}
