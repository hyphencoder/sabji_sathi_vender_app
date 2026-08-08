import 'package:flutter/material.dart';

import '../models/low_stock_model.dart';

class LowStockTile extends StatelessWidget {
  const LowStockTile({super.key, required this.product});

  final LowStockModel product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: CircleAvatar(
        radius: 24,
        backgroundColor: colorScheme.primaryContainer,
        child: const Icon(Icons.shopping_basket_outlined),
      ),

      title: Text(product.name),

      subtitle: Text("Only ${product.stock} ${product.unit} left"),

      trailing: FilledButton.tonal(
        onPressed: () {},
        child: const Text("Restock"),
      ),
    );
  }
}
