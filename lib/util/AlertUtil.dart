import 'package:flutter/material.dart';

import 'ApiResponse.dart';

class AlertUtil {
  static void success(BuildContext context, ApiResponse response) {
    final snackBar = SnackBar(
      content: Text(response.message ?? 'Successful'),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void error(BuildContext context, ApiResponse response) {
    final snackBar = SnackBar(
      content: Text(response.message ?? 'An error occurred'),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void exception(BuildContext context, dynamic error) {
    String errorMessage = 'An unexpected error occurred';

    if (error is Exception) {
      errorMessage = error.toString();
    } else if (error is String) {
      errorMessage = error;
    } else if (error is Map) {
      errorMessage = error['message'] ?? errorMessage;
    }

    final snackBar = SnackBar(
      content: Text(errorMessage),
      backgroundColor: Colors.orange,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
