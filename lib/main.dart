import 'package:flutter/material.dart';
import 'package:prince1025/app.dart';
import 'package:prince1025/core/services/api_caller.dart';
import 'package:prince1025/core/services/auth_api_service.dart';
import 'package:prince1025/core/services/storage_service.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services
  await StorageService.init();
  AuthApiService.init();
  ApiCaller.init(); // Initialize the new API caller service

  runApp(GlowUp());
}
