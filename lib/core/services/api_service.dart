import 'package:dio/dio.dart';

import 'package:top_pay/core/services/api_endpoints.dart';
import 'package:top_pay/core/utils/api_error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:top_pay/core/utils/logger.dart';

class ApiService {
  final Dio _dio;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: ApiEndpoints.connectTimeout,
          receiveTimeout: ApiEndpoints.receiveTimeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        requestHeader: false,
        responseHeader: false,
        logPrint: (object) => Logger.debug(object.toString(), 'DIO'),
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            final idToken = await user.getIdToken();

            if (idToken != null && idToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $idToken';
              Logger.debug('Firebase token attached to request', 'API_AUTH');
            } else {
              Logger.debug('Firebase token not available', 'API_AUTH');
            }
          }
          handler.next(options);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }
}
