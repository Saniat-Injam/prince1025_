import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:prince1025/core/services/auth_api_service.dart';

/// A unified API caller service to reduce duplicate code
/// and provide consistent error handling across the app
/// Uses Dio for HTTP requests with proper API response error handling
class ApiCaller {
  static final Logger _logger = Logger();
  static late Dio _dio;

  /// Initialize the API caller with Dio instance
  static void init() {
    _dio = AuthApiService.getDio();
  }

  /// GET request with proper error handling
  /// [endpoint] - API endpoint to call
  /// [showLoading] - Whether to show loading indicator
  /// [loadingMessage] - Custom loading message
  /// [onSuccess] - Callback for successful response
  /// [onError] - Optional custom error handler
  static Future<T?> get<T>({
    required String endpoint,
    bool showLoading = true,
    String? loadingMessage,
    T? Function(dynamic data)? onSuccess,
    void Function(String error)? onError,
  }) async {
    return _makeRequest<T>(
      method: 'GET',
      endpoint: endpoint,
      showLoading: showLoading,
      loadingMessage: loadingMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// POST request with proper error handling
  /// [endpoint] - API endpoint to call
  /// [data] - Request body data
  /// [showLoading] - Whether to show loading indicator
  /// [loadingMessage] - Custom loading message
  /// [onSuccess] - Callback for successful response
  /// [onError] - Optional custom error handler
  static Future<T?> post<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    bool showLoading = true,
    String? loadingMessage,
    T? Function(dynamic data)? onSuccess,
    void Function(String error)? onError,
  }) async {
    return _makeRequest<T>(
      method: 'POST',
      endpoint: endpoint,
      data: data,
      showLoading: showLoading,
      loadingMessage: loadingMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// PUT request with proper error handling
  /// [endpoint] - API endpoint to call
  /// [data] - Request body data
  /// [showLoading] - Whether to show loading indicator
  /// [loadingMessage] - Custom loading message
  /// [onSuccess] - Callback for successful response
  /// [onError] - Optional custom error handler
  static Future<T?> put<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    bool showLoading = true,
    String? loadingMessage,
    T? Function(dynamic data)? onSuccess,
    void Function(String error)? onError,
  }) async {
    return _makeRequest<T>(
      method: 'PUT',
      endpoint: endpoint,
      data: data,
      showLoading: showLoading,
      loadingMessage: loadingMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// PATCH request with proper error handling
  /// [endpoint] - API endpoint to call
  /// [data] - Request body data
  /// [showLoading] - Whether to show loading indicator
  /// [loadingMessage] - Custom loading message
  /// [onSuccess] - Callback for successful response
  /// [onError] - Optional custom error handler
  static Future<T?> patch<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    bool showLoading = true,
    String? loadingMessage,
    T? Function(dynamic data)? onSuccess,
    void Function(String error)? onError,
  }) async {
    return _makeRequest<T>(
      method: 'PATCH',
      endpoint: endpoint,
      data: data,
      showLoading: showLoading,
      loadingMessage: loadingMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// DELETE request with proper error handling
  /// [endpoint] - API endpoint to call
  /// [showLoading] - Whether to show loading indicator
  /// [loadingMessage] - Custom loading message
  /// [onSuccess] - Callback for successful response
  /// [onError] - Optional custom error handler
  static Future<T?> delete<T>({
    required String endpoint,
    bool showLoading = true,
    String? loadingMessage,
    T? Function(dynamic data)? onSuccess,
    void Function(String error)? onError,
  }) async {
    return _makeRequest<T>(
      method: 'DELETE',
      endpoint: endpoint,
      showLoading: showLoading,
      loadingMessage: loadingMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// Core method to handle all HTTP requests
  /// [method] - HTTP method (GET, POST, PUT, DELETE)
  /// [endpoint] - API endpoint to call
  /// [data] - Request body data (for POST, PUT)
  /// [showLoading] - Whether to show loading indicator
  /// [loadingMessage] - Custom loading message
  /// [onSuccess] - Callback for successful response
  /// [onError] - Optional custom error handler
  static Future<T?> _makeRequest<T>({
    required String method,
    required String endpoint,
    Map<String, dynamic>? data,
    bool showLoading = true,
    String? loadingMessage,
    T? Function(dynamic data)? onSuccess,
    void Function(String error)? onError,
  }) async {
    try {
      // Show loading if requested
      if (showLoading) {
        EasyLoading.show(status: loadingMessage ?? 'Loading...');
      }

      _logger.i('📤 Making $method request to: $endpoint');
      if (data != null) {
        _logger.d('Request data: $data');
      }

      Response response;

      // Make the appropriate HTTP request
      switch (method.toUpperCase()) {
        case 'GET':
          response = await _dio.get(endpoint);
          break;
        case 'POST':
          response = await _dio.post(endpoint, data: data);
          break;
        case 'PUT':
          response = await _dio.put(endpoint, data: data);
          break;
        case 'PATCH':
          response = await _dio.patch(endpoint, data: data);
          break;
        case 'DELETE':
          response = await _dio.delete(endpoint);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      // Check if response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('✅ $method request successful: $endpoint');

        // Dismiss loading if shown
        if (showLoading) {
          EasyLoading.dismiss();
        }

        // Call success callback if provided
        if (onSuccess != null) {
          return onSuccess(response.data);
        }

        return response.data as T?;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: '$method request failed with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _logger.e('❌ $method request failed: $endpoint');
      _logger.e('Dio error: ${e.message}');

      // Extract API error message from response
      String errorMessage = _extractApiErrorMessage(e);
      _logger.e('API error message: $errorMessage');

      // Dismiss loading if shown
      if (showLoading) {
        EasyLoading.dismiss();
      }

      // Call custom error handler if provided, otherwise show default error
      if (onError != null) {
        onError(errorMessage);
      } else {
        EasyLoading.showError(errorMessage);
      }

      return null;
    } catch (e) {
      _logger.e('❌ Unexpected error in $method request: $endpoint');
      _logger.e('Error: $e');

      // Dismiss loading if shown
      if (showLoading) {
        EasyLoading.dismiss();
      }

      String errorMessage = 'An unexpected error occurred. Please try again.';

      // Call custom error handler if provided, otherwise show default error
      if (onError != null) {
        onError(errorMessage);
      } else {
        EasyLoading.showError(errorMessage);
      }

      return null;
    }
  }

  /// Extract meaningful error message from API response
  /// Prioritizes API response error messages over Dio exception messages
  /// [error] - DioException from API call
  /// Returns proper error message to display to user
  static String _extractApiErrorMessage(DioException error) {
    // Try to get error message from API response first
    if (error.response?.data != null) {
      final responseData = error.response!.data;

      // Handle different response data formats
      if (responseData is Map<String, dynamic>) {
        // Check for common error message fields in API response
        if (responseData.containsKey('message') &&
            responseData['message'] != null &&
            responseData['message'].toString().isNotEmpty) {
          return responseData['message'].toString();
        }

        if (responseData.containsKey('error') &&
            responseData['error'] != null &&
            responseData['error'].toString().isNotEmpty) {
          return responseData['error'].toString();
        }

        if (responseData.containsKey('errors') &&
            responseData['errors'] != null) {
          // Handle validation errors array
          final errors = responseData['errors'];
          if (errors is List && errors.isNotEmpty) {
            return errors.first.toString();
          }
          if (errors is Map) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first.toString();
            }
            return firstError.toString();
          }
        }
      }

      // If response data is a string, use it directly
      if (responseData is String && responseData.isNotEmpty) {
        return responseData;
      }
    }

    // Fall back to status code based messages
    final statusCode = error.response?.statusCode;
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Authentication failed. Please login again.';
      case 403:
        return 'Access denied. You don\'t have permission.';
      case 404:
        return 'Service not found. Please try again later.';
      case 422:
        return 'Validation failed. Please check your input.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        break;
    }

    // Fall back to connection error messages
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.receiveTimeout:
        return 'Response timeout. Please try again.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.unknown:
        return 'No internet connection. Please check your network.';
      default:
        return 'Network error occurred. Please try again.';
    }
  }

  /// Show success message with EasyLoading
  /// [message] - Success message to display
  static void showSuccess(String message) {
    EasyLoading.showSuccess(message);
  }

  /// Show error message with EasyLoading
  /// [message] - Error message to display
  static void showError(String message) {
    EasyLoading.showError(message);
  }

  /// Show info message with EasyLoading
  /// [message] - Info message to display
  static void showInfo(String message) {
    EasyLoading.showInfo(message);
  }

  /// Dismiss any active EasyLoading dialog
  static void dismiss() {
    EasyLoading.dismiss();
  }
}
