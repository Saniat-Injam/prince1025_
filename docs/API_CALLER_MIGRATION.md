# ApiCaller Migration Guide

This guide explains how to migrate existing controllers from using Dio directly to using the new `ApiCaller` service.

## Benefits of ApiCaller

1. **Reduced Duplicate Code**: No more try-catch blocks, loading states, or error handling boilerplate
2. **Better Error Messages**: Shows actual API response error messages instead of Dio exception messages
3. **Consistent UI**: Unified loading and error message display across the app
4. **Cleaner Controllers**: Focus on business logic instead of network infrastructure

## Migration Steps

### Step 1: Update Imports

**Before:**
```dart
import 'package:dio/dio.dart';
import 'package:prince1025/core/services/auth_api_service.dart';
```

**After:**
```dart
import 'package:prince1025/core/services/api_caller.dart';
```

### Step 2: Remove Dio Instance

**Before:**
```dart
class SomeController extends GetxController {
  final Dio _dio = AuthApiService.getDio();
  // ...
}
```

**After:**
```dart
class SomeController extends GetxController {
  // No need for Dio instance
  // ...
}
```

### Step 3: Replace API Calls

#### GET Request Migration

**Before:**
```dart
Future<void> fetchData() async {
  try {
    EasyLoading.show(status: 'Loading...');
    
    final response = await _dio.get('/api/data');
    
    if (response.statusCode == 200) {
      // Handle success
      final data = response.data;
      EasyLoading.showSuccess('Data loaded successfully!');
      // Process data...
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Failed to load data',
      );
    }
  } on DioException catch (e) {
    EasyLoading.showError(AuthApiService.handleApiError(e));
  } catch (e) {
    EasyLoading.showError('Something went wrong');
  }
}
```

**After:**
```dart
Future<void> fetchData() async {
  await ApiCaller.get(
    endpoint: '/api/data',
    loadingMessage: 'Loading...',
    onSuccess: (data) {
      // Handle success
      ApiCaller.showSuccess('Data loaded successfully!');
      // Process data...
      return null;
    },
    onError: (error) {
      // Optional custom error handling
      // Error is automatically shown by ApiCaller
    },
  );
}
```

#### POST Request Migration

**Before:**
```dart
Future<void> createData(Map<String, dynamic> requestData) async {
  try {
    EasyLoading.show(status: 'Creating...');
    
    final response = await _dio.post('/api/data', data: requestData);
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      EasyLoading.showSuccess('Created successfully!');
      // Handle success...
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Failed to create data',
      );
    }
  } on DioException catch (e) {
    EasyLoading.showError(AuthApiService.handleApiError(e));
  } catch (e) {
    EasyLoading.showError('Creation failed');
  }
}
```

**After:**
```dart
Future<void> createData(Map<String, dynamic> requestData) async {
  await ApiCaller.post(
    endpoint: '/api/data',
    data: requestData,
    loadingMessage: 'Creating...',
    onSuccess: (data) {
      ApiCaller.showSuccess('Created successfully!');
      // Handle success...
      return null;
    },
  );
}
```

#### PUT Request Migration

**Before:**
```dart
Future<void> updateData(String id, Map<String, dynamic> requestData) async {
  try {
    EasyLoading.show(status: 'Updating...');
    
    final response = await _dio.put('/api/data/$id', data: requestData);
    
    if (response.statusCode == 200) {
      EasyLoading.showSuccess('Updated successfully!');
      // Handle success...
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Failed to update data',
      );
    }
  } on DioException catch (e) {
    EasyLoading.showError(AuthApiService.handleApiError(e));
  } catch (e) {
    EasyLoading.showError('Update failed');
  }
}
```

**After:**
```dart
Future<void> updateData(String id, Map<String, dynamic> requestData) async {
  await ApiCaller.put(
    endpoint: '/api/data/$id',
    data: requestData,
    loadingMessage: 'Updating...',
    onSuccess: (data) {
      ApiCaller.showSuccess('Updated successfully!');
      // Handle success...
      return null;
    },
  );
}
```

#### DELETE Request Migration

**Before:**
```dart
Future<void> deleteData(String id) async {
  try {
    EasyLoading.show(status: 'Deleting...');
    
    final response = await _dio.delete('/api/data/$id');
    
    if (response.statusCode == 200) {
      EasyLoading.showSuccess('Deleted successfully!');
      // Handle success...
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Failed to delete data',
      );
    }
  } on DioException catch (e) {
    EasyLoading.showError(AuthApiService.handleApiError(e));
  } catch (e) {
    EasyLoading.showError('Delete failed');
  }
}
```

**After:**
```dart
Future<void> deleteData(String id) async {
  await ApiCaller.delete(
    endpoint: '/api/data/$id',
    loadingMessage: 'Deleting...',
    onSuccess: (data) {
      ApiCaller.showSuccess('Deleted successfully!');
      // Handle success...
      return null;
    },
  );
}
```

## Advanced Usage

### Custom Error Handling

If you need custom error handling logic:

```dart
await ApiCaller.post(
  endpoint: '/api/data',
  data: requestData,
  onSuccess: (data) {
    // Handle success
    return null;
  },
  onError: (error) {
    // Custom error handling
    if (error.contains('validation')) {
      // Handle validation errors
      showCustomValidationDialog();
    } else if (error.contains('unauthorized')) {
      // Handle auth errors
      redirectToLogin();
    } else {
      // Use default error display
      ApiCaller.showError(error);
    }
  },
);
```

### Disable Automatic Loading

If you want to handle loading states manually:

```dart
await ApiCaller.post(
  endpoint: '/api/data',
  data: requestData,
  showLoading: false, // Disable automatic loading
  onSuccess: (data) {
    // Handle success
    return null;
  },
);
```

### Typed Responses

For type-safe responses:

```dart
Future<UserModel?> fetchUser(String userId) async {
  UserModel? user;
  
  await ApiCaller.get<Map<String, dynamic>>(
    endpoint: '/api/users/$userId',
    onSuccess: (data) {
      if (data != null) {
        user = UserModel.fromJson(data);
      }
      return data;
    },
  );
  
  return user;
}
```

## Error Message Priority

The ApiCaller prioritizes error messages in this order:

1. **API Response Message**: `response.data['message']`
2. **API Response Error**: `response.data['error']`
3. **API Response Errors Array**: `response.data['errors'][0]`
4. **Status Code Messages**: Based on HTTP status codes
5. **Connection Error Messages**: Based on Dio exception types

This ensures users see meaningful error messages from your API instead of technical Dio errors.

## Migration Checklist

- [ ] Replace Dio imports with ApiCaller import
- [ ] Remove Dio instance declarations
- [ ] Convert try-catch blocks to ApiCaller methods
- [ ] Update loading state management
- [ ] Update error handling
- [ ] Test API error message display
- [ ] Verify loading states work correctly
- [ ] Check that success messages are shown appropriately

## Files Already Migrated

✅ `auth_controller.dart` - All API calls migrated
✅ `registration_controller.dart` - Registration API call migrated

## Files That Need Migration

The following controllers still use the old Dio pattern and should be migrated:

- `profile_controller.dart`
- `home_controller.dart`
- `courses_controller.dart`
- `videos_controller.dart`
- `notification_controller.dart`
- Any other controllers with direct Dio usage

Follow this guide to migrate them one by one, testing each migration thoroughly.
