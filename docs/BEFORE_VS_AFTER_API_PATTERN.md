# Before vs After: API Calling Pattern

## OLD PATTERN (With Duplicate Code and Dio Exceptions)

```dart
class OldAuthController extends GetxController {
  final Dio _dio = AuthApiService.getDio();
  final Logger _logger = Logger();

  // ❌ DUPLICATE CODE - This pattern repeats in every API call
  Future<void> login() async {
    try {
      EasyLoading.show(status: 'Logging in...');
      _logger.i('📤 Logging in user');

      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('✅ Login successful');
        final loginResponse = LoginResponse.fromJson(response.data);
        await StorageService.saveAuthData(loginResponse.accessToken, loginResponse.user);
        EasyLoading.showSuccess("Login successful!");
        Get.offAll(BottomNavScreen());
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Login failed with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _logger.e('❌ Login failed: ${e.message}');
      // ❌ SHOWS DIO EXCEPTION ERROR instead of API response error
      EasyLoading.showError('Login failed. Please try again.');
    } catch (e) {
      _logger.e('❌ Unexpected error during login: $e');
      EasyLoading.showError('Login failed. Please try again.');
    }
  }

  // ❌ SAME PATTERN REPEATED - More duplicate code
  Future<void> sendOTPCode() async {
    try {
      EasyLoading.show(status: "Sending OTP...");
      _logger.i('📤 Sending OTP');

      final response = await _dio.post(
        ApiConstants.sendOtp,
        data: {'userId': userId, 'method': method},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('✅ OTP sent successfully');
        EasyLoading.showSuccess('Verification code sent');
        // Navigate...
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Send OTP failed with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _logger.e('❌ Send OTP failed: ${e.message}');
      // ❌ GENERIC ERROR MESSAGE instead of actual API error
      EasyLoading.showError(AuthApiService.handleApiError(e));
    } catch (e) {
      _logger.e('❌ Unexpected error sending OTP: $e');
      EasyLoading.showError('Failed to send OTP. Please try again.');
    }
  }

  // ❌ YET MORE DUPLICATE CODE for every API call...
  Future<void> verifyOTPCode() async {
    try {
      EasyLoading.show(status: "Verifying code...");
      // ... same pattern repeats
    } on DioException catch (e) {
      // ... same error handling repeats
    } catch (e) {
      // ... same generic error handling
    }
  }
}
```

**Problems with OLD pattern:**
- 🚫 **Duplicate Code**: Same try-catch-loading pattern in every method
- 🚫 **Generic Errors**: Shows Dio exceptions instead of actual API error messages
- 🚫 **Inconsistent**: Each developer might handle errors differently
- 🚫 **Hard to Maintain**: Changes to error handling require updating every method
- 🚫 **Verbose**: Business logic hidden in network boilerplate

---

## NEW PATTERN (With ApiCaller - Clean & Consistent)

```dart
class NewAuthController extends GetxController {
  final Logger _logger = Logger();
  // ✅ NO DIO INSTANCE NEEDED

  // ✅ CLEAN & FOCUSED - Only business logic, no network boilerplate
  Future<void> login() async {
    _logger.i('📤 Logging in user');

    await ApiCaller.post<LoginResponse>(
      endpoint: ApiConstants.login,
      data: {'email': email, 'password': password},
      loadingMessage: 'Logging in...',
      onSuccess: (data) {
        _logger.i('✅ Login successful');
        final loginResponse = LoginResponse.fromJson(data);
        StorageService.saveAuthData(loginResponse.accessToken, loginResponse.user);
        ApiCaller.showSuccess("Login successful!");
        Get.offAll(BottomNavScreen());
        return loginResponse;
      },
      onError: (error) {
        _logger.e('❌ Login failed: $error');
        // ✅ ERROR IS AUTOMATICALLY SHOWN with actual API message
      },
    );
  }

  // ✅ CONSISTENT PATTERN - Same clean approach for all API calls
  Future<void> sendOTPCode() async {
    _logger.i('📤 Sending OTP');

    await ApiCaller.post(
      endpoint: ApiConstants.sendOtp,
      data: {'userId': userId, 'method': method},
      loadingMessage: "Sending OTP...",
      onSuccess: (data) {
        _logger.i('✅ OTP sent successfully');
        ApiCaller.showSuccess('Verification code sent');
        // Navigate...
        return null;
      },
      onError: (error) {
        _logger.e('❌ Send OTP failed: $error');
        // ✅ ACTUAL API ERROR MESSAGE is automatically shown
      },
    );
  }

  // ✅ NO BOILERPLATE - Focus on what matters
  Future<void> verifyOTPCode() async {
    _logger.i('📤 Verifying OTP');

    await ApiCaller.post(
      endpoint: ApiConstants.verifyOtp,
      data: {'userId': _userId, 'otp': otpString},
      loadingMessage: "Verifying code...",
      onSuccess: (data) {
        _logger.i('✅ OTP verified successfully');
        final verificationResponse = OtpVerificationResponse.fromJson(data);
        StorageService.saveAuthData(verificationResponse.accessToken, verificationResponse.user);
        ApiCaller.showSuccess("Registration completed successfully!");
        Get.offAll(() => BottomNavScreen());
        return null;
      },
      onError: (error) {
        _logger.e('❌ OTP verification failed: $error');
        // ✅ PROPER ERROR HANDLING with API response messages
      },
    );
  }
}
```

**Benefits of NEW pattern:**
- ✅ **No Duplicate Code**: Consistent pattern across all API calls
- ✅ **Real Error Messages**: Shows actual API response errors to users
- ✅ **Clean Controllers**: Focus on business logic, not network infrastructure
- ✅ **Easy to Maintain**: Changes to error handling happen in one place
- ✅ **Type Safe**: Optional generic typing for responses
- ✅ **Flexible**: Custom error handling when needed

---

## Error Message Comparison

### OLD Pattern Error Messages (Generic/Technical):
- ❌ "Login failed. Please try again."
- ❌ "Network error occurred"
- ❌ "DioException: Connection timeout"
- ❌ "Failed to send OTP. Please try again."

### NEW Pattern Error Messages (From API Response):
- ✅ "Invalid email or password" (from API)
- ✅ "Account is temporarily locked" (from API)
- ✅ "Email already exists" (from API)
- ✅ "OTP has expired. Please request a new one" (from API)
- ✅ Falls back to meaningful messages based on status codes

---

## Code Reduction Comparison

### OLD: 50+ lines per API call
```dart
Future<void> apiCall() async {
  try {                                    // Line 1-2
    EasyLoading.show(status: 'Loading...'); // Line 3
    final response = await _dio.post(       // Line 4-7
      endpoint,
      data: requestData,
    );
    if (response.statusCode == 200 ||       // Line 8-15
        response.statusCode == 201) {
      // Handle success
      EasyLoading.showSuccess('Success!');
      // Business logic...
    } else {                                // Line 16-21
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Failed',
      );
    }
  } on DioException catch (e) {            // Line 22-25
    _logger.e('Error: ${e.message}');
    EasyLoading.showError('Generic error');
  } catch (e) {                           // Line 26-29
    _logger.e('Unexpected error: $e');
    EasyLoading.showError('Something went wrong');
  }                                       // Line 30
}
```

### NEW: 15 lines per API call
```dart
Future<void> apiCall() async {
  await ApiCaller.post(                   // Line 1-12
    endpoint: endpoint,
    data: requestData,
    loadingMessage: 'Loading...',
    onSuccess: (data) {
      // Business logic only...
      ApiCaller.showSuccess('Success!');
      return null;
    },
    onError: (error) {
      // Optional custom handling
    },
  );                                     // Line 13
}
```

**Result: 66% less code per API call!**

---

## Implementation Status

### ✅ Completed Migrations:
- `auth_controller.dart` - All authentication API calls
- `registration_controller.dart` - User registration API call
- `main.dart` - ApiCaller initialization

### 🔄 Ready to Migrate:
All other controllers that use Dio directly can now be migrated using the same pattern.

Follow the migration guide in `docs/API_CALLER_MIGRATION.md` for step-by-step instructions.
