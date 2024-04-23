import 'dart:developer';

import 'package:ampushare/data/models/auth_model/auth_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioHelper {

  static Future<Dio> getDioForAuth() async {
    final dio = Dio();
    dio.options = BaseOptions(
      baseUrl: dotenv.get("API_HOST", fallback: "http://192.168.1.108:8585"), // Replace with your base URL
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return dio;
  }

  static Future<Dio> getDio() async {
    final prefs = await SharedPreferences.getInstance();
    final authModelString = prefs.getString('authModel');
    AuthModel authModel = AuthModel(
        access: '',
        refresh: '',
        user: AuthUser(firstName: '', lastName: '', profileImage: '', id: 0, email: ''));
    if (authModelString != null) {
      authModel = authModelFromJson(authModelString);
    }
    final accessToken = authModel.access;

    log("[+] Access Token");
    log(authModelString!);
    log(accessToken);

    final dio = Dio();
    dio.options = BaseOptions(
      baseUrl: dotenv.get("API_HOST", fallback: "http://192.168.1.108:8585"),
      // Replace with your base URL
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 30),
    );

    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    // dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) {
    //     // Handle request here (e.g., logging)
    //     handler.next(options);
    //   },
    //   onResponse: (response, handler) {
    //     // Handle response here (e.g., logging)
    //     handler.next(response);
    //   },
    //   onError: (DioError error, handler) {
    //     // Handle error here (e.g., display error message)
    //     handler.next(error);
    //   },
    // ));

    return dio;
  }
}
