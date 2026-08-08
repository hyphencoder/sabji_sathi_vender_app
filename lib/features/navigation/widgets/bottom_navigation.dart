import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vender_app/features/navigation/models/navigation_items.dart';

import '../providers/navigation_provider.dart';
import 'nav_item.dart';

class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          height: 78,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  Theme.of(context).brightness == Brightness.dark ? 0.30 : 0.10,
                ),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: List.generate(navigationItems.length, (index) {
              final item = navigationItems[index];

              return NavItem(
                title: item.label,
                icon: item.icon,
                selectedIcon: item.selectedIcon,
                isSelected: currentIndex == index,
                onTap: () {
                  ref.read(navigationProvider.notifier).changeIndex(index);
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
