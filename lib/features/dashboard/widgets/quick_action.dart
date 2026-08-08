import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vender_app/core/routes/app_routes.dart';
import 'package:vender_app/features/dashboard/widgets/quick_action_card.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Actions",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(
            "Manage your store quickly",
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 20),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.20,
            children: [
              DashboardActionCard(
                title: "Add Product",
                subtitle: "Create new",
                icon: Icons.add_box_outlined,
                iconColor: Colors.green,
                onTap: () {
                  context.push(AppRoutes.addProducts);
                },
              ),

              DashboardActionCard(
                title: "Products",
                subtitle: "128 Active",
                icon: Icons.inventory_2_outlined,
                iconColor: Colors.blue,
                onTap: () {},
              ),

              DashboardActionCard(
                title: "Orders",
                subtitle: "12 Pending",
                icon: Icons.receipt_long_outlined,
                iconColor: Colors.orange,
                onTap: () {},
              ),

              DashboardActionCard(
                title: "Analytics",
                subtitle: "Today's Report",
                icon: Icons.bar_chart_outlined,
                iconColor: Colors.purple,
                onTap: () {},
              ),

              DashboardActionCard(
                title: "Categories",
                subtitle: "15 Categories",
                icon: Icons.category_outlined,
                iconColor: Colors.teal,
                onTap: () {},
              ),

              DashboardActionCard(
                title: "Low Stock",
                subtitle: "5 Items Left",
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.red,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
