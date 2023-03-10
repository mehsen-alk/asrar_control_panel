import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../config/strings_manager.dart';
import 'firebase_auth_exception_handler.dart';
import 'failure.dart';
import 'firebase_exception_handler.dart';

class ExceptionHandler implements Exception {
  late final Failure failure;

  ExceptionHandler.handle(exception) {
    if (kDebugMode) {
      print("\x1B[31m exception cached: ${exception.runtimeType} ${exception.toString()} \x1B[0m");
    }

    bool found = false;

    if (!found && exception is FirebaseAuthException) {
      failure = FirebaseAuthExceptionHandler.handle(exception).getFailure();
      found = true;
    }

    if (!found && exception is FirebaseException) {
      failure = FirebaseExceptionHandler.handle(exception).getFailure();
      found = true;
    }

    if (!found) {
      print(
          "unhandled exception: ${exception.runtimeType} ${exception.toString()}");

      failure = Failure(0, AppStrings.undefined);
    }
  }
}

enum DataSourceExceptions { noInternetConnections, forbidden }

extension DataSourceExceptionsExtensions on DataSourceExceptions {
  Failure getFailure() {
    switch (this) {
      case DataSourceExceptions.noInternetConnections:
        return Failure(
            ResponseCode.noInternetConnection, AppStrings.noInternetError);
      case DataSourceExceptions.forbidden:
        return Failure(ResponseCode.forbidden, AppStrings.forbiddenError);
    }
  }
}

class ResponseCode {
  static const int success = 200; // success with data
  static const int noContent = 201; // success with no data (no content)
  static const int badRequestError = 400; // failure, API rejected request
  static const int unauthorized = 401; // failure, user is not authorized
  static const int forbidden = 403; //  failure, API rejected request
  static const int internalServerError = 500; // failure, crash in server side
  static const int bandwidthLimitExceeded = 509;
  static const int notFound = 404; // failure, not found

  // local status code
  static const int connectTimeout = -1;
  static const int cancel = -2;
  static const int receiveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int defaultError = -7;
}

class ApiInternalStatus {
  static const int success = 0;
  static const int failure = 1;
}
