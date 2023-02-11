import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_caching/providers/user_provider.dart';

class DetailsPage extends ConsumerWidget {
  const DetailsPage(this.id, {super.key});
  final int id;

  @override
  Widget build(BuildContext context, ref) {
    final asyncUser = ref.watch(userProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text('$id')),
      body: Center(
        child: asyncUser.when(
          data: (user) => Text(user.name),
          error: (e, __) => Text('$e'),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
