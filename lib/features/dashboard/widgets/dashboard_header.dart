import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.shopName,
    this.shopLogo,
    this.notificationCount = 0,
    this.onNotificationTap,
  });

  final String shopName;
  final String? shopLogo;
  final int notificationCount;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: colorScheme.primaryContainer,
            backgroundImage: shopLogo != null && shopLogo!.isNotEmpty
                ? NetworkImage(shopLogo!)
                : null,
            child: shopLogo == null || shopLogo!.isEmpty
                ? Icon(
                    Icons.store_rounded,
                    color: colorScheme.primary,
                    size: 28,
                  )
                : null,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              shopName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: onNotificationTap,
                icon: const Icon(Icons.notifications_outlined, size: 28),
              ),

              if (notificationCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      notificationCount > 9
                          ? '9+'
                          : notificationCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
