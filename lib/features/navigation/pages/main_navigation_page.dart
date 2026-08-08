import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vender_app/features/navigation/models/navigation_items.dart';

import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation.dart';

class MainNavigationPage extends ConsumerWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: navigationItems.map((item) => item.page).toList(),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
