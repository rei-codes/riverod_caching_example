import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// creates a dio instance with some configurations
final dioService = Provider<Dio>((ref) {
  const baseUrl = 'https://jsonplaceholder.typicode.com/';
  final options = BaseOptions(baseUrl: baseUrl);
  return Dio(options)..interceptors.addAll([DioLogger(), DelayedRequest()]);
});

// logs the dio activities
class DioLogger extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('request sent to server', name: 'DioLogger');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('data fetched from server', name: 'DioLogger');
    handler.resolve(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.type == DioErrorType.cancel) {
      log('request cancelled by user', name: 'DioLogger');
    }
    super.onError(err, handler);
  }
}

class DelayedRequest extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// if the request is from [DetailsPage], delay the request 2 seconds
    /// (just to demonstrate the cache mechanism better)
    if (options.path.contains('/')) {
      Future.delayed(
        const Duration(seconds: 2),
        () => handler.next(options),
      );
    } else {
      handler.next(options);
    }
  }
}
