import 'package:flutter/material.dart';

import '../data/dashboard_dummy.dart';
import 'low_stock_tile.dart';

class LowStockSection extends StatelessWidget {
  const LowStockSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Low Stock",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                ],
              ),

              const SizedBox(height: 16),

              ...lowStockProducts.map(
                (product) => LowStockTile(product: product),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
