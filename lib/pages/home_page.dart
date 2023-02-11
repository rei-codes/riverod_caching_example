import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_caching/providers/user_provider.dart';

import 'details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('HomePage'),
      ),
      body: const _ListView(),
      floatingActionButton: const _RefreshButton(),
    );
  }
}

class _RefreshButton extends ConsumerWidget {
  const _RefreshButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      child: const Icon(Icons.refresh),
      onPressed: () {
        log('clicked on refresh button');
        ref.invalidate(usersProvider);
      },
    );
  }
}

class _ListView extends ConsumerWidget {
  const _ListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUsers = ref.watch(usersProvider);
    return asyncUsers.when(
      data: (users) {
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, i) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => DetailsPage(users[i].id)),
                );
              },
              child: Card(
                child: ListTile(
                  title: Text(users[i].name),
                ),
              ),
            );
          },
        );
      },
      error: (_, __) => const Center(child: Text('err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
