import 'package:flutter/material.dart';

enum ProductStatus { inStock, lowStock, outOfStock }

class ProductStatusChip extends StatelessWidget {
  const ProductStatusChip({super.key, required this.status});

  final ProductStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ProductStatus.inStock => ("In Stock", Colors.green),
      ProductStatus.lowStock => ("Low Stock", Colors.orange),
      ProductStatus.outOfStock => ("Out of Stock", Colors.red),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
