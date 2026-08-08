import 'package:flutter/material.dart';
import 'package:vender_app/features/dashboard/widgets/quick_action.dart';

import '../widgets/dashboard_header.dart';
import '../widgets/low_stock_section.dart';
import '../widgets/recent_orders.dart';
import '../widgets/revenue_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: DashboardHeader(shopName: 'Green Grocer'),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            const SliverToBoxAdapter(
              child: RevenueCard(
                revenue: '₹4,250',
                orders: 42,
                growth: '+15% from yesterday',
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            const SliverToBoxAdapter(child: QuickActions()),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            const SliverToBoxAdapter(child: RecentOrders()),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            const SliverToBoxAdapter(child: LowStockSection()),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}
