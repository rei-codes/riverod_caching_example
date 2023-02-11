import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_caching/utils/extensions.dart';

import '../models/user.dart';
import '../services/dio_service.dart';

/// gets a user list
final usersProvider = FutureProvider.autoDispose<List<User>>(
  (ref) async {
    /// debounce only when refreshing
    if (ref.state.isRefreshing) {
      await ref.debounce();
    }

    log('get users', name: 'usersProvider');

    final dio = ref.read(dioService);
    final res = await dio.get('users');
    final List list = res.data;
    return list.map((e) => User.fromJson(e)).toList();
  },
  dependencies: [dioService],
);

/// gets a user with given id
final userProvider = FutureProvider.autoDispose.family<User, int>(
  (ref, id) async {
    /// logs the lifecycle
    ref.logger();

    /// caches for 3 seconds (it's a default duration for this example)
    final link = ref.cacheFor();

    /// creates a cancel token with auto cancel option
    final token = ref.cancelToken();

    try {
      final dio = ref.read(dioService);
      final res = await dio.get('users/$id', cancelToken: token);
      return User.fromJson(res.data);
    } on DioError catch (e) {
      /// if the request is canceled, close the link,
      /// and let the provider dispose itself
      if (e.type == DioErrorType.cancel) {
        link.close();
      }
      rethrow;
    }
  },
  dependencies: [dioService],
);
