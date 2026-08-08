import 'package:flutter/material.dart';

import '../data/dashboard_dummy.dart';
import 'order_tile.dart';

class RecentOrders extends StatelessWidget {
  const RecentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Recent Orders",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text("View All")),
                ],
              ),

              const SizedBox(height: 12),

              ...recentOrders.map((order) => OrderTile(order: order)),
            ],
          ),
        ),
      ),
    );
  }
}
