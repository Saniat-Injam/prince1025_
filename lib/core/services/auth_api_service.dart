import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:prince1025/core/utils/constants/api_constants.dart';
import 'package:prince1025/core/services/storage_service.dart';

/// API service for handling authentication related API calls
/// Uses Dio for HTTP requests with proper error handling
/// This is a reusable network caller
class AuthApiService {
  static final Logger _logger = Logger();
  static late Dio _dio;

  /// Initialize Dio with base configuration
  static void init() {
    _dio = Dio();

    // Configure base options
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);

    // Add interceptors for logging and token management
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available with Bearer prefix
          final token = StorageService.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          _logger.i('🚀 REQUEST: ${options.method} ${options.path}');
          _logger.d('Headers: ${options.headers}');
          _logger.d('Data: ${options.data}');

          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i(
            '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}',
          );
          _logger.d('Response Data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('❌ ERROR: ${error.requestOptions.path}');
          _logger.e('Error Message: ${error.message}');
          _logger.e('Error Response: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );
  }

  /// Get the configured Dio instance for reuse in controllers
  static Dio getDio() => _dio;

  /// Handle API errors and show appropriate error messages
  /// [error] - DioException from API call
  static String handleApiError(DioException error) {
    String errorMessage = 'Something went wrong';

    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final responseData = error.response!.data;

      switch (statusCode) {
        case 400:
          errorMessage = 'Invalid request data';
          break;
        case 401:
          errorMessage = 'Unauthorized access';
          break;
        case 403:
          errorMessage = 'Access forbidden';
          break;
        case 404:
          errorMessage = 'Service not found';
          break;
        case 422:
          errorMessage = 'Validation error';
          break;
        case 500:
          errorMessage = 'Server error occurred';
          break;
        default:
          errorMessage = 'Network error occurred';
      }

      // Try to get error message from response
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        }
      }
    } else if (error.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Connection timeout';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Response timeout';
    } else if (error.type == DioExceptionType.unknown) {
      errorMessage = 'No internet connection';
    }

    _logger.e('❌ API Error: $errorMessage');
    return errorMessage;
  }
}
