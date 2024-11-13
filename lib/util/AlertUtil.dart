import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import 'ApiResponse.dart';

class AlertUtil {
  static void success(BuildContext context, ApiResponse response) {
    PanaraInfoDialog.show(
      context,
      title: "Success",
      message: response?.message ?? 'Successful',
      buttonText: 'OK',
      onTapDismiss: () {
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.success,
      barrierDismissible: false,
    );
  }

  static void error(BuildContext context, ApiResponse response) {
    String errorMessage = 'An error occurred';

    errorMessage = response.message ?? errorMessage;

    PanaraInfoDialog.show(
      context,
      title: "Error",
      message: errorMessage,
      buttonText: 'OK',
      onTapDismiss: () {
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.error,
      barrierDismissible: false,
    );
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

    PanaraInfoDialog.show(
      context,
      title: "Error",
      message: errorMessage,
      buttonText: 'OK',
      onTapDismiss: () {
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.error,
      barrierDismissible: false,
    );
  }
}
